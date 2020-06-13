title: beanutils
author: Joe Tong
tags:
  - JAVAEE
  - BEANUTILS
categories:
  - IT
date: 2019-09-12 10:46:00
---
BeanUtil工具类的使用
BeanUtils的使用

1.commons-beanutils的介绍

commons-beanutils是Apache组织下的一个基础的开源库，它提供了对Java反射和内省的API的包装，依赖内省，其主要目的是利用反射机制对JavaBean的属性进行处理。我们知道一个JavaBean通常包含了大量的属性，很多情况下，对JavaBean的处理导致了大量的get/set代码堆积，增加了代码长度和阅读代码的难度，现在有了BeanUtils，我们对JavaBean属性的处理就方便很多。

2.BeanUtils的使用

BeanUtils是commons-beanutils包下的一个工具类，如果想在我们的项目中使用这个类需要导入以下两个jar包：

l commons-beanutils.jar

l commons-logging.jar

下面我们就来练习如何使用BeanUtils，案例详情请参考BeanUtils使用案例详解，点击此处下载案例源代码，具体如下：

(1)创建一个web应用，Example5，将上面说到的两个jar包拷贝的WEB-INF/lib下；

(2)在该应用下的src目录下新建一个Class类，名称为Person，主要代码如例1-1所示：

例1-1 Person.java

```
public class Person {

  private Stringname;

  private int age;

  private Stringgender;

  private boolean bool;

    此处省略以上四个属性的get/set方法

@Override

  public String toString() {

  return "Person [name=" + name + ", age=" + age + ", gender=" + gender

      + "]";

  }

}
```
例1-1中，定义了四个成员变量，并重写了toString()方法。

(3)在src目录下新建一个Class类，名称为Demo，在该类中定义了一个单元测试方法，主要代码如例1-2所示：

例1-2 Demo.java

```
public class Demo {

  @Test

  public void fun1() throws Exception{

    String className="cn.itcast.domain.Person";

    Class clazz=Class.forName(className);

    Object bean=clazz.newInstance();

    BeanUtils.setProperty(bean, "name", "张三");

  BeanUtils.setProperty(bean, "age", "23");

  BeanUtils.setProperty(bean, "gender", "男");

  BeanUtils.setProperty(bean, "xxx", "XXX");

  System.out.println(bean);

  }

}
```

例1-2中，利用反射获得Person类的对象，然后使用BeanUtils类的静态方法setProperty(Object bean,String name,Object value)为指定bean的指定属性赋值。该方法的第一参数是javaBean对象，第二个参数是javaBean的属性，第三个参数是属性的值。

(4)运行Demo类的单元测试方法fun1()，控制台打印结果如图1-1所示：

图1-1 控制台打印结果

图1-1中，Person信息的打印格式是我们再Person类的toString()方法中设置的。

(5)使用BeanUtils的getProperty(Object bean,String name)方法获取指定bean的指定属性值，如例1-3所示：

```
public class Demo {

  @Test

  public void fun1() throws Exception{

    String className="cn.itcast.domain.Person";

    Class clazz=Class.forName(className);

    Object bean=clazz.newInstance();

    BeanUtils.setProperty(bean, "name", "张三");

  BeanUtils.setProperty(bean, "age", "23");

  BeanUtils.setProperty(bean, "gender", "男");

  BeanUtils.setProperty(bean, "xxx", "XXX");

  System.out.println(bean);

String age = BeanUtils.getProperty(bean, "age");

  System.out.println(age);

  }

}
```

(6)测试fun1方法，控制台打印结果如图1-2所示：

图1-2 控制台打印结果

以上是通过BeanUtils类的setProperty()和getProperty()方法对javaBean属性的设置和获取；开发中可能会有这样的需求：将表单提交过来的请求参数封装在一个javaBean中，这个时候我们再使用BeanUtils的setProperty()和getProperty()方法就会很麻烦；因此BeanUtils又为我们提供了一个静态方法populate(Object bean,Map properties)，其中第二个参数就是封装请求参数的Map，我们可以通过request.getParameterMap()方法获取一个封装了所有请求参数的Map对象。

