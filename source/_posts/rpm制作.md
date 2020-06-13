title: rpm制作
author: Joe Tong
tags:
  - LINUX 
  - RPM
categories:  
  - IT
date: 2020-03-18 11:20:51
---
linux下RPM包制作

展开
1.rpmbuild
rpm是Redhat系linux系统的包管理器，使用rpmbuild工具可以制作rpm包。

2.rpmbuild的配置文件
（1）rpmrc配置文件
/usr/lib/rpm/rpmrc
/usr/lib/rpm/redhat/rpmrc
/etc/rpmrc
~/.rpmrc
（2）macro宏配置文件
/usr/lib/rpm/macros
/usr/lib/rpm/redhat/macros
/etc/rpm/macros
~/.rpmmacros

3.使用rpmbuild制作rpm包通用过程
通用过程如下：
（1）计划做什么rpm包，比如软件包或库等
（2）收集源码包
（3）如果需要打补丁，收集补丁文件
（4）确定依赖关系包
（5）开始动手制作RPM包
A）设定好目录结构，我们在这些目录中制作我们的RPM包，我们需要下列目录 ：
    BUILD —— 源代码解压后的存放目录，以及后续执行的configure，make，make install命令都是在该目录下执行的
    RPMS —— 制作完成后的RPM包存放目录，里面有与平台相关的子目录
    SOURCES —— 收集的源材料，补丁的存放位置
    SPECS   —— SPEC文件存放目录
    SRMPS   —— 存放生成的SRMPS包的目录
B）把源码包或补丁包放入SOURCES目录中
C）创建spec文件，这是纲领文件，rpmbuild命令根据spec文件来制作rpm包
D）使用rpmbuild命令制作rpm包
（6）测试制作的RPM包
（7）为RPM包签名
备注：rpm制作中，最关键的步骤是编写spec文件。

