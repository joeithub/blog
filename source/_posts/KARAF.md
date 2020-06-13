title: KARAF
author: Joe Tong
tags:
  - KARAF
  - JAVAEE
categories:
  - IT
date: 2019-07-24 19:18:00
---
Karaf：简述对Karaf的认识

Karaf是基于OSGI之上建立的应用容器，能方便部署各种选定的组件，简化打包和安装应用的操作难度。Open DayLight项目发布之初，后台框架仅采用OSG技术，但自从第三版氦He版本至今， Open Daylight项目就采用了Kaaf作为后台的框架，明显提升了项目的可用性和灵活性。
Karaf是一个 Apache软件基金会项目，具有 Apache v2许可证。是一个基于实时运行的轻量级的基于OSGI的容器，各种组件和应用都能部署到这个容器中。  
一、Karaf 的架构图 &nbsp;
![upload successful](/images/pasted-27.png)
二、Karaf 的安装目录结构 &nbsp;

/bin: 启动脚本  
/etc: 初始化文件  
/data: 工作目录  
/cache: OSGi框架包缓存  
/generated-bundles: 部署使用的临时文件夹  
/log: 日志文件  
/deploy: 热部署目录  
/instances: 含有子实例的目录  
/lib: 包含引导库  
/lib/ext:JRE扩展目录  
/lib/endorsed: 赞同库目录 
/system: OSGi包库，作为一个Maven2存储库  


三、Karaf的基本特性  
Karaf典型的特性有:  
热部署： Karaf支持 OSGI bundles的热部署。实现这个支持的关键在于 Karaf持续监测[home]/deply目录内的jar文件。每次当一个jar文件被复制到这个文件夹内，它将在运行时被安装。可以更新或删除它，这个改动将被自动处理。此外， Karaf也支持 exploded bundles和自定义的部署(默认包含 blueprint和 spring)  
动态配置：服务通常通过OsGi服务的配置管理来进行配置。这样的配置可在 Karaf中的[home]/ec目录使用合适的文件进行定义。这样配置被监控，并且属性的改变将传播给服务。
日志系统：使用Log4J支持的集中日志后端，Kaaf能支持许多不同的APls(JDK14、JCL、SLF4J、 Avalon、 Tomcat、OSGi)。  
供应：库或应用的供应( Provisioning)能通过不同的方式完成。供应在本地下载、安装、启动。
原生OS整合：Karaf能以服务的方式整合到一个操作系统OS中，这样生命周期就和这个OS相绑定。
扩展的内核控制台：Karaf的内核控制台可管理服务，安装新应用或库，并且管理它们的状态。这个内核能通过部署新命令以安装新功能或应用实现动态扩展。  
远程访问：使用任何的SSH客户端以连接Karaf并且在控制台发出命令。  
基于JAAS的安全框架。  
管理实例：Karaf提供简单的命令以管理多实例。通过控制台能简单地创建、删除、启动、终止 Karaf的实例。  
四、karaf在 Open Daylight使用中的一些常用命令  
[cmd]-help：获取一个指定命令的相关帮助。    
`若需要了解 bundle: list命令，则输入:bundle: list --help; Karat将返回有关这个命令的帮助。`
features: list：查看已安装的 features。  
`feature: install my_feature：安装本地 feature的命令。  `
如 `feature: install odl-reston。  `
`feature:uninstall my_feature`:卸载已经安装的fm的命令。  
如  
`feature uninstall odl-restconf ` 

`feature: repo-add my repo：将库安装至本地。`  
如 `feature: repo-add camel2.152  `

log: display：显示系统日志，可配合grep来筛选需要查看的内容。  
system: shutdown：关闭系统，退出 Karaf。同样也可运行halt命令退出 Karaf。  
注意:  
进入 Karaf的控制台后，按&lt; Tab &gt;键即可显示目前所有可用的命令。  
控制台支持&lt; Tab &gt;键的输入辅助完成功能，当输入一个命令的前面一些字符时，按&lt; Tab &gt;键后，控制台将自动列出所有可能的命令，并且在只有一个提示命令时自动完成该命令的输入。

Karaf教程之安装和应用开发

概览

安装和启动

一些便利的命令

Tasklist - 一个小的OSGI应用

父pom和通用工程的设置

Tasklist-model

Tasklist-persistence

Tasklist-ui

Tasklist-features

在Karaf中安装应用

总结



概览

以这篇文章为起点，我将开始写一系列关于Apache Karaf的文章，Apache Karaf是一个基于Equinox或者Felix框架开发的一个OSGI容器。 
与这些框架最大的不同在于它带来了优秀的管理功能。

Karaf突出的特性如下: 
- 可扩展控制台和Bash相似的命令补齐功能 
- ssh控制台 
- 从maven仓库中获取bundles和features的部署文件 
- 可以在命令行中轻松的创建一个新的实例

所有这些特性使开发服务端OSGi应用和开发一般的java应用几乎一样的简单。 
从某个层面上，部署和管理比目前我知道所有应用服务器都好。所有这些karaf特性的结合带来了最终的程序。在我看来，Karaf允许轻量级的开发风格就像J2EE结合spring应用程序的灵活性一样。

安装和启动

从karaf官网下载Karaf4.0.7。
解压并运行bin/karaf。
一些便利的命令

