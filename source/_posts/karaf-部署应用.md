title: 'karaf 部署应用 '
author: Joe Tong
tags:
  - ONOS
  - JAVAEE
categories:
  - IT
date: 2019-07-26 07:29:00
---

#### ONOS编程系列(一)之简单应用开发

一个ONOS application是使用mevan做管理的OSGi bundle。 因此，ONOS application 可以归结为Java类和pom文件的集合。本教程以基于intent的交互式转发application为例，讨论了如何从零开始建立一个新应用。
本教程假设读者已经具备ONOS的运行经验，能够熟练启动ONOS实例。有关ONOS的启动不做过多描述。如果出现启动上的问题，请移步官方wiki文档自行寻找答案。
本文章结束后，你应该学会：

    应用的组织与结构；
    如何在多个服务中注册你的应用；
    北向API的基本应用；
    如何运行一个应用。

一、在idea中导入工程

1.设置项目的目录结构  
应用的根目录设置在apps/之下：  

2.添加并编辑pom文件  
在启动karaf/ONOS命令行界面以后，直接用feature:install加上名字，即可安装此应用。 
然后，编辑apps/pom.xml，在文件中以形式包含该项目：

![upload successful](/images/pasted-33.png)

2.3 在karaf中注册该应用  
Karaf在运行时若要部署该应用module，需要名为feature.xml的描述性文件，编辑 ${ONOS_ROOT}/features/features.xml：   

![upload successful](/images/pasted-32.png)

该应用的核心是名为 IntentReactiveForwarding.java的文件，被定义在${ONOS_ROOT}/apps/ src/main/java/org/onosproject/ifwd/ 里。
为了便于对文档进行注释，在main/java/下需要添加一个package-info.java文件，其包含一下内容：

![upload successful](/images/pasted-34.png)

3.1 注册Karaf，使其自动加载

karaf的模块加载机制需要几个annotations，即注解，去注册。可用的注解尤其是以下四个尤为重要：

    @Component(immediate = true) - declares a class as a component to activate, and forces immediate activation;
    @Activate - marks a method as the method to call during the component startup routine;
    @Deactivate - marks a method as the method to call during component shutdown;
    @Reference(cardinality = ReferenceCardinality.MANDATORY_UNARY) - Marks a service as an application's dependency,and requires one instance of such a service to be loaded before this application's activation.
       
![upload successful](/images/pasted-35.png)

3.2 注册服务

接下来，我们的应用必须使用CoreService注册一个独一无二的application ID，这样才能够使该应用正常使用ONOS的其他服务。我们的应用接下来还要使用PacketService监听PacketIn和PacketOut事件。而PacketService需要一个事件处理器的类，该类用途单一，通常写在其所属类的内部，成为其私有内部类：

![upload successful](/images/pasted-36.png)

3.3增加包处理代码

在上一步的私有内部类ReactivePacketProcessor里，要覆写扩展自接口PacketProcessor的方法process()。每当有网络包进来的时候，PacketService都会调用一下process()函数。这意味着我们可以在这个方法里定义我们自己的包转发行为：

![upload successful](/images/pasted-37.png)
接下来我们要实现上图中用到的三个方法，注意，这些方法定义在私有内部类的外面，是IntentReactiveForwarding的成员：

![upload successful](/images/pasted-38.png)
3.4 编译该应用  

3.5 启动该应用  

启动分为动态启动与静态启动：  
动态启动就是用karaf clean命令启动onos之后，在onos命令行下键入feature:installonos-app-ifwd命令安装该应用。  
静态启动就是修改karaf的启动配置文件。该文件路径为${KARAF_ROOT}/etc/org.apache.karaf.features.cfg，直接将onos-app-ifwd字样缀到featuresBoot变量的尾部即可。  
启动并加载该应用以后，可已键入：  
	
`feature:list -i | grepifwd`

该应用安装以后，并不能对其做什么操作，也无法看到它的运行情况，这时我们就需要将该应用扩展为一种服务，以便于其它服务或者应用与其交互，并且需要新建一条karaf的命令，用于展示当前应用的相关信息与状态。
