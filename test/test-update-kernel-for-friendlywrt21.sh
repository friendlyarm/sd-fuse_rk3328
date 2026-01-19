#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi-r2-v6.6.y

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3328
cd sd-fuse_rk3328
if [ -f ../../friendlywrt21-images.tgz ]; then
	tar xvzf ../../friendlywrt21-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlywrt21-images.tgz
    tar xvzf friendlywrt21-images.tgz
fi

if [ -f ../../kernel-rk3328.tgz ]; then
	tar xvzf ../../kernel-rk3328.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3328
fi

KERNEL_SRC=$PWD/kernel-rk3328 ./build-kernel.sh friendlywrt21
sudo ./mk-sd-image.sh friendlywrt21
