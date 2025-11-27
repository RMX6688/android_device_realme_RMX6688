#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/realme/RMX6688/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_RMX6688
PRODUCT_DEVICE := RMX6688
PRODUCT_MANUFACTURER := Realme
PRODUCT_BRAND := Realme
PRODUCT_MODEL := RE602AL1

PRODUCT_GMS_CLIENTID_BASE := android-realme

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="sys_mssi_64_cn_armv82-user 15 AP3A.240617.008 1755271183721 release-keys" \
    BuildFingerprint=oplus/ossi/ossi:15/AP3A.240617.008/1755271183721:user/release-keys
