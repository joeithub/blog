title: Gson
author: Joe Tong
tags:
  - JAVAEE
categories:  
  - IT
date: 2020-01-09 20:26:16
---


Gson处理json数据，转换javaBean的时候，替换输出字段名，解析日期的坑

有的时候，我们输出的json数据可能跟原始javabean不一样。为了说明这个问题，举例如下：

```
package com.zhdw.mgrclient.test;

import java.util.Date;

public class Person {
    private String name;
    private int age;
    private Date birthday;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }
}
```
javabean对象，比较简单，以下是测试类：

```
package com.zhdw.mgrclient.test;

import java.util.Date;

import com.google.gson.Gson;

public class JSONTest {

    public static void main(String[] args) {
        Person hbk = new Person();
        hbk.setAge(30);
        hbk.setName("黄宝康");
        hbk.setBirthday(new Date());
        Gson gson = new Gson();
        String result = gson.toJson(hbk);
        System.out.println(result);
    }
}
```

运行输出
> {"name":"黄宝康","age":30,"birthday":"May 21, 2018 11:50:23 AM"}

需求，我需要输出NAME，而不是小写的name，第二，日期格式不是我想要的。

Gson针对这两个问题，提供了相关注解，只需要在Person的name字段加入相关注解即可。

```
@SerializedName("NAME")
    private String name;
```

再次运行输出如下：可以看出name已经输出成NAME了，第一个问题解决。
> {"NAME":"黄宝康","age":30,"birthday":"May 21, 2018 11:53:25 AM"}

针对第二个问题，查看了相关博客，在不同环境中由于返回的Local字符串不同，在不同环境日期格式输出会不一样。

Gson默认处理Date对象的序列化/反序列化是通过一个SimpleDateFormat对象来实现的，通过下面的代码去获取实例：
> DateFormat.getDateTimeInstance() 

在不同的locale环境中，这样获取到的SimpleDateFormat的模式字符串会不一样。

> Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();


使用GsonBuilder()构建Gson对象，而不是之前的new Gson(); 
这样运行输出了我们想要的格式。

> {"NAME":"黄宝康","age":30,"birthday":"2018-05-21 11:57:16"}

其他设置：

如打印美化的json格式数据等
```
GsonBuilder builder = new GsonBuilder();
builder.setPrettyPrinting();
Gson gson = builder.create();
```

通过上面的设置，控制台输出的json格式是带有缩进的。

上面为了解决大小写需求是通过注解的方式解决的，其实Gson还可以通过如下方式解决。（先去掉注解@SerializedName(“NAME”)）


```
public static void main(String[] args) {
        Person hbk = new Person();
        hbk.setAge(30);
        hbk.setName("黄宝康");
        hbk.setBirthday(new Date());
        GsonBuilder builder = new GsonBuilder();
        builder.setPrettyPrinting();
        // 设置字段名称策略
        builder.setFieldNamingStrategy(new FieldNamingStrategy() {

            @Override
            public String translateName(Field field) {
                // 业务规则可以自定义，实际项目可能会比较复杂
                if(field.getName().equals("name")){
                    return "NAME";
                }
                return field.getName();
            }
        });
        Gson gson = builder.setDateFormat("yyyy-MM-dd HH:mm:ss").create();
        String result = gson.toJson(hbk);
        System.out.println(result);
    }
```
默认Gson输出json，会把javabean的所有字段都输出，有的时候，业务上需要隐藏敏感字段。 
适应，给Person增加ignore属性，同时生成getter和setter方法。
```
private String ignore;
public String getIgnore() {
    return ignore;
}

public void setIgnore(String ignore) {
    this.ignore = ignore;
}
```

测试类：
```
public static void main(String[] args) {
        Person hbk = new Person();
        hbk.setAge(30);
        hbk.setName("黄宝康");
        hbk.setBirthday(new Date());
        hbk.setIgnore("不要看见我");
        Gson gson = new Gson();
        System.out.println(gson.toJson(hbk));
    }
```

控制台会输出ignore字段

> {"name":"黄宝康","age":30,"birthday":"May 23, 2018 4:08:04 PM","ignore":"不要看见我"}


为了不看见ignore字段，我们只需要在ignore属性前加上transient修饰符即可。


> private transient String ignore;


再次运行测试类，输出

> {"name":"黄宝康","age":30,"birthday":"May 23, 2018 4:12:41 PM"}

