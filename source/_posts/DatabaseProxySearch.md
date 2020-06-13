title: DatabaseProxySearch
author: Joe Tong
tags:
  - JAVAEE
  - MYBATIS
categories:
  - IT
date: 2019-07-10 21:38:00
---
###### mybatis学习心得 &nbsp;
1.What do I have? &nbsp;
我有什么 

2.SqlMapCofing.xml  
(1)从配置文件中的property中我们能知道数据库连接信息，有了这些信息就可以创建&lt;font color="red"&gt;Connection对象&lt;/font&gt; &nbsp;
(2)mappers &nbsp;
有了mapper就有了映射配置信息,就能读到下面IUserDao.xml文件

3.IUserDao.xml &nbsp;
有了namespace的全限定类名   &nbsp;
和   
有了id的方法名   &nbsp;
能唯一确定执行哪条sql    
有了sql语句就可以获取PreparedStatement  
有了resultType就可以知道结果封装到哪里

读取配置文件：用到的技术就是解析XML的技术
我们此处用到的技术是dom4j解析xml技术

接下来  
1.根据配置文件的信息创建Connection对象  
注册驱动，获取链接  
2.获取预处理对象PreparedStatement  
此时需要sql语句 &nbsp;
conn.preparedStatement(sql);得到PreparedStatement  
**sql就从配置文件中来**  
3.执行查询  
preparedStatement.execute();得到ResultSet  
4.遍历结果集用于封装  
List&lt;E&gt; list = new ArrayList();  
while（resultSet.next()）{  
    E element = xxx; &nbsp;
    xxx怎么得到？这里用到的技术是反射 &nbsp;
    是根据全限定类名resultType通过反射得到的  
    实例化一个对象出来  
    即:  
    E element = （E）Class.forName(配置的全限定类名).newInstance(); &nbsp;
    这里需要强转一下，因为得到的是一个obj对象 &nbsp;
    进行封装，把每个xx的内容都添加到element中  
    我们的实体类属性和表中的列名是一致的，  
    于是我们就可以把表的列名看成是实体类的属性名称  
    就可以使用反射的方式根据名称获取每个属性，并把值赋进去。  
    把element加到list中  
    list.add(element);  
};  
  
5.返回list    
 &nbsp;return list;
 &nbsp;
**注意配置文件位置使用绝对路径或相对路径都不好**  
文件位置只能使用两种方式
第一个：使用类加载器，它只能读取类路径的配置文件Resources.getResourceAsStream(配置文件)得到输入流InputStream
第二个：使用servletContext对象的getRealPath()获取部署在环境里的真实路径
&lt;font color="gree"&gt;创建工厂&lt;/font&gt;mybatis使用了&lt;font color="blue"&gt;**构建者模式**&lt;/font&gt;&lt;u&gt;SqlSessionFactoryBuilder&lt;/u&gt;  
把输入流给构建者builder会给我们建好工厂sqlsessionfactory &nbsp;
工厂给我们产生SqlSession这里使用的是工厂模式降低类之间的依赖关系即解藕 &nbsp;
通过sqlsession代理模式getMapper创建Dao接口实现类   
getMapper 都做了什么？  
类加载器它使用的和被代理的对象是相同的类加载器  
代理对象要实现的接口：和被代理对象实现相同的接口 &nbsp;
如何代理：它就是增强的方法，我们需要自己来提供  
此处是一个InvocationHandler的接口，我们需要些一个该接口的实现类在实现类中调用selectList方法
Proxy.newProxyInstance(类加载器，代理对象要实现的接口字节码数组，如何代理)
