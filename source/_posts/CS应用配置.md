#### 【EnUSP】windows/mac客户端的针对B/S和C/S业务配置采用相同的配置入口

[TOC]

### 需求描述

可以在应用发布中，添加Web应用和网络层应用。

其中网络层应用即对应C/S应用，并通过隧道方式可以访问。

在网络层应用发布中，添加内网策略配置，定义内网访问的感兴趣流量。

同时可以定义访问域名黑白名单，设定访问的权限。

### 需求分析

在应用类型中添加CS应用，对应白名单， 

在安全策略访问策略中添加 CS策略对应黑名单，

用户登录时一并下发给网关

### 实现方案

一、 添加cs应用:

应用类型中添加cs应用选项

CS应用对应的配置有

1.配置项（ip和域名），

2.ip

- IP ip为特定的某一个ip而不是IP段

- 协议 （TCP、UDP、ANY）(ANY表示TCP,UDP都可) 

- 端口

  <img src="C:\Users\tongq\Desktop\2.png" alt="2" style="zoom: 100%;" />

3.域名

- 域名

- 内网IP

- 协议 （TCP、UDP、ANY）(ANY表示TCP,UDP都可) 

- 端口

  <img src="C:\Users\tongq\Desktop\5.png" alt="5" style="zoom:100%;" />

  合并存到`tb_apps_service_info` 里的server字段中 

  *例:* 
  
  > TCP://enlink.cn-192.168.10.10:443
  >
  > UDP://192.168.10.10:1010
  >
  > ANY://192.168.10.10:9000

<img src="C:\Users\tongq\Desktop\1.png" alt="1" style="zoom: 80%;" />

<img src="C:\Users\tongq\Desktop\2.png" alt="2" style="zoom: 85%;" />

<img src="C:\Users\tongq\Desktop\5.png" alt="5" style="zoom:85%;" />

<img src="C:\Users\tongq\Desktop\3.png" alt="3" style="zoom:77%;" />

<img src="C:\Users\tongq\Desktop\4.png" alt="4" style="zoom:77%;" />

添加cs应用同时绑定角色和应用分组和网关以及信用等级等

添加应用接口

`ip:port/api/service/add`

method: P

body

```
{
    connectState: "0"
    description: ""
    group: ""
    groupSearch: ""
    icon: "/files/icon/app.png"
    id: ""
    name: "cs"
    path: ""
    server: "tcp://192.168.10.10:9555"
    terminalProtocol: ""
    type: "cs"
}
```

二、应用分组中添加cs组

```
INSERT INTO `tb_apps_service_group`(`id`, `name`, `parent_id`, `path`, `description`, `sort_number`, `state`, `creator`, `create_time`, `updator`, `update_time`) VALUES ('3', 'cs', '0', '/cs', '', 'A', '0', '00000000-2019-0918-0000-admin0000000', '2020-03-09 13:45:14', '00000000-2019-0918-0000-admin0000000', '2020-03-26 19:45:24');
```

![7](C:\Users\tongq\Desktop\7.png)

三、在策略表`tb_apps_strategy_conf`type中加上一种类型53用作CS策略,同时在/user/strategy/access/add接口中加上cs策略type=53的判断

![6](C:\Users\tongq\Desktop\6.png)

四、用户登录通知网关

延用web应用下发逻辑

