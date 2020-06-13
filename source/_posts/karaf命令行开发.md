title: karaf命令行开发
author: Joe Tong
tags:
  - ONOS
  - JAVAEE
categories:
  - IT
date: 2019-07-26 21:49:00
---

ONOS编程系列(二)命令行命令与服务开发

此文章承接ONOS编程系列（一） Application Tutorial ，如果尚未看过上一篇，请先看完上一篇，再回过头来看此篇。
本文章的目的在于让读者明白：

    如何将新建的application扩展为新的服务，以便其他服务或者应用可以调用它
    如何将该application的功能扩展为Karaf命令行界面下的一个新命令

我们假设你已经安装并且能初步掌握Mininet，因为后面的测试工作需要用到它。  
项目架构

![upload successful](/images/pasted-39.png)
一、扩展为服务  
1.1 定义服务接口  
首先，在onos-api包下定义一个新的服务的接口，该包目录是${ONOS_ROOT}/core/api/src/main/java/org/onosproject/net/。在此目录下，创建一个新文件夹apps/，作为新接口的位置。接口文件放在此处的意义在于只有这样cli的包才能访问到它，而cli包正是实现命令行命令的包。  

![upload successful](/images/pasted-40.png)    


![upload successful](/images/pasted-41.png)  

1.2 导入服务接口  
接下来，我们会在IntentReactiveForwarding文件中实现该服务接口。  

![upload successful](/images/pasted-42.png)  
在本教程中我们用不到该应用生成的服务，不过如果要调用该服务，只需要这样既可：  

![upload successful](/images/pasted-43.png)    

1.3 实现该服务接口

要实现该服务接口，我们向类IntentReactiveForwarding增加了新的Map，endPoints成员变量。Map成员在process()方法中用来存储HostService提供的终端信息。

![upload successful](/images/pasted-44.png)  

现在，一个引用了ForwardingMapService的模块就可以通过调用getEndPoints()方法获取能够双向通信的终端列表了，这些终端上都安装了本模块的intents。

接下来，创建一个新的Karaf CLI命令来使用这个新的服务。该命令的动能是列出map的内容，并且可选地提供一个过滤参数，来过滤主机源的地址。  

二、创建karaf的一个新命令  
Karaf CLI命令定义在项目目录${ONOS_ROOT}/cli/之下。有两种类型的命令，分别在不同的目录下：  

    ${ONOS_ROOT}/cli/src/main/java/org/onosproject/cli 系统配置与监视相关的命令所在目录
    ${ONOS_ROOT}/cli/src/main/java/org/onosproject/cli/net 网络配置与监视相关的命令所在目录  
    
我们要建立的命令要显示网络相关的信息，所以我们要在第二个目录下增加我们的command类。  

2.1 新建一个command类

在第二个目录下，创建一个名为ForwardingMapCommand的类文件。该类是AbstractShellCommand的子类，在类中要使用命令相关的一些注解：

    @Command 该注解用来设置命令的名字，作用范围以及功能描述
    @Argument 该注解用来指定命令的参数

![upload successful](/images/pasted-45.png)  



2.3 注册这个command，使其能在karaf CLI下使用  
接下来，我们需要编辑shell-config.xml文件，该文件位于${ONOS_ROOT}/cli/src/main/resources/OSGI-INF/blueprint/，其作用是告诉karaf有新的命令加入了。编辑格式是在里面填上我们的命令的相关信息：  

![upload successful](/images/pasted-46.png)  

三、验证  
3.1 重编译，重启动ONOS  

一切修改完毕之后，进入onos根目录重新编译，编译成功之后运行onos：  

![upload successful](/images/pasted-47.png)  

进入欢迎界面之后，可以键入“fwdmap --help”查看我们新建命令的描述： 

![upload successful](/images/pasted-48.png)  

3.2 启动Mininet，构建测试网络  

新开一个命令行界面，在此界面下开启mininet（默认是本地启动，所以ip是127.0.0.1）：  
sudomn --topo=tree,2,2 --controller=remote,ip=127.0.0.1 --mac
此时，在ONOS界面下可以看到四个终端，三个交换机：   
3.3 测试命令行  
键入fwdmap，可以看到没有什么结果返回，因为这个时候网络中的主机之间还没有进行通信呢。  

![upload successful](/images/pasted-49.png)  

切换到mininet控制界面，键入pingall，执行一次主机间的通信。

![upload successful](/images/pasted-50.png)  
然后再切换回onos命令行，再次键入fwdmap命令：  

![upload successful](/images/pasted-51.png)  
问题一

在onos命令行下键入fwdmap，如果出现以下结果：  
就要回头看看IntentReactiveForwarding类前面有没有加@Service注解了。    

如果注解没问题，那么就有可能是当前并没有安装ifwd模块。用命令“feature:list -i | grepifwd”查看当前是否安装了ifwd模块，如果返回结果为空，则要手动安装一下：feature:installonos-app-ifwd 。  
问题二

在用mininet命令行下pingall以后，再次在onos下键入fwdma，如果还没有任何输出，可能就是源代码哪里又出了问题。

我下载到源代码以后，切换版本到了onos-1.1，该版本下，本来就是有一个ifwd的项目的，不过比教程里的东西要少一些。在手动敲入代码的时候，我大致略过了已有的代码，但是注意，教程里的代码并非完全在原有代码基础上进行的增加，在IntentReactiveForwarding文件中，函数setUpConnectivity中，红框框住的部分是原有的部分，蓝框框住的部分是教程中的部分，可以看到，两者还是有一点区别的：  

![upload successful](/images/pasted-52.png)    
解决这个问题以后，再次走一遍流程，应该就能看到结果了吧。


