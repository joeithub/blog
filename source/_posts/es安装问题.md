title: es安装问题
author: Joe Tong
tags:
  - ES
categories:  
  - IT
date: 2020-02-29 17:47:36
---

# 1 max file descriptors [65535] for elasticsearch process likely too low, increase to at least [65536]
&nbsp; &nbsp; vim /etc/security/limits.conf
&nbsp; &nbsp; 添加如下内容:
&nbsp; &nbsp; elasticsearch &nbsp;- &nbsp;nofile &nbsp;65536
# 2 elasticsearch dead but subsys locked
&nbsp; &nbsp; rm /var/lock/subsys/elasticsearch
# 3 system call filters failed to install; check the logs and fix your configuration or disable system call filters at your own risk
&nbsp; &nbsp; centos6 不支持 bootstrap.system_call_filter
&nbsp; &nbsp; 修改elasticsearch.yml设置bootstrap.system_call_filter: false
# 4 安装X-pack证书
&nbsp; &nbsp; curl -XPUT -u elastic 'http://&lt;host&gt;:&lt;port&gt;/_xpack/license' -H "Content-Type: application/json" -d @license.json
# 5 &nbsp;max number of threads [1024] for user [elasticsearch] is too low, increase to at least [2048]
&nbsp; &nbsp; vim /etc/security/limits.conf
&nbsp; &nbsp; 添加如下内容:
&nbsp; &nbsp; elasticsearch - nproc 2048
# 6 error: "net.bridge.bridge-nf-call-ip6tables" is an unknown key&nbsp;
&nbsp; &nbsp; 先执行
&nbsp; &nbsp; modprobe bridge
# 7 memory locking requested for elasticsearch process but memory is not locked
&nbsp; &nbsp; vim /etc/security/limits.conf
&nbsp; &nbsp; 添加如下内容
&nbsp; &nbsp; elasticsearch soft memlock unlimited
&nbsp; &nbsp; elasticsearch hard memlock unlimited
# 8 如果怎么也连接不上主节点
&nbsp; &nbsp; 修改防火墙配置或者关闭防火墙
&nbsp; &nbsp; service iptables stop
# 9 detected index data in default.path.data [/var/lib/elasticsearch] where there should not be any
&nbsp; &nbsp; 这是因为在配置自定义datapath前启动了es, 确认之前的启动是误启动，删除留下的文件即可
&nbsp; &nbsp; rm -rf /var/lib/elasticsearch/nodes



