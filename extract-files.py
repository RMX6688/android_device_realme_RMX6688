#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)

from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
    ): lib_fixup_vendor_suffix,
    (
        'android.hardware.graphics.allocator-V1-ndk',
        'android.hardware.graphics.composer3-V2-ndk',
    ): lib_fixup_remove,
}

blob_fixups: blob_fixups_user_type = {
    ('vendor/bin/hw/android.hardware.wifi-service-mtk'): blob_fixup()
        .replace_needed('libwifi-hal.so', 'libwifi-hal-mtk.so'),
    ('vendor/etc/init/android.hardware.wifi-service-mtk.rc'): blob_fixup()
        .regex_replace(r'/vendor/bin/hw/android\.hardware\.wifi-service-lazy',
                       '/vendor/bin/hw/android.hardware.wifi-service-mtk'),
    ('vendor/lib64/hw/hwcomposer.mtk_common.so'): blob_fixup()
        .add_needed('libprocessgroup_shim.so'),
}

module = ExtractUtilsModule(
    'RMX6688',
    'realme',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    check_elf=False,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
