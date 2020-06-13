title: tk.mybatis
author: Joe Tong
tags:
  - JAVAEE
  - TK.MYBATIS
categories:  
  - IT 
date: 2019-10-24 10:08:59
---
```
mapper:
  mappers: cn.enlink.ensbrain.core.basedao.BaseDao
  not-empty: false
  identity: MYSQL
```
UUID：设置生成UUID的方法，需要用OGNL方式配置，不限制返回值，但是必须和字段类型匹配
IDENTITY：取回主键的方式，可以配置的内容看下一篇如何使用中的介绍
ORDER：<seletKey>中的order属性，可选值为BEFORE和AFTER
catalog：数据库的catalog，如果设置该值，查询的时候表名会带catalog设置的前缀
schema：同catalog，catalog优先级高于schema
seqFormat：序列的获取规则,使用{num}格式化参数，默认值为{0}.nextval，针对Oracle，可选参数一共4个，对应0,1,2,3分别为SequenceName，ColumnName, PropertyName，TableName
notEmpty：insert和update中，是否判断字符串类型!=’’，少数方法会用到
style：实体和表转换时的规则，默认驼峰转下划线，可选值为normal用实体名和字段名;camelhump是默认值，驼峰转下划线;uppercase转换为大写;lowercase转换为小写
enableMethodAnnotation：可以控制是否支持方法上的JPA注解，默认false。
