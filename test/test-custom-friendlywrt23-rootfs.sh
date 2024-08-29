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
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlywrt23-images.tgz
tar xzf friendlywrt23-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/rootfs/rootfs-friendlywrt23.tgz

sudo tar xzfp rootfs-friendlywrt23.tgz --numeric-owner --same-owner
sudo ./build-rootfs-img.sh rootfs-friendlywrt23 friendlywrt23

./mk-sd-image.sh friendlywrt23
./mk-emmc-image.sh friendlywrt23 autostart=yes
