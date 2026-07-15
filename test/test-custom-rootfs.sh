#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3328/images
    ROOTFS_URL=http://cdn.local/friendlyelec-cdn/rootfs/rk3328
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3328/images
    ROOTFS_URL=https://downloads.friendlyelec.com/rootfs/rk3328
fi
# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3328
cd sd-fuse_rk3328
wget ${CDN_URL}/ubuntu-noble-core-arm64-images.tgz
tar xzf ubuntu-noble-core-arm64-images.tgz
wget ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget ${ROOTFS_URL}/rootfs-ubuntu-noble-core-arm64.tgz
wget ${ROOTFS_URL}/rootfs-ubuntu-noble-core-arm64.tgz.sha256
sha256sum -c rootfs-ubuntu-noble-core-arm64.tgz.sha256

sudo tar xzfp rootfs-ubuntu-noble-core-arm64.tgz --numeric-owner --same-owner
sudo ./build-rootfs-img.sh ubuntu-noble-core-arm64/rootfs ubuntu-noble-core-arm64

./mk-sd-image.sh ubuntu-noble-core-arm64
./mk-emmc-image.sh ubuntu-noble-core-arm64
