# sd-fuse_rk3328
Create bootable SD card for NanoPi R2S/NanoPi NEO3

## How to find the /dev name of my SD Card
Unplug all usb devices:
```
ls -1 /dev > ~/before.txt
```
plug it in, then
```
ls -1 /dev > ~/after.txt
diff ~/before.txt ~/after.txt
```

## Build friendlycore bootable SD card
```
git clone https://github.com/friendlyarm/sd-fuse_rk3328.git -b kernel-4.19
cd sd-fuse_rk3328
sudo ./fusing.sh /dev/sdX friendlycore-arm64
```
You can build the following OS: friendlycore-focal-arm64, friendlycore-lite-focal-arm64.  
Because the android system has to run on the emmc, so you need to make eflasher img to install Android.  

Notes:  
fusing.sh will check the local directory for a directory with the same name as OS, if it does not exist fusing.sh will go to download it from network.  
So you can download from the netdisk in advance, on netdisk, the images files are stored in a directory called images-for-eflasher, for example:
```
cd sd-fuse_rk3328
tar xvzf ../images-for-eflasher/friendlycore-lite-focal-arm64-images.tgz
sudo ./fusing.sh /dev/sdX friendlycore-lite-focal-arm64
```

