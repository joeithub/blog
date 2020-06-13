title: docker onos
author: Joe Tong
tags:
  - ONOS
  - DOCKER
categories:
  - IT
date: 2019-07-24 06:17:00
---
在Docker中运行ONOS  

下载镜像：  

`docker pull onosproject/onos`

![upload successful](/images/pasted-19.png)


 查看上一步下载的镜像

`docker images`

![upload successful](/images/pasted-20.png)

  

  

创建docker容器实例  
`docker run -t -d --name onos1 onosproject/onos`

  
![upload successful](/images/pasted-21.png)


 查看上一步创建的docker实例  



![upload successful](/images/pasted-22.png)

修改~/.bashrc文件，获取容器实例的IP  
```
docker-ip() {

sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"

}
```
  

`. ~/.bashrc`

  

 

用SSH连接一个容器实例，密码是karaf  
```
ssh -p 8101 karaf@`docker-ip onos1`
```

![upload successful](/images/pasted-23.png)

  

 激活Openflow

onos&gt; app activate org.onosproject.openflow

onos&gt; app activate org.onosproject.fwd


![upload successful](/images/pasted-24.png)

如果上述命令报错，则SSH连接到其它docker实例,直至成功激活Openflow

  

  

测试  
`apt install mininet`
```
mn --topo tree,2 --controller remote,ip=`docker-ip onos3`
```


![upload successful](/images/pasted-25.png)

![upload successful](/images/pasted-26.png)
