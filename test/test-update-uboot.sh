#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
UBOOT_URL=https://github.com/friendlyarm/uboot-rockchip
UBOOT_BRANCH=nanopi4-v2017.09

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git -b kernel-4.19 sd-fuse_rk3328
cd sd-fuse_rk3328
if [ -f ../../friendlycore-focal-arm64-images.tgz ]; then
	tar xvzf ../../friendlycore-focal-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlycore-focal-arm64-images.tgz
	tar xvzf friendlycore-focal-arm64-images.tgz
fi

git clone ${UBOOT_URL} --depth 1 -b ${UBOOT_BRANCH} uboot-RK3328
UBOOT_SRC=$PWD/uboot-RK3328 ./build-uboot.sh friendlycore-focal-arm64
./mk-sd-image.sh friendlycore-focal-arm64
