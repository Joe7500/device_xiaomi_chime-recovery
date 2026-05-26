
# Build FBE v2
source build/envsetup.sh
bash device/xiaomi/chime/vendorsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=chime
export LC_ALL="C"
lunch twrp_chime-eng && make clean && mka adbd recoveryimage -j$(nproc --all)

if [ $? -ne 0 ]; then exit 1; fi

cp out/target/product/chime/Orange*.zip .

# Build FBE v1
cp device/xiaomi/chime/recovery/root/system/etc/recovery.fstab.bak device/xiaomi/chime/recovery/root/system/etc/recovery.fstab

source build/envsetup.sh
bash device/xiaomi/chime/vendorsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=chime
export LC_ALL="C"
lunch twrp_chime-eng && make clean && mka adbd recoveryimage -j$(nproc --all)

if [ $? -ne 0 ]; then exit 1; fi

FZIP_PATH=$(ls -1tr out/target/product/chime/Orange*.zip | tail -1)
FIMG_PATH=$(ls -1tr out/target/product/chime/Orange*.img | tail -1)
FZIP_NAME=$(basename "$FZIP_PATH")
FIMG_NAME=$(basename "$FIMG_PATH")
FZIP_NAME_PREFIX=$(echo "$FZIP_NAME" | cut -d '-' -f 1-3)
FZIP_NAME_SUFFIX=$(echo "$FZIP_NAME" | cut -d '-' -f 4-)
FIMG_NAME_PREFIX=$(echo "$FIMG_NAME" | cut -d '-' -f 1-3)
FIMG_NAME_SUFFIX=$(echo "$FIMG_NAME" | cut -d '-' -f 4-)

cp "$FZIP_PATH" "$FZIP_NAME_PREFIX"-"fbeV1-""$FZIP_NAME_SUFFIX"
cp "$FIMG_PATH" "$FIMG_NAME_PREFIX"-"fbeV1-""$FIMG_NAME_SUFFIX"

