#!/bin/bash
set -eu

[ -f ${PWD}/mk-emmc-image.sh ] || {
	echo "Error: please run at the script's home dir"
	exit 1
}

TOP=$PWD
true ${SOC:=rk3328}
KIMG=kernel.img
KDTB=resource.img
OUT=${PWD}/out

UBOOT_DIR=$1
KERNEL_DIR=$2
BOOT_DIR=$3
ROOTFS_DIR=$4
PREBUILT=$5
TARGET_OS=$6


# kernel bin
KMODULES_OUTDIR="${OUT}/output_${SOC}_kmodules"
(cd ${KERNEL_DIR} && {
	cp ${KIMG} ${KDTB} ${TOP}/${TARGET_OS}/
})

# rootfs
rm -rf ${ROOTFS_DIR}/lib/modules/*
(cd ${KMODULES_OUTDIR}/lib/ && {
        tar -cf - * | tar -xf - -p --same-owner --numeric-owner -C `readlink -f ${ROOTFS_DIR}/lib`
})

# firmware
cp -avf ${PREBUILT}/firmware/etc ${ROOTFS_DIR}/
cp -avf ${PREBUILT}/firmware/system ${ROOTFS_DIR}/
if [ -d ${ROOTFS_DIR}/lib ]; then
    cp -avf ${PREBUILT}/firmware/usr/lib/* ${ROOTFS_DIR}/lib
else
    cp -avf ${PREBUILT}/firmware/usr ${ROOTFS_DIR}/
fi

exit 0