|命令|描述
|:-|:-|
|la	|显示所有安装的bundle|
|list|显示用户的bundle|
|service:list|显示active的OSGI服务。这个列表十分长。这里有一个方便的方法，就是你可以使用unix的管道，如 “ls
|exports|显示导出的packages和bundles，这个命令可以帮助你查找出package是来自哪里
|feature:list|显示所有feature包括已安装和未安装的
|feature:install webconsole|	访问http://localhost:8181/system/console，用karaf/karaf登录并花些时间看下它所提供的信息
|diag|	显示那些无法启动的bundle的诊断信息
|log:tail|	显示日志。可以按ctrl-c返回控制台
|Ctrl-d|	退出控制台。如果是主控制台，则karaf被关闭
重启后OSGI容器会保存状态

注意Karaf和其他所有的OSGI容器一样会维护已安装和已启动的bundles的最后状态。所以如果有些组件再也不能工作，重启也不一定有所帮助。为了启动一个全新的Karaf，可以停止karaf然后删除data目录或者启动的时候加个clean参数bin/karaf clean。

检查日志

Karaf运行的时候非常安静。为了不错过错误消息，可以运行tail -f data/karaf.log让日志文件处于打开状态。

Tasklist - 一个小的OSGI应用

没有任何有用的应用，Karaf是一个很棒但是没用的容器。所以让我们来创建第一个应用吧。好消息是创建一个OSGI应用非常的简单，maven会处理很多事情。和一个正常的maven工程的差异是非常少的。我推荐使用Eclipse 4写应用程序，Eclipse 4默认已经安装m2eclipse插件。

从github的Karaf-Tutorial仓库中获取源码。

`git clone https://github.com/cschneider/Karaf-Tutorial.git`  

或者从 https://github.com/cschneider/Karaf-Tutorial/zipball/master 下载示例工程，然后解压到某个目录下。  

导入到Eclipse   
- 启动Eclipse Neon或者更新版本。   
- 在Eclipse中选择File -&gt; Import -&gt; Existing maven project -&gt; Browse到刚才解压的目录选择tasklist 子文件夹。   
- Eclipse将显示所有它找到的maven工程。   
- 单击默认导入所有工程。  

Eclipse将导入所有的工程并使用m2eclipse插件管理它们之间所有的依赖。  

tasklist有以下这些工程组成。  

|模块	|描述
|:-|:-|
|tasklist-model|	服务接口和Task类
|tasklist-persistence|	提供了一个TaskService接口的简单持久化实现
|tasklist-ui|	使用TaskService显示任务列表的servlet
|tasklist-features|	为应用提供features的描述信息，使应用能够很容易的安装到Karaf容器中
父pom和通用工程的设置

pom.xml打包bundle，而maven-bundle-plugin创建具有OSGi Manifest信息的jar包。默认情况，插件导入java文件import的或者在bluneprint上下文引用的所有的包。同时导出不包含内部实现的所有包。在我们的例子中我们想要model包被导入，但是persistence的实现包不导入。按照命名约定，我们不需要额外的配置。

Tasklist-model

这个工程包含domain model，这里指Task类和TaskService接口。model同时被persistence工程和用户界面工程使用。任意TaskService服务的使用者只需要依赖model工程。所以不用直接绑定到当前的实现。

Tasklist-persistence

简单持久化实现的TaskServiceImpl类用一个简单的HashMap管理task。类用@Singleton注解标记自己为blueprint bean。注解@OsgiServiceProvider用于标记为自己是一个OSGi服务，而@Properties注解允许添加服务属性。在这个例子中我们设置的属性service.exported.interfaces可以被我们在后续的教程要介绍的CXF-DOSGI使用。目前该教程这个属性可以删除。
```
@OsgiServiceProvider
@Properties(@Property(name = "service.exported.interfaces", value = "*"))
@Singleton
public class TaskServiceImpl implements TaskService {
    ...
}
```
blueprint-maven-plugin插件将处理上面的类，且自动创建合适的blueprint xml文件。这样可以帮我们节省手动写blueprint xml文件的时间。

自动创建的blueprint xml文件位于target/generated-resources文件夹下
```
&lt;blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0"&gt;
    &lt;bean id="taskService" class="net.lr.tasklist.persistence.impl.TaskServiceImpl" /&gt;
    &lt;service ref="taskService" interface="net.lr.tasklist.model.TaskService" /&gt;
&lt;/blueprint&gt;
```

Tasklist-ui

UI工程使用一个TaskServlet显示任务列表和单独的任务。为了和tasks任务协作，这个servlet需要TaskService服务。我们通过使用注解@Inject和@OsgiService注入TaskService服务，@Inject注解能够根据类型注入任意的实例。而注解@OsgiService将创建一个指定类型的OSGiSerivce服务的blueprint引用。（译注：这里我是这么理解的，@OsgiService表示从Karaf中获取一个bean，@Inject则负责注入） 
这个类被暴露为一个OSGi服务,该类是一个有特别属性alias=/tasklist的接口java.http.Servlet实现。这样做触发了pax web的whiteboard扩展器接收这个服务，并使用url /tasklist映射到该servlet。

