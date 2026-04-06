#!/system/bin/sh
set -x
# TWRP Debug Boot Script - @vbs_1 & @dream_7x - Recovery-Sync
LOGFILE="/tmp/recovery_debug.log"

log_msg() {
    MSG="[debug_boot] $1"
    echo "$MSG" | tee -a "$LOGFILE" > /dev/kmsg
}

exec 2>>"$LOGFILE" # Capture all stderr to logfile

log_msg "--- TWRP DEBUG BOOT START ---"

# 1. Identity restoration
log_msg "Extracting device identities..."

# Try to get real values. Fallback to current if sensing fails.
# Real values are usually in /vendor/build.prop
VENDOR_PROP="/vendor/build.prop"
[ -f /vendor/etc/build.prop ] && VENDOR_PROP="/vendor/etc/build.prop"

REAL_VER=$(getprop ro.vendor.build.version.release)
REAL_PATCH=$(getprop ro.vendor.build.security_patch)

# If getprop gave us the "fake" 2099 or empty, try reading the file directly
if [ "$REAL_PATCH" = "2099-12-31" ] || [ -z "$REAL_PATCH" ]; then
    log_msg "getprop reported 2099 or empty. Scanning $VENDOR_PROP directly..."
    if [ -f "$VENDOR_PROP" ]; then
        REAL_VER=$(grep -m 1 "ro.vendor.build.version.release=" "$VENDOR_PROP" | cut -d'=' -f2)
        FILE_PATCH=$(grep -m 1 "ro.vendor.build.security_patch=" "$VENDOR_PROP" | cut -d'=' -f2)
        [ -n "$FILE_PATCH" ] && [ "$FILE_PATCH" != "2099-12-31" ] && REAL_PATCH="$FILE_PATCH"
    fi
fi

if [ -n "$REAL_VER" ] && [ "$REAL_VER" != "14" ]; then
    log_msg "Applying Identity: Android $REAL_VER — Patch: $REAL_PATCH"
    /system/bin/resetprop ro.build.version.release "$REAL_VER"
    /system/bin/resetprop ro.build.version.release_or_codename "$REAL_VER"
    /system/bin/resetprop ro.build.version.security_patch "$REAL_PATCH"
else
    log_msg "Identity check skipped or version matches stock (14)."
fi

# 2. Block Device Alignment (Mediatek)
log_msg "Aligning block device paths..."
mkdir -p /dev/block/platform/bootdevice/by-name/
for part in preloader_raw_a preloader_raw_b; do
    [ -L /dev/block/by-name/$part ] && ln -sf /dev/block/by-name/$part /dev/block/platform/bootdevice/by-name/$part
done

# 3. TEE Node Readiness
log_msg "Ensuring TEE node permissions..."
chmod 0666 /dev/teepriv0 /dev/tee0 2>/dev/null
chown system:system /dev/teepriv0 /dev/tee0 2>/dev/null

# 4. VINTF manifest sync
log_msg "Patching VINTF manifest..."
if [ -d /vendor/etc/vintf ]; then
    mkdir -p /tmp/vintf
    cp -rf /vendor/etc/vintf/* /tmp/vintf/
    find /tmp/vintf -type f -name "*.xml" -exec sed -i 's/version="5.0"/version="4.0"/g' {} +
    chmod -R 755 /tmp/vintf
    chown -R system:system /tmp/vintf
    mount -o bind /tmp/vintf /vendor/etc/vintf
fi

# 5. Signal Readiness & Clean Startup
log_msg "Signaling VINTF ready..."
stop keystore2
stop gatekeeper-1-0
stop keymint-mitee
setprop twrp.vintf.ready 1

# 6. Wait for KeyMint and Start Keystore (Backgrounded)
(
    log_msg "Starting AIDL watcher thread..."
    WAIT=0
    while [ $WAIT -lt 20 ]; do
        if service list 2>/dev/null | grep -q "IKeyMintDevice"; then
            log_msg "KeyMint AIDL found after ${WAIT}s. Starting Keystore2..."
            break
        fi
        sleep 1
        WAIT=$((WAIT + 1))
    done
    start keystore2
    log_msg "Watcher thread finished."
) &
WATCHER_PID=$!

log_msg "--- TWRP DEBUG BOOT END (Waiting for watcher ${WATCHER_PID}) ---"
wait $WATCHER_PID
exit 0
# Persistence loop disabled to prevent instability
# (Service monitoring should be handled by init.recovery.rc triggers)