4.rpm制作举例
以制作tengine的安装包为例来说明：
（1）设置制作rpm包的主目录
在RedHat/Centos下制作rpm包的缺省目录是/usr/src/redhat. 当然我们可以自定义这个主目录，方法如下：
新建~/.rpmmacros文件，增加如下内容：
%_topdir        /home/wahaha
备注：表示制作rpm包的主目录是/home/wahaha，之前所说BUILD|RPMS|SOURCES等目录就是在_topdir代表的目录中。
（2）在主目录中创建rpm打包需要用到的子目录
cd /home/wahaha && mkdir -pv {BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
（3）把收集的源码放到SOURCES下
cp /tmp/tengine-1.4.2.tar.gz /home/wahaha/SOURCES
备注：源文件或补丁文件都要放到SOURCES目录中
（4）在SPECS下建立重要的spec文件
cd /home/wahaha/SPECS && vim tengine.spec
备注：这个步骤非常重要，编写spec文件
（5）用rpmbuild命令制作rpm包，rpmbuild命令会根据spec文件来生成rpm包
 rpmbuild 
-ba 既生成src.rpm又生成二进制rpm
-bs 只生成src的rpm
-bb 只生二进制的rpm
-bp 执行到pre段
-bc 执行到build段
-bi 执行到install段
-bl 检测有文件没包含
（6）测试生成的rpm包是否可以使用
可以通过命令：
rpm -ivh tengine-1.4.2-1.el6.x86_64.rpm  ##测试安装
rpm -e tengine  ##测试卸载
（7）为rpm包签名
使用gpg生成秘钥对，然后使用rpm --addsign为rpm包签名，然后使用rpm --checksig命令即可

5.spec文件的结构
spec文件一般包括如下几个部分：
（1）introduction section
该部分主要定义包的一些基本信息，比如程序名、版本号、发行号以及描述信息等。
（2）prep section
该部分是以宏%prep开始。prep section用来解压源码包到BUILD目录，并cd到解压后的目录。
（3）build section
该部分是以宏%build开始。build section是用来编译程序的，例如执行configure、make等命令。值得注意的是，如果源文件不需要编译，这个部分只写一个%build就可以了，其他的留空，既不用写configure，make等命令了。
（4）install section
该部分是以宏%install开始。install section用来将软件安装到临时目录的，即安装测试。后面rpm打包时会从这个临时安装目录中提取文件的。这个安装的临时目录是我们在introduction section定义的BuildRoot标签来指定的，或者rpmbuild有一个buildroot宏来定义的。
（5）clean section
该部分是以宏%clean开始。主要用来清除BUILD目录中的内容。
（6）files section
该部分是以宏%files开始。用于指定最终生成的rpm包中应该包含哪些文件（在BUILDROOT路径下找），files段中指明的文件一定要在BUILDROOT目录下存在，不然会报错哦
（7）changelog section
该部分是以宏%changelog开始。用来说明该软件的变更历史信息。
备注：以上是spec主要的几个部分，其实在复杂的应用场景中，还有其他的section哦，慢慢了解吧

如下为tengine软件的spec文件举例：
### 0.define section                 #自定义宏段，这个不是必须的
### %define nginx_user nginx         #这是我们自定义了一个宏，名字为nginx_user值为nginx，%{nginx_user}引用

### 1.The introduction section       #介绍区域段
Name:           tengine              #名字为tar包的名字
Version:        1.4.2                #版本号，一定要与tar包的一致哦
Release:        1%{?dist}            #释出号，也就是第几次制作rpm
Summary:        tengine from TaoBao  #软件包简介，最好不要超过50字符
Group:          System Environment/Daemons       #组名，可以通过less /usr/share/doc/rpm-4.8.0/GROUPS选择合适的组
License:        GPLv2                            #许可，GPL还是BSD等 
URL:            http://laoguang.blog.51cto.com   #可以写一个网址
Packager:       Laoguang <ibuler@qq.com>         #rpm包制作作者
Vendor:         TaoBao.com                       #rpm包所属组织
Source:        %{name}-%{version}.tar.gz         #定义用到的source，也就是你收集的，可以用宏来表示，也可以直接写名字。如果有多个源文件的话，可以通过Source0、Source1、Source2等来指定
patch0:            a.patch                       #rpm包制作需要的补丁，如果有的话，需要写上。如有多个补丁包，可以通过patch0、patch1等来指明
BuildRoot:      %_topdir/BUILDROOT               #这个是软件make install的测试安装目录，也就是测试中的根。我们可以自定义这个目录的位置
BuildRequires:  gcc,make                         #编译阶段需要依赖的包
Requires:       pcre,pcre-devel,openssl,chkconfig  #使用rpm -ivh安装已经制作完成的rpm包时需要依赖的包
%description                                       #软件包描述，尽情的写吧
It is a Nginx from Taobao.                         #描述内容

###  2.The Prep section 准备阶段,主要目的解压source并cd进去
%prep                                  #以%prep宏开始
%setup -q                              #这个宏的作用静默模式解压并cd
%patch0 -p1                            #如果需要在这打补丁，依次写

###  3.The Build Section 编译制作阶段，主要目的就是编译
%build                                 #以%build宏开始
./configure \                          #./configure 也可以用%configure来替换
  --prefix=/usr \                                
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx/nginx.pid  \
  --lock-path=/var/lock/nginx.lock \
  --user=nginx \
  --group=nginx \
  --with-http_ssl_module \
  --with-http_flv_module \
  --with-http_stub_status_module \
  --with-http_gzip_static_module \
  --http-client-body-temp-path=/var/tmp/nginx/client/ \
  --http-proxy-temp-path=/var/tmp/nginx/proxy/ \
  --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ \
  --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
  --http-scgi-temp-path=/var/tmp/nginx/scgi \
  --with-pcre
make %{?_smp_mflags}                   #make后面的意思是，如果就多处理器的话make时并行编译

###  4.Install section  安装阶段
%install                               #以%install宏开始     
rm -rf %{buildroot}                    #先删除原来的安装的，如果你不是第一次安装的话
make install DESTDIR=%{buildroot}      #DESTDIR指定安装的目录，而不是真实的安装目录，所以在introduction section设置的BuildRoot就是在这个地方被引用的

###  4.1 scripts section               #没必要可以不写
%pre                                   #rpm安装前执行的脚本
if [ $1 == 1 ];then                    #$1==1 代表的是第一次安装，2代表是升级，0代表是卸载
        /usr/sbin/useradd -r nginx 2> /dev/null  ##其实这个脚本写的不完整
fi
%post                            #安装后执行的脚本

%preun                           #卸载前执行的脚本
if [ $1 == 0 ];then
        /usr/sbin/userdel -r nginx 2> /dev/null
fi
%postun                          #卸载后执行的脚本

###  5.clean section 清理段,删除buildroot
%clean                           #以%clean宏开始
rm -rf %{buildroot}

###  6.file section 要包含的文件
%files                           #以%files宏开始
%defattr (-,root,root,0755)      #设定默认权限，如果下面没有指定权限，则继承默认
/etc/                            #下面的内容要根据你在%{rootbuild}下生成的来写     
/usr/
/var/

###  7.chagelog section  改变日志段
%changelog                       #以%changelog宏开始
*  Fri Dec 29 2012 laoguang <ibuler@qq.com> - 1.0.14-1
- Initial version
备注：关于spec文件编写的一些语法知识点
（1）定义标签语法
TagName: value,    ##例如Name: nginx
标签可以当做宏来引用，即可以使用%{TagName}或%TagName来引用（引用tag名称的时候不区分大小写）
备注：BuildRoot可以通过%{buildroot}，也可以通过$RPM_BUILD_ROOT来引用。
（2）自定义宏语法
%define macro_name value
然后可以通过%{macro_name }或%macro_name来引用。
（3）spec文件中注释
spec文件中使用#符号，来表示注释
（4）rpm制作中涉及到的宏
%{?dist}   这是一个宏，？表示有就加上，没有就不加。dist一般是系统的发行版本，比如el5，el6，el7等
%{}是宏，像%{__rm}带两个下划线的也是宏，它代表着linux命令。

6.rpm制作和rpm包安装的过程原理
（1）rpmbuild制作执行过程
rpmbuild制作rpm包是以SPEC文件中的剧本来执行的，如下只是简单地说明下过程：
->将SOURCES目录中源文件，解压到BUILD的目录中。例如BUILD/nginx-1.4/*
->切到BUILD/nginx-1.4/目录执行configure，make等命令
->执行make install将软件安装到BUILDROOT目录中（备注：使用rpmbuild制作包的过程中，会有安装的过程，只是说安装到一个临时的目录中）
->file section字段指定BUILDROOT目录中哪些文件被归档到最终的rpm包中
->打包完成后，就执行clean操作，会删除BUILD目录中内容
（2）rpm -ivh安装rpm包的过程
我们通过rpm -qpl *.rpm可以看到rpm包中的文件是有目录结构的，当我们执行rpm -ivh命令时，就会按照这个目录结构来建立，并将相应的文件install命令到对应的位置。另外rpm -ivh时，还会执行SPEC中的一些script section的命令哦，例如创建用户、增加开机启动等。
（3）rpm -Uvh升级软件的过程
通过rpm -Uvh升级软件时，会用新版本rpm包的文件替换到已经安装的系统文件。当然如果是新增的文件，直接install到对应的目录就好了。
备注：使用rpm -ivh或rpm -Uvh都会更新rpm的数据库了。

7.rpm制作的最佳实践
（1）要使用普通账户制作rpm包，因为在制作rpm包中，会执行spec文件中的一些shell命令，如果命令有问题会带来不确定的后果。
（2）在Redhat/Centos 6中，可能需要在软件安装时，能够配置好initd控制脚本以及logrotate日志切割，那我们可以先制作好这些文件，然后作为Source引入到rpm包就可以了。同样地，在RedHat/Centos 7中，可能需要/lib/systemd/system/*.service配置文件，我们也可以先制作好，然后作为源文件引入到rpm包就好了。
（3）有些软件需要用特定的账户执行，例如apache服务用apache账户来启动。那么我们在可以在脚本段中去定义这些操作就好了。
（4）SRPM包中一般包含了源文件、SPEC文件等内容，我们可以下载一些开源软件的srpm包，做一些修改后再重新制作rpm包。当然我们可以学习SPEC的编写内容哦
（5）使用rpm --showrc 或 rpmbuild --showrc命令，可以显示rpmbuild配置文件中定义的宏，灰常重要，例如通过rpm --showrc | grep _topdir就可以查看rpm制作的主目录。当我们编写spec文件中，就可以通过该命令来查看一些宏的具体含义。
（6）有时我们需要对源文件做成多个rpm包，例如mysql就有mysql-%{version}.rpm、mysql-server-%{version}.rpm等，这个是可以在spec文件中控制的，已达到分拆rpm包的目的。
（7）rpm包搜索网址
http://rpmfind.net
http://rpm.pbone.net/



linux制做RPM包
制作rpm包

1.制作流程
1.1 前期工作
       1）创建打包用的目录rpmbuild/{BUILD,SPECS,RPMS, SOURCES,SRPMS}

              建议使用普通用户，在用户家目录中创建

       2）确定好制作的对象，是源码包编译打包还只是一些库文件打包

       3）编写SPEC文件

       4）开始制作

  1.2 RPM制作过程
       1）读取并解析 filename.spec 文件

2）运行 %prep 部分来将源代码解包到一个临时目录，并应用所有的补丁程序。

3）运行 %build 部分来编译代码。

4）运行 %install 部分将代码安装到构建机器的目录中。

5）读取 %files 部分的文件列表，收集文件并创建二进制和源 RPM 文件。

6）运行 %clean 部分来除去临时构建目录。

补充说明：

       BUILD目录：制作车间，二进制tar.gz包的解压后存放的位置，并在此目录进行编译安装

       SPECS目录：存放SPEC文件

       RPMS目录：存放制作好的rpm包

       SOURCES目录：存放源代码

       SRPMS目录：存放编译好的二进制rpm包

       BUILDROOT目录：此目录是在BUILD目录中执行完make install之后生成的目录，里面存放的是编译安装好的文件，他是./configure中—prefix指定path的根目录

1.3制作工具：rpmbuild
       制作过程的几个状态

       rpmbuild -bp   执行到%prep

       rpmbuild -bc   执行到%build中的config

       rpmbuild -bi         执行至%build中的install

       rpmbuild -ba    编译后做成rpm包和src.rpm包

rpmbuild -bs        仅制作src.rpm包

rpmbuild -bb    仅制作rpm包     

 

2.SPEC文件
2.1 spec文件参数：
自定义软件包基本参数：

Name   软件包名字

Version  软件包版本

Release    软件包修订号

Summary  软件包简单描述

Group  软件包所属组。必须是系统定义好的组

License   软件授权方式，通常就是GPL

Vendor  软件包发型厂商

Packager   软件包打包者

URL   软件包的url

Source  定义打包所需的源码包，可以定义多个，后面使用%{SOURCE}调用

Patch  定义补丁文件，后面可以使用%{Patch}调用

BuildRoot  定义打包时的工作目录

BuildRequires  定义打包时依赖的软件包

Requires  定义安装时的依赖包，形式为Package name  或者 Package  >= version

Prefix %{_prefix}| %{_sysconfdir} ： %{_prefix} 这个主要是为了解决今后安装rpm包时，并不一定把软件安装到rpm中打包的目录的情况。这样，必须在这里定义该标识，并在编写%install脚本的时候引用，才能实现rpm安装时重新指定位置的功能

%{_sysconfdir} 这个原因和上面的一样，但由于%{_prefix}指/usr，而对于其他的文件，例如/etc下的配置文件，则需要用%{_sysconfdir}标识

%package 定义一个子包

%description  详细描述信息

 

自定义打包参数;

%prep  预处理段，默认是解压源码包，可以自定义shell命令和调用RPM宏命令

%post rpm安装后执行的命令，可以自定义shell命令和调用RPM宏命令

%preun rpm卸载前执行的命令，可以自定义shell命令和调用RPM宏命令

%postun rpm卸载后执行的命令，可以自定义shell命令和调用RPM宏命令

%patch  打补丁阶段

%build  编译安装段，此段包含./configure和 make 安装阶段

%install 安装阶段，会把编译好的二进制文件安装到BUILDROOT为根的目录下

%files  文件段，定义软件打包时的文件，分为三类--说明文档（doc），配置文件（config）及执行程序，还可定义文件存取权限，拥有者及组别。其路径为相对路径

%changelog  定义软件包修改的日志

 

 

2.2补充：
Group： 
软件包所属类别，具体类别有：
Amusements/Games （娱乐/游戏）
Amusements/Graphics（娱乐/图形）
Applications/Archiving （应用/文档）
Applications/Communications（应用/通讯）
Applications/Databases （应用/数据库）
Applications/Editors （应用/编辑器）
Applications/Emulators （应用/仿真器）
Applications/Engineering （应用/工程）
Applications/File （应用/文件）
Applications/Internet （应用/因特网）
Applications/Multimedia（应用/多媒体）
Applications/Productivity （应用/产品）
Applications/Publishing（应用/印刷）
Applications/System（应用/系统）
Applications/Text （应用/文本）
Development/Debuggers （开发/调试器）
Development/Languages （开发/语言）
Development/Libraries （开发/函数库）
Development/System （开发/系统）
Development/Tools （开发/工具）
Documentation （文档）
System Environment/Base（系统环境/基础）
System Environment/Daemons （系统环境/守护）
System Environment/Kernel （系统环境/内核）
System Environment/Libraries （系统环境/函数库）
System Environment/Shells （系统环境/接口）
User Interface/Desktops（用户界面/桌面）
User Interface/X （用户界面/X窗口）
User Interface/X Hardware Support （用户界面/X硬件支持）

 

%setup 的用法

       %setup 不加任何选项，仅仅打开源码包

       %setup -n   newdir  将软件包解压至新目录（重命名解压的包），默认

       %setup -c 解压缩之前先产生目录。

%setup -b num 将第num个source文件解压缩。

%setup -T 不使用default的解压缩操作。

%setup -T -b 0 将第0个源代码文件解压缩。

%setup -c -n newdir 指定目录名称newdir，并在此目录产生rpm套件。

%setup -q  解压不输出信息

%Patch用法

       先使用Patch{n}定义补丁包，然后使用%patch{n}或者%{patch{n}}来调用打补丁

补丁号命名规则

              0-9 Makefile、configure 等的补丁

10-39 指定功能或包含他的文件的补丁

40-59 配置文件的补丁

60-79 字体或字符补丁

80-99 通过 xgettexize 得到的目录情况的补丁

100- 其他补丁

%patch 最简单的补丁方式，自动指定patch level。

%patch 0 使用第0个补丁文件，相当于%patch -p 0。

%patch -s 不显示打补丁时的信息。

%patch -T 将所有打补丁时产生的输出文件删除

%patch  -b name 在打补丁之前，将源文件加入name，缺省为.org

 

%file用法

       %defattr (-,root,root) 指定包装文件的属性，分别是(mode,owner,group)，-表示默认值，对文本文件是0644，可执行文件是0755

       %attr(600,work,work)  指定特定的文件目录权限

fattr (-,root,root)

 

本段是文件段，用于定义构成软件包的文件列表，那些文件或目录会放入rpm中，分为三类-说明文档（doc），配置文件（config）及执行程序，还可定义文件存取权限，拥有者及组别。

 

这里会在虚拟根目录下进行，千万不要写绝对路径，而应用宏或变量表示相对路径。

※特别需要注意的是：%install部分使用的是绝对路径，而%file部分使用则是相对路径，虽然其描述的是同一个地方。千万不要写错。

%files  -f %{name}.lang tui

file1 #文件中也可以包含通配符，如*

file2

directory #所有文件都放在directory目录下

%dir /etc/xtoolwait #仅是一个空目录/etc/xtoolwait打进包里

%doc  表示这是文档文件，因此如安装时使用--excludedocs将不安装该文件，

%doc /usr/X11R6/man/man1/xtoolwait.* #安装该文档

%doc README NEWS #安装这些文档到/usr/share/doc/%{name}-%{version} 或者 /usr/doc或者

%docdir #定义说明文档的目录，例如/root，在这一语句后，所有以/root开头的行都被定义为说明文件。

%config /etc/yp.conf #标志该文件是一个配置文件，升级过程中，RPM会有如下动作。

%config(missisgok) /etc/yp.conf 此配置文件可以丢失，即使丢失了，RPM在卸载软件包时也不认为这是一个错误，并不报错。一般用于那些软件包安装后建立的符号链接文件，

/etc/rc.d/rc5.d/S55named文件，此类文件在软件包卸载后可能需要删除，所以丢失了也不要紧。

%config(noreplace) /etc/yp.conf

#该配置文件不会覆盖已存在文件(RPM包中文件会以.rpmnew存在于系统，卸载时系统中的该配置文件会以.rpmsave保存下来，如果没有这个选项，安装时RPM包中文件会以.rpmorig存在于系统 )

覆盖已存在文件(没被修改)，创建新的文件加上扩展后缀.rpmnew(被修改)

%{_bindir}/*

%config  /etc/aa.conf

%ghost /etc/yp.conf #该文件不应该包含在包中,一般是日志文件，其文件属性很重要，但是文件内容不重要，用了这个选项后，仅将其文件属性加入包中。

%attr(mode, user, group) filename #控制文件的权限如%attr(0644,root,root) /etc/yp.conf

如果你不想指定值，可以用-

%config %attr(-,root,root) filename #设定文件类型和权限

fattr(-,root,root) #设置文件的默认权限,-表示默认值，对文本文件是0644，可执行文件是0755

%lang(en) %{_datadir}/locale/en/LC_MESSAGES/tcsh* #用特定的语言标志文件

%verify(owner group size) filename #只测试owner,group,size，默认测试所有

%verify(not owner) filename #不测试owner，测试其他的属性

所有的认证如下：

group：  认证文件的组

maj：    认证文件的主设备号

md5：    认证文件的MD5

min：    认证文件的辅设备号

mode：   认证文件的权限

mtime：  认证文件最后修改时间

owner：  认证文件的所有者

size：   认证文件的大小

symlink：认证符号连接

如果描述为目录，表示目录中出%exclude外的所有文件。

%files

fattr(-,root,root)

%doc

%{_bindir}/*

%{_libdir}/liba*

%{_datadir}/file

%{_infodir}/*

%{_mandir}/man[15]/*

%{_includedir}

%exclude %{_libdir}/debug

（%exclude 列出不想打包到rpm中的文件。※小心，如果%exclude指定的文件不存在，也会出错的。）

如果把

%files

fattr(-,root,root)

%{_bindir}

写成

%files

fattr(-,root,root)

/usr/bin

则打包的会是根目录下的/usr/bin中所有的文件。

%files libs

fattr(-,root,root)

%{_libdir}/*so.*

%files devel

�fattr(-,root,root)

%{_includedir}/*

 

install的用法

       -b：为每个已存在的目的地文件进行备份；

       -d：创建目录，类似mkdir -p

-D：创建目的地前的所有目录，然后将来源复制到目的地。复制文件

-g：自行设置所属的组；

-m：自行设置权限，而不是默认的rwxr-xr-x

-o：自行设置所有者

-p：以来源文件的修改时间作为相应的目的地的文件属性

%pre %post %pretun %postun 用法

rpm提供了一种信号机制：不同的操作会返回不同的信息，并放到默认变量$1中

 

0代表卸载、1代表安装、2代表升级

    if [“$1” = “0” ] ;then

       comond

fi

用于判断rpm的动作

2.3 典型的spec文件案例：
 
 
3.技巧：
1）如果要避免生成debuginfo包：这个是默认会生成的rpm包。则可以使用下面的命令
       echo '%debug_package %{nil}' >> ~/.rpmmacros

2）配置 RPM 在构建时使用新的目录结构，而不是默认的目录结构：
 echo "%_topdir $HOME/rpmbuild" > ~/.rpmmacros

 

 

4.使用FPM制作RPM包
1）安装：

       yum -y install ruby rubygems ruby-devel   安装ruby 和gem

       gem install fpm                             安装fpm工具

 

2）准备编译安装好的源码包

       /usr/local/libiconv

 

3）打包：

       fpm  -f -s dir  -t rpm -n beyond-libiconv --epoch=0 -v '1.14' -C /usr/local  --iteration 1.el6  ./libiconv-1.14

 

参数解释

 

-f 强制输出，如果文件已存在，将会覆盖源文件

-s 指定源文件为目录 dir

-t  指定制作的包类型（rpm，deb solaris etc）

-n  指定制作的包名

-- epoch  指定时间戳

-v  指定软件版本

-C  指定软件安装的目录

--iteration  指定软件的适用平台

./libiconv-1.14  本次打包的文件

 

 

附加参数：

-e  可以在打包之前编译 spec文件

-d  指定依赖的软件包 用法 –d ‘Package’  或 –d ‘Package > version’

--description 软件包描述

-p 生成的package文件输出位置

--url   说明软件包的url

--post-install ：软件包安装完成之后所要运行的脚本；和”--after-install” 意思一样

--pre-install ：软件包安装完成之前所要运行的脚本；和”--before-install” 意思一样

--post-uninstall ：软件包卸载完成之后所要运行的脚本；和”--after-remove”意思一样

--pre-uninstall：软件包卸载完成之前所要运行的脚本；和”--before-remove”意思一样

 

fpm打包php案例：

fpm   -f -s dir -t rpm -n beyond-php --epoch=0 -v '5.2.14' -C /usr/local/ -p ./ --iteration 1.el6  -d 'beyond-libiconv' -d 'beyond-libmcrypt' -d 'beyond-mcrypt' -d 'beyond-mhash' -d 'libxml2' -d 'libxml2-devel'  -d 'zlib' -d 'zlib-devel' -d 'libpng' -d 'libpng-devel' -d 'freetype' -d 'freetype-devel' -d 'autoconf' -d 'gd' -d 'gd-devel' -d 'libjpeg' -d 'libjpeg-devel'  -d 'curl' -d 'curl-devel' -d 'mysql-devel' -d 'openssl' -d 'openssl-devel' -d 'openldap-devel' -d 'libtool-ltdl' -d 'libtool-ltdl-devel' --url http://sa.beyond.com/source/php-5.2.14.tar.gz --license GPL  --post-install ./preinstall.sh   /usr/local/php




