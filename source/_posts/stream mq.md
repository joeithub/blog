title: springcloud stream mq
author: Joe Tong
tags:
  - SPRING STREAM
categories:  
  - IT
date: 2019-10-24 10:08:59
---

安装RabbitMQ
window下安装: 
(1)：下载erlang，原因在于RabbitMQ服务端代码是使用并发式语言erlang编写的，下载地址：http://www.erlang.org/downloads，双击.exe文件进行安装就好，安装完成之后创建一个名为ERLANG_HOME的环境变量，其值指向erlang的安装目录，同时将%ERLANG_HOME%\bin加入到Path中，最后打开命令行，输入erl，如果出现erlang的版本信息就表示erlang语言环境安装成功；

![环境变量](/images/环境变量.png "环境变量")
![cmd1](/images/cmd1.png "cmd1")

(2)：下载RabbitMQ，下载地址：http://www.rabbitmq.com/，同样双击.exe进行安装就好。然后下载RabbitMQ 管理插件，可以更好的可视化方式查看Rabbit MQ 服务器实例的状态。
1.使用管理员打开命令窗口，进入安装目录sbin：
输入命令：rabbitmq-plugins.bat enable rabbitmq_management

2.安装成功后，重启服务器

输入命令：net stop RabbitMQ &amp;&amp; net start RabbitMQ

![cmd2](/images/cmd2.png "cmd2")

3.用户及权限管理

使用rabbitmqctl控制台命令来创建用户，密码，绑定权限等。

查看已有用户及用户的角色：rabbitmqctl.bat list_users  默认会存在一个来宾账号 guest

新增一个用户：rabbitmqctl.bat add_user username password

![cmd3](/images/cmd3.png "cmd3")

新增成功后，可以看见新增的角色为[]，guest的角色是administor。

rabbitmq用户角色可分为五类：超级管理员, 监控者, 策略制定者, 普通管理者以及其他

(1) 超级管理员(administrator)
可登陆管理控制台(启用management plugin的情况下)，可查看所有的信息，并且可以对用户，策略(policy)进行操作。
(2) 监控者(monitoring)
可登陆管理控制台(启用management plugin的情况下)，同时可以查看rabbitmq节点的相关信息(进程数，内存使用情况，磁盘使用情况等) 
(3) 策略制定者(policymaker)
可登陆管理控制台(启用management plugin的情况下), 同时可以对policy进行管理。
(4) 普通管理者(management)
仅可登陆管理控制台(启用management plugin的情况下)，无法看到节点信息，也无法对策略进行管理。
(5) 其他的
无法登陆管理控制台，通常就是普通的生产者和消费者

下面给新增的用户来增加administrator角色

rabbitmqctl.bat set_user_tags username administrator

![cmd4](/images/cmd4.png "cmd4")

4.消息队列的管理

使用浏览器打开 http://localhost:15672 访问Rabbit Mq的管理控制台，使用刚才创建的账号登陆系统：

![cmd5](/images/cmd5.png "cmd5")

RibbitMQ的具体运用
结构原理：

![cmd6](/images/cmd6.png "cmd6")

spring cloud stream
Spring Cloud Stream 是一个构建消息驱动微服务的框架.

![stream](/images/stream.png "stream")

应用程序通过 inputs 或者 outputs 来与 Spring Cloud Stream 中binder 交互，通过我们配置来 binding ，而 Spring Cloud Stream 的 binder 负责与中间件交互。

Binder 是 Spring Cloud Stream 的一个抽象概念，是应用与消息中间件之间的粘合剂。

通过 binder ，可以很方便的连接中间件，可以动态的改变消息的destinations（对应于 Kafka 的topic，Rabbit MQ 的 exchanges）

，这些都可以通过外部配置项来做到。

 新建一个stream项目，主要有3部分，消息产生者类(provider)，消息消费者类(receive)，stream input/output通道定义类(source)

 由于是微服务框架，这里我把stream的有关定义都放到了这个项目集中定义，其他用到stream的项目直接引入这个项目的jar包就可以使用其中的类：
 