相关代码小片段
```
@OsgiServiceProvider(classes = Servlet.class)
@Properties(@Property(name = "alias", value = "/tasklist"))
@Singleton
public class TaskListServlet extends HttpServlet {

    @Inject @OsgiService
    TaskService taskService;
}
```
自动创建的blueprint xml文件位于target/generated-resources文件夹下
```
&lt;blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0"&gt;
    &lt;reference id="taskService" availability="mandatory" interface="net.lr.tasklist.model.TaskService" /&gt;
    &lt;bean id="taskServlet" class="net.lr.tasklist.ui.TaskListServlet"&gt;
        &lt;property name="taskService" ref="taskService"&gt;&lt;/property&gt;
    &lt;/bean&gt;
    &lt;service ref="taskServlet" interface="javax.servlet.http.HttpServlet"&gt;
        &lt;service-properties&gt;
            &lt;entry key="alias" value="/tasklist" /&gt;
        &lt;/service-properties&gt;
    &lt;/service&gt;
&lt;/blueprint&gt;
```
Tasklist-features

最后一个工程仅安装一个feature描述信息文件到一个maven仓库，这样我们可以很容易的安装应用到Karaf。描述信息定义了一个叫tasklist的feature和将从maven仓库下载安装的bundles
```
&lt;feature name="example-tasklist-persistence" version="${pom.version}"&gt;
    &lt;bundle&gt;mvn:net.lr.tasklist/tasklist-model/${pom.version}&lt;/bundle&gt;
    &lt;bundle&gt;mvn:net.lr.tasklist/tasklist-persistence/${pom.version}&lt;/bundle&gt;
&lt;/feature&gt;

&lt;feature name="example-tasklist-ui" version="${pom.version}"&gt;
    &lt;feature&gt;http&lt;/feature&gt;
    &lt;feature&gt;http-whiteboard&lt;/feature&gt;
    &lt;bundle&gt;mvn:net.lr.tasklist/tasklist-model/${pom.version}&lt;/bundle&gt;
    &lt;bundle&gt;mvn:net.lr.tasklist/tasklist-ui/${pom.version}&lt;/bundle&gt;
&lt;/feature&gt;
```
一个feature可以由其他features和bundles组成，这些features和bundles也应该被安装。一般bundles使用mvn urls。这也意味着它们从配置好的仓库或者你的本地maven仓库~/.m2/repository中加载。

在Karaf中安装应用
```
feature:repo-add mvn:net.lr.tasklist/tasklist-features/1.0.0-SNAPSHOT/xml
feature:install example-tasklist-persistence example-tasklist-ui
```
添加features描述信息文件到Karaf，所以它被添加到可用的features列表中，然后安装和启动tasklist feature。运行命令之后tasklist应用应该运行了。

list

检查tasklist的所有bundles是在active状态。如果没有，尝试启动它们和检查日志。

http:list
```
ID | Servlet         | Servlet-Name   | State       | Alias     | Url
---------------------------------------------------------------------
56 | TaskListServlet | ServletModel-2 | Deployed    | /tasklist | [/tasklist/*]
```
应该显示TaskListServlet。默认情况下这个例子应该运行在http://localhost:8181/tasklist。

你可以通过创建一个文本文件”etc/org.ops4j.pax.web.cfg”改变端口。文本内容为”org.osgi.service.http.port=8080”。这个方式将告诉HttpService使用这个端口8080. 现在tasklist应用应该运行在http://localhost:8080/tasklist地址。

总结

在该教程中我们已经安装了Karaf和学习了一些命令。然后我们创建了一个小的OSGi应用，这个应用涉及到servlets，OSGi服务，blueprint和whiteboard模式。下一个教程我们看下在OSGi中Apache Camel和Apache CXF的使用。


Apache Karaf用户指导  

一 安装karaf  

本章讲述如何在windows和unix平台安装Apache Karaf，这里你将知道预先要安装什么软件，如何下载并且安装Karaf。  

预安装需求  
硬件：  
- 20M磁盘剩余空间。  
操作系统：  
Windows：Windows vista，Windows XP sp2，windows2000。- Unix：Ubuntu Linux，Powerdog Linux,MacOS，AIX,HP-UX,Solaris，任何支持java的unix平台。  
环境：  
Java SE 1.5x或者更高。- 环境变量JAVAHOME必须设置为java运行时的安装目录，比如C:\Program Files\Java\jdk1.6.026。按住windows和break键切换到高级选项，点击环境变量，把上面的路径加入到变量中。  
从源码构建  
如果你想从源码构建KARAF，需求会有点不同：  

硬件：  
- 200M磁盘空间便于apache karaf源码展开或者是SVN的验证，以及maven构建和依赖maven组件的下载。  
环境：  
JDK 1.5或者是更高。- Apache maven 2.2.1.  
在windows上构建  
这过程说明如何下载和安装windows上的源码文件。注：Karaf需要java5编译，构建和运行。  

在浏览器输入http://karaf.apache.org/index/community/download.html.  
滚动到“Apache Karaf”区域选择需要的链接。源码文件名称类似于：apache-karaf-x.y-src.zip.  
解压缩zip文件到你选择的目录中，请记住非法java路径的限制，比如！，%等。  
用maven 2.2.1 或者更高的java5来构建karaf。 构建karaf的方法如下：  
Cd [karaf安装路径]\src- Mvn  
这两个步骤均需要10到15分钟。  
用zip工具加压文件，windows的路径是 [karaf安装路径]\assembly\target\apache-karaf-x.y.zip
转到开始karaf一节  
在Unix上构建  
本过程将讲述如何在unix系统上下载和安装源码文件。这里假定unix机器上有浏览器，没有浏览器的请参照前面二进制unix安装区域。注：Karaf需要java5编译，构建和运行。  

