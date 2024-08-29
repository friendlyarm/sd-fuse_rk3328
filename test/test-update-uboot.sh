#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
UBOOT_REPO=https://github.com/friendlyarm/uboot-rockchip
UBOOT_BRANCH=nanopi4-v2017.09

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3328
cd sd-fuse_rk3328
if [ -f ../../ubuntu-noble-core-arm64-images.tgz ]; then
	tar xvzf ../../ubuntu-noble-core-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/ubuntu-noble-core-arm64-images.tgz
    tar xvzf ubuntu-noble-core-arm64-images.tgz
fi

git clone ${UBOOT_REPO} --depth 1 -b ${UBOOT_BRANCH} uboot-rk3328
UBOOT_SRC=$PWD/uboot-rk3328 ./build-uboot.sh ubuntu-noble-core-arm64
sudo ./mk-sd-image.sh ubuntu-noble-core-arm64
