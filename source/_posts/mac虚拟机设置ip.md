title: mac虚拟机设置ip
author: Joe Tong
tags:
  - MAC
categories:  
  - SYSTEM 
date:  2019-12-02 19:48:55 
---
Mac 以太网连接 报无效的服务器地址 BasicIPv6ValidationError
用Mac这么久，一直是用WiFi连接网络，没搞过以太网连接，我也是醉了

显然 Mac 不能像 Windows 一样，插入网线就可以自动连接网络。需要设置一下IP地址

然后悲伤的事情发生了，显示无效的服务器地址  BasicIPv6ValidationError 

解决方案：

思路是这样的：先关闭IPv6，然后设置IPv4，再重新开启IPv6。

update 2017.03.14  我发现其实可以直接用命令行修改IPv4，不用管IPv6，如果它没报错的话

1. 关闭 IPv6

显然 ”高级“ &gt; "TCP/IP" 下 IPv6 没有提供关闭选项，所以需要用终端命令  网络命令参看这里

终端输入：networksetup -setv6off Ethernet

这时候系统会弹窗要求输入密码，搞定后你会发现 ”高级“ &gt; "TCP/IP" 下 IPv6 多了个关闭选项
2. 设置IPv4地址

终端输入：networksetup -setmanual Ethernet 192.168.31.2 255.255.255.0 192.168.1.1

对应IP地址、子网掩码、路由器

设置完成后，可以看到，以太网显示状态是：已连接


这个时候已经连接网络了，如果还不能正常上网，比如我是 QQ可以连接，但网页打不开，说明 DNS 有问题



3. 设置DNS




