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
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/ubuntu-noble-core-arm64-images.tgz
tar xzf ubuntu-noble-core-arm64-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/rootfs/rootfs-ubuntu-noble-core-arm64.tgz

TEMPSCRIPT=`mktemp script.XXXXXX`
cat << 'EOL' > $PWD/$TEMPSCRIPT
#!/bin/bash
tar xzf rootfs-ubuntu-noble-core-arm64.tgz --numeric-owner --same-owner
echo hello > ubuntu-noble-core-arm64/rootfs/root/welcome.txt
./build-rootfs-img.sh ubuntu-noble-core-arm64/rootfs ubuntu-noble-core-arm64
EOL
chmod 755 $PWD/$TEMPSCRIPT
if [ $(id -u) -ne 0 ]; then
    ./tools/fakeroot-ng $PWD/$TEMPSCRIPT
else
    $PWD/$TEMPSCRIPT
fi
rm $PWD/$TEMPSCRIPT

./mk-sd-image.sh ubuntu-noble-core-arm64
./mk-emmc-image.sh ubuntu-noble-core-arm64
