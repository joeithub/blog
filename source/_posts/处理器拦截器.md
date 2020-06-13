title: HandlerInterceptor的preHandle、postHandle、afterCompletion方法的作用
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - INTERCEPTOR
categories:
  - IT
date: 2019-09-24 11:12:00
---
#### 处理器拦截器（HandlerInterceptor）详解
(1)preHandle方法是进行处理器拦截用的，顾名思义，该方法将在Controller处理之前进行调用。  
SpringMVC中的Interceptor拦截器是链式的，可以同时存在多个Interceptor，然后SpringMVC会根据声明的前后顺序一个接一个的执行，而且所有的Interceptor中的preHandle方法都会在Controller方法调用之前调用。
**（SpringMVC的这种Interceptor链式结构也是可以进行中断的，这种中断方式是令preHandle的返回值为false，当preHandle的返回值为false的时候整个请求就结束了。）**  
重写preHandle方法，在请求发生前执行。  
(2)postHandle是进行处理器拦截用的，这个方法只会在当前这个Interceptor的preHandle方法返回值为true的时候才会执行。它的执行时间是在处理器进行处理之后，也就是在Controller的方法调用之后执行，但是它会在DispatcherServlet进行视图的渲染之前执行，也就是说在这个方法中你可以对ModelAndView进行操作。这个方法的链式结构跟正常访问的方向是相反的，也就是说先声明的Interceptor拦截器该方法反而会后调用。  
重写postHandle方法，在请求完成后执行。  
(3)afterCompletion这个方法只会在当前这个Interceptor的preHandle方法返回值为true的时候才会执行。该方法将在整个请求完成之后，也就是DispatcherServlet渲染了视图执行。（如性能监控中我们可以在此记录结束时间并输出消耗时间，还可以进行一些资源清理）
