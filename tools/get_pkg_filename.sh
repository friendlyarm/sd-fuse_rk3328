#!/bin/bash

TARGET_OS=$1
case ${TARGET_OS} in
buildroot)
        ROMFILE=buildroot-images.tgz;;
eflasher)
        ROMFILE=emmc-flasher-images.tgz;;
*)
	ROMFILE=unsupported-${TARGET_OS}.tgz
esac
echo $ROMFILE
