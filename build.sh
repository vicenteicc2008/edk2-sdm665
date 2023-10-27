#!/bin/bash
# based on the instructions from edk2-platform
set -e
. build_common.sh
# not actually GCC5; it's GCC7 on Ubuntu 18.04.
GCC5_AARCH64_PREFIX=aarch64-linux-gnu- build -j$(nproc) -s -n 0 -a AARCH64 -t GCC5 -p MiA2Pkg/MiA2Pkg.dsc
gzip -c < workspace/Build/MiA2Pkg/DEBUG_GCC5/FV/MIA2PKG_UEFI.fd >uefi_image
cat ginkgo.dtb >>uefi_image
python3 ./mkbootimg.py \
  --kernel ./ImageResources/bootpayload.bin \
  --ramdisk ./ImageResources/ramdisk \
  --kernel_offset 0x00000000 \
  --ramdisk_offset 0x00000000 \
  --tags_offset 0x00000000 \
  --os_version 13.0.0 \
  --os_patch_level "$(date '+%Y-%m')" \
  --header_version 1 \
  -o uefi.img \
  ||_error "\nFailed to create Android Boot Image!\n"