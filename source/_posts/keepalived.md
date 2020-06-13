title: keepalived
author: Joe Tong
tags:
  - JAVAEE
  - KEEPALIVED
  - 高可用
categories:
  - IT
date: 2019-09-10 21:57:00
---
高性能集群软件Keepalived的介绍以及安装与配置  

Keepalived介绍：  
           Keepalived是Linux下一个轻量级的高可用解决方案；起初是为LVS设计的，专门用来监控集群系统中各个服务节点的状态。它根据TCP/IP参考模型的第三、第四和第五层交换机机制检测每个服务节点的状态，如果某个服务节点出现异常，或工作出现故障，Keepalived将检测到，并将出现故障的服务节点从集群系统中剔除，而在故障节点恢复正常后，Keepalived又可以自动将此服务节点重新加入服务器集群中，这些工作全部自动完成，不需要人工干涉，需要人工完成的只是修复出现故障的服务节点。
           Keepalived后来又加入了VRRP的功能，VRRP（Virtual Router Redundancy Protocol,虚拟路由器冗余协议）出现的目的是解决静态路由出现的单点故障问题，通过VRRP可以实现网络不间断稳定运行。因此，Keepalived一方面具有服务器状态检测和故障隔离功能，另一方面也具有HA cluster 功能。
           
VRRP协议与工作原理  
VRRP，它是一种主备模式的协议，通过VRRP可以在网络发生故障时透明地进行设备切换而不影响主机间的数据通信；这其中涉及两个概念：物理路由器和虚拟路由器。
         VRRP可以将两台或多台物理路由器设备虚拟成一个虚拟路由器，这个虚拟路由器通过虚拟IP（一个或多个)对外提供服务，而在虚拟路由器内部是多个物理路由器协同工作，同一时间只有一台物理路由器对外提供服务，这台物理路由器被称为主路由器（处于MASTER角色）。一般情况MASTER由选举算法产生，它拥有对外服务的虚拟IP，提供各种网络功能，如ARP请求、ICMP、数据转发等。而其他物理路由器不拥有对外的虚拟Ip，也不提供对外网络功能，仅仅接收MASTER的VRRP状态通告信息，这些路由器被统称为备份路由器（处于BACKUP角色）。当主路由器失效时，处于BACKUP角色的备份路由器将重新进行选举，产生一个新的主路由器进入MASTER角色继续提供对外服务。
        每个虚拟路由器独有一个唯一标识，称为VRID，一个VRID与一组IP地址构成了一个虚拟路由器。在VRRP协议中，所有的报文都是通过IP多播形式发送的，而在一个虚拟路由器中，只有处于MASTER角色的路由器会一直发生VRRP数据包，处于BACKUP角色的路由器只接收MASTER发送过来的报文信息，用来监控MASTER运行状态，因此，不会发生BACKUP抢占的现象，除非它的优先级更高。而当MASTER出现故障，多台BACKUP就会进行选举，优先级最高的BACKUP成为新的MASTER，这种选举并进行角色切换的过程非常快，因而保证了服务的持续可用性。
        
Keepalived工作原理  
keepalive运行机制如下：  
        在网络层，运行着4个重要的协议：互联网协议IP、互联网控制报文协议ICMP、地址转换协议ARP以及反向地址转换协议RARP。Keepalived在网络层采用的最常见的工作方式是通过ICMP协议向服务器集群中的那个节点发送一个ICMP数据包（类似于ping实现的功能），如果某个节点没有返回响应数据包，那么认为此节点发生了故障，Keepalived将报告次节点失效，并从服务器集群中剔除故障节点。
        在传输层，提供了两个主要的协议：传输控制协议TCP和用户数据协议UDP。传输控制协议TCP可以提供可靠的数据传输服务、Ip地址和端口代表TCP的一个连接端。要获得TCP服务，需要在发送机的一个端口上和接收机的一个端口上建立连接，而Keepalived在传输层就是利用TCP协议的端口连接和扫描技术来判断集群点是否正常的。比如，对于常见的WEB服务默认的80端口、SSH服务默认的22端口等，Keepalived一旦在传输层探测到这些端口没有响应数据返回，就认为这些端口发生异常，然后强制将此端口对应得节点从服务器集群组中移除。
       在应用层，可运行FTP、TELNET、SMTIP、DNS等各种不同类型的高层协议，Keepalived的运行方式也更加全面化和复杂化，用户可以通过自定义Keepalived的工作方式；例如：用户可以通过编写程序来运行keepalived。而keepalived将根据用户的设定检测各种程序或服务是否运行正常，如果Keepalived的检测结果与用户设定不一致时，Keepalived将把对应的服务从服务器中移除。  
       
Keepalived的组件：  
核心组件：  
             VRRP　Stack:实现HA集群中失败切换（Failover)功能。Keepalived通过VRRP功能能
