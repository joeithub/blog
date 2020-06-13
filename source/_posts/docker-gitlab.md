title: docker gitlab
author: Joe Tong
tags:
  - DOCKER
  - GITLAB
categories:
  - IT
date: 2019-07-16 17:54:00
---
使用docker搭建gitlab初体验+数据备份

一. 背景  
作为程序员，像GitHub这种好工具是必须得十分了解的，但是有时GitHub并不能满足我们所有的需求，就如作者所在的公司，我们的代码都是商业性的产品，不可能放到GitHub的开放仓库中的，而申请GitHub私人仓库需要钱。这就陷入了尴尬的局面，那有没有一种既能具有GitHub一样的功能，又能保护隐私免费的管理工具呢？答案是肯定的，感谢程序员伟大的开源精神，我们有了GitLab!!!今天笔者在这里就跟大家分享一下自己使用docker搭建GitLab的过程吧，这其中踩了一些坑，希望看过这篇文章的人不用在踩我踩过的坑了！  
二. 环境介绍  
服务器信息：  
CPU : 2  
DISK : 30G  
RAM : 4G  
OS : Linux centos7-0 3.10.0-229.el7.x86_64  
这里笔者使用的是自己公司的服务器，也可以使用虚拟机进行搭建  
三. 搭建过程  
1. 安装docker  
因为我们是使用docker搭建的，所以需要先安装docker，docker支持不同的OS，具体的安装信息这里不做详细介绍，可以自己的操作系统，参考官方的安装指南进行安装。  http://www.docker.io  
2. 安装GitLab及相关组件  
GitLab需要用到数据库来存储相关数据，所以需要在安装GitLab的同时安装数据库，这里使用的是postgresql和redis。我在查找相关的镜像，之后发现有很多现成的镜像，这里我使用的sameersbn镜像。但是有一点我认为不是很好的是：这个镜像没有把redis、postgresql集成到gitlab的容器里面，需要先单独pull这两个镜像run一下，然后再pull gitlab的镜像进行安装。  
使用如下命令分别拉取最新的镜像：  
docker pull sameersbn/redis  
docker pull sameersbn/postgresql  
docker pull sameersbn/gitlab  
这里有第一个坑：因为我们默认都是从docker的官方仓库中拉去镜像，但是由于国内访问国外的网站有墙，而且速度也是十分的慢，所以需要代理。这里推荐Daocloud加速器 https://www.daocloud.io/ 免费使用，但是需要先注册，登录成功后，找到加速器执行相关命令即可。笔者亲测速度明显快很多！  
使用如下命令运行postgresql镜像：  
```
docker run --name postgresql -d \  
-e 'DB_NAME=gitlabhq_production' \  
-e 'DB_USER=gitlab' \
-e 'DB_PASS=password' \  
-e 'DB_EXTENSION=pg_trgm' \  
-v /home/root/opt/postgresql/data:/var/lib/postgresql \  
sameersbn/postgresql
```
这里需要解释的是：
(1). 以上是一条命令，反斜杠是为了在命令内换行方便阅读，如果不喜欢，也可以写在一行。  
(2). -e后面跟的都是容器的环境参数，都是在制作镜像的时候指定好的，所以不要去改动。  
(3). -v后面是添加数据卷，这样在容器退出的时候数据就不会丢失，其中 /home/root/opt/postgresql/data是作者自己创建的文件夹，读者可以自己自定义，后面的部分是容器内的文件路径，需要保持不变。  
(4). 命令执行成功之后会在控制台显示一串容器的编号，可以使用命令docker ps查看刚刚启动的容器。  

