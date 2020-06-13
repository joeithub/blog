title: es设置密码
author: Joe Tong
tags:
  - JAVAEE
  - ES
categories:  
  - IT
date: 2020-06-04 16:28:18
---

[TOC]

# es设置密码
elasticsearch 6.3 以后的版本不需要license

tar包安装的 elasticsearch 配置用户名密码
## 生成证书
到bin文件夹下（CA证书：elastic-stack-ca.p12）
`./elasticsearch-certutil ca `

`./elasticsearch-certutil cert --ca elastic-stack-ca.p12 `

上面命令执行成功后，会生成elastic-certificates.p12证书
将elastic-stack-ca.p12 elastic-certificates.p12 移动到 配置文件目录


## 配置文件
```
#数据地址
path.data: /var/lib/elasticsearch3
#日志地址
path.logs: /var/log/elasticsearch3
#集群名称
cluster.name: enlink-es6.8
#节点名称
node.name: 10.10.10.4
#network.host: 0.0.0.0
#允许访问的地址
network.host: 10.10.10.4
#端口
http.port: 9200
#集群交互端口
#transport.tcp.port: 9300
#ping集群地址
discovery.zen.ping.unicast.hosts: ["10.20.0.179:9302", "10.10.10.3:9300", "10.10.10.2:9300"]
#至少发现多少节点组成集群
discovery.zen.minimum_master_nodes: 2
#是否锁定内存
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
#开启（安全）密码功能
xpack.security.enabled: true
#ssl认证开启
xpack.security.transport.ssl.enabled: true
#认证的方式通过证书
xpack.security.transport.ssl.verification_mode: certificate
#证书放的位置
xpack.security.transport.ssl.keystore.path: ./elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: ./elastic-certificates.p12
#允许跨域
http.cors.enabled: true
http.cors.allow-origin: "*"
http.cors.allow-headers: X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization
```

## 后台运行
`./elasticsearch -d`

## 配置用户名密码
`elasticsearch-setup-passwords interactive`

#数据迁移
&gt; 将数据目录下的索引里的所有文件夹拷到新集群数据地址的索引目录即可

例如
原集群数据地址`/var/lib/elasticsearch/nodes/0/indices/`
新集群数据地址`/var/lib/elasticsearch3/nodes/0/indices/`
直接将原集群索引数据拷贝到新集群数据地址即可