在浏览器输入http://karaf.apache.org/ download.html.
滚动到“Apache Karaf”区域选择需要的链接。源码文件名称类似于：apache-karaf-x.y-src.zip.    
解压缩zip文件到你选择的目录中，例如：gunzip apache-karaf-x.y-src.tar.gz tar xvf apache-karaf-x.y-src.tar请记住非法java路径的限制，比如！，%等
用maven构建karaf建议方法如下: cd [karaf安装路径]\src cvn 5.解压缩刚刚创建的文件 cd [karaf安装路径]/assembly/target gunzip apache-karaf-x.y.tar.gz tar xvf apache-karaf-x.y.tar
转到开始karaf一节  
Windows安装过程  
这里说明如何在windows系统上下载和安装二进制文件。  

在浏览器输入 http://karaf.apache.org/index/community/download.html.  
滚动到“Apache Karaf”区域选择需要的链接。源码文件名称类似于：apache-karaf-x.y-src.zip.  
解压缩zip文件到你选择的目录中，请记住非法java路径的限制，比如！，%等。  
转到开始karaf一节  
可选：在Windows中启用彩色控制台输出  
- 提示：如果你安装karaf到很深的路径或者是非法的java路径，！，%等，你可以创建一个bat文件来执行：subst S: "C:\your very % problematic path!\KARAF" 这样karaf的路径是 s: 这样的短类型。  
Unix安装过程  
这里属于如何在unix系统上下载和安装二进制文件。  

在浏览器输入http://karaf.apache.org/ download.html.
滚动到“Apache Karaf”区域选择需要的链接。源码文件名称类似于：apache-karaf-x.y.tar.gz  
解压缩zip文件到你选择的目录中，例如：gunzip apache-karaf-x.y.tar.gz tar xvf apache-karaf-x.y.tar 请记住非法java路径的限制，比如！，%等。  
转到开始karaf一节  
安装后的步骤  
在开始使用karaf之前强烈建议设置指向JDK的JAVA_HOME用来定位java可执行文件，并且应该配置为指向已安装java se5或者6的根目录。  

二 目录结构  

Karaf安装目录结构如下：  

/bin: 启动脚本  
/etc: 初始化文件  
/data: 工作目录  
/cache: OSGi框架包缓存  
/generated-bundles: 部署使用的临时文件夹  
/log: 日志文件  
/deploy: 热部署目录  
/instances: 含有子实例的目录  
/lib: 包含引导库  
/lib/ext:JRE扩展目录  
/lib/endorsed: 赞同库目录  
/system: OSGi包库，作为一个Maven2存储库  
Data文件夹包括karaf所有的工作和临时文件，如果你想从一个初始状态重启，你可以清空这个目录，这和“恢复初始化设置”一样的效果。  

三 启动和停止karaf  

本章介绍如何启动和停止Apache Karaf和各种可用的选项。  

启动karaf  
Windows下：打开一个控制台窗口，更改到安装目录，并运行Karaf。对于二进制文件，运行 Cd [karaf安装目录] 然后输入：bin\karaf.bat  

Linux下：打开一个控制台窗口，更改到安装目录，并运行Karaf。运行 Cd [karaf安装目录] 然后输入：bin\karaf 警告：karaf运行后不要关闭控制台，否则会终止karaf（除非用非控制台启动karaf）。  

非控制台启动karaf  
没有控制台也可以启动karaf，它总可以是用远程SSH访问，是用下面的命令： bin\karaf.bat server 或者是unix下：bin/karaf server  

在后台启动karaf  
采用以下命令可以轻易地在后台进程启动karaf：   Bin\start.bat 或者在unix下：bin/start  

重置模式启动karaf  
清空[karaf安装目录]\data文件夹就可以简单的在重置模式启动karaf，为方便起见，在karaf启动脚本使用以下参数也可以实现重置启动： bin/start clean  
  
停止karaf  
无论是windows还是unix，你都可以在karaf控制台采用以下命令来停止它： `osgi:shutdown`, 或者简单的是：`shutdown`。    

Shutdown命令会询问你是否真的想要停止，如果你确认停止并且拒绝确认信息，你可以用-f或者-force选项： osgi：shutdown –f， 也可以用时间参数来延迟停止，时间参数有不同的形式。  

首先，可以是绝对时间各式hh：mm。第二，也可以是+m，其中m是等待的分。现在就是+0。  

下面的命令可以在10:35am关闭karaf:  

osgi:shutdown 10:35。  

下面的命令在10分钟后关闭karaf：  

osgi:shutdown +10。  

如果你在主控制台运行，用注销或者Ctrl+D退出控制台也可以终止karaf实例。 在控制台你可以运行如下命令：  

bin\stop.bat  

或者在unix下：  

bin/stop。  

四 使用控制台  

