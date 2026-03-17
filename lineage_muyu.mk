#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_tablet.mk)

# Inherit from muyu device
$(call inherit-product, device/xiaomi/muyu/device.mk)

# Device identifier
PRODUCT_NAME := lineage_muyu
PRODUCT_DEVICE := muyu
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Xiaomi Pad 7 Pro
PRODUCT_MANUFACTURER := xiaomi

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="muyu-user 14 UKQ1.240624.001 OS3.0.11.0.WOYCNXM release-keys" \
    BuildFingerprint=Xiaomi/muyu/muyu:14/UKQ1.240624.001/OS3.0.11.0.WOYCNXM:user/release-keys \
    DeviceProduct=muyu
