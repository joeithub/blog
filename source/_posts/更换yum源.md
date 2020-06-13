title: 更换yum源rpmbuild包制作
author: Joe Tong
tags:
  - CENTOS
  - REPO
categories:  
  - SYSTEM
date: 2019-12-26 19:12:18
---


更换yum源
163yum源：
1）备份当前yum源防止出现意外还可以还原回来

cd /etc/yum.repos.d/
cp /CentOS-Base.repo /CentOS-Base-repo.bak
2）使用wget下载163yum源repo文件

wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
3) 清理旧包

yum clean all
4）把下载下来163repo文件设置成为默认源

mv CentOS7-Base-163.repo CentOS-Base.repo
5）生成163yum源缓存并更新yum源

yum makecache
yum update
阿里云yum源：
1）备份当前yum源防止出现意外还可以还原回来

cd /etc/yum.repos.d/
cp /CentOS-Base.repo /CentOS-Base-repo.bak
2）使用wget下载阿里yum源repo文件

wget http://mirrors.aliyun.com/repo/Centos-7.repo
3) 清理旧包

yum clean all
4）把下载下来阿里云repo文件设置成为默认源


mv Centos-7.repo CentOS-Base.repo
5）生成阿里云yum源缓存并更新yum源

yum makecache
yum update


1,查找rpm-build，并安装

1）yum 安装

yum list |grep rpm-build 查找合适的rpm-build包
yum install -y&nbsp;rpm-build.x86_64&nbsp;

2）非yum 安装&nbsp;
如果没有yum源，可以先将rpm-build.rpm 下载到本地，下载rpm-build的时候，需要安装和操作系统版本一致的。否则会提示错误。比如我的系统如下：&nbsp;

Linux sjs_78_213 2.6.32-220.17.1.el6.x86_64 #1 SMP Thu Apr 26 13:37:13 EDT 2012 x86_64 x86_64 x86_64 GNU/Linux&nbsp;

对应的rpm包是 ：rpm-build-4.8.0-19.el6_2.1.x86_64.rpm &nbsp;。
查找rpm包可以到 http://rpm.pbone.net/ &nbsp;

下载rpm包 ：&nbsp;
wget&nbsp;ftp://ftp.pbone.net/mirror/ftp.scientificlinux.org/linux/scientific/6.0/x86_64/updates/security/rpm-build-4.8.0-19.el6_2.1.x86_64.rpm&nbsp;

安装 &nbsp; rpm -ivh&nbsp;rpm-build-4.8.0-19.el6_2.1.x86_64.rpm&nbsp;&nbsp;


2,创建一个普通用户，以普通用户打包
最好以普通用户打包，否则会有一些稀奇古怪的问题。
adduser wang&nbsp;
su - wang
mkdir -p /home/wang/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

echo "%_topdir&nbsp; /home/wang/rpmbuild" &gt;~/.rpmmacros&nbsp;&nbsp;

rpmbuild --showrc|grep _topdir

cd&nbsp;&nbsp;/home/wang/rpmbuild/SPECS&nbsp;
rpmbuild -ba&nbsp; dteworker-client.spec &nbsp;

一个完整的rpmbuild目录可以下载http://download.csdn.net/detail/wisgood/8384763，然后解压,打包即可。

rpmbuild用法
利用rpmbuild打包，需要两类文件：1、源码，源码以tar归档进行压缩的源码包，以及一些.patch文件，存放于目录./SOURCES下；2、.spec文件，定义了打包的动作，以及依赖，是打包的最主要类容。

首先介绍SPEC文件：

SPEC文件的一些语法： 

.spec中的条件判断语句有两种：
1、if结构
引用
%if %{str}
%else
       动作
%endif
其中%{str}是条件，0为假，非0为真。
2、?:结构
引用
%{?变量:动作1}动作2
其中{}用于控制范围，而“？”号和“：”号是分割符，如果要判断条件是非的情况，可以在“？”号前加“！”号。
此条件与前面的%if有点不同，其只判断变量是否定义，定义了就为真，否则就为假，即使变量定义为0，也为真，并运行后面的语句。

