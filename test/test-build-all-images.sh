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
git clone ../../.git -b master sd-fuse_rk3328
cd sd-fuse_rk3328


wget http://${HTTP_SERVER}/dvdfiles/rk3328/images-for-eflasher/friendlycore-lite-focal-arm64-images.tgz
tar xzf friendlycore-lite-focal-arm64-images.tgz

wget http://${HTTP_SERVER}/dvdfiles/rk3328/images-for-eflasher/friendlywrt-images.tgz
tar xzf friendlywrt-images.tgz

wget http://${HTTP_SERVER}/dvdfiles/rk3328/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz


./mk-sd-image.sh friendlycore-lite-focal-arm64
./mk-emmc-image.sh friendlycore-lite-focal-arm64

./mk-sd-image.sh friendlywrt
./mk-emmc-image.sh friendlywrt

./mk-emmc-image.sh friendlycore-lite-focal-arm64 filename=friendlycore-lite-focal-auto-eflasher.img autostart=yes

echo "done."
