#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 35

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/realme/RMX6688/RMX6688-vendor.mk)