spec文件的一些定义：  

Name:　　#软件包的名称

Version:　　#软件包的版本号

Release:　　#发布的序列

Epoch:　　#发布的序列

Summary:　　#摘要

Group:　　#组描述

License:　　发行许可证

Sources[0-n]:　　#打包的源码包

Patch0:  *.patch      #补丁文件

BuildRequires:　　#打包时依赖的软件

Requires:　　#安装此rpm包时依赖的软件包

BuildRoot:　　#安装此软件的虚拟根目录

以上是描述性的元素，其中Epoch:Version:Release表示了rpm包的新旧，优先级依次降低，打出的rpm包也是以${package}-${Version}-${Release}命名。


spec文件主体内容：

spec文件中引用的一些宏变量主要定义在/usr/lib/rpm/macros中

主要有三个阶段：

%pre

#预处理阶段，解压缩软件包

%setup 

%setup 不加任何选项，仅将软件包打开。
%setup -n newdir 将软件包解压在newdir目录。
%setup -c 解压缩之前先产生目录。
%setup -b num 将第num个source文件解压缩。
%setup -T 不使用default的解压缩操作。
%setup -T -b 0 将第0个源代码文件解压缩。
%setup -c -n newdir 指定目录名称newdir，并在此目录产生rpm套件。
%patch 最简单的补丁方式，自动指定patch level。
%patch0 -p0 打第1个补丁，利用当前相对路径名称
%pacth1 -p2 打第2个补丁，忽略补丁文件第一层目录
%patch 0 使用第0个补丁文件，相当于%patch ?p 0。
%patch -s 不显示打补丁时的信息。
%patch -T 将所有打补丁时产生的输出文件删除。
　　

%build 编译阶段

./configure  --prefix=$RPM_BUILD_ROOT/usr
make    
or
%configure            #可以用rpm –eval '%configure'命令查看该宏
make

在openstack项目中直接是:python setup.py build

%install 将软件安装到虚拟根目录

常用命令：

make DESTDIR=$RPM_BUILD_ROOT install

install [options] src ${RPM_BUILD_ROOT}/${dst} #安装配置文件至指定目录,相当于cp

建立连接关系等。

在openstack 项目中：

%{_python2} setup.py install -01 --skip-build --root %{buildroot}

 
%clean

清理一些临时文件，或是生产中不需要的文件


%files [name]

文件和目录的归档，rpm包真正包含的内容，$name 与package name对应，一个package生成一个rpm包,名字${name}-￥{version}-${release}.rpm。若没有name，则即是spec Name项。

files是相对路径，应用宏或变量表示相对路径：

如果描述为目录，表示目录中除%exclude外的所有文件。
%defattr (-,root,root) 指定包装文件的属性，分别是(mode,owner,group)，-表示默认值，对文本文件是0644，可执行文件是0755

%changelog 变更日志

一般会把git log记录输入，openstack文件中记录的日志：

git rev-parse --abbrev-ref HEAD &gt;&gt; *.spec

git log --pretty=oneline --abbrev-commit | head -n +1 &gt;&gt; *.spec


 #生成patch的命令

diff -Naur path/to/A_Project  path/to/B_Project &gt; Project.patch （A是原始项目）

或者利用 git命令:

#new 是有更改的分支，old是没有更改的分支
git checkout new
git format-patch -M old
 
生成：000-*.patch
git打patch的命令：

git am 000-*.patch

#解析rpm包

rpm -qpl *.rpm #列出rpm包包含的内容

rpm2cpio *.rpm | cpio -div  #解压缩出rpm包

yum-duilddep *.spec 安装spec文件中的所有编译依赖软件，BuidRequires。

rpmbuild --define "_topdir ${dir:-/home/rpmbuild}" -bb *.spec

_topdir指定打包的目录，rpmbuild/{SURCES,BUILD,BUILDROOT,SPECS,RPMS,SRPMS}。

也可以向spec文件传入参数，也是利用--define