查看可用的命令  
按提示键tab可以在控制台看到可用的命令列表：    
```
root@root&gt; &lt;tab&gt;Display all 182 possibilities? (y or n)
*:help                           addurl                           admin:change-opts
admin:change-rmi-registry-port   admin:change-ssh-port            admin:connect
admin:create                     admin:destroy                    admin:list
admin:rename                     admin:start                      admin:stop
bundle-level                     cancel                           cat
change-opts                      change-rmi-registry-port         change-ssh-port
clear                            commandlist                      config:cancel
config:edit                      config:list                      config:propappend
config:propdel                   config:proplist                  config:propset
config:update                    connect                          create
create-dump                      destroy                          dev:create-dump
dev:dynamic-import               dev:framework                    dev:print-stack-traces
dev:restart                      dev:show-tree                    dev:watch
display                          display-exception                dynamic-import
each                             echo                             edit
exec                             exports                          features:addurl
features:info                    features:install                 features:list
features:listrepositories        features:listurl                 features:listversions
features:refreshurl              features:removerepository        features:removeurl
features:uninstall               framework                        get
grep                             head                             headers
help                             history                          if
imports                          info                             install
jaas:cancel                      jaas:commandlist                 jaas:list
jaas:manage                      jaas:roleadd                     jaas:roledel
jaas:update                      jaas:useradd                     jaas:userdel
jaas:userlist                    java                             list
listrepositories                 listurl                          listversions
log:clear                        log:display                      log:display-exception
log:get                          log:set                          log:tail
logout                           ls                               manage
more                             new                              osgi:bundle-level
osgi:headers                     osgi:info                        osgi:install
osgi:list                        osgi:ls                          osgi:refresh
osgi:resolve                     osgi:restart                     osgi:shutdown
osgi:start                       osgi:start-level                 osgi:stop
osgi:uninstall                   osgi:update                      packages:exports
packages:imports                 print-stack-traces               printf
propappend                       propdel                          proplist
propset                          refresh                          refreshurl
removerepository                 removeurl                        rename
resolve                          restart                          roleadd
roledel                          set                              shell:cat
shell:clear                      shell:each                       shell:echo
shell:exec                       shell:grep                       shell:head
shell:history                    shell:if                         shell:info
shell:java                       shell:logout                     shell:more
shell:new                        shell:printf                     shell:sleep
shell:sort                       shell:tac                        shell:tail
show-tree                        shutdown                         sleep
sort                             ssh                              ssh:ssh
ssh:sshd                         sshd                             start
start-level                      stop                             tac
tail                             uninstall                        update
useradd                          userdel                          userlist
watch
root@root&gt;
```
获得命令的帮助
要查看一个特定的命令的帮助，在命令后加--help或使用help命令加上命令的名称：

`karaf@root&gt; feature:list --help`
描述

   ` feature:list       列出库中定义的所有功能。`
语法

    `feature:list [options]`
选项

   ` --help               显示此帮助信息`  
   `-i, --installed      只列出已安装的功能列表`  
更多…  
所有可用命令列表和它们的用法，也可以在一个专门的章节。  

你在开发指南会获得更多的shell语法的深入引导。  

如开发指南解释的那样，控制台可以很容易的被新命令扩展。  

五 网络控制台  

Karaf Web控制台提供了一个运行时的图形概述。  

你可以是用它来：  

安装和卸载功能  
启动，停止，安装捆绑  
创建子实例  
配置Karaf  
查看日志信息  
安装web控制台  
默认情况下web控制台是不安装的，安装请在karaf提示中运行以下命令： root@karaf&gt; features:install webconsole  

访问Web控制台  
访问本地运行的一个karaf实例，在浏览器输入：   http://localhost:8181/system/console 使用karaf用户名和karaf密码来登录系统，如果你修改过用户名或密码，请是用修改后的。  

改变web控制台端口号  
默认情况下，控制台在8181端口运行，你可以通过创建属性文件etc/org.ops4j.pax.web.cfg并在后面添加如下属性设置（改成任意你想要的端口号）来改变端口：  

`org.osgi.service.http.port=8181`    

六 远程控制台  

使用远程实例  
初始化远程实例  
用它本地控制台管理karaf实例不总是有意义的，你可以用远程控制台远程管理karaf。  

当你启动karaf时，它使任何其他Karaf控制台或纯SSH客户端可以通过SSH访问远程控制台。远程控制台提供本地控制台的所有功能，并通过运行它里面的容器和服务给远程用户完全控制。  

SSH主机名和端口号在配置文件[karaf安装目录]/etc/org.apache.karaf.shell.cfg用以下默认值配置：  

sshPort=8101  
sshHost=0.0.0.0  
sshRealm=karaf  
hostKey=${karaf.base}/etc/host.key  
你可以用初始化命令或者编辑上面的文件更改这个配置，但是需要重启ssh控制台以便它是用新的参数。  
```
# define helper functions  
bundle-by-sn = { bm = new java.util.HashMap ;  each (bundles) { $bm put ($it symbolicName) $it } ; $bm get $1 }
bundle-id-by-sn = { b = (bundle-by-sn $1) ; if { $b } { $b bundleId } { -1 } }
# edit config
config:edit org.apache.karaf.shell
config:propset sshPort 8102
config:update 
# force a restart
osgi:restart --force (bundle-id-by-sn org.apache.karaf.shell.ssh)
```
远程连接和断开
使用ssh：ssh命令

