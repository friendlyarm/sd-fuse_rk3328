#!/bin/bash
set -eux

HTTP_SERVER=112.124.9.243

# hack for me
PCNAME=`hostname`
if [ x"${PCNAME}" = x"tzs-i7pc" ]; then
       HTTP_SERVER=192.168.1.9
fi

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git -b kernel-4.19 sd-fuse_rk3328
cd sd-fuse_rk3328

wget http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlycore-focal-arm64-images.tgz
tar xzf friendlycore-focal-arm64-images.tgz

wget http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/buildroot-images.tgz
tar xzf buildroot-images.tgz

wget http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

./mk-sd-image.sh friendlycore-focal-arm64
./mk-emmc-image.sh friendlycore-focal-arm64

./mk-sd-image.sh buildroot
./mk-emmc-image.sh buildroot

./mk-emmc-image.sh buildroot filename=buildroot-auto-eflasher.img autostart=yes

echo "done."
