title: springcloudstream-rabbitmq
author: Joe Tong
  - RABBITMQ
  - MQ
categories:  
  - IT 
date: 2019-10-24 10:08:59
---

[TOCM]

[TOC]

## 依赖
```
&lt;dependency&gt;
  &lt;groupId&gt;org.springframework.cloud&lt;/groupId&gt;
  &lt;artifactId&gt;spring-cloud-starter-stream-rabbit&lt;/artifactId&gt;
&lt;/dependency&gt;
```

同样，创建使用者项目，但只能创建spring-cloud-starter-stream-rabbit依赖项。

### 1.建立生产者
如前所述，消息从发布者传递到交换并传递到队列的整个过程是通过通道完成的。因此，让我们创建一个HelloBinding包含我们MessageChannel称为“ greetingChannel” 的接口：

```
interface HelloBinding {
    @Output("greetingChannel")
    MessageChannel greeting();
}
```
由于这将发布消息，因此我们使用了@Output注释。方法名称可以是我们想要的任何名称，当然，在一个接口中可以有多个通道。

现在，让我们创建一个REST端点，将消息推送到此通道：

```
@RestController
public class ProducerController {

    private MessageChannel greet;

    public ProducerController(HelloBinding binding) {
        greet = binding.greeting();
    }

    @GetMapping("/greet/{name}")
    public void publish(@PathVariable String name) {
        String greeting = "Hello, " + name + "!";
        Message&lt;String&gt; msg = MessageBuilder.withPayload(greeting)
            .build();
        this.greet.send(msg);
    }
}
```

上面，我们创建了一个ProducerController具有greet 属性的类MessageChannel。这是通过我们之前声明的方法在构造函数中初始化的。

注意：我们也可以以紧凑的方式进行相同的操作，但是我们使用不同的名称来使您更清楚地了解事物之间的联系。

然后我们有一个简单的REST的映射，一个需要从PathVariable 获取name，并创建一个Message类型的String使用MessageBuilder。最后，我们使用.send()方法通过MessageChannel来发布消息。

现在，我们必须向Spring讲述我们的HelloBinding，我们将在我们的主类中使用@EnableBinding注释：

```
@EnableBinding(HelloBinding.class)
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```
#### 配置文件
最后，我们必须告诉Spring如何连接RabbitMQ（通过前面的“ AMQP URL”），并找到一种方法将“ greetingChannel”连接到可能的使用者。

这两个都在application.properties内定义：

```
spring.rabbitmq.addresses=&lt;amqp url&gt;

spring.cloud.stream.bindings.greetingChannel.destination = greetings

server.port=8080
```

### 2.建立消费者
现在，我们需要收听先前创建的频道，即“ greetingChannel”。让我们为其创建一个绑定：

```
public interface HelloBinding {
String GREETING = "greetingChannel";
    @Input(GREETING)
    SubscribableChannel greeting();
}
```

与生产者绑定的两个区别应该很明显。由于我们正在使用消息，因此我们使用SubscribableChannel和@Input注释连接到将推送数据的“ greetingChannel”。

现在，让我们创建在其中将实际处理数据的方法：

```
@EnableBinding(HelloBinding.class)
public class HelloListener {
    @StreamListener(target = HelloBinding.GREETING)
    public void processHelloChannelGreeting(String msg) {
        System.out.println(msg);
    }
}
```

在这里，我们创建了一个类HelloListener，该类的方法带有@StreamListener以表示的“ greetingChannel”。此方法需要a String作为参数，我们刚刚在控制台中登录了该参数。我们还在班级顶部HelloBinding使用启用了此处@EnableBinding。

再一次，我们使用了在这儿使用了@EnableBinding 而不是主main类中，目的是告诉您，如何组织名称，声明等取决于您或您的团队，这取决于您。

让我们也看看我们的主类，我们没有改变：
```
@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```
在application.properties我们需要定义我们做了生产者同样的事情，不同的是，这将在不同端口上运行：

