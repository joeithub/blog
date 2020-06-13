title: command num of  file  for linux
author: Joe Tong
tags:
  - LINUX
  - SHELL
categories:
  - IT
date: 2019-07-17 16:41:00
---
linux 下查看文件个数及大小
查看当前目录下的文件数量：

ls -l |grep "^-"|wc -l

或

find ./company -type f | wc -l

查看某文件夹下文件的个数，包括子文件夹里的。

ls -lR|grep "^-"|wc -l

查看某文件夹下文件夹的个数，包括子文件夹里的。

ls -lR|grep "^d"|wc -l

说明：

ls -l

长列表输出该目录下文件信息(注意这里的文件，不同于一般的文件，可能是目录、链接、设备文件等)

grep "^-"

这里将长列表输出信息过滤一部分，只保留一般文件，如果只保留目录就是 ^d

wc -l

统计输出信息的行数，因为已经过滤得只剩一般文件了，所以统计结果就是一般文件信息的行数，又由于

一行信息对应一个文件，所以也就是文件的个数。

 

linux查看文件大小：

du -sh 查看当前文件夹大小

du -sh * | sort -n 统计当前文件夹(目录)大小，并按文件大小排序

du -sk filename 查看指定文件大小


