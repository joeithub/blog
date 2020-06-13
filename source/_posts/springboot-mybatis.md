title: springboot+mybatis
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - MYBATIS
categories:
  - IT
date: 2019-07-10 00:16:00
---
SpringBoot整合Mybatis完整详细版

后来进了新公司，用不到而且忙于任务，今天重温一遍居然有些忘了，看来真是好记性不如烂笔头。于是写下本篇SpringBoot整合Mybatis的文章，做个笔记。

本章节主要搭建框架，下章节实现登录注册以及拦截器的配置：SpringBoot整合Mybatis完整详细版二：注册、登录、拦截器配置

本章项目源码下载：springBoot整合mybatis完整详细版

github地址：https://github.com/wjup/springBoot_Mybatis


`IDE：idea、DB：mysql`

新建一个Spring Initializr项目
![图一](https://img-blog.csdn.net/20180926174038560?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2lrdTUyMDA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

创建项目的文件结构以及jdk的版本 
![图2](https://img-blog.csdn.net/20180926174149120?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2lrdTUyMDA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
选择项目所需要的依赖
![](https://img-blog.csdn.net/20180926174507971?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2lrdTUyMDA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
修改项目名，finish完成
![](https://img-blog.csdn.net/20180926174536917?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2lrdTUyMDA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

来看下建好后的pom
```
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"&gt;
	&lt;modelVersion&gt;4.0.0&lt;/modelVersion&gt;
 
	&lt;groupId&gt;com.example&lt;/groupId&gt;
	&lt;artifactId&gt;demo&lt;/artifactId&gt;
	&lt;version&gt;0.0.1-SNAPSHOT&lt;/version&gt;
	&lt;packaging&gt;jar&lt;/packaging&gt;
 
	&lt;name&gt;demo&lt;/name&gt;
	&lt;description&gt;Demo project for Spring Boot&lt;/description&gt;
 
	&lt;parent&gt;
		&lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
		&lt;artifactId&gt;spring-boot-starter-parent&lt;/artifactId&gt;
		&lt;version&gt;2.0.5.RELEASE&lt;/version&gt;
		&lt;relativePath/&gt; &lt;!-- lookup parent from repository --&gt;
	&lt;/parent&gt;
 
	&lt;properties&gt;
		&lt;project.build.sourceEncoding&gt;UTF-8&lt;/project.build.sourceEncoding&gt;
		&lt;project.reporting.outputEncoding&gt;UTF-8&lt;/project.reporting.outputEncoding&gt;
		&lt;java.version&gt;1.8&lt;/java.version&gt;
	&lt;/properties&gt;
 
	&lt;dependencies&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
			&lt;artifactId&gt;spring-boot-starter-jdbc&lt;/artifactId&gt;
		&lt;/dependency&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
			&lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;
		&lt;/dependency&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;org.mybatis.spring.boot&lt;/groupId&gt;
			&lt;artifactId&gt;mybatis-spring-boot-starter&lt;/artifactId&gt;
			&lt;version&gt;1.3.2&lt;/version&gt;
		&lt;/dependency&gt;
 
		&lt;dependency&gt;
			&lt;groupId&gt;mysql&lt;/groupId&gt;
			&lt;artifactId&gt;mysql-connector-java&lt;/artifactId&gt;
			&lt;scope&gt;runtime&lt;/scope&gt;
		&lt;/dependency&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
			&lt;artifactId&gt;spring-boot-starter-test&lt;/artifactId&gt;
			&lt;scope&gt;test&lt;/scope&gt;
		&lt;/dependency&gt;
	&lt;/dependencies&gt;
 
	&lt;build&gt;
		&lt;plugins&gt;
			&lt;plugin&gt;
				&lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
				&lt;artifactId&gt;spring-boot-maven-plugin&lt;/artifactId&gt;
			&lt;/plugin&gt;
		&lt;/plugins&gt;
	&lt;/build&gt;
 
 
&lt;/project&gt;
```
**修改配置文件**  
&lt;u&gt;本文不使用application.properties文件 而使用更加简洁的application.yml文件。将resource文件夹下原有的application.properties文件删除，创建application.yml配置文件（备注：其实SpringBoot底层会把application.yml文件解析为application.properties）&lt;/u&gt;  

**本文创建了两个yml文件（application.yml和application-dev.yml），分别来看一下内容**
```
application.yml

spring:
  profiles:
    active: dev
```
```
application-dev.yml

server:
  port: 8080
 
spring:
  datasource:
    username: root
    password: 1234
    url: jdbc:mysql://localhost:3306/springboot?useUnicode=true&amp;characterEncoding=utf-8&amp;useSSL=true&amp;serverTimezone=UTC
    driver-class-name: com.mysql.jdbc.Driver
 
mybatis:
  mapper-locations: classpath:mapping/*Mapper.xml
  type-aliases-package: com.example.entity
 
#showSql
logging:
  level:
    com:
      example:
        mapper : debug
```
两个文件的意思是：  

&lt;font color="#FF0000"&gt;在项目中配置多套环境的配置方法。
因为现在一个项目有好多环境，开发环境，测试环境，准生产环境，生产环境，每个环境的参数不同，所以我们就可以把每个环境的参数配置到yml文件中，这样在想用哪个环境的时候只需要在主配置文件中将用的配置文件写上就行如application.yml&lt;/font&gt;&lt;br&gt; 



笔记：在Spring Boot中多环境配置文件名需要满足application-{profile}.yml的格式，其中{profile}对应你的环境标识，比如：  
* application-dev.yml：开发环境  
* application-test.yml：测试环境  
* application-prod.yml：生产环境  

至于哪个具体的配置文件会被加载，需要在application.yml文件中通过spring.profiles.active属性来设置，其值对应{profile}值。

还有配置文件中最好不要有中文注释，会报错。

解决方法（未测试）：spring boot application.yml文件中文注释乱码

接下来把启动文件移到com.example下，而且springboot的启动类不能放在java目录下！！！必须要个包将它包进去

否则会报错误：

`Your ApplicationContext is unlikely to start due to a @ComponentScan of the default package.`  
这个原因值得注意就是因为有时候很难在IDEA中的项目目录认出来这个错误并且还容易扫描不到一些类，传送门：SpringBoot扫描不到controller

                         

然后开始创建实体类实现业务流程
创建包controller、entity、mapper、service。resources下创建mapping文件夹，用于写sql语句，也可以用注解的方式直接写在mapper文件里。下面直接贴代码

数据库表结构（之前小项目的表，直接拿来用）
```
CREATE TABLE `user` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `userName` varchar(32) NOT NULL,
  `passWord` varchar(50) NOT NULL,
  `realName` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

```

entity.java
```
package com.example.entity;
 
/**
 * @Author:wjup
 * @Date: 2018/9/26 0026
 * @Time: 14:39
 */
public class User {
    private Integer id;
    private String userName;
    private String passWord;
    private String realName;
 
    public Integer getId() {
        return id;
    }
 
    public void setId(Integer id) {
        this.id = id;
    }
 
    public String getUserName() {
        return userName;
    }
 
    public void setUserName(String userName) {
        this.userName = userName;
    }
 
    public String getPassWord() {
        return passWord;
    }
 
    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }
 
    public String getRealName() {
        return realName;
    }
 
    public void setRealName(String realName) {
        this.realName = realName;
    }
 
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", userName='" + userName + '\'' +
                ", passWord='" + passWord + '\'' +
                ", realName='" + realName + '\'' +
                '}';
    }
}
```
UserController.java
```
package com.example.controller;
 
import com.example.entity.User;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
 
/**
 * @Author:wjup
 * @Date: 2018/9/26 0026
 * @Time: 14:42
 */
 
@RestController
@RequestMapping("/testBoot")
public class UserController {
 
    @Autowired
    private UserService userService;
 
    @RequestMapping("getUser/{id}")
    public String GetUser(@PathVariable int id){
        return userService.Sel(id).toString();
    }
}
```

UserService.java
```
package com.example.service;
 
import com.example.entity.User;
import com.example.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
 
/**
 * @Author:wjup
 * @Date: 2018/9/26 0026
 * @Time: 15:23
 */
@Service
public class UserService {
    @Autowired
    UserMapper userMapper;
    public User Sel(int id){
        return userMapper.Sel(id);
    }
}
```
UserMapper.java
```
package com.example.mapper;
 
import com.example.entity.User;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;
 
/**
 * @Author:wjup
 * @Date: 2018/9/26 0026
 * @Time: 15:20
 */
@Repository
public interface UserMapper {
 
    User Sel(int id);
}
```
UserMapping.xml
```
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd"&gt;
&lt;mapper namespace="com.example.mapper.UserMapper"&gt;
 
    &lt;resultMap id="BaseResultMap" type="com.example.entity.User"&gt;
        &lt;result column="id" jdbcType="INTEGER" property="id" /&gt;
        &lt;result column="userName" jdbcType="VARCHAR" property="userName" /&gt;
        &lt;result column="passWord" jdbcType="VARCHAR" property="passWord" /&gt;
        &lt;result column="realName" jdbcType="VARCHAR" property="realName" /&gt;
    &lt;/resultMap&gt;
 
    &lt;select id="Sel" resultType="com.example.entity.User"&gt;
        select * from user where id = #{id}
    &lt;/select&gt;
 
&lt;/mapper&gt;
```
最终框架结构
![](https://img-blog.csdn.net/20180927095234881?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2lrdTUyMDA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

完成以上，下面在启动类里加上注解用于给出需要扫描的mapper文件路径@MapperScan("com.example.mapper") 
```
package com.example;
 
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
 
@MapperScan("com.example.mapper") //扫描的mapper
@SpringBootApplication
public class DemoApplication {
 
	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}
```
最后启动，浏览器输入地址看看吧：http://localhost:8080/testBoot/getUser/1


测试成功，就这样基本框架就搭建成功了

最后给个番外篇如何更改启动时显示的字符拼成的字母，就是更改下图标红框的地方
![](https://img-blog.csdn.net/20180927093510607?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2lrdTUyMDA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

其实很好改，只需要在resources下新建一个txt文件就可以，命名为banner.txt，那这种字符该怎么拼出来呢，下面推荐一个网址，有这种工具，链接传送门：字母转字符。如下：
![](https://img-blog.csdn.net/20180926172941481?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2lrdTUyMDA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

直接输入要生成的字母，系统会自动转换，然后复制下面转换好的字符到新建的banner.txt文件中，重新启动项目就可以了。
