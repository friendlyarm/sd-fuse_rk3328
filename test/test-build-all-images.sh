#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3328
cd sd-fuse_rk3328

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlycore-focal-arm64-images.tgz
tar xzf friendlycore-focal-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/buildroot-images.tgz
tar xzf buildroot-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

./mk-sd-image.sh friendlycore-focal-arm64
./mk-emmc-image.sh friendlycore-focal-arm64

./mk-sd-image.sh buildroot
./mk-emmc-image.sh buildroot

./mk-emmc-image.sh buildroot filename=buildroot-auto-eflasher.img autostart=yes

echo "done."
