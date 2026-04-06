# Copyright (C) 2017-2023 The Android Open Source Project
# Copyright (C) 2014-2023 The Team Win LLC
# SPDX-License-Identifier: Apache-2.0

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Configure Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Configure virtual_ab compression.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# Configure launch_with_vendor_ramdisk.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Dynamic
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Virtual A/B
ENABLE_VIRTUAL_AB := true

AB_OTA_UPDATER := true

# A/B updater updatable partitions list. Keep in sync with the partition list.
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_boot

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# API
PRODUCT_SHIPPING_API_LEVEL := 32

# Bootctrl
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-mtkimpl \
    android.hardware.boot@1.2-mtkimpl.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctrl

# Fastbootd
TW_INCLUDE_FASTBOOTD := true

PRODUCT_PACKAGES += \
    android.hardware.security.rkp-V3-ndk \
    android.hardware.fastboot@1.0-impl-mock

# Health Hal
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload

# MTK PlPath Utils
PRODUCT_PACKAGES += \
    mtk_plpath_utils.recovery

# Additional binaries & libraries needed for recovery
TARGET_RECOVERY_DEVICE_MODULES += \
    libion 

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.vibrator-V1-ndk_platform.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so

# Keymint / decryption libs - pulled from stock device, copied into vendor_boot ramdisk
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/debug_boot.sh:$(TARGET_COPY_OUT_RECOVERY)/root/debug_boot.sh \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymint.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymint.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymint_support.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymint_support.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libmiriskmanager_mitee.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libmiriskmanager_mitee.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/lib_android_keymaster_keymint_utils.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/lib_android_keymaster_keymint_utils.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymaster_messages.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymaster_messages.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymaster_portable.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymaster_portable.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libpuresoftkeymasterdevice.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libpuresoftkeymasterdevice.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libsoft_attestation_cert.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libsoft_attestation_cert.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libkeymaster4support.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libkeymaster4support.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libteecli.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libteecli.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/android.system.keystore2-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/android.system.keystore2-V1-ndk.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libcppbor_external.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libcppbor_external.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/libcppcose_rkp.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/libcppcose_rkp.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/android.hardware.gatekeeper@1.0.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/android.hardware.gatekeeper@1.0.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.keymint-V3-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/android.hardware.security.keymint-V3-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.keymint-V3-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.security.keymint-V3-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.keymint-V2-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/lib64/android.hardware.security.keymint-V2-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.keymint-V2-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.security.keymint-V2-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.sharedsecret-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.security.sharedsecret-V1-ndk.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/android.hardware.security.secureclock-V1-ndk.so:$(TARGET_COPY_OUT_RECOVERY)/root/system/lib64/android.hardware.security.secureclock-V1-ndk.so \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.security.keymint-service.mitee.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.security.keymint-service.mitee.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.security.secureclock-service.mitee.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.security.secureclock-service.mitee.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.security.sharedsecret-service.mitee.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/android.hardware.security.sharedsecret-service.mitee.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest_fixed.xml:$(TARGET_COPY_OUT_RECOVERY)/root/manifest_fixed.xml

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Overrides
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.device=$(PRODUCT_RELEASE_NAME)

# Use /product/etc/fstab.postinstall to mount system_other.
PRODUCT_PRODUCT_PROPERTIES += \
    ro.postinstall.fstab.prefix=/system
