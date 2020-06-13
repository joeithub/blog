title: Mac格式化u盘和dmg
author: Joe Tong
tags:
  - MAC
categories:
  - SYSTEM
date: 2019-10-29 10:26:00
---
2.格式化U盘

这个U盘最好选择一个USB3.0版本、8G或16G内存的。

3.将ISO文件转换为dmg格式

执行命令

cd /users/用户名/下载文件夹
hdiutil convert AAAA.iso -format UDRW -o BBBBB.dmg&nbsp; &nbsp; //AAAA为你下载ISO镜像的名字；BBBBB你随意取就好
4.制作启动U盘

diskutil list

diskutil unmountDisk /dev/diskN&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; //N为上面命令中显示出的你U盘的序号，一般是2。

sudo dd if =BBBBB.dmg of=/dev/rdiskN bs=2m&nbsp; &nbsp; &nbsp; &nbsp; //N同样为你U盘的序号

