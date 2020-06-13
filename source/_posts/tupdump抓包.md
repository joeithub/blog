title: tupdump抓包
author: Joe Tong
tags:
  - LINUX
  - SHELL
categories:
  - IT
date: 2019-08-31 19:10:00
---
### tcpdump 抓包写文件

抓端口8080的包  
```
tcpdump tcp port 8080 -n 
tcpdump tcp port 8080 -w /tmp/xxxx.cap
```

抓119.29.121.116的80端口的包   
`tcpdump tcp port 8080 and host 10.104.102.228 -n`

`tcpdump tcp port 8080 and host 10.104.102.228 -w /tmp/xxxx.cap
`

**tcpdump 的抓包保存到文件的命令参数是-w xxx.cap ** 

抓eth0的包    

`tcpdump -i eth0 -w /tmp/xxx.cap`

抓端口8080的包  

`tcpdump tcp port 8080 -w /tmp/xxxx.cap
` 

抓 119.29.121.116的包  

`tcpdump -i eth0 host 119.29.121.116 -w /tmp/xxx.cap`  

抓119.29.121.116的80端口的包  

`tcpdump -i eth0 host 119.29.121.116 and port 80 -w /tmp/xxx.cap`


抓119.29.121.116的icmp的包

`tcpdump -i eth0 host 119.29.121.116 and icmp -w /tmp/xxx.cap`


抓119.29.121.116的80端口和110和25以外的其他端口的包  

`tcpdump -i eth0 host 119.29.121.116 and ! port 80 and ! port 25 and ! port 110 -w /tmp/xxx.cap`

抓vlan 1的包   

`tcpdump -i eth0 port 80 and vlan 1 -w /tmp/xxx.cap`

抓pppoe的密码  

`tcpdump -i eth0 pppoes -w /tmp/xxx.cap`  

以100m大小分割保存文件， 超过100m另开一个文件 -C 100m  

抓10000个包后退出 -c 10000  

后台抓包， 控制台退出也不会影响：  

nohup tcpdump -i eth0 port 110 -w /tmp/xxx.cap &amp;  

抓下来的文件可以直接用ethereal 或者wireshark打开。 
