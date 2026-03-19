#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    BlobFixupCtx,
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/xiaomi/muyu',
    'device/xiaomi/sm8635-common',
    'hardware/qcom-caf/sm8650',
    'hardware/qcom-caf/wlan',
    'hardware/xiaomi',
    'vendor/qcom/opensource/commonsys/display',
    'vendor/qcom/opensource/commonsys-intf/display',
    'vendor/qcom/opensource/dataservices',
    'vendor/xiaomi/sm8635-common',
]

lib_fixups: lib_fixups_user_type = {
    'android.hardware.graphics.allocator-V1-ndk': 'android.hardware.graphics.allocator-V2-ndk',
}

blob_fixups: blob_fixups_user_type = {
    'odm/etc/camera/enhance_motiontuning.xml': blob_fixup()
        .regex_replace(r'<\?xml=version', '<?xml version'),
    'odm/etc/camera/motiontuning.xml': blob_fixup()
        .regex_replace(r'<\?xml=version', '<?xml version'),
    'odm/etc/camera/night_motiontuning.xml': blob_fixup()
        .regex_replace(r'<\?xml=version', '<?xml version'),
}

module = ExtractUtilsModule(
    'muyu',
    'xiaomi',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(
        module,
        'sm8635-common',
        module.vendor,
    )
    utils.run()