下面通过一个例子来了解BeanUtils类的populate(Object bean,Map properties)方法，如下所示：

(7)在Example5中创建一个javaBean类，User，主要代码如例1-4所示：

例1-4 User.java

```
public class User {

  private Stringusername;

  private String password;

    此处省略User类的成员变量的get/set方法

@Override

  public String toString() {

  return "User [username=" + username + ", password=" + password + "]";

  }

}
```
(8)在Demo类中再定义一个单元测试方法fun2，主要代码如例1-5所示：

例1-5 fun2()方法
```
@Test

public void fun2() throws Exception {

  Map&lt;String,String&gt; map = new  HashMap&lt;String,String&gt;();

  map.put("username", "zhangSan");

  map.put("password", "123");

  User user = new User();

  BeanUtils.populate(user, map);

  System.out.println(user);

}
```
例1-5中，将map里面的数据封装到javaBean中，这里有一个要求：Map中的key值要与JavaBean中的属性名称保持一致，否则封装不进去。

(9)测试fun2方法，控制台打印结果如图1-3所示：

图1-3 控制台打印结果

现在我们再对BeanUtils进行封装，封装成一个工具类，我们之前也封装过类似的一个工具类，该工具类中提供了一个方法用来获取不重复的32位长度的大写字符串，如下所示：

(10)在Example5中创建一个工具类，名称为CommonUtils，在该类中定义一个方法，用来将map中的数据封装到javaBean中，主要代码如例1-6所示：

例1-6 CommonUtils.java

```
public class CommonUtils {

  /**

  * 生成不重复的32位长的大写字符串

  * @return

  */

  public static String uuid() {

  return UUID.randomUUID().toString().replace("-","").toUpperCase();

  }

  /**

  * 把map转换成指定类型的javaBean对象

  * @param map

  * @param clazz

  * @return

  */

  public static &lt;T&gt; T toBean(Map map, Class&lt;T&gt; clazz) {

  try {

    /*

      * 1. 创建指定类型的javabean对象

      */

    T bean = clazz.newInstance();

    /*

      * 2. 把数据封装到javabean中

      */

    BeanUtils.populate(bean, map);

    /*

      * 返回javabean对象

      */

    return bean;

  } catch(Exception e) {

    throw new RuntimeException(e);

  }

  }

}
```
例1-6中，CommonUtils定义了一个静态的泛型方法：toBean(Map map,Class&lt;T&gt; clazz)，根据传递的参数来判断将map中的数据封装到哪个javaBean中。当中来利用了反射获得指定类型的javaBean对象，然后再调用BeanUtils类的populate()方法。

(11)在Demo类中再定义一个单元测试方法fun3，主要代码如例1-7所示：

例1-7 fun3()方法

```
@Test

public void fun3() {

  Map&lt;String,String&gt; map = new  HashMap&lt;String,String&gt;();

  map.put("username", "lisi");

  map.put("password", "123");

  /*

    * request.getParameterMap();

    */

  User user = CommonUtils.toBean(map, User.class);

  System.out.println(user);

}
```

例1-7中，将map中的数据使用CommonUtils类的toBean()方法封装到user中，然后返回一个user对象。

(12)运行fun3()方法，控制台打印结果如图1-4所示：

图1-4 控制台打印结果

需要注意的是，在使用BeanUtils类的setProperty()、getProperty()和populate()方法时都抛出了异常，我们制作的帮助类需要对异常进行处理，这样在调用这个帮助类的这个方法时就不用再对异常进行处理。另外，在调用BeanUtils的setProperty()方法时，如果设置的属性不存在或者没有给javaBean的某个属性赋值，该方法不会抛出异常。


