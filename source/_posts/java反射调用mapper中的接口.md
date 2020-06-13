title: java反射调用mapper中的接口
author: Joe Tong
tags:
  - JAVAEE
  - MYBATIS
  - REFLECTION
categories:
  - IT
date: 2019-09-18 06:44:00
---
Ijava中的反射需要一个实例，但是接口无法提供这样的实例，但是JDK提供了一个叫做动态代理的东西，这个代理恰恰只能代理接口。所以我们想要反射接口需要使用这个动态代理来做。

在java的动态代理机制中，有两个重要的东西，一个是 InvocationHandler(接口)、另一个则是 Proxy(类)，这是我们动态代理必须用到的两个东西。

首先创建一个接口（以studentMapper为例，其中提供了一个根据ID获取student对象的方法）：

```
public interface StudentMapper{
        /**
        * 根据id查对象
        */
        Student selectById(@Param("id") Integer id);
        }
```
现在如果我们需要反射使用该接口根据学生ID获取学生对象是无法直接反射调取的，所以我们需要一个动态代理类，下面创建一个MyInvocationHandler，需要实现上面说的InvocationHandler接口：

```
public class MyInvocationHandler implements InvocationHandler {
 
    private Object target;
 
    public MyInvocationHandler(Object target) {
        this.target = target;
    }
 
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        return method.invoke(target,args);
    }
}
```

其中该类设置了一个target属性，该属性即为需要代理的接口对象，也就是studentMapper，还提供了一个需要一个参数的构造函数。

自此，我们的代理工作基本做完，现在需要调用一下这个代理类

```
try{
            Class interfaceImpl = Class.forName("StudentMapper");//这里要写全类名
            Object instance = Proxy.newProxyInstance(
                           interfaceImpl.getClassLoader(), 
                           new Class[]{interfaceImpl}, 
                           new MyInvocationHandler(sqlSession.getMapper(interfaceImpl))
                           );
 
            Method method = instance.getClass().getMethod("selectById", Integer.class);
            
            method.invoke(instance,2);
        }catch(Exception e){
            e.printStackTrace();}

}
```
这里需要注意，newProxyInstance()方法中最后一个参数，即为我们创建的动态代理的类（因为我这里调用的接口为mybatis中mapper中的接口，所以需要从sqlSession中getMapper）.

最后得到该Mapper的接口之后反射调用selectById方法即可。


