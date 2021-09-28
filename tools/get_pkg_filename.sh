#!/bin/bash

TARGET_OS=$1
case ${TARGET_OS} in
friendlywrt)
        ROMFILE=friendlywrt-images.tgz;;
friendlycore-lite-focal-arm64)
        ROMFILE=friendlycore-lite-focal-arm64-images.tgz;;
eflasher)
        ROMFILE=emmc-flasher-images.tgz;;
*)
	ROMFILE=
esac
echo $ROMFILE
