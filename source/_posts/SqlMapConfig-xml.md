title: SqlMapConfig.xml
author: Joe Tong
tags:
  - JAVAEE
  - MYBATIS
categories:
  - IT
date: 2019-07-10 05:06:00
---
```
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!DOCTYPE configuration  
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"  
  "http://mybatis.org/dtd/mybatis-3-config.dtd"&gt;
  &lt;!-- mybatis的主配置文件 --&gt;
&lt;configuration&gt;
 &nbsp; &nbsp;&lt;!-- 配置环境 (可以随便起个名但约定成俗就叫mysql)--&gt;
    &lt;environments default="mysql"&gt;
        &lt;!-- 配置mysql的环境--&gt;
        &lt;environment id="mysql"&gt;
            &lt;!-- 配置事务的类型--&gt;
            &lt;transactionManager type="JDBC"&gt;&lt;/transactionManager&gt;
            &lt;!-- 配置数据源（连接池） --&gt;
            &lt;dataSource type="POOLED"&gt;
                &lt;!-- 配置连接数据库的4个基本信息 --&gt;
                &lt;property name="driver" value="com.mysql.jdbc.Driver"/&gt;
                &lt;property name="url" value="jdbc:mysql://localhost:3306/my_mybatis"/&gt;
                &lt;property name="username" value="root"/&gt;
                &lt;property name="password" value="1234"/&gt;
            &lt;/dataSource&gt;
        &lt;/environment&gt;
    &lt;/environments&gt;

    &lt;!-- 指定映射配置文件的位置，映射配置文件指的是每个dao独立的配置文件 --&gt;
    &lt;mappers&gt;
        &lt;mapper resource="com/enlink/dao/IUserDao.xml"/&gt;
        &lt;!--  通过resource或者class来区分判断用的是配置文件还是注解方式  
        &lt;mapper class="com.enlink.dao.IUserDao"/&gt;
        --&gt;
    &lt;/mappers&gt; 
&lt;/configuration&gt;
  ```