![class](/images/class.png "class")

消息提供者配置：
```
public interface MessageProviderSource {

    // exchange名称
    public static final String EXCHANGE_OUT = "exporttv_exchange_out";
    
    // 绑定exchange
    @Output(MessageProviderSource.EXCHANGE_OUT)
    public MessageChannel messageOutput();
 
    
}
```

```
@EnableBinding(MessageProviderSource.class)
public class MessageProvider {

    @Autowired
    private MessageProviderSource messageSource;

    public void sendApplicationLoadMessage(HashMap&lt;String, Integer&gt; map) {
    // 创建并发送消息
    messageSource.messageOutput().send(message(map));
    }

    private static final &lt;T&gt; Message&lt;T&gt; message(T val) {
    return MessageBuilder.withPayload(val).build();
    }
}
```

消息消费者配置：

```
public interface MessageReceiveSource {

    // exchange名称
    public static final String EXCHANGE_IN = "exporttv_exchange_in";
    // 绑定通道
    @Input(MessageReceiveSource.EXCHANGE_IN)
    public SubscribableChannel  messageIutput();
}
```

```
@EnableBinding(MessageReceiveSource.class) 
public class MessageReceive {
    
    @StreamListener(MessageReceiveSource.EXCHANGE_IN)
    public void ApplicationLoadMessage(Message&lt;HashMap&lt;String,Integer&gt;&gt; message) {
    
    }
}
```

然后其他项目引入这个项目后，还要在yml中配置一下绑定：

消息提供者yml

```
spring:
  cloud:
    stream:
      bindings: # 服务的整合处理 
        exporttv_exchange_out: 
          destination: exporttv_exchange # 绑定exchange
          content-type: application/json # 设置消息类型
          binder: exporttv-rabbitmq      # 消息中间件
      binders:
        exporttv-rabbitmq:
          type: rabbit
          environment:
            spring:
              rabbitmq:
                host: localhost
                port: 5672
                username: guest
                password: guest
                virtual-host: /
```

消息消费者yml：

```
spring:
  cloud:
    stream:
      bindings: # 服务的整合处理 
        exporttv_exchange_in: 
          destination: exporttv_exchange # 绑定exchange
          content-type: application/json # 设置消息类型
          group: exporttv-group          # 进行操作的分组
          binder: exporttv-rabbitmq      # 消息中间件
      binders:
        exporttv-rabbitmq:
          type: rabbit
          environment:
            spring:
              rabbitmq:
                host: localhost
                port: 5672
                username: guest
                password: guest
                virtual-host: /
```

下面说说提供者和消费者怎么引用之前定义的类

消息提供者项目：

![msg](/images/message.png "msg")

```
@Service
public class SendApplicationMessage {

    @Autowired
    private MessageProvider messageProvider;

    public void SendApplicationLoadMessage() {

    try {

        // 业务功能省略
       

        messageProvider.sendApplicationLoadMessage();

    } catch (Exception e) {
        // 打印错误日志
        LogUtil.printLog(e, Exception.class);
        // 抛出错误
        throw new MyRuntimeException(ResultEnum.DBException);
    }
    }

}
```
消息消费者子项目：

```
@Component
public class ReceiveApplicationMessage extends MessageReceive{
    
    @Autowired
    private ApplicationService applicationService;
    
    @Override
    public void ApplicationLoadMessage(Message&lt;HashMap&lt;String,Integer&gt;&gt; message) {
    
    Integer toalYear = message.getPayload().get("year");
    Integer toalMonth = message.getPayload().get("month");
    Integer toalWeek = message.getPayload().get("week");
    Integer toanId = message.getPayload().get("toanId");
    
    applicationService.updateApplicationLoad(toalYear, toalMonth, toalWeek, toanId);
    }
    
}
```





