#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from sm8635-common
$(call inherit-product, device/xiaomi/sm8635-common/common.mk)

# Kernel modules
# muyu-kernel tree layout (populated by its extract-files.sh from OTA zip):
#   modules/vendor/   → vendor_dlkm partition (.ko + modules.load)
#   modules/ramdisk/  → vendor_boot ramdisk   (.ko + modules.load)
#   modules/system/   → system_dlkm partition  (GKI base modules)
KERNEL_PATH := device/xiaomi/muyu-kernel

# vendor_dlkm modules
ifneq ($(wildcard $(KERNEL_PATH)/modules/vendor/modules.load),)
BOARD_VENDOR_KERNEL_MODULES_LOAD           := $(strip $(shell cat $(KERNEL_PATH)/modules/vendor/modules.load))
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/modules/vendor/modules.blocklist

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*.ko,$(KERNEL_PATH)/modules/vendor/,$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules)
endif

# vendor_boot ramdisk modules
ifneq ($(wildcard $(KERNEL_PATH)/modules/ramdisk/modules.load),)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD           := $(strip $(shell cat $(KERNEL_PATH)/modules/ramdisk/modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/modules/ramdisk/modules.blocklist

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*.ko,$(KERNEL_PATH)/modules/ramdisk/,$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules)
endif

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.muyu.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.muyu.rc

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay

# ODM VINTF manifest fragments — REMOVED
# All 15 HALs are already declared in the main odm/etc/vintf/manifest.xml
# from sm8635-common. Separate fragments would cause duplicate HAL conflicts.

# ODM init scripts not installed by extract-utils
PRODUCT_COPY_FILES += \
    vendor/xiaomi/muyu/proprietary/odm/etc/init/vendor.xiaomi.hardware.dtool1.rc:$(TARGET_COPY_OUT_ODM)/etc/init/vendor.xiaomi.hardware.dtool1.rc

# Vendor kernel headers (Qualcomm display/audio headers from prebuilt kernel)
# The generated_kernel_includes module runs 'make headers_install' which only
# exports standard UAPI headers. Qualcomm vendor headers (display/media, etc.)
# are only in the prebuilt kernel-headers/ and must be injected separately.
PRODUCT_VENDOR_KERNEL_HEADERS += device/xiaomi/muyu-kernel/qcom/kernel-headers

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    device/xiaomi/muyu

# Inherit from the proprietary files makefile
$(call inherit-product, vendor/xiaomi/muyu/muyu-vendor.mk)
