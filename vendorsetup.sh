#!/bin/bash
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2021 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
FDEVICE="chime"
#set -o xtrace

fox_get_target_device() {
	local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
	if [ -n "$chkdev" ]; then
		FOX_BUILD_DEVICE="$FDEVICE"
	else
		chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
		[ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
	fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
	fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
	# Language and locale
	export TW_DEFAULT_LANGUAGE="en"
	export LC_ALL="C"
	export TARGET_DEVICE_ALT="citrus, lime, lemon, pomelo, juice, chime"
	export ALLOW_MISSING_DEPENDENCIES=true
	# Partition settings
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export FOX_RECOVERY_SYSTEMEXT_PARTITION="/dev/block/mapper/system_ext"
	export FOX_RECOVERY_PRODUCT_PARTITION="/dev/block/mapper/product"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
	export FOX_RECOVERY_ODM_PARTITION="/dev/block/mapper/odm"
	# OrangeFox features
	export OF_USE_GREEN_LED="0"
	export OF_USE_MAGISKBOOT="1"
	export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES="1"
	export OF_DONT_PATCH_ENCRYPTED_DEVICE="1"
	export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER="1"
	export OF_NO_TREBLE_COMPATIBILITY_CHECK="1"
	export OF_NO_MIUI_PATCH_WARNING="1"
	export OF_IGNORE_LOGICAL_MOUNT_ERRORS="1"
	export OF_FBE_METADATA_MOUNT_IGNORE="1"
	export FOX_ENABLE_APP_MANAGER="1"
	export OF_ENABLE_FRP_ADDON="1"
	export FOX_USE_BUSYBOX_BINARY="1"
	export OF_DEFAULT_KEYMASTER_VERSION="4.1"
	export OF_ADVANCED_SECURITY="1"
	# Shell and utilities
	export FOX_USE_BASH_SHELL="1"
	export FOX_ASH_IS_BASH="1"
	export FOX_USE_TAR_BINARY="1"
	export FOX_USE_SED_BINARY="1"
	export FOX_USE_XZ_UTILS="1"
	export FOX_USE_NANO_EDITOR="1"
	# Backup and OTA
	export OF_QUICK_BACKUP_LIST="/boot;/dtbo;/vbmeta;/vbmeta_system;/system_image;/system_ext_image;/vendor_image;/product_image;"
	export OF_KEEP_DM_VERITY="1"
	export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES="1"
	export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR="1"
	export OF_DISABLE_MIUI_OTA_BY_DEFAULT="1"
	export FOX_DELETE_AROMAFM="1"
	export FOX_BUGGED_AOSP_ARB_WORKAROUND="1546300800"
	# Try to prevent potential data format errors
	export OF_UNBIND_SDCARD_F2FS="1"
	# Screen settings
	export OF_SCREEN_H="2340"
	export OF_STATUS_H="80"
	export OF_STATUS_INDENT_LEFT="55"
	export OF_STATUS_INDENT_RIGHT="55"
	export OF_HIDE_NOTCH="1"
	export OF_CLOCK_POS="1"
	# F2FS compression
	export OF_ENABLE_FS_COMPRESSION="1"
	# Avoid decryption problems on some devices and ROMs
	export OF_FIX_DECRYPTION_ON_DATA_MEDIA="1"
	# Patch avb20 - some ROM recoveries try to overwrite custom recoveries
	export OF_PATCH_AVB20="1"
	# Support disabling avb2.0 by patching vbmeta/vbmeta_system
	export OF_SUPPORT_VBMETA_AVB2_PATCHING="1"
	# Disable automatic rebooting after openrecoveryscript finishes
	export OF_DISABLE_ORS_AUTO_REBOOT="1"

	# R11.3 Settings
	export FOX_MAINTAINER_PATCH_VERSION="15"
	export OF_MAINTAINER="Joe7500"
	export OF_MAINTAINER_AVATAR="device/xiaomi/chime/icon.png"

	# Custom maintainer avatar
	cp -v device/xiaomi/chime/icon.png bootable/recovery/gui/theme/portrait_hdpi/images/Default/About/maintainer.png

	# Set Dark as default theme
	cp -v bootable/recovery/gui/theme/portrait_hdpi/themes/styles/Dark.xml bootable/recovery/gui/theme/portrait_hdpi/themes/style.xml

	# Enable navbar (old style navigation)
	echo '<?xml version="1.0"?>
        <recovery>
        <variables>
                <variable name="navbar_disable" value="0"/>
                <variable name="navbar_disable_add" value="0"/>
                <variable name="screen_h" value="2340"/>
                <variable name="real_gestures_enable" value="0"/>
        </variables>
        </recovery>' >bootable/recovery/gui/theme/portrait_hdpi/themes/navbar.xml

	# Let's see what are our build VARs
	if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
		export | grep "FOX" >>$FOX_BUILD_LOG_FILE
		export | grep "OF_" >>$FOX_BUILD_LOG_FILE
		export | grep "TARGET_" >>$FOX_BUILD_LOG_FILE
		export | grep "TW_" >>$FOX_BUILD_LOG_FILE
	fi
fi
