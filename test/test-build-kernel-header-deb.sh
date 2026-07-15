#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3328/images
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3328/images
fi
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi4-v4.19.y

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
	wget ${CDN_URL}/friendlycore-focal-arm64-images.tgz
	tar xvzf friendlycore-focal-arm64-images.tgz
fi

if [ -f ../../kernel-RK3328.tgz ]; then
	tar xvzf ../../kernel-RK3328.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-RK3328
fi

MK_HEADERS_DEB=1 KERNEL_SRC=$PWD/kernel-RK3328 ./build-kernel.sh friendlycore-focal-arm64
