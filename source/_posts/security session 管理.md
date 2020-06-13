title: security session 管理
author: Joe Tong
tags:
  - JAVAEE 
  - SECURITY
categories: 
  - IT
date: 2020-06-05 16:11:18
---

## Session超时管理
在SpringBoot中，可以直接在配置文件中对Session超时时间进行设置

### 默认为30分钟，这里的单位是秒
server.session.timeout = 10 * 60

SpringBoot中默认的Session超时时间是30分钟，通过配置文件设置的单位的是，但是最少设置为60秒

Session 超时处理
在之前的系统设计中，如果Session超时了，那么再次调用被限制的接口，会跳转到登录页面。这里我们可以更人性化一点，告知前端是用户Session超时还是未登录

```
// BrowerSecurityConfig.java
protected void configure(HttpSecurity http) {
    http.sessionManagement()                           // session超时跳转
         .invalidSessionUrl("/session/invalid");
}
```
当然这里还是需要把相应的接口url放入可允许访问的配置中的

集群Session处理
一般情况下，服务都会部署到至少两台服务器上面，这样可以保证当一台服务器出现问题的时候，依然可以正常的工作。
所以就会出现如下的情况：用户A第一次登录，该请求是在服务器1上处理的，那么Session信息就保存在了服务器1上面。过了一段时间，用户A又来访问了，这个时候如果在负载均衡那一层没有做处理，就有可能请求来到了服务器2上面，这个时候服务器2上没有保存过用户的Session，就会要求用户去再次登录。

简单的解决： 我们就不将Session信息存在服务器上了，而是存到专门的一块存储服务中。每次有用户请求来的时候，服务器都先去访问一下存储服务。

代码实现
这里其实Spring就提供了相应的库来支持这种Session集群处理，

```
&lt;dependency&gt;
    &lt;groupId&gt;org.springframework.session&lt;/groupId&gt;
    &lt;artifactId&gt;spring-session&lt;/artifactId&gt;
&lt;/dependency&gt;
```

spring-session支持如下几种存储Session的方式：

```
public enum StoreType {
    REDIS,
    MONGO,
    JDBC,
    HAZELCAST,
    HASH_MAP,
    NONE;

    private StoreType() {
    }
}
```
这里我们以REDIS为例 ，在配置文件中进行配置

`spring.session.store-type = REDIS`

这样就可以了，SpringBoot会采用默认的Redis配置，如果需求修改Redis配置，也是很简单的。

Session控制
最大Session数
有的时候我们希望这样：当用户在其他地方登录了，原来登录过的Session就失效

```
// BrowerSecurityConfig.java
protected void configure(HttpSecurity http) {
    http.sessionManagement()
        // session超时跳转
        .invalidSessionStrategy(invalidSessionStrategy) 
        // 最大并发session
        .maximumSessions(securityProperties.getBrowser().getSession().getMaximumSessions())   
        // 是否阻止新的登录
        .maxSessionsPreventsLogin(securityProperties.getBrowser().getSession().isMaxSessionsPreventsLogin())    
        // 并发session失效原因
        .expiredSessionStrategy(sessionInformationExpiredStrategy)      
        .and()
        .and()
}

```



