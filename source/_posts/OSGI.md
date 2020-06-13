title: OSGI
author: Joe Tong
tags:
  - JAVAEE
  - OSGI
categories:
  - IT
date: 2019-07-24 10:23:00
---
OSGI （面向Java的动态模型系统）   
 
OSGi（开放服务网关协议，Open Service Gateway Initiative）技术是Java动态化模块化系统的一系列规范。OSGi一方面指维护OSGi规范的OSGI官方联盟，另一方面指的是该组织维护的基于Java语言的服务（业务）规范。简单来说，OSGi可以认为是Java平台的模块层。OSGi服务平台向Java提供服务，这些服务使Java成为软件集成和软件开发的首选环境。SGi技术提供允许应用程序使用精炼、可重用和可协作的组件构建的标准化原语，这些组件能够组装进一个应用和部署中。  
开放服务网关协议有双重含义。一方面它指OSGi Alliance组织；另一方面指该组织制定的一个基于Java语言的服务规范——OSGi服务平台。 OSGi Alliance是一个由Sun Microsystems、IBM、爱立信等于1999年3月成立的开放的标准化组织，最初名为Connected Alliance。该组织及其标准原本主要目的在于使服务提供商通过住宅网关，为各种家庭智能设备提供各种服务。该平台逐渐成为一个为室内、交通工具、移动电话和其他环境下的所有类型的网络设备的应用程序和服务进行传递和远程管理的开放式服务平台。
该规范和核心部分是一个框架，其中定义了应用程序的生命周期模式和服务注册。基于这个框架定义了大量的OSGi服务：日志、配置管理、偏好，HTTP（运行servlet）、XML分析、设备访问、软件包管理、许可管理、星级、用户管理、IO连接、连线管理、Jini和UPnP。  
这个框架实现了一个优雅、完整和动态的组件模型。应用程序（称为bundle）无需重新引导可以被远程安装、启动、升级和卸载（其中Java包/类的管理被详细定义）。API中还定义了运行远程下载管理政策的生命周期管理。<font color="red">服务注册允许bundles去检测新服务和取消的服务，然后相应配合。 </font>OSGI框架一般具备的基础功能： 
支持模块化的动态部署。基于OSGI而构建的系统可以以模块化的方式动态地部署至框架中，从而增加、扩展或改变系统的功能。支持模块化的封装和交互。每个工程（模块）可通过声明Export-Package对外提供访问此工程的类和接口。  
支持模块的动态扩展。基于OSGI提供的面向服务的组件模型的设计方法，以及OSGI实现框架提供的扩展点方法可实现模块的动态扩展。模块化的设计。在OSGI中模块由一个或多个bundle构成，模块之间的交互通过Import-Package、Export-Package以及OSGI Service的方式实现。  
动态化的设计。动态化的设计是指系统中所有的模块必须支持动态的插拔和修改，“即插即用，即删即无”。  
可扩展的设计。通常使用定义扩展点的方式。按照Eclipse推荐的扩展点插件的标准格式定义bundle中的扩展点，其它要扩展的bundle可通过实现相应的扩展点来扩展该bundle的功能。<font color="red">每个bundle拥有独立的class loader，通过它来完成本bundle类的加载。 </font>
稳定、高效的系统。基于OSGI的系统采用的是微核机制，微核机制保证了系统的稳定性，微核机制的系统只要微核是稳定运行的，那么系统就不会崩溃，也就是说基于OSGI的系统不会受到运行在其中的bundle的影响，不会因为bundle的崩溃而导致整个系统的崩溃。 [1]    
OSGi服务平台提供在多种网络设备上无需重启的动态改变构造的功能。为了最小化耦合度和促使这些耦合度可管理，OSGi技术提供一种面向服务的架构，它能使这些组件动态地发现对方。OSGi联盟已经开发了例如像HTTP服务器、配置、日志、安全、用户管理、XML等很多公共功能标准组件接口。这些组件的兼容性插件实现可以从进行了不同优化和使用代价的不同计算机服务提供商得到。然而，服务接口能够基于专有权基础上开发。  
因为OSGi技术为集成提供了预建立和预测试的组件子系统，所以OSGi技术使你从改善产品上市时间和降低开发成本上获益。因为这些组件能够动态发布到设备上，所以OSGi技术也能降低维护成本和拥有新的配件市场机会。 

OSGI规范的核心组件是OSGI框架。这个框架为应用程序（被叫做组件（bundle））提供了一个标准环境。整个框架可以划分为一些层次：
 
OSGI 
L0：运行环境
L1：模块
L2：生命周期管理
L3：服务注册
还有一个无处不在的安全系统渗透到所有层。
 
L0层执行环境是Java环境的规范。Java2配置和子规范，像J2SE，CDC，CLDC，MIDP等等，都是有效的执行环境。OSGi平台已经标准化了一个执行环境，它是基于基础轮廓和在一个执行环境上确定了最小需求的一个小一些的变种，该执行环境对OSGi组件是有用的。
L1模块层定义类的装载策略。OSGi框架是一个强大的具有严格定义的类装载模型。它基于Java之上，但是增加了模块化。在Java中，正常情况下有一个包含所有类和资源的类路径。OSGi模块层为一个模块增加了私有类同时有可控模块间链接。模块层同安全架构完全集成，可以选择部署到部署封闭系统，防御系统，或者由厂商决定的完全由用户管理的系统。
L2生命周期层增加了能够被动态安装、开启、关闭、更新和卸载的bundles。这些bundles依赖于于具有类装载功能的模块层，但是增加了在运行时管理这些模块的API。生命周期层引入了正常情况下不属于一个应用程序的动态性。扩展依赖机制用于确保环境的操作正确。生命周期操作在安全架构保护之下，使其不受到病毒的攻击。
L3层增加了服务注册。服务注册提供了一个面向bundles的考虑到动态性的协作模型。bundles能通过传统的类共享进行协作，但是类共享同动态安装和卸载代码不兼容。服务注册提供了一个在bundles间分享对象的完整模型。定义了大量的事件来处理服务的注册和删除。这些服务仅仅是能代表任何事物的Java对象。很多服务类似服务器对象，例如HTTP服务器，而另一些服务表示的是一个真实世界的对象，例如附近的一个蓝牙手机。这个服务模块提供了完整安全保障。该服务安全模块使用了一个很聪明的方式来保障bundles之间通信安全。



标准服务  
在该框架之上，OSGi联盟定义了很多服务。这些服务通过一个Java接口指定。bundles能够实  
 
OSGI   
现这个接口，并在注册服务层注册该服务。服务的客户端在注册库中找到它，或者当它出现或者消失时做出响应。这个同SOA架构使用Web服务进行发布的方式相似。  
两者主要不同是Web服务总是需要传输层，这个使它比采用直接方法调用的OSGi服务慢几千倍。同时，OSGi组件能够对这些服务的出现和消失做出响应。更多的信息可以从OSGi服务平台发行版本4手册或者PDF下载中找到。需要注意的是每一种服务都是抽象定义的，与不同计算机服务商的实现相独立。  