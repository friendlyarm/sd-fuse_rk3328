#!/bin/bash

TARGET_OS=$1
case ${TARGET_OS} in
buildroot)
        ROMFILE=buildroot-images.tgz;;
friendlycore-focal-arm64)
        ROMFILE=friendlycore-focal-arm64-images.tgz;;
debian-*)
        ROMFILE=${TARGET_OS%-*}-arm64-images.tgz;;
eflasher)
        ROMFILE=emmc-flasher-images.tgz;;
*)
    ROMFILE=unsupported-${TARGET_OS}.tgz
esac
echo $ROMFILE
