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
    lib_fixup_remove,
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

# Xiaomi AIDL libs that exist as prebuilt .so but not as build targets.
# Remove them from shared_libs so the ELF checker doesn't drop the binaries.
# They'll be loaded at runtime from the vendor/odm partitions.
libs_xiaomi_aidl = (
    'vendor.xiaomi.hardware.aidl.midevauth-V1-ndk_platform',
    'vendor.xiaomi.hardware.aidl.mtdservice-V1-ndk_platform',
    'vendor.xiaomi.hardware.aidl.tidaservice-V1-ndk_platform',
    'vendor.xiaomi.hardware.dtool1-V1-ndk',
    'vendor.xiaomi.hardware.fx.tunnel-V1-ndk',
    'vendor.xiaomi.hardware.keyboardnanoapp_aidl-V1-ndk',
    'vendor.xiaomi.hardware.mfidoca-V1-ndk_platform',
    'vendor.xiaomi.hardware.mikeybag-V1-ndk_platform',
    'vendor.xiaomi.hardware.misauth-V1-ndk_platform',
    'vendor.xiaomi.hardware.mlipay-V1-ndk_platform',
    'vendor.xiaomi.hardware.mrm-V1-ndk_platform',
    'vendor.xiaomi.hardware.otrpagent2-V1-ndk',
    'vendor.xiaomi.hardware.seaaudio-V1-ndk',
    'vendor.xiaomi.hardware.vsimapp-V1-ndk_platform',
    'vendor.xiaomi.sensor.camera-V1-ndk',
)

# ODM-only native libs that aren't build targets
libs_xiaomi_odm = (
    'libesesbprovision',
    'libmidevauth',
    'libmiface',
    'libmlipay',
    'libmiriskmanager',
    'libmt',
    'libRecordCNN',
    'libtida',
    'libvsim',
)

# Fingerprint/touch AIDL libs not available as build targets
libs_fingerprint_aidl = (
    'com.fingerprints.extension3-V1-ndk',
    'com.fingerprints.fpc.extension-V1-ndk',
    'vendor.qti.hardware.fingerprint-V1-ndk',
    'vendor.xiaomi.hardware.fingerprintextension-V1-ndk',
    'vendor.xiaomi.hw.touchfeature-V1-ndk',
)

def _lib_fixup_version_bump(lib: str, partition: str) -> str:
    """Bump AIDL interface versions to match the source tree."""
    replacements = {
        'android.hardware.graphics.allocator-V1-ndk': 'android.hardware.graphics.allocator-V2-ndk',
        'android.hardware.biometrics.common-V3-ndk': 'android.hardware.biometrics.common-V4-ndk',
        'android.hardware.biometrics.fingerprint-V3-ndk': 'android.hardware.biometrics.fingerprint-V4-ndk',
    }
    return replacements.get(lib, lib)

lib_fixups: lib_fixups_user_type = {
    'android.hardware.graphics.allocator-V1-ndk': _lib_fixup_version_bump,
    # Biometrics V3 conflicts with V4 in the source tree — remove to avoid
    # multiple-version AIDL errors. The correct version loads at runtime.
    ('android.hardware.biometrics.common-V3-ndk',
     'android.hardware.biometrics.fingerprint-V3-ndk'): lib_fixup_remove,
    libs_xiaomi_aidl: lib_fixup_remove,
    libs_xiaomi_odm: lib_fixup_remove,
    libs_fingerprint_aidl: lib_fixup_remove,
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
