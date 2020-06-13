title: 分布式eureka
author: Joe Tong
tags:
  - JAVAEE
  - EUREKA
  - SPRINGBOOT
  - 分布式
categories:
  - IT
date: 2019-10-12 13:47:00
---
* Netflix Eureka 简介  
 * 1、Eureka 是 Netflix 公司开发的服务发现框架，Spring Cloud 对它提供了支持，将它集成在了自己的&nbsp;spring-cloud-netflix &nbsp;子项目中。

 * 2、Netflix 公司在 Github 上开源了很多项目，Eureka 只是其中一个，Netflix 开源主页：https://github.com/Netflix

 * 3、Netflix Eureka GitHub 开源地址：https://github.com/Netflix/eureka。

AWS Service registry for resilient mid-tier load balancing and failover.（Eureka 是用于弹性中间层负载平衡和故障转移的AWS服务注册中心）

* 1.简介  
EureKa在Spring Cloud全家桶中担任着服务的注册与发现的落地实现。Netflix在设计EureKa时遵循着AP原则，它基于REST的服务，用于定位服务，以实现云端中间层服务发现和故障转移，功能类似于Dubbo的注册中心Zookeeper。

* 2.实现原理

![upload successful](/images/pasted-185.png)

EureKa采用CS的设计架构，即包括了Eureka Server（服务端），EureKa client（客户端）。
1.EureKa Server 提供服务注册，各个节点启动后，在EureKa server中进行注册；

2 EureKa Client 是一个Java客户端，用于和服务端进行交互，同时客户端也是一个内置的默认使用轮询负载均衡算法的负载均衡器。在应用启动后，会向Eueka Server发送心跳（默认30秒）。如果Eureka Server在多个心跳周期内没有接受到某个节点的心跳，EureKa Server将会从服务注册表中将这个服务移出（默认90秒）。

* 3.SpringCloud Eureka的使用步骤  
 * 3.1Eureka Service端(服务端)  
 * 3.1.1.POM.XML  
  导入相依的依赖 
  
  ```
  &lt;dependency&gt;
  &lt;groupId&gt;org.springframework.cloud&lt;/groupId&gt;
  &lt;artifactId&gt;spring-cloud-starter-eureka-server&lt;/artifactId&gt;
  &lt;/dependency&gt;
  ```

 * 3.1.2.application.yml  
配置文件的配置demo

  ```
  eureka:
    instance:
      #单机hostname: localhost
      hostname: eureka7002.com         #eureka服务端的实例名称
    client:
      register-with-eureka: false     #false表示不向注册中心注册自己。
      fetch-registry: false           #false表示自己端就是注册中心，我的职责就是维护服务实例，并不需要去检索服务
      service-url:
        #单机设置与Eureka Server交互的地址查询服务和注册服务都需要依赖这个地址（单机）。
        #defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/

        #Eureka高复用时设置其他的Eureka之间通信
        #defaultZone: http://eureka7003.com:7003/eureka/,http://eureka7004.com:7004/eureka/
         defaultZone: http://eureka7003.com:7003/eureka/
    #server:
      #enable-self-preservation: false   #Eureka服务端关闭心跳连接测试
  ```

 * 3.1.3.主程序类  
  添加注解
  @EnableEurekaServer  
    demo :
  
    ```
    package com.mark.eureka;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

    @EnableEurekaServer
    @SpringBootApplication
    public class EurekaServerApplication {

        public static void main(String[] args) {
            SpringApplication.run(EurekaServerApplication.class, args);
        }
    }
    ```
    
 启动后访问设置的端口eg http://127.0.0.1:7002/
 &nbsp;
 ![upload successful](/images/pasted-186.png)
 
 * 3.2Eureka Clinet(客户端)
 
   * 3.2.1 pom.XMl
   
    &nbsp; ```
 &nbsp; &nbsp;  &lt;!-- 将微服务provider侧注册进eureka --&gt;
      &lt;dependency&gt;
        &lt;groupId&gt;org.springframework.cloud&lt;/groupId&gt;
        &lt;artifactId&gt;spring-cloud-starter-eureka&lt;/artifactId&gt;
      &lt;/dependency&gt;   
      
     ```

   
   * 3.2.2 application.yml  
    

     server:
      port: 8001
     eureka:
       client:                #客户端注册进eureka服务列表内
         service-url:
           #单机defaultZone: http://localhost:7002/eureka
           #集群是
           #defaultZone: http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/,http://eureka7004.com:7004/eureka/
         defaultZone: http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
       instance:
         instance-id: microservicecloud-dept8001
         prefer-ip-address: true    #访问路径可以显示IP地址
     info:                  #在Eure页面访问info返回的信息的配置
       app.name: atguigu-microservicecloud
       company.name: www.mark.com
       build.artifactId: $project.artifactId$
       build.version: $project.version$

  
   * 3.2.3主程序类  
   
  添加注解：（注意和服务端区分开）  
  @EnableEurekaClient  
  @EnableDiscoveryClient 
  
  ```
    @SpringBootApplication
    @EnableEurekaClient
    @EnableDiscoveryClient
    public class Deptprovider8003_App {
  ```
     
 * 3.3补充  
  如果是Eureka Client的消费者，如果获取注册中心中的微服务，那么还需要在配置类中注入一个组件RestTemplate  
  demo

  ```  
    package com.mark.springcloud.config;

    import org.springframework.cloud.client.loadbalancer.LoadBalanced;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;
    import org.springframework.web.client.RestTemplate;

    /**
     * Created by Choisaaaa on 2018/7/7.
     * 自定义配置类
     */

    @Configuration
    public class MyConfig {
        @Bean
        @LoadBalanced//使用负载均衡
        public RestTemplate restTemplate(){
            return new RestTemplate();
        }
    }  

  ```
   
 调用的demo  
   
```
    package com.mark.springcloud.controller;

    import com.mark.springcloud.entities.Dept;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;
    import org.springframework.web.client.RestTemplate;

    import java.util.List;

    /**
     * Created by Choisaaaa on 2018/7/7.
     *
     */
    @RestController
    @RequestMapping("/consumer/dept")
    public class DeptControler_Consumer {

        //private static final String REST_URL_PREFIX = "http://localhost:8001";
        //MICROSERVICECLOUD-DEP：为Eureka Server中心的微服务实例名称
        private static final String REST_URL_PREFIX = "http://MICROSERVICECLOUD-DEPT";

        @Autowired
        private RestTemplate restTemplate;

        @RequestMapping(value = "/add")
        public boolean add(Dept dept) {
            return restTemplate.getForObject(REST_URL_PREFIX+"/dept/add",Boolean.class,dept);
        }

        @RequestMapping(value = "get/{id}")
        public Dept get(@PathVariable("id") Long id) {
            return restTemplate.getForObject(REST_URL_PREFIX+"/dept/get/"+id,Dept.class);
        }

        @RequestMapping(value = "/list")
        public List&lt;Dept&gt; list(){
            return restTemplate.getForObject(REST_URL_PREFIX+"/dept/list",List.class);
        }

        //消费者调用服务发现
        @RequestMapping("/discovery")
        public Object discovery() {
            return restTemplate.getForObject(REST_URL_PREFIX+"/dept/discovery",Object.class);
        }
    }  
```

参考：  &nbsp;
https://www.cnblogs.com/knowledgesea/p/11208000.html &nbsp;
熔断 
https://blog.csdn.net/qq_36763236/article/details/82024039   
https://www.cnblogs.com/guagua-join-1/p/9638767.html