使用如下命令运行redis镜像：  
```
docker run --name redis -d \  
-v /home/root/opt/redis/data:/var/lib/redis \  
sameersbn/redis 
```
这里跟启动postgresql一样。
使用如下命令运行GitLab镜像：
```
docker run --name gitlab -d \
--link postgresql:postgresql --link redis:redisio \
-p 10022:22 -p 10080:80 \
-e 'GITLAB_PORT=10080' \
-e 'GITLAB_SSH_PORT=10022' \
-e 'GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string'\
-e 'GITLAB_SECRETS_SECRET_KEY_BASE=long-and-random-alpha-numeric-string' \
-e 'GITLAB_SECRETS_OTP_KEY_BASE=long-and-random-alpha-numeric-string'\
-e 'GITLAB_HOST=服务器地址' \
-e 'GITLAB_EMAIL=邮箱地址' \
-e 'SMTP_ENABLED=true' \
-e 'SMTP_DOMAIN=www.sina.com' \
-e 'SMTP_HOST=smtp.sina.com' \ 
-e 'SMTP_STARTTLS=false'  \
-e 'SMTP_USER=邮箱地址' \
-e 'SMTP_PASS=邮箱密码' \
-e 'SMTP_AUTHENTICATION=login' \
-e 'GITLAB_BACKUP_SCHEDULE=daily' \
-e 'GITLAB_BACKUP_TIME=10:30' \
-v /home/root/opt/gitlab/data:/home/git/data \
sameersbn/gitlab
```
这里需要解释的是：
(1). 网上又很多教程讲关于使用docker安装GitLab，但是讲的不全面，至少我按照他们的方法安装时不能正常运行，这里是第三个坑：一定要加上如下环境参数：
```
-e 'GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string'\
-e 'GITLAB_SECRETS_SECRET_KEY_BASE=long-and-random-alpha-numeric-string' \
-e 'GITLAB_SECRETS_OTP_KEY_BASE=long-and-random-alpha-numeric-string'\
```
有关于这三个环境参数的含义：



官方的解释 

我个人的理解是用来进行加密的key。
(2). 上面有关SMTP的环境参数是配置邮箱的，需要填上对应的邮箱信息，我使用的是新浪邮箱，读者可以根据自己的邮箱进行填写。
(3). 使用GitLab需要两个端口，一个是web端口，一个是SSH端口用于push代码的所以一下代码进行端口映射和指定：

-p 10022:22 -p 10080:80 \
-e 'GITLAB_PORT=10080' \
-e 'GITLAB_SSH_PORT=10022' \
(4). GitLab有自带的备份，这里可以通过如下进行配置：
-e 'GITLAB_BACKUP_SCHEDULE=daily' \
-e 'GITLAB_BACKUP_TIME=10:30' \
指定的是每天10:30进行备份。
说到这里基本上GitLab就搭建好了，这里还有一个小坑就是：运行这些容器的时候可以把代码写进shell脚本中，然后通过脚本进行运行，不然直接在终端打的话很麻烦。
一下就是笔者安装完后的截图，直接访问：http://服务器地址:10080 即可，首次访问可能会出现错误页面，刷新几下页面就可以了然后在修改密码默认用户名：root 之后就可以正常使用。


登录界面 


group 


admin area 
四. 备份
我们可以使用GitLab自带的备份功能，在启动容器的时候就进行设置，然后再使用GitLab的 app:rake gitlab:backup:restore命令进行恢复，这里网上的教程都有说明可以参考以下网站：
sameersbn的GitHub wiki：
https://github.com/sameersbn/docker-gitlab#automated-backups
这个是官方的所以比较全面，里面还有关于各种环境参数的介绍。
这里作者使用的是如下的备份方法：
因为我们在运行postgresql、redis和GitLab的时候都使用了本地的文件夹进行了数据的持久化，而且我们实际需要备份的数据都在本地了，那么其实就可以直接使用rsync命令备份本地的这些卷（刚刚的文件夹）即可，无需再去深入到GitLab内部。如果搭建的GitLab崩溃了，或者服务器崩溃了，直接再使用docker再搭一个，在把刚刚的卷跟对应的postgresql、redis和GitLab内的数据文件夹进行映射即可。这是也不需要修改之前的启动命令，十分的方便而且作者自己测试过，发现能够达到要求，原先的仓库、用户的SSH信息等都在。



修改100.230 /data/gitlab_875/config/gitlab.rb (docker gitlab875 /etc/gitlab/gitlab.rb)
增加:  
```
gitlab_rails['smtp_enable'] = true
#gitlab_rails['smtp_address'] = "smtp.domain.cn"
gitlab_rails['smtp_address'] = "12.34.56.78"
gitlab_rails['smtp_port'] = 25
gitlab_rails['smtp_user_name'] = "gitlabadmin@domain.cn"
gitlab_rails['smtp_password'] = "yourpassword"
gitlab_rails['smtp_domain'] = "smtp.domain.cn"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false
gitlab_rails['smtp_openssl_verify_mode'] = 'none'

gitlab_rails['gitlab_email_enabled'] = true
gitlab_rails['gitlab_email_from'] = 'gitlabadmin@domain.cn'
gitlab_rails['gitlab_email_display_name'] = 'gitlabadmin'
gitlab_rails['gitlab_email_reply_to'] = 'gitlabadmin@domain.cn'
gitlab_rails['gitlab_email_subject_suffix'] = ''
```
