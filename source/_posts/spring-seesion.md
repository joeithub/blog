title: spring session实现session共享
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - SESSION
categories:
  - IT
date: 2019-10-12 16:18:00
---
使用Spring Session redis进行Session共享

在搭建完集群环境后，不得不考虑的一个问题就是用户访问产生的session如何处理。

session的处理有很多种方法，详情见转载的上篇博客：集群/分布式环境下5种session处理策略

在这里我们讨论其中的第三种方法：session共享。

redis集群做主从复制，利用redis数据库的最终一致性，将session信息存入redis中。当应用服务器发现session不在本机内存的时候，就去redis数据库中查找，因为redis数据库是独立于应用服务器的数据库，所以可以做到session的共享和高可用。



不足：

1.redis需要内存较大，否则会出现用户session从Cache中被清除。

2.需要定期的刷新缓存

初步结构如下 &nbsp;

![upload successful](/images/pasted-187.png)
但是这个结构仍然存在问题，redis master是一个重要瓶颈，如果master崩溃的时候，但是redis不会主动的进行master切换，这时session服务中断。

但是我们先做到这个结构，后面再进行优化修改。  
Spring Boot提供了Spring Session来完成session共享。

官方文档：http://docs.spring.io/spring-session/docs/current/reference/html5/guides/boot.html#boot-sample

首先创建简单的Controller： 

```
@Controller
public class UserController {
	
	@RequestMapping(value="/main", method=RequestMethod.GET)
	public String main(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String sessionId = (String) session.getAttribute("sessionId");
		if (null != sessionId) { // sessionId不为空
			System.out.println("main sessionId:" + sessionId);
			return "main";
		} else { // sessionId为空
			return "redirect:/login";
		}
	}
	
	
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public String login() {
		return "login";
	}
	
	@RequestMapping(value="/doLogin", method=RequestMethod.POST)
	public String doLogin(HttpServletRequest request) {
		System.out.println("I do real login here");
		HttpSession session = request.getSession();
		String sessionId = UUID.randomUUID().toString();
		session.setAttribute("sessionId", sessionId);
		System.out.println("login sessionId:" + sessionId);
		return "redirect:/main";
	}
}
```
简单来说就是模拟一下权限控制，如果sessionId存在就访问主页，否则就跳转到登录页面。  
那么如何实现session共享呢？

加入以下依赖：  

```
&lt;!-- spring session --&gt;
&lt;dependency&gt;
	&lt;groupId&gt;org.springframework.session&lt;/groupId&gt;
	&lt;artifactId&gt;spring-session&lt;/artifactId&gt;
	&lt;version&gt;1.3.0.RELEASE&lt;/version&gt;
&lt;/dependency&gt;
&lt;!-- redis --&gt;
&lt;dependency&gt;
	&lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
	&lt;artifactId&gt;spring-boot-starter-redis&lt;/artifactId&gt;
&lt;/dependency&gt;
```


增加配置类：

```
@EnableRedisHttpSession
public class HttpSessionConfig {
	@Bean
	public JedisConnectionFactory connectionFactory() {
	        return new JedisConnectionFactory();
	}
}
```
这个配置类有什么用呢？
官方文档：

The Spring configuration is responsible for creating a Servlet Filter that replaces the HttpSession implementation with an implementation backed by Spring Session.&nbsp;

也就是说，这个配置类可以创建一个过滤器，这个过滤器支持Spring Session代替HttpSession发挥作用。

The @EnableRedisHttpSession annotation creates a Spring Bean with the name of springSessionRepositoryFilter that implements Filter. The filter is what is in charge of replacing the HttpSession implementation to be backed by Spring Session. In this instance Spring Session is backed by Redis.

@EnableRedisHttpSession注解会创建一个springSessionRepositoryFilter的bean对象去实现这个过滤器。过滤器负责代替HttpSession。

也就是说，HttpSession不再发挥作用，而是通过过滤器使用redis直接操作Session。

在application.properties中添加redis的配置：

```
spring.redis.host=localhost
spring.redis.password=
spring.redis.port=6379
```

这样，就完成了Session共享了。是不是很简单？业务代码甚至不需要一点点的修改。
验证：

![upload successful](/images/pasted-188.png)
一开始redis数据库是空的。

运行项目：

![upload successful](/images/pasted-190.png)
访问页面之后，可以在redis中看到session的信息。

随便登陆之后：

![upload successful](/images/pasted-191.png)

进入到了main中。说明当前这个session中是存在sessionId的。

我们查看当前页面的cookie。也就是说，这个cookie是存在sessionId的。

![upload successful](/images/pasted-192.png)

再运行一个新的项目，端口为8081。在原本的浏览器中直接打开一个新的标签页，我们知道，这个时候cookie是共享的。访问localhost:8081/main


![upload successful](/images/pasted-193.png)
我们直接访问新的项目成功了！！同一个cookie，可以做到session在不同web服务器中的共享。



最后再次强调：

** HttpSession的实现被Spring Session替换，操作HttpSession等同于操作redis中的数据。**





