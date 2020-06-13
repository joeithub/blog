title: '@PostConstruct'
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
categories:
  - IT
date: 2019-09-05 10:53:00
---
###### 简介
Java EE5 引入了@PostConstruct和@PreDestroy这两个作用于Servlet生命周期的注解，实现Bean初始化之前和销毁之前的自定义操作。此文主要说明@PostConstruct。

###### API使用说明

* PostConstruct 注释用于在依赖关系注入完成之后需要执行的方法上，以执行任何初始化。此方法必须在将类放入服务之前调用。支持依赖关系注入的所有类都必须支持此注释。即使类没有请求注入任何资源，用 PostConstruct 注释的方法也必须被调用。只有一个方法可以用此注释进行注释。应用 PostConstruct 注释的方法必须遵守以下所有标准：该方法不得有任何参数，除非是在 EJB 拦截器 (interceptor) 的情况下，根据 EJB 规范的定义，在这种情况下它将带有一个 InvocationContext 对象 ；该方法的返回类型必须为 void；该方法不得抛出已检查异常；应用 PostConstruct 的方法可以是 public、protected、package private 或 private；除了应用程序客户端之外，该方法不能是 static；该方法可以是 final；如果该方法抛出未检查异常，那么不得将类放入服务中，除非是能够处理异常并可从中恢复的 EJB。

***

** 总结为一下几点： **

只有一个方法可以使用此注释进行注解；  
被注解方法不得有任何参数；  
被注解方法返回值为void；  
被注解方法不得抛出已检查异常；  
被注解方法需是非静态方法；  
此方法只会被执行一次；

Servlet执行流程图  
两个注解加入只会，Servlet执行流程图：  



![upload successful](/images/pasted-120.png)

在具体Bean的实例化过程中，@PostConstruct注释的方法，会在构造方法之后，init方法之前进行调用。

实例
基于Spring boot编写的可执行方法见github：https://github.com/HappySecondBrother/example
UserService方法（提供缓存数据）：


```
package com.secbro.service;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author 二师兄
 * @date 2016/8/10
 */
@Service
public class UserService {

    public List&lt;String&gt; getUser(){

        List&lt;String&gt; list = new ArrayList&lt;&gt;();
        list.add("张三");
        list.add("李四");
        return list;
    }
}
```
BusinessService方法，通过@PostConstruct调用UserService：

```
package com.secbro.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.List;

/**
 * @author 二师兄
 * @date 2016/8/10
 */
@Service
public class BusinessService {

    @Autowired
    private UserService userService;

    private List&lt;String&gt; list = null;

    /**
     * 构造方法执行之后，调用此方法
     */
    @PostConstruct
    public void init(){
        System.out.println("@PostConstruct方法被调用");
        // 实例化类之前缓存获得用户信息
        List&lt;String&gt; list = userService.getUser();
        this.list = list;
        if(list != null &amp;&amp; !list.isEmpty()){
            for(String user : list){
                System.out.println("用户：" + user);
            }
        }
    }

    public BusinessService(){
        System.out.println("构造方法被调用");
    }

    public List&lt;String&gt; getList() {
        return list;
    }

    public void setList(List&lt;String&gt; list) {
        this.list = list;
    }
}
```

执行结果：

```
构造方法被调用
@PostConstruct方法被调用
用户：张三
用户：李四
```

项目应用  
** 在项目中@PostConstruct主要应用场景是在初始化Servlet时加载一些缓存数据等。**

注意事项
使用此注解时会影响到服务的启动时间。服务器在启动时会扫描WEB-INF/classes的所有文件和WEB-INF/lib下的所有jar包。
