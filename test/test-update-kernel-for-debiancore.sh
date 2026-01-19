#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi-r2-v6.6.y

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3328
cd sd-fuse_rk3328

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

if [ -f ../../debian-trixie-core-arm64-images.tgz ]; then
	tar xvzf ../../debian-trixie-core-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/debian-trixie-core-arm64-images.tgz
    tar xvzf debian-trixie-core-arm64-images.tgz
fi

if [ -f ../../kernel-rk3328.tgz ]; then
	tar xvzf ../../kernel-rk3328.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3328
fi

wget http://${HTTP_SERVER}/sd-fuse/kernel-3rd-drivers.tgz
if [ -f kernel-3rd-drivers.tgz ]; then
	pushd out
	tar xzf ../kernel-3rd-drivers.tgz
	popd
fi

KERNEL_SRC=$PWD/kernel-rk3328 ./build-kernel.sh debian-trixie-core-arm64
sudo ./mk-sd-image.sh debian-trixie-core-arm64
