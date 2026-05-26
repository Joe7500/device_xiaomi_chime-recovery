
OFOX_BUILD_PATH=`pwd`
OFOX_BRANCH=12.1

if echo "$@" | grep sync ; then
   if ls .repo ; then
      if ! grep twrp-12 .repo/manifests/.git/config ; then
         echo "ERROR: wrong repo?"
         exit 1
      fi
   if
   rm -rf bootable/recovery/ vendor/recovery/ sync/
   git clone https://gitlab.com/OrangeFox/sync.git
   cd sync
   ./orangefox_sync.sh --branch $OFOX_BRANCH --path "$OFOX_BUILD_PATH"
   git clone https://gitlab.com/OrangeFox/misc/scripts
   cd "$OFOX_BUILD_PATH"
   rm -rf device/xiaomi/chime
   git clone https://github.com/Joe7500/device_xiaomi_chime-recovery -b fox-12.0 device/xiaomi/chime
fi

source build/envsetup.sh
bash device/xiaomi/chime/vendorsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=chime
export LC_ALL="C"
lunch twrp_chime-eng && make clean && mka adbd recoveryimage -j$(nproc --all)
