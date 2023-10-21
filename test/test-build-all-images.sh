#!/bin/bash
set -eux

HTTP_SERVER=112.124.9.243

# hack for me
PCNAME=`hostname`
if [ x"${PCNAME}" = x"tzs-i7pc" ]; then
       HTTP_SERVER=127.0.0.1
fi

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git -b master sd-fuse_rk3328
cd sd-fuse_rk3328


wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlycore-lite-focal-arm64-images.tgz
tar xzf friendlycore-lite-focal-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/debian-bullseye-core-arm64-images.tgz
tar xzf debian-bullseye-core-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/openmediavault-arm64-images.tgz
tar xzf openmediavault-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlywrt23-images.tgz
tar xzf friendlywrt23-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlywrt22-images.tgz
tar xzf friendlywrt22-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlywrt21-images.tgz
tar xzf friendlywrt21-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz


./mk-sd-image.sh friendlycore-lite-focal-arm64
./mk-emmc-image.sh friendlycore-lite-focal-arm64

./mk-sd-image.sh debian-bullseye-core-arm64
./mk-emmc-image.sh debian-bullseye-core-arm64

./mk-sd-image.sh openmediavault-arm64
./mk-emmc-image.sh openmediavault-arm64

./mk-sd-image.sh friendlywrt23
./mk-emmc-image.sh friendlywrt23

./mk-sd-image.sh friendlywrt22
./mk-emmc-image.sh friendlywrt22

./mk-sd-image.sh friendlywrt21
./mk-emmc-image.sh friendlywrt21

./mk-emmc-image.sh friendlycore-lite-focal-arm64 filename=friendlycore-lite-focal-auto-eflasher.img autostart=yes

echo "done."
