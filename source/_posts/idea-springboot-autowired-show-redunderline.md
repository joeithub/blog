title: idea springboot autowired hide red underline
author: Joe Tong
tags:
  - JAVAEE
  - IDEA
  - MYBATIS
categories:
  - IT
date: 2019-07-16 02:30:00
---
SpringBoot：Dao层mapper注入报红问题

在mapper接口上加上

@Component注解
例如:
```
import com.example.sptingboot_mybatis.model.User;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Component;

import java.util.List;

@Mapper
@Component("IUser")
public interface IUser {
   List&lt;User&gt; findAll();
}
``` 

就可以解决问题



原文链接：https://blog.csdn.net/Sir_He/article/details/81879854 
