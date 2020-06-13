title: onos ENV
author: Joe Tong
tags:
  - ONOS
  - JAVAEE
categories:
  - IT
date: 2019-08-10 13:19:00
---
虚拟机开发  
搭建所采用的是SDNHUB上封好的VirtualBox虚拟机（页面上有虚拟机账号密码），下载地址为：http://sdnhub.org/tutorials/sdn-tutorial-vm/  

开始搭建：

1：在第一次启动的话，默认会打开火狐浏览器和一个终端，并且会提示是否更新系统（我和同事都选的否）。

2：在终端中输入（因为onos目录直接在~/下，打开终端直接依此输入以下命令）：
```
$ cd onos
$ source ./tools/dev/bash_profile 
$ echo $KARAF_ROOT
$ mvn clean install -nsu -DskipIT -DskipTests
$ onos-setup-karaf clean
$ ok clean

http://localhost:8181/onos/ui/index.html
自带eclipse
```

<hr/>

真机开发  
1.check out source code 
```
git clone https://gerrit.onosproject.org/onos/
cd onos  
source tools/dev/bash_profile 设置环境量  
bazel build onos 编译onos  
bazel test 测试  
bazel run onos-local 在后台启动  
onos localhost 进入后台可以  
onos-gui localhost   即可跳到gui页面 username:onos password:rocks

导入idea
bazel project
```
2.设置环境变量
```
vi ～/.bash_profile
export ONOS_ROOT=~/onos/
source $ONOS_ROOT/tools/dev/bash_profile
```
1.查看下本地IP
2.设置环境变量
export ONOS_IP=本地IP
3.启动onos
onos-karaf clean