# Copyright (C) 2017-2023 The Android Open Source Project
# Copyright (C) 2014-2023 The Team Win LLC
# SPDX-License-Identifier: Apache-2.0

LOCAL_PATH := $(call my-dir)

subdir_makefiles=$(call first-makefiles-under,$(LOCAL_PATH))
$(foreach mk,$(subdir_makefiles),$(info including $(mk) ...)$(eval include $(mk)))
