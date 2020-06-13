title: docker重指定挂载镜像
author: Joe Tong
tags:
  - DOCKER
categories: 
  - IT
date: 2019-07-22 06:36:00
---
docker-修改容器的挂载目录三种方式  
方式一：修改配置文件（需停止docker服务）  
1、停止docker服务  
systemctl stop docker.service（关键，修改之前必须停止docker服务）  
2、vim /var/lib/docker/containers/container-ID/config.v2.json  
修改配置文件中的目录位置，然后保存退出  

 "MountPoints":{"/home":{"Source":"/docker","Destination":"/home","RW":true,"Name":"","Driver":"","Type":"bind","Propagation":"rprivate","Spec":{"Type":"bind","Source":"//docker/","Target":"/home"}}}

3、启动docker服务  
systemctl start docker.service  
4、启动docker容器  
docker start &lt;container-name/ID&gt;  
方式二：提交现有容器为新镜像，然后重新运行它  

$ docker ps  -a   &nbsp;
|CONTAINERID|IMAGE|COMMAND|CREATED|STATUS|PORTS|NAMES|    
|:-|:-|:-|:-|:-|:-|:-|   &nbsp;
|5a3422adeead|ubuntu:14.04|"/bin/bash"| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; About a minute ago|Exited(0)|About a minute ago|agitated_newton|  
$ docker commit 5a3422adeead newimagename  
$ docker run -ti -v "$PWD/dir1":/dir1 -v    "$PWD/dir2":/dir2 newimagename /bin/bash  

然后停止旧容器，并使用这个新容器，如果由于某种原因需要新容器使用旧名称，请在删除旧容器后使用docker rename。  
方式三：export容器为镜像，然后import为新镜像  

$docker container export -o ./myimage.docker 容器ID  
$docker import ./myimage.docker newimagename   
$docker run -ti -v "$PWD/dir1":/dir1 -v    "$PWD/dir2":/dir2 newimagename /bin/bash  

然后停止旧容器，并使用这个新容器，如果由于某种原因需要新容器使用旧名称，请在删除旧容器后使用docker rename。  
