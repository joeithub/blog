title: ali系统
author: Joe Tong
tags:
  - JAVAEE
categories:  
  - IT
date: 2020-01-17 14:18:19
---


双十一大概会产生多大的数据量呢，可能大家没概念，举个例子央视拍了这么多年电视新闻节目，几十年下来他存了大概80P的数据。而今年双11一天，阿里要处理970P的数据，做为一个IT人，笔者认为今年”双十一“阿里最大的技术看点有有以下两个：

阿里的数据库，也就是刚刚拿下TPC冠军的OcceanBase，处理峰值也达到了骇人听闻的6100万次/秒，
阿里核心系统百分百上云了。
如果把信息系统比做一个武林高手，那么如此之大的交易量代表了他的刚猛威武，而全面触云又代表他灵动飘逸。而能把刚猛和灵活完美结合是简直是神才能达到的境界。

上云虽好，但不适合大规模计算，由于底层与用户之间多了一个虚拟化层，所以云计算平台一般都会产生10%左右的调度损耗，而这10%的损耗也让很多密集计算型的应用场景不太合适使用云平台。所以站在IT视角，云计算也不太合适双十一的场景。那么阿里刚猛兼顾灵活的武功是如何练成的呢？

乾坤大挪移-Tair

通过阿里的官宣来看在Tair之前还有一个LVS的负载均衡层，不过那些都不是国产的自研技术，也不细表了。

Tair是阿里自研的开源缓存服务中间件（Github地址：。https://github.com/alibaba/tair）提供快速访问的内存（MDB引擎）/持久化（LDB引擎）存储服务，基于高性能、高可用的分布式集群架构，满足读写性能要求高及容量可弹性伸缩的业务需求，在双十一秒杀的体系内完成乾坤大挪移般的加速工作。

通常情况下，一个 Tair 集群中包含2台 Configserver 及多台 DataServer。其中两台 Configserver 互为主备。通过和 Dataserver 之间的心跳检测获取集群中存活可用的 Dataserver，构建数据在集群中的分布信息。Dataserver 负责数据的存储，并按照 Configserver 的指示完成数据的复制和迁移工作。Client 在启动的时候，从 Configserver 获取数据分布信息，根据数据分布信息，和相应的 Dataserver 进行交互，完成用户的请求。

![](/images/dataserver.png)

其核心的模块就是Configserver，具体的代码在

https://github.com/alibaba/tair/blob/master/src/configserver/conf_server_table_manager.cpp

以初始化函数为例：
```
using namespace std;
 
void conf_server_table_manager::init()
 
{ flag = client_version = server_version = server_bucket_count = server_copy_count = plugins_version = area_capacity_version = last_load_config_time = NULL;//初始化标志位
 
&nbsp;migrate_block_count = NULL;
 
&nbsp;hash_table = m_hash_table = d_hash_table = NULL;
 
&nbsp;file_name = "";
 
&nbsp;hash_table_deflate_data_for_client = hash_table_deflate_data_for_data_server = NULL;
 
&nbsp;hash_table_deflate_data_for_client_size = hash_table_deflate_data_for_data_server_size = 0;
 
&nbsp;file_opened = false;
 
&nbsp;if(transition_version != NULL)//如不为空，则删除
 
&nbsp;{
 
&nbsp;&nbsp;&nbsp; delete transition_version;
 
&nbsp;}
 
&nbsp;if(recovery_version != NULL)//如不为空，则删除
 
&nbsp;{
 
&nbsp;&nbsp; delete recovery_version;
 
&nbsp;}
 
&nbsp;if(recovery_block_count != NULL) //如不为空，则删除
 
&nbsp;{
 
&nbsp;&nbsp;&nbsp; delete recovery_block_count;
 
&nbsp;}
 
&nbsp;transition_version = new uint32_t();
 
&nbsp;recovery_version = new uint32_t();
 
&nbsp;recovery_block_count = new int32_t();
 
&nbsp;*transition_version = 0;
 
&nbsp;*recovery_version = 0;
 
&nbsp;*recovery_block_count = -1;
 
}

```
凌波微步--SOFAStack：SOFAStack（Scalable Open Financial Architecture Stack）是阿里研发的一套开源的用于构建微服务的分布式中间件（Github地址：https://github.com/sofastack），微服务最大的优势就是方便灵活，与凌波微步的武功有异曲同工之妙。它包含了构建微服务体系的众多组件，包括研发框架、RPC 框架，服务注册中心，分布式链路追踪，Metrics监控度量、分布式事务框架、服务治理平台等，结合社区优秀的开源产品，可以快速搭建一套完善的微服务体系。
：https://blog.csdn.net/BEYONDMA/article/details/103213493

使用SOFAStack可以快速的构建出架构完整的微服务体系：

![](/images/sofastack.png)

九阳神功-OceanBase:勇夺TPC冠军的OceanBase也是阿里自研的金融级关系型数据库，由于是其集群化的特性使其具备了有如九阳神功般取之不尽，用之不竭的内力。

![](/images/occeanbase.jpeg)

笔者在前文《200行代码解读国产数据库阿里OceanBase的速度之源》 《揭秘OceanBase的王者攻略》已经对于这个数据库做了详尽的介绍，这里不再赘述。

武穆遗书-飞天操作系统：飞天（Apsara）是由阿里云自主研发、服务全球的超大规模通用计算操作系统。正所谓韩信点兵，多多益善，飞天能将百万级服务器连成一台超级计算机，还能有条不紊的通过云计算向用户提供计算能力。

我们看到在飞天的基础公共模块之上，有两个最核心的服务，一个是盘古，另一个是伏羲。盘古是存储管理服务，伏羲是资源调度服务，飞天内核之上应用的存储和资源的分配都是由盘古和伏羲管理。具体见下图：

![](/images/feitian.jpeg)

飞天最底层是遍布全球的几十个数据中心，成百上千万台服务器，把这么多服务器连成一片变成一个整体，绝对是上乘的兵法才能做到的，所以飞天堪称是阿里“双十一“的武穆兵法。

真武七截阵-神龙云服务器: 在《倚天屠龙记》中真武七截阵是由张三丰创始的阵法，人数越多威力越强，而神龙云服务器也其最大的特点就是把虚拟化层的损耗几乎为零，随着物理服务数量的增多，性能却一点也不打折，堪称IT界的真武七截阵。

其最大亮点是阿里自研的MOC芯片，MOC是专门用于虚拟化层的调度服务，将宝贵的CPU与内存资源由复杂的云调度中解放出来，开创了一种新型的云服务器形式，神龙能与阿里云产品家族中的其他计算产品无缝对接。比如存储、网络、数据库等产品，完全兼容ECS云服务器实例的镜像系统，可以自由地在普通ECS实例以及神龙云服务器实例间变配，从而更多元化地结合客户的业务场景进行资源构建。


所以阿里的“双十一”既有顶级的武学又有强悍的阵法、兵法加持，所以才能达到如此的高度，不久前阿里的平头哥芯片公司发布了无剑平台，这可能也代表着阿里的技术体系已经到了既刚且灵的境界。不仅如此纵阿里的技术体系最令人惊喜的是这些技术全部出于国产自研，甚至大部分已经开源，相信今后国产的底层软件也会在阿里等龙头的带领下迎来爆发。




