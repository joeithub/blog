title: '@Table 注解详解'
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
categories:
  - IT
date: 2019-10-11 11:16:00
---
spring @Table注解    
作用是 ： 声明此对象映射到数据库的数据表，通过它可以为实体指定表(talbe)

常用的两个属性： 
1、name 用来命名 当前实体类 对应的数据库 表的名字   
`@Table(name = "tab_user"）`

2、uniqueConstraints 用来批量命名唯一键 
其作用等同于多个：@Column(unique = true)

`@Table(name = "tab_user",uniqueConstraints = {@UniqueConstraint(columnNames={"uid","email"})})`

![upload successful](/images/pasted-183.png)
![upload successful](/images/pasted-184.png)


