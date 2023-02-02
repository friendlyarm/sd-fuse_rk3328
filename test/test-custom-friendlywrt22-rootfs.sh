#!/bin/bash
set -eu

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
git clone ../../.git sd-fuse_rk3328
cd sd-fuse_rk3328
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlywrt22-images.tgz
tar xzf friendlywrt22-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/rootfs/rootfs-friendlywrt22.tgz

TEMPSCRIPT=`mktemp script.XXXXXX`
cat << 'EOL' > $PWD/$TEMPSCRIPT
#!/bin/bash
tar xzf rootfs-friendlywrt22.tgz --numeric-owner --same-owner
echo hello > rootfs-friendlywrt22/root/welcome.txt
./build-rootfs-img.sh rootfs-friendlywrt22 friendlywrt22
EOL
chmod 755 $PWD/$TEMPSCRIPT
if [ $(id -u) -ne 0 ]; then
    ./tools/fakeroot-ng $PWD/$TEMPSCRIPT
else
    $PWD/$TEMPSCRIPT
fi
rm $PWD/$TEMPSCRIPT

./mk-sd-image.sh friendlywrt22
./mk-emmc-image.sh friendlywrt22 autostart=yes