你可以使用ssh：ssh命令来连接远程karaf控制台。 `karaf@root&gt; ssh:ssh -l karaf -P karaf -p 8101 hostname`

注意：默认的密码是karaf，但是我们强烈建议个更改。在安全模块查看更多信息。 为了确定你已经连接到正确的karaf实例，输入ssh：info在karaf提示符。返回当前连接的实例的信息，如下所示。
```
Karaf
  Karaf home  /local/apache-karaf-2.0.0
  Karaf base  /local/apache-karaf-2.0.0
  OSGi Framework  org.eclipse.osgi - 3.5.1.R35x_v20090827
JVM
  Java Virtual MachineJava HotSpot(TM) Server VM version 14.1-b02
  ...
```
使用karaf客户端
Karaf允许你安全的连接到远程karaf实例而不必运行本地karaf实例。

例如，在同一台机器上快速连接在server模式下运行的karaf实例，在karaf安装目录运行以下命令：` bin/client`。 通常情况下，你需要提供主机名，端口，用户名和密码来连接到远程实例。如果你使用的客户端在一个较大的脚本，你可以附加控制台命令如下： `bin/client -a 8101 -h hostname -u karaf -p karaf features:install wrapper`

显示可用的客户端选项，输入：
```
&gt; bin/client --help
Apache Karaf client
  -a [port] specify the port to connect to
  -h [host] specify the host to connect to
  -u [user] specify the user name
  -p [password] specify the password
  --helpshows this help message
  -vraise verbosity
  -r [attempts] retry connection establishment (up to attempts times)
  -d [delay]intra-retry delay (defaults to 2 seconds)
  [commands]commands to run
 ```
如果没有指定的命令，客户端将在互动模式。

使用纯SSH客户端
你也可以使用你的unix系统中的纯SSH客户端或者windows SSH客户端像putty来连接。 `~$ ssh -p 8101 karaf@localhost karaf@localhost's password:`

从远程控制台断开
按Ctrl+D，shell：logout或者简单的在karaf提示符输入logout就可以断开远程控制台。

关闭远程实例
使用远程控制台
如果你已经用ssh:ssh命令或者karaf客户端连接到远程控制台，你可以用使用osgi:shutdown命令来停止远程实例。 注意：在远程控制台按Ctrl + D键，简单地关闭远程连接并返回到本地shell。

使用karaf客户端
使用karaf客户端停止远程实例，在karaf安装目录/lib目录运行以下命令： `bin/client -u karaf -p karaf -a 8101 hostname osgi:shutdown`

七 子实例

管理子实例
一个Karaf的子实例是一个副本，你可以分别启动和部署应用程序。实例不包含的完整副本Karaf，但只有一个配置文件和数据文件夹的副本，其中包含了所有运行中的信息，日志文件和临时文件。

使用管理控制台命令
管理控制台命令允许您在同一台机器创建和管理Karaf实例。每一个新的运行时是运行时创建的子实例。您可以轻松地使用的名称管理子实例，而不是网络地址。有关管理命令的详细信息，请参阅管理命令。

创建子实例
你可以在karaf控制台输入admin:create创建新的运行时实例.

如下例子所示，admin:create将使运行时在活动的运行时{实例/名称}目录创建新的运行时安装。新的实例是一个新的karaf实例并且分配一个SSH端口号基于始于8101的增量和一个RMI注册端口号基于始于1099的增量。
```
karaf@root&gt;admin:create finn
Creating new instance on SSH port 8106 and RMI port 1100 at: /home/fuse/esb4/instances/finn
Creating dir:  /home/fuse/esb4/instances/finn/bin
Creating dir:  /home/fuse/esb4/instances/finn/etc
Creating dir:  /home/fuse/esb4/instances/finn/system
Creating dir:  /home/fuse/esb4/instances/finn/deploy
Creating dir:  /home/fuse/esb4/instances/finn/data
Creating file: /home/fuse/esb4/instances/finn/etc/config.properties
Creating file: /home/fuse/esb4/instances/finn/etc/java.util.logging.properties
Creating file: /home/fuse/esb4/instances/finn/etc/org.apache.felix.fileinstall-deploy.cfg
Creating file: /home/fuse/esb4/instances/finn/etc/org.apache.karaf.log.cfg
Creating file: /home/fuse/esb4/instances/finn/etc/org.apache.karaf.features.cfg
Creating file: /home/fuse/esb4/instances/finn/etc/org.ops4j.pax.logging.cfg
Creating file: /home/fuse/esb4/instances/finn/etc/org.ops4j.pax.url.mvn.cfg
Creating file: /home/fuse/esb4/instances/finn/etc/startup.properties
Creating file: /home/fuse/esb4/instances/finn/etc/system.properties
Creating file: /home/fuse/esb4/instances/finn/etc/org.apache.karaf.shell.cfg
Creating file: /home/fuse/esb4/instances/finn/etc/org.apache.karaf.management.cfg
Creating file: /home/fuse/esb4/instances/finn/bin/karaf
Creating file: /home/fuse/esb4/instances/finn/bin/start
Creating file: /home/fuse/esb4/instances/finn/bin/stop
karaf@root&gt;
```
改变子实例端口号
你可以使用admin:change-ssh-port命令来改变分配给子实例的SSH端口号。命令语法是： admin:change-ssh-port 实例 端口号，需要注意的必须停止子实例才能运行此命令。  

