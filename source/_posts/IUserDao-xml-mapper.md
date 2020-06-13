title: IUserDao.xml(mapper)
author: Joe Tong
tags:
  - JAVAEE
  - MYBATIS
categories:
  - IT
date: 2019-07-10 05:39:00
---
```
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd"&gt;
&lt;mapper namespace="com.enlink.dao.IUserDao"&gt;
 &nbsp; &nbsp;&lt;!--配置查询所有--&gt;  &lt;!--返回类型封装到哪里--&gt;
    &lt;select id="findAll" resultType="com.enlink.domain.User"&gt;
        select * from user
    &lt;/select&gt;
&lt;/mapper&gt;
```
