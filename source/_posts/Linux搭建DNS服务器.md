title: 搭建DNS服务器
author: Joe Tong
tags:
  - LINUX
  - DNS
categories:  
  - IT
date: 2019-11-25 13:06:43 
---

## Linux下DNS服务器常规操作
Red Hat Linux的各个版本已经包含DNS服务器的软件--Bind，一般不需要用户另行安装，如果用户需要安装最新版本，可以到Bind官网http://www.bind.com/浏览最新消息。也可以到其它网站下载。

源码软件包：https://www.isc.org/downloads/

例如，在其它网站中下载源码包软件包bind-9.10.4-P1.tar.gz

以下是安装过程中的一些指令：

```
[root@localhost root]# tar xzvf bind-9.10.4-P1.tar.gz
[root@localhost root]# cd bind-9.10.4-P1
[root@localhost bind-9.10.4-P1]# ./configure
[root@localhost bind-9.10.4-P1]# make
[root@localhost bind-9.10.4-P1]# make install
```

其中各参数含义如下：

```
tar xzvf bind-9.10.4-P1.tar.gz        //解压缩软件包
./configure                               //针对机器做安装的检查和设置，大部分工作由机器自动完成
make                                     //编译
make install                            //安装
```

软件包的功能
```
Bind：提供了域名服务的主要程序以及相关文件。

Bind-utils:提供了对DNS服务器的测试工具程序（nslookupdup、dig等）

Bind-chroot:为Bind提供了一个伪装的根目录以增强安全性

Caching-namserver:为配置Bind作为缓存域名服务器提供必要的默认配置文件，用于参考
```

DNS常规操作
1.启动DNS服务器：
`/etc/init.d/named start`
2.停止DNS服务器：
`/etc/init.d/named stop`
3.重新启动DNS服务器:
`/etc/init.d/named restart`

DNS配置文件

与DNS相关的两个特殊文件
1./etc/resolv.conf

该文件用来指定系统中DNS服务器的IP地址和一些相关信息，格式如下：
```
search abc.com.cn
nameserver 10.1.6.250
nameserver 192.168.1.254
```

2./etc/host.conf

该文件决定进行域名解析时查找host文件和DNS服务器的顺序，其格式如下：

`order hosts,bind`

Bind的配置文件

Bind的主配置文件是etc/name.conf,该文件是文本文件，一般需手动生成。除了主配置文件外，/var/named目录下的所有文件都是DNS服务器的相关配置文件，下面详细讲述这些文件的配置。

1.name.conf文件详解

```
options {
listen-on port 53 { 127.0.0.1; };      //设置named服务器监听端口及IP地址
listen-on-v6 port 53 { ::1; };
directory       "/var/named";    //设置区域数据库文件的默认存放地址
dump-file       "/var/named/data/cache_dump.db";
statistics-file "/var/named/data/named_stats.txt";
memstatistics-file "/var/named/data/named_mem_stats.txt";

allow-query     { localhost; };   //允许DNS查询客户端
allow-query-cache { any; };
};
logging {
channel default_debug {
file "data/named.run";
severity dynamic;
};
};
view localhost_resolver {
match-clients      { any; };
match-destinations { any; };
recursion yes;                  //设置允许递归查询
include "/etc/named.rfc1912.zones";
};
```

2.区域配置文件/etc/named.rfc1912.zones

```
zone "." IN {    //定义了根域
type hint;       //定义服务器类型为hint
file "named.ca";  //定义根域的配置文件名
};

zone "localdomain" IN {   //定义正向DNS区域
type master;              //定义区域类型
file "localdomain.zone";  //设置对应的正向区域地址数据库文件
allow-update { none; };   //设置允许动态更新的客户端地址（none为禁止）
};

zone "localhost" IN {
type master;
file "localhost.zone";
allow-update { none; };
};

zone "0.0.127.in-addr.arpa" IN {   //设置反向DNS区域
type master;
file "named.local";
allow-update { none; };
};
```

3.根域配置文件named.ca

根域配置文件设定根域的域名数据库，包括根域中13台DNS服务器的信息。几乎所有系统的这个文件都是一样的，用户不需要进行修改。

4.正向域名解析数据库文件

```
$TTL 600
@        IN   SOA    dns.cwlinux.com   dnsadmin.cwlinux.com. (//SOA字段
                          2015031288   //版本号    同步一次  +1
                             1H        //更新时间
                             2M        // 更新失败，重试更新时间
                             2D        // 更新失败多长时间后此DNS失效时间
                             1D        //解析不到请求不予回复时间
)
         IN    NS   dns            //有两域名服务器
         IN    NS   ns2
         IN    MX  10 mial        // 定义邮件服务器，10指优先级  0-99 数字越小优先级越高
ns2      IN    A    192.168.1.113  //ns2域名服务器的ip地址
dns      IN    A    192.168.1.10   //dns域名服务器的ip地址
mail     IN    A    192.168.1.111   //邮件服务器的ip地址
www      IN    A    192.168.1.112   //www.cwlinux.com的ip地址
pop      IN   CNAME  mail         //pop的正式名字是mail
ftp      IN   CNAME  www         //ftp的正式名字是www
```

5.反向域名解析数据库文件
```
$TTL 600
@         IN   SOA    dns.cwlinux.com.   dnsadmin.cwlinux.com. (
                             2014031224
                             1H
                             2M
                             2D
                             1D
)
         IN   NS      dns.cwlinux.com.
10       IN   PTR     dns.cwlinux.com.     //反向解析PTR格式
111       IN   PTR     mail.cwlinux.com.
112       IN   PTR     www.cwlinux.com.
// 声明域的时候已经有了，192.168.1 所以我们只需要输入10既代表192.168.1.10jc
```

DNS客户端的配置文件

Linux系统中，DNS客户端的配置文件是/etc/resolv.conf,该文件记录了DNS服务器的地址和域名。

一般格式如下：
```
#more /etc/resolv.conf
nameserver 10.1.6.250  
domainname abc.com.cn
```

其中，关键字nameserver记录该域中DNS服务器的IP地址，domainname记录所在域的名称。


