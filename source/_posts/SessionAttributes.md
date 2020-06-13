title: '@SessionAttributes'
author: Joe Tong
tags:
  - JAVAEE
  - ANNOTATION
  - SESSION
  - SPRINGBOOT
categories:
  - IT
date: 2019-09-23 18:44:00
---
#### @SessionAttributes原理  
默认情况下Spring MVC将模型中的数据存储到request域中。&lt;font color="red"&gt;当一个请求结束后，数据就失效了。如果要跨页面使用。那么需要使用到session。而@SessionAttributes注解就可以使得模型中的数据存储一份到session域中。&lt;/font&gt;

@SessionAttributes参数 

1、names：这是一个字符串数组。里面应写需要存储到session中数据的名称。

2、types：根据指定参数的类型，将模型中对应类型的参数存储到session中

3、value：其实和names是一样的。

```
@RequestMapping("/test")
 public String test(Map&lt;String,Object&gt; map){
    map.put("names", Arrays.asList("caoyc","zhh","cjx"));
    map.put("age", 18);
    return "hello";
}
```
```
 1、request中names:${requestScope.names}&lt;br/&gt;
 2、request中age:${requestScope.age}&lt;br/&gt;
 &lt;hr/&gt;
 3、session中names:${sessionScope.names }&lt;br/&gt;
 4、session中age:${sessionScope.age }&lt;br/&gt;
```

![upload successful](/images/pasted-158.png)

【总结】:上面代码没有指定@SessionAttributes，所有在session域总无法获取到对应的数据。

下面我们加上@SessionAttributes注解

```
 @SessionAttributes(value={"names"},types={Integer.class})
  @Controller
  public class Test {
  
      @RequestMapping("/test")
      public String test(Map&lt;String,Object&gt; map){
          map.put("names", Arrays.asList("caoyc","zhh","cjx"));
          map.put("age", 18);
          return "hello";
     }
 }
 ```
 
 再次访问页面：
 
 
![upload successful](/images/pasted-159.png)

可以看到session域中值已存在

【注意】：@SessionAttributes注解只能在类上使用，不能在方法上使用
