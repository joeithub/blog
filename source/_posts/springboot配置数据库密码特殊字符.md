title: springboot配置数据库密码特殊字符
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
categories:
  - IT
date: 2019-09-16 15:24:00
---
springboot配置数据库密码特殊字符报错问题  
一般的springboot项目会有application.yml或者application.properties文件，开发中需要连接数据库时密码可能会有特殊字符，.properties文件不会报错，但是.yml文件会报错。

解决：yml中password对应的&lt;font color="red"&gt;值用单引号引住&lt;/font&gt;（'!@test'）就可以了，如下

```
spring:
    datasource:
        password: '!@test'
        type: com.alibaba.druid.pool.DruidDataSource
        url: jdbc:mysql://localhost:3306/test?characterEncoding=utf-8&amp;serverTimezone=GMT%2B8
        username: root
```
