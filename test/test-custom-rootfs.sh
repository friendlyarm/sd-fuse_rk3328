#!/bin/bash
set -eu

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
git clone ../../.git sd-fuse_rk3328
cd sd-fuse_rk3328
wget http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlycore-lite-focal-arm64-images.tgz
tar xzf friendlycore-lite-focal-arm64-images.tgz
wget http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget http://${HTTP_SERVER}/dvdfiles/RK3328/rootfs/rootfs-friendlycore-lite-focal-arm64.tgz

TEMPSCRIPT=`mktemp script.XXXXXX`
cat << 'EOL' > $PWD/$TEMPSCRIPT
#!/bin/bash
tar xzf rootfs-friendlycore-lite-focal-arm64.tgz --numeric-owner --same-owner
echo hello > friendlycore-lite-focal-arm64/rootfs/root/welcome.txt
./build-rootfs-img.sh friendlycore-lite-focal-arm64/rootfs friendlycore-lite-focal-arm64
EOL
chmod 755 $PWD/$TEMPSCRIPT
if [ $(id -u) -ne 0 ]; then
    ./tools/fakeroot-ng $PWD/$TEMPSCRIPT
else
    $PWD/$TEMPSCRIPT
fi
rm $PWD/$TEMPSCRIPT

./mk-sd-image.sh friendlycore-lite-focal-arm64
sudo ./mk-emmc-image.sh friendlycore-lite-focal-arm64
