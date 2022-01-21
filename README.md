# sd-fuse_rk3328 for kernel-4.19
Create bootable SD card for NanoPi R2S/NanoPi R2C/NanoPi R2C Plus/NanoPi NEO3
  
***Note: Since RK3328 contains multiple different versions of kernel and uboot, please refer to the table below to switch this repo to the specified branch according to the OS***  
| OS                                     | branch          | image directory name                  |
| -------------------------------------- | --------------- | ------------------------------------- |
| [ ]friendlywrt                         | kernel-5.15.y   | friendlywrt                           |
| [*]buildroot                           | kernel-4.19     | buildroot                             |
| [*]friendlycore focal                  | kernel-4.19     | friendlycore-focal-arm64              |
| [ ]friendlycore lite focal             | kernel-5.15.y   | friendlycore-lite-focal-arm64         |

  
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
sudo ./fusing.sh /dev/sdX buildroot
```
You can build the following OS: buildroot.  
Because the android system has to run on the emmc, so you need to make eflasher img to install Android.  

Notes:  
fusing.sh will check the local directory for a directory with the same name as OS, if it does not exist fusing.sh will go to download it from network.  
So you can download from the netdisk in advance, on netdisk, the images files are stored in a directory called images-for-eflasher, for example:
```
cd sd-fuse_rk3328
tar xvzf ../images-for-eflasher/buildroot-images.tgz
sudo ./fusing.sh /dev/sdX buildroot
```

