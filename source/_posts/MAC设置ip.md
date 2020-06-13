title: MAC设置ip
author: Joe Tong
tags:
  - MAC
categories:  
  - SYSTEM
date: 2020-03-19 10:02:13
---

BasicIPv6ValidationError解决办法

打开终端按如下命令操作

1.列出你的网卡

networksetup -listallnetworkservices

2.关闭ipv6

networksetup -setv6off "你网卡名字"

3.设置ip地址

networksetup -setmanual "网卡名字" 192.168.31.2 255.255.255.0 192.168.1.1

