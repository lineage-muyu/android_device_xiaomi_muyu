#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from sm8635-common
$(call inherit-product, device/xiaomi/sm8635-common/common.mk)

# Kernel modules
# muyu-kernel tree provides prebuilt kernel, dtb, dtbo and vendor_dlkm modules.
# When device/xiaomi/muyu-kernel is present:
KERNEL_PATH := device/xiaomi/muyu-kernel

ifneq ($(wildcard $(KERNEL_PATH)/modules/vendor_dlkm/modules.load),)
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/modules/vendor_dlkm/modules.load))
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/modules/vendor_dlkm/modules.blocklist

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(KERNEL_PATH)/modules/vendor_dlkm/,$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules)
endif

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    device/xiaomi/muyu

# Inherit from the proprietary files makefile
$(call inherit-product, vendor/xiaomi/muyu/muyu-vendor.mk)
