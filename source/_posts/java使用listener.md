title: java使用listener
author: Joe Tong
tags:
  - JAVAEE
  - LISTENER
categories:
  - IT
date: 2019-09-28 11:09:42
---
定义  
用于监听Web应用的内部事件的实现类。可以监听用户session的开始与结束，用户请求的到达等等，当事件发生时，会回调监听器的内部方法
使用Listener步骤  
通过实现具体接口创建实现类（可实现多个监听器接口）  
配置实现类成为监听器，有两种配置方式：  
直接用@WebListener注解修饰实现类  
通过web.xml方式配置，代码如下：  

```
&lt;listener&gt;
    &lt;listener-class&gt;com.zrgk.listener.MyListener&lt;/lisener-class&gt;
&lt;/listener&gt;
```

* 常用Web事件监听器接口
 * ServletContextListener  
   * 1.该接口用于监听Web应用的启动与关闭  
   * 2.该接口的两个方法：    
        * 1.contextInitialized(ServletContextEvent event); //   启动web应用时调用  
        * 2.contextDestroyed(ServletContextEvent event); // 关闭web应用时调用  
   * 3.如何获得application对象：  
ServletContext application = event.getServletContext();
   * 4.示例

```
@WebListener
public class MyServetContextListener implements ServletContextListener{

    //web应用关闭时调用该方法
    @Override
    public void contextDestroyed(ServletContextEvent event) {
        ServletContext application = event.getServletContext();
        String userName = application.getInitParameter("userName"); 
        System.out.println("关闭web应用的用户名字为："+userName);
    }

    //web应用启动时调用该方法
    @Override
    public void contextInitialized(ServletContextEvent event) {
        ServletContext application = event.getServletContext();
        String userName = application.getInitParameter("userName");     
        System.out.println("启动web应用的用户名字为："+userName);
    }

}
```

* ServletContextAttributeListener  
   * 1.该接口用于监听ServletContext范围（application）内属性的改变。  
   * 2.该接口的两个方法：  
     * 1.attributeAdded(ServletContextAttributeEvent event); // 当把一个属性存进application时触发   
     * 2.attributeRemoved(ServletContextAttributeEvent event); // 当把一个属性从application删除时触发     
     * 3.attributeReplaced(ServletContextAttributeEvent event); // 当替换application内的某个属性值时触发  
   * 3.如何获得application对象：  
ServletContext application = event.getServletContext();  
   * 4.示例  

```
@WebListener
public class MyServletContextAttributeListener implements ServletContextAttributeListener{

    //向application范围内添加一个属性时触发
    @Override
    public void attributeAdded(ServletContextAttributeEvent event) {
        String name = event.getName();//向application范围添加的属性名
        Object val = event.getValue();      //向application添加的属性对应的属性值
        System.out.println("向application范围内添加了属性名为："+name+"，属性值为："+val+"的属性");

    }

    //删除属性时触发
    @Override
    public void attributeRemoved(ServletContextAttributeEvent event) {
        // ...      
    }

    //替换属性值时触发
    @Override
    public void attributeReplaced(ServletContextAttributeEvent event) {
        // ...      
    }

}
```


* ServletRequestListener与ServletRequestAttributeListener
  * 1.ServletRequestListener用于监听用户请求，而ServletRequestAttributeListener用于监听request范围内属性的变化。  
  * 2.ServletRequestListener两个需要实现的方法  
    * 1.requestInitialized(ServletRequestEvent event); //用户请求到达、被初始化时触发       
    * 2.requestDestroyed(ServletRequestEvent event); // 用户请求结束、被销毁时触发    
  * 3.ServletRequestAttributeListener两个需要实现的方法  
    * 1.attributeAdded(ServletRequestAttributeEvent event); // 向request范围内添加属性时触发    
    * 2.attributeRemoved(ServletRequestAttributeEvent event); // 从request范围内删除某个属性时触发    
    * 3.attributeReplaced(ServletRequestAttributeEvent event); // 替换request范围内某个属性值时触发    
  * 4.获取reqeust对象  
HttpServletRequest req = (HttpServletRequest)event.getServletRequest();  
  * 5.代码片  
  
```
@WebListener
public class MyRequestListener implements ServletRequestListener,ServletRequestAttributeListener{

    //用户请求结束、被销毁时触发
    @Override
    public void requestDestroyed(ServletRequestEvent event) {
        HttpServletRequest req = (HttpServletRequest) event.getServletRequest();
        String ip = req.getRemoteAddr();
        System.out.println("IP为:"+ip+"的用户发送到"+req.getRequestURI()+"的请求结束");
    }

    //用户请求到达、被初始化时触发
    @Override
    public void requestInitialized(ServletRequestEvent event) {
        HttpServletRequest req = (HttpServletRequest) event.getServletRequest();
        String ip = req.getRemoteAddr();
        System.out.println("IP为:"+ip+"的用户发送到"+req.getRequestURI()+"的请求被初始化");
    }

    //向request范围内添加属性时触发
    @Override
    public void attributeAdded(ServletRequestAttributeEvent event) {
        String name = event.getName();
        Object val = event.getValue();
        System.out.println("向request范围内添加了名为："+name+"，值为："+val+"的属性");
    }

    //删除request范围内某个属性时触发
    @Override
    public void attributeRemoved(ServletRequestAttributeEvent event) {
        //...       
    }

    //替换request范围内某个属性值时触发
    @Override
    public void attributeReplaced(ServletRequestAttributeEvent event) {
        // ...      
    }
}
```

* HttpSessionListener与HttpSessionAttributeListener
  * 1.HttpSessionListener监听用户session的开始与结束，而HttpSessionAttributeListener监听HttpSession范围（session）内的属性的改变。  
  * 2.HttpSessionListener要实现的方法：
    * 1.sessionCreated(HttpSessionEvent event); // 用户与服务器的会话开始、创建时触发
    * 2.sessionDestroyed(HttpSessionEvent event); // 用户与服务器的会话结束时触发
  * 3.HttpSessionAttributeListener要实现的方法：
    * 1.attributeAdded(HttpSessionBindingEvent event) ; // 向session范围内添加属性时触发
    * 2.attributeRemoved(HttpSessionBindingEvent event); // 删除session范围内某个属性时触发
    * 3.attributeReplaced(HttpSessionBindingEvent event); // 替换session范围内某个属性值时触发
  * 3.如何得到session对象
HttpSession session = event.getSession();
  * 4.代码片

```
@WebListener
public class MySessionListener implements HttpSessionListener,HttpSessionAttributeListener {

    //建立session会话时触发
    @Override
    public void sessionCreated(HttpSessionEvent event) {
        HttpSession session = event.getSession();
        String sessionId = session.getId();
        System.out.println("建立了会话，会话ID为："+sessionId);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent event) {
        // ...      
    }

    //向session范围内添加属性时触发
    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        String name = event.getName();
        Object val = event.getValue();
        System.out.println("向session范围内添加了名为："+name+",值为："+val+"的属性");
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        // ...      
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
        // ...      
    }

}
```








