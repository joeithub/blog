title: '@AutoConfigureBefore'
author: Joe Tong
date: 2019-09-04 14:28:11
tags:
  - ANNOTATION
categories:
  - IT
---
1.了解自动配置的bean  

查看(脱掉)Spring的代码(衣服),auto-configuration 就是一个实现了Configuration接口的类。使用@Conditional注解来限制何时让auto-configuration 生效，通常auto-configuration 使用ConditionalOnClass和ConditionalOnMissingBean注解，这两注解的确保只有当我们拥有相关类的时候使得@Configuration注解生效。

2.auto-configuration的目录结构
Spring Boot 会检查所有jar包下的META-INF/spring.factories文件，这个文件中EnableAutoConfiguration 的KEY下面罗列了需要自动配置的类，例如：  

```
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
com.mycorp.libx.autoconfigure.LibXAutoConfiguration,\
com.mycorp.libx.autoconfigure.LibXWebAutoConfiguration
```
当我们需要对配置类的加载顺序排序的时候，可以使用  
@AutoConfigureAfter或者@AutoConfigureBefore注解。  
例如，如果我们提供了一个特殊的web configuration,需要在WebMvcAutoConfiguration之后才对我们注解的类进行加载。  
如果想要自动排序，可以使用@AutoconfigureOrder注解，这个注解类似于@Order，但是它是专门给auto-configuration使用。  

```
Auto-configuration 只有通过这种方式加载，确保 他们定义在一个特定的包空间下能够被扫描。
```

3.Condition注解  
我们在auto-configuration中看到不止一个使用了@Condition注解的类，比如   @ConditionalOnMissingBean，那么下面就介绍一下auto-configuration中常用的注解  

Class Conditions  
@ConditionalOnClass和@ConditionalOnMissingClass 注解允许拥有或缺失指定的类进行配置，另外使用了ASM技术 来解析注解，我们可以使用value属性来引用出真实的类，即使这个类不会出现在正在运行的程序类路径中，如果希望指定类名，可以使用name属性  

bean Conditions  
ConditionalOnBean和ConditionalOnMissingBean注解允许用于或确实指定的bean来进行配置，我们可以使用value属性配置一个特别的类型。或者用name配置特殊的名字，search属性允许限制搜索ApplicationContext中的层次结构。

```
@Configuration
 public  class MyAutoConfiguration { @Bean @ConditionalOnMissingBean public MyService myService（）{...}
}
```

在这个方法中，myService如果还没有存在Spring容器中，那么它将会在这个方法中得到创建。

这里特别需要注意bean的启动顺序，因为在做一个共享库的时候影响十分深远，所以，我们应当尽量使用@ConditionalOnBean 和@ConditionalOnMissingBena注解在auto-configuration的过程中。保证用户在添加了自已定义的bean后能够正常的加载系统。

```
@ConditionalOnBean和@ConditionalOnMissingBean不会阻止被@Configuration注解的类加载，所以这些条件应当去标记具体包含的每个方法
```

Property Condition  
@ConditionalOnProperty注解允许基于Spring的环境属性进行配置，使用prefix和name参数来检查指定的属性值，任何存在且不等于属性false都将被匹配，更高级的检查可以使用havingValue和matchIfMissing属性。  

Resource Condition  
@ConditionalOnResource注解去判断指定的资源是否存在，可以使用常规的Spring约束来指定资源，例如file://home/usr/test.dat。

Web Application Condition  
@ConditionalOnWebApplication和@ConditionalOnNotWebApplication注解允许根据应用是否是一个“web应用程序”被包括配置。

SPEL表达式  
该@ConditionalOnExpression注释允许基于一个的结果被包括配置使用SpEL表达。

创建自定义的starter  
一个完整的Spring Boot starter应该包含下面这些组件：

autoconfigure 模块包含了自动配置的代码
starter模块提供了一个autoconfigure的模块和其他额外的依赖。

命名的问题  
需要确保为我们的starter提供了一个合适名字，不要让模块名字叫spring-boot等一系列不知所云的名称，即使你用的不同的Maven GroupId，我们应当让模块名称更规范，容易理解。

例如我们正在创建一个acme的start模块，命名推荐叫做acme-spring-boot-autoconfigure和acme-spring-boot-starter，

final  
starter其实是一个空的模块，它的唯一目的其实就是提供一个必要的依赖关系，