同样，你可以使用admin:change-rmi-registry-port命令改变分配给子实例的RMI注册端口号。命令的语法是：   admin:change-rmi-registry-port instance port，需要注意的必须停止子实例才能运行此命令。  

启动子实例
新的子实例在停止状态下被创建，用admin:start命令来启动子实例并使之准备主机应用。这个命令需要一个标识你想启动的子实例的instance-name参数。  

列出所有容器实例  
要查看一个特定的安装下运行的所有Karaf实例的列表，使用admin:list命令。  
```
karaf@root&gt;admin:list
  SSH Port   RMI Port   State   Pid  Name
[8107] [  1106] [Started ] [10628] harry
[8101] [  1099] [Started ] [20076] root
[8106] [  1105] [Stopped ] [15924] dick
[8105] [  1104] [Started ] [18224] tom
karaf@root&gt;
```
连接到子实例
你可以使用admin:connect命令连接到开始的子实例远程控制台，这需要三个参数： admin:connect [-u username] [-p password] instance, 一旦你连接到子实例，karaf提示符显示现在实例的名字，如下： karaf@harry&gt;

停止一个子实例
在实例自己内部停止一个子实例，输入osgi:shutdown或者简单的shutdown。 远程停止子实例，换句话说，从父或者兄弟实例，使用`admin:stop： admin:stop instance`

注销一个子实例
你可以使用`admin:destroy`命令永久的删除一个停止的子实例：

`*admin:destroy instance*`
请注意只有停止的实例可以被注销。

使用管理脚本
你也可以管理本地的karaf实例，在karaf安装目录/bin目录下的管理员脚本提供了像管理员控制台相同的命令，除了admin:connect。
```
&gt; bin/admin
Available commands:
  change-ssh-port - Changes the secure shell port of an existing container instance.
  change-rmi-registry-port - Changes the RMI registry port (used by management layer) of an existing container instance.
  create - Creates a new container instance.
  destroy - Destroys an existing container instance.
  list - List all existing container instances.
  start - Starts an existing container instance.
  stop - Stops an existing container instance.
Type 'command --help' for more help on the specified command.
```
例如，列出所有本机器的karaf实例，输入：

bin/admin list
八 安全

管理用户名和密码
默认安全配置使用一个位于 karaf安装目录/etc/users.properties属性文件存储授权的用户和他们的密码。

默认的用户名是karaf，与之相关联的密码也是karaf。我们强烈建议在将karaf转移到产品前通过编辑上面的文件修改默认密码。

在karaf中用户现在被使用在三个地方：

访问SSH控制台
访问JMX管理层
访问web控制台
这三种方式的全部委托基于安全认证的相同的JAAS。 users.properties文件包含一或者多行，每行都定义了一个用户，密码和相关的角色。 user=password[,role][,role]...

管理角色
JAAS角色可以被各种组件使用。三个管理层（SSH,JMX和web控制台）都使用用基于认证系统的全局角色。默认的角色名称在etc/system.properties中使用karaf.admin.role系统属性配置，并且默认值是admin。对管理层进行身份验证的所有用户必须有这个角色的定义。

这个值的语法如下： [classname:]principal

其中classname是主要对象的类名（默认以org.apache.karaf.jaas.modules.RolePrincipal），主要是这一类（默认为admin）的主要的名称。 注意，可以使用以下配置ConfigAdmin对于一个给定的层改变角色：

Layer	PID	Value
SSH	org.apache.karaf.shell	sshRole
JMX	org.apache.karaf.management	jmxRole
Web	org.apache.karaf.webconsole	role
启用密码加密
为了避免密码是纯文本，密码可以加密存储在配置文件中。 这可以通过以下命令轻易的实现：
```
# edit config
config:edit org.apache.karaf.jaas
config:propset encryption.enabled true
config:update 
# force a restart
dev:restart
```
用户第一次登录，密码将在 etc/users.properties 配置文件中被自动的加密。加密密码在前面加上{CRYPT}，因此很容易识别。

管理领域
更多关于更改默认领域或者部署新领域信息将会在开发者指南中被提供。

部署安全供应商
有些应用程序需要特定的安全性提供者可用，如BouncyCastle。JVM在这些jar包的使用上施加一些限制：他们必须签署和引导类路径上可用。部署这些供应商的方法之一是把他们放在位于$ JAVAHOME/ JRE/ lib / ext的JRE文件夹中并且修改安全策略配置（$JAVAHOME/jre/lib/security/java.security）以登记等供应商。

虽然这种方法工作的很好，他将会有全局的影响并且需要你配置所有相应的服务器。

Karaf提供了一个简单的方式来配置额外的安全性提供者：

把你的供应商jar放在karaf-install-dir/lib/ext中
修改初始化文件 karaf-install-dir/etc/config.properties ，添加如下属性： org.apache.karaf.security.providers = xxx,yyy 这个属性的值是一个逗号分隔的提供商类名的注册名单。 例如：org.apache.karaf.security.providers = org.bouncycastle.jce.provider.BouncyCastleProvider 此外，你可能想向系统中捆绑的供应商的类提供访问，使所有束可以访问那些。它可以通过在相同的配置文件中修改org.osgi.framework.bootdelegation 属性来实现： 
```
org.osgi.framework.bootdelegation = ...,org.bouncycastle*
```
九 故障转移部署

