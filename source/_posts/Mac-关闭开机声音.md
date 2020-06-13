title: Mac 关闭开机声音
author: Joe Tong
date: 2019-07-22 09:08:31
tags:
  - MAC
categories:
  - SYSTEM
---
苹果 Mac系统如何关闭开机声音？  
1、打开 “应用程序” ，打开“实用工具”，找到并打开[终端]程序，然后输入如下命令并回车（注意，复制的时候不要多复制了空格）： &amp;nbsp;
`sudo nvram SystemAudioVolume=%80`  

2、之后会提示输入密码，输入你的用户密码，回车，如下图。这样之后再次启动Mac的时候就是完全静音的了。
（注意：输入密码是看不到的，不像普通的输入密码那样能看到，你只管输就可以了，输入完按回车。）

3、如果想要恢复正常的开机声音，只要在终端中再次输入如下命令即可：
`sudo nvram -d SystemAudioVolume`