再结合LVS负载均衡软件即可部署一个高性能的负载均衡集群系统。
ipvs wrapper:可以将设置好的IP VS规则发送到内核空间并提交给IP VS模块，最终实
现 IP VS模块的负载均衡功能。
           checkers:这是Keepalived 最基础的功能，也是最主要的功能，可实现对服务器运行状
态检测和故障隔离。
HA Cluster的配置前提：  
(1) 各节点时间必须同步；
   ntp, chrony
(2) 确保iptables及selinux不会成为阻碍；
(3) 各节点之间可通过主机名互相通信（对KA并非必须）；
建议使用/etc/hosts文件实现；
(4) 确保各节点的用于集群服务的接口支持MULTICAST通信；
   D类：224-239；
Keepalived安装与配置：  
Centos6.4以后版本可以直接yum安装：
 yum install keepalived  
 程序环境：    
 主配置文件：/etc/keepalived/keepalived.conf
 主程序文件：/usr/sbin/keepalived  
 Unit File:keepalived.service
 Unit File的环境配置文件：/etc/sysconfig/keepalived
根据配置文件所实现的功能，将Keepalived配置分三类：  
Global Configuration  
VRRPD 配置、LVS配置  

全局配置以”`global_defs”`作为标识，在“`global_defs`”区域内的都是  
全局配置选项： 


```  
global_defs {
notification_email {  
acassen@firewall.loc                                   failover@firewall.loc                                   sysadmin@firewall.loc
}  
notification_email_from                                   Alexandre.Cassen@firewall.loc
smtp_server 192.168.200.1                             smtp_connect_timeout 30
router_id LVS_DEVEL
vrrp_mcast_group4 224.110.129.18
}
```
主配置文件详解

```
global_defs {
   notification_email {   #发送报警邮件收件地址
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc   #指明报警邮件的发送地址
   smtp_server 192.168.200.1    #邮件服务器地址
   smtp_connect_timeout 30      #smtp的超时时间
   router_id LVS_DEVEL          #物理服务器的主机名
   vrrp_mcast_group4            #定义一个组播地址
   static_ipaddress
        {
        192.168.1.1/24 dev eth0 scope global
        }
        static_routes
        {
        192.168.2.0/24 via 192.168.1.100 dev eth0
        }

}
    vrrp_sync_group VG_1 {              #定义一个故障组，组内有一个虚拟路由出现故障另一个也会一起跟着转移，适用于LVS的NAT模型。
        group {
            VI1     # name of vrrp_instance (below)         
            VI2     # One for each moveable IP

             }
    }


vrrp_instance VI_1 {        #定义一个虚拟路由
    state MASTER|BACKUP     #当前节点在此虚拟路由器上的初始状态；只能有一个是MASTER，余下的都应该为BACKUP；
    interface eth0          #绑定为当前虚拟路由器使用的物理接口；
    virtual_router_id 51    #当前虚拟路由器的惟一标识，范围是0-255；
    priority 100            #当前主机在此虚拟路径器中的优先级；范围1-254；
    advert_int 1            #通告发送间隔，包含主机优先级、心跳等。
    authentication {        #认证配置   
        auth_type PASS      #认证类型，PASS表示简单字符串认证
        auth_pass 1111      #密码,PASS密码最长为8位

   virtual_ipaddress {
    192.168.200.16          #虚拟路由IP地址，以辅助地址方式设置
    192.168.200.18/24 dev eth2 label eth2:1 #以别名的方式设置
    }

track_interface {
        eth0
        eth1

}                           #配置要监控的网络接口，一旦接口出现故障，则转为FAULT状态；
nopreempt                   #定义工作模式为非抢占模式；
preempt_delay 300           #抢占式模式下，节点上线后触发新选举操作的延迟时长；
   virtual_routes {         #配置路由信息，可选项
               #  src &lt;IPADDR&gt; [to] &lt;IPADDR&gt;/&lt;MASK&gt; via|gw &lt;IPADDR&gt; [or &lt;IPADDR&gt;] dev &lt;STRING&gt; scope
       &lt;SCOPE&gt; tab
               src 192.168.100.1 to 192.168.109.0/24 via 192.168.200.254 dev eth1
               192.168.112.0/24 via 192.168.100.254       192.168.113.0/24  via  192.168.200.254  or 192.168.100.254 dev eth1      blackhole 192.168.114.0/24
           }


    notify_master &lt;STRING&gt;|&lt;QUOTED-STRING&gt;       #当前节点成为主节点时触发的脚本。
    notify_backup &lt;STRING&gt;|&lt;QUOTED-STRING&gt;       #当前节点转为备节点时触发的脚本。
    notify_fault &lt;STRING&gt;|&lt;QUOTED-STRING&gt;        #当前节点转为“失败”状态时触发的脚本。
    notify &lt;STRING&gt;|&lt;QUOTED-STRING&gt;              #通用格式的通知触发机制，一个脚本可完成以上三种状态的转换时的通知。
    smtp_alert                                   #如果加入这个选项，将调用前面设置的邮件设置，并自动根据状态发送信息 
}
virtual_server 192.168.200.100 443 {    #LVS配置段 ，设置LVS的VIP地址和端口
    delay_loop                          #服务轮询的时间间隔；检测RS服务器的状态。
    lb_algo rr                          #调度算法，可选rr|wrr|lc|wlc|lblc|sh|dh。
    lb_kind NAT                         #集群类型。
    nat_mask 255.255.255.0              #子网掩码，可选项。
    persistence_timeout 50              #是否启用持久连接，连接保存时长
    protocol TCP                        #协议，只支持TCP
    sorry_server &lt;IPADDR&gt; &lt;PORT&gt;        #备用服务器地址，可选项。

    real_server 192.168.201.100 443 {   #配置RS服务器的地址和端口
        weight 1                        #权重
     SSL_GET {                          #检测RS服务器的状态，发送请求报文
            url {
              path /                    #请求的URL
              digest ff20ad2481f97b1754ef3e12ecd3a9cc  #对请求的页面进行hash运算，然后和这个hash码进行比对，如果hash码一样就表示状态正常
              status_code &lt;INT&gt;         #判断上述检测机制为健康状态的响应码,和digest二选一即可。

            }                           #这个hash码可以使用genhash命令请求这个页面生成
            connect_timeout 3           #连接超时时间
            nb_get_retry 3              #超时重试次数
            delay_before_retry 3        #每次超时过后多久再进行连接
            connect_ip &lt;IP ADDRESS&gt;     #向当前RS的哪个IP地址发起健康状态检测请求
            connect_port &lt;PORT&gt;         #向当前RS的哪个PORT发起健康状态检测请求
            bindto &lt;IP ADDRESS&gt;         #发出健康状态检测请求时使用的源地址；
            bind_port &lt;PORT&gt;            #发出健康状态检测请求时使用的源端口；
        }
    }
}

```