Karaf提供故障转移功能，使用一个简单的锁定文件系统或JDBC锁定机制。在这两种情况下，一个容器级锁系统允许绑定预装到副Karaf实例，以提供更快的故障转移性能。

简单文件锁定  
简单文件锁定机制用于驻留在同一台主机的实例故障转移配置。 要使用这个功能，按照如下形式编辑`$KARAF_HOME/etc/system.properties`文件中的每个系统上的主/从设置：  
```
karaf.lock=true
karaf.lock.class=org.apache.felix.karaf.main.SimpleFileLock
karaf.lock.dir=&lt;PathToLockFileDirectory&gt;
karaf.lock.delay=10
```
说明：确保karaf.lock.dir属性指向相同的主从实例目录，以便当主释放从，从只能获得锁定。  

JDBC锁定  
JDBC锁定机制的目的就是为了存在单独机器上的故障转移配置。在此部署中，主实例拥有一个Karaf锁定数据库上的表上的锁，如果主失去了锁，等待从进程获得锁定表，并全面启动它的容器。  

要使用这个功能，按照如下形式设置每个系统上的主/从设置：  

更新CLASSPATH包含JDBC驱动程序  

更新KARAF_HOME/bin/ karaf脚本有独特的JMX远程端口设置，如果实例驻留在同一主机上  

更新KARAF_HOME的/ etc/ system.properties文件如下：  
```
    karaf.lock=true
    karaf.lock.class=org.apache.felix.karaf.main.DefaultJDBCLock
    karaf.lock.level=50
    karaf.lock.delay=10
    karaf.lock.jdbc.url=jdbc:derby://dbserver:1527/sample
    karaf.lock.jdbc.driver=org.apache.derby.jdbc.ClientDriver
    karaf.lock.jdbc.user=user
    karaf.lock.jdbc.password=password
    karaf.lock.jdbc.table=KARAF_LOCK
    karaf.lock.jdbc.clustername=karaf
    karaf.lock.jdbc.timeout=30
```
说明：

如果JDBC驱动程序不在classpath中会失败。
将创建数据库名称“sample”，如果它不存在于数据库。
Karaf的第一个实例来获得锁定表的是主实例。
如果数据库连接丢失，主实例尝试正常关闭，主数据库服务恢复时允许一个从的实例成为主，前主将需要手动重新启动。
Oracle的JDBC锁定
在JDBC锁定情况下如果你采用oracle作为你的数据库，在$KARAF_HOME/etc/system.properties 文件中的karaf.lock.class 属性必须指向org.apache.felix.karaf.main.OracleJDBCLock。 否则，对于你的设置初始化system.properties文件是正常的，例如：
```
karaf.lock=true
karaf.lock.class=org.apache.felix.karaf.main.OracleJDBCLock
karaf.lock.jdbc.url=jdbc:oracle:thin:@hostname:1521:XE
karaf.lock.jdbc.driver=oracle.jdbc.OracleDriver
karaf.lock.jdbc.user=user
karaf.lock.jdbc.password=password
karaf.lock.jdbc.table=KARAF_LOCK
karaf.lock.jdbc.clustername=karaf
karaf.lock.jdbc.timeout=30
```
正如默认的JDBC锁定设置，Oracle JDBC驱动包必须在calsspath中，为了确保如此你可以在karaf启动之前复制ojdbc14.jar到karaf的lib文件夹下。 说明：karaf.lock.jdbc.url 需要活动的SID，这意味着在使用这个特定的锁之前你必须手动创建数据库实例。

容器级锁定 
容器级锁定允许绑定预装到从内核的实例，以提供更快的故障转移性能。容器级锁被简单的文件和JDBC锁定机制支持。 为了实现容器及说定，添加如下内容到  `$KARAF_HOME/etc/system.properties` 文件中在每个系统的主从设置上：  
```
karaf.lock=true
karaf.lock.level=50
karaf.lock.delay=10
```
Karaf.log.level属性告诉karaf实例引导过程带来的OSGI容器有多远。分配相同级别的绑定或者是更低的也会在那个karaf实例中被启动。  

绑定开始级别在$KARAF_HOME/etc/startup.properties指定，以jar.name=levle的形式。核心系统绑定级数低于50，用户绑定级别大于50。  

级别	行为  
1	一个“冷”的备用实例，核心绑定不会被加载到容器中，从实例将等待指导锁定需要启动服务器。  
&lt;50	一个“热”的备用实例，核心捆绑将被加载到容器，从实例等待指导锁需要启动用户级别绑定。控制台对于每个从实例可以在这个级别访问。  
&gt;50	这个设置不建议作为用户捆绑被启动。
注意：挡在同一主机上使用“热”备用，你需要设置JMX远程端口为唯一值以避免绑定冲突，你可以编辑karaf启动脚本以包括以下内容：
```
DEFAULT_JAVA_OPTS="-server $DEFAULT_JAVA_OPTS 
-Dcom.sun.management.jmxremote.port=1100 
-Dcom.sun.management.jmxremote.authenticate=false
```
