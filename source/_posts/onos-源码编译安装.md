title: onos-buck 源码编译安装
author: Joe Tong
tags:
  - JAVAEE
  - ONOS
categories:
  - IT
date: 2019-07-20 02:29:00
---
老版本  onos-buck
ONOS新版本源码安装方式 
发表于 2017-03-08   |   分类于 项目展示   |     |    访问量: 
1.安装JDK（从Oracle官网下载，不要用OpenJDK）
1.Download and Extract JDK package, such as jdk-8u121-linux-x64.tar.gz.
`
tar -xzf jdk-8u121-linux-x64.tar.gz`

and you can see new directory /home/yourname/jdk1.8.0_121. 
2.Add two environment variables into ~/.bashrc or /etc/profile:

```
export JAVA_HOME=/home/yourname/jdk1.8.0_121
export PATH=${JAVA_HOME}/bin:$PATH
```

3.Save and open a new terminal, go on next step.
```
sudo apt-get install software-properties-common -y && \
sudo add-apt-repository ppa:webupd8team/java -y && \
sudo apt-get update && \
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections && \
sudo apt-get install oracle-java8-installer oracle-java8-set-default -y
```
2.下载源码并编译
```
git clone https://gerrit.onosproject.org/onos
cd onos #之后的命令均在此目录下
tools/build/onos-buck build onos --show-output
```
正常的话，会打印出.tar.gz目录，这个就是二进制安装文件。
3.本地运行ONOS
`tools/build/onos-buck run onos-local -- clean debug`
以上命令将会从本地的 onos.tar.gz文件中进行本地安装，并在后台开启ONOS服务。在终端上将会持续打出ONOS的日志内容。clean选项会使其进行ONOS的清洁安装，而debug选项意为默认调试端口5005将会开启。
4.设置环境变量
在/etc/profile中添加： 
```
export ONOS_ROOT=/home/yourname/onos
source $ONOS_ROOT/tools/dev/bash_profile
```
5.开启ONOS的CLI控制台
在本地开启ONOS之后，在新的终端执行以下命令：
`tools/test/bin/onos localhost`
6.开启ONOS的GUI界面
在本地开启ONOS之后，在新的终端执行以下命令： 
`tools/test/bin/onos-gui localhost`
#（实际执行了open http://$host:8181/onos/ui，Ubuntu不支持，
#出错Couldn't get a file descriptor referring to the console）
或者访问http://localhost:8181/onos/ui （推荐）
默认用户名onos，密码rocks
7.ONOS单元测试  
To execute ONOS unit tests, including code Checkstyle validation, run the following command:   
`tools/build/onos-buck test`  
8.导入工程到IDE`  
If you want to import the project into IntelliJ, you can generate the hierarchical module structure via the following command:` 
`tools/build/onos-buck project`

Then simply open the onos directory from IntelliJ IDEA.