健康状态检测机制

HTTP_GET  
SSL_GET  
TCP_CHECK   
SMTP_CHECK  
MISS_CHECK #调用自定义脚本进行检测  

```
TCP_CHECK {
        connect_ip &lt;IP ADDRESS&gt;         #向当前RS的哪个IP地址发起健康状态检测请求;
        connect_port &lt;PORT&gt;             #向当前RS的哪个PORT发起健康状态检测请求;
        bindto &lt;IP ADDRESS&gt;             #发出健康状态检测请求时使用的源地址；
        bind_port &lt;PORT&gt;                #发出健康状态检测请求时使用的源端口；
        connect_timeout &lt;INTEGER&gt;       #连接请求的超时时长；
}
```
注：在配置服务前需要注意几台主机的防火墙策略，和SELinux配置。
`ip a l eth0`

注意：主设备必需先于从设备启动。
Keepalived的执行配置的脚本文件时，需要一个默认的用户keepalived_script，使用如下命令进行添加：

` useradd keepalived_script `

防火墙配置
防火墙配置文件是/etc/sysconfig/iptables
需要在防火墙配置文件中加入以下两条规则：

```
-A DEFAULT-INPUT -p vrrp -j ACCEPT      #允许vrrp组播协议访问；
-A DEFAULT-INPUT -p tcp -m multiport --dports 3306,6379  -j ACCEPT
允许对方ip访问本机的mysql端口和redis端口  #ip需要配置成对方ip
```
主：

```
global_defs {
	router_id casb_device
	enable_script_security
}
vrrp_instance VI_REDIS {
	state MASTER  
	interface eth0
	virtual_router_id 51
	priority 100
	advert_int 1
	authentication {
		auth_type PASS
		auth_pass 1111
	}
	virtual_ipaddress {
		192.168.100.237
	}
	notify_master "/usr/local/enlink/casb_master.sh"
	notify_backup "/usr/local/enlink/casb_backup.sh"
}
```

备：

```
global_defs {
	router_id casb_device
	enable_script_security
}
vrrp_instance VI_REDIS {
	state BACKUP  #定义主备
	interface eth0
	virtual_router_id 51
	priority 100
	advert_int 1  
 &nbsp; nopreempt #只有在备时配置
	authentication {
		auth_type PASS
		auth_pass 1111
	}
	virtual_ipaddress {
		192.168.100.237 #被争夺的虚拟ip
	}
	notify_master "/usr/local/enlink/casb_master.sh"
	notify_backup "/usr/local/enlink/casb_backup.sh"
}
```
