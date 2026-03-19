#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/muyu
KERNEL_PATH := device/xiaomi/muyu-kernel

# Inherit from sm8635-common board configuration
include device/xiaomi/sm8635-common/BoardConfigCommon.mk

# Board
TARGET_BOOTLOADER_BOARD_NAME := muyu

# Kernel version (6.1.118, GKI 2.0)
TARGET_KERNEL_VERSION := 6.1
TARGET_KERNEL_SOURCE := kernel/xiaomi/sm8635
TARGET_KERNEL_CONFIG := defconfig

# Kernel — prebuilt from device/xiaomi/muyu-kernel
# The muyu-kernel tree stores individual DTBs in dtbs/ (extracted from vendor_boot).
# dtb.img is not committed; generate it once with: cat dtbs/*.dtb > dtb.img
# DTBs go into vendor_boot (GKI 2.0), NOT boot.img — do NOT add --dtb to
# BOARD_MKBOOTIMG_ARGS.
ifneq ($(wildcard $(KERNEL_PATH)/kernel),)
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_PREBUILT_KERNEL       := $(KERNEL_PATH)/kernel
BOARD_PREBUILT_DTBOIMAGE     := $(KERNEL_PATH)/dtbo.img
BOARD_INCLUDE_DTB_IN_BOOTIMG :=
BOARD_KERNEL_SEPARATED_DTBO  :=
endif

ifneq ($(wildcard $(KERNEL_PATH)/dtb.img),)
TARGET_PREBUILT_DTB := $(KERNEL_PATH)/dtb.img
endif

# VINTF — override to remove manifest_non_qmaa.xml which duplicates
# soundtrigger@2.3 already declared in the vendor manifest.xml
DEVICE_MANIFEST_FILE := \
    $(COMMON_PATH)/configs/vintf/manifest.xml

# Allow missing treble sepolicy tests (removed due to compat map build issues)
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true

# VINTF — device-specific compatibility matrix for Xiaomi ODM HALs
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DEVICE_PATH)/compatibility_matrix.xml

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Partitions — measured from stock firmware CN OS3.0.11.0.WOYCNXM (rawprogram0.xml)
# super: 2752512 sectors × 4096 bytes/sector = 11274289152 bytes
# dtbo: actual dtbo.img size from firmware
BOARD_DTBOIMG_PARTITION_SIZE         := 20971520
BOARD_SUPER_PARTITION_SIZE           := 11274289152
BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := 11270094848 # (BOARD_SUPER_PARTITION_SIZE - 4 MiB)
