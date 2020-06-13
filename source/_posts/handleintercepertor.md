title: HandlerInterceptor
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
categories:
  - IT
date: 2019-07-15 11:33:00
---
Spring Boot使用处理器拦截器HandlerInterceptor

首先我们说说什么是处理器拦截器，SpringWebMVC的处理器拦截器，类似于Servlet开发中的过滤器Filter，用于处理器进行预处理和后处理。

|使用场景|  
|:-|
|1、日志记录：记录请求信息的日志，以便进行信息监控、信息统计、计算PV（Page View）等.|  
|2、权限检查：如登录检测，进入处理器检测检测是否登录，如果没有直接返回到登录页面；|
|3、性能监控：有时候系统在某段时间莫名其妙的慢，可以通过拦截器在进入处理器之前记录开始时间，在处理完后记录结束时间，从而得到该请求的处理时间（如果有反向代理，如apache可以自动记录）；|
|4、通用行为：读取cookie得到用户信息并将用户对象放入请求，从而方便后续流程使用，还有如提取Locale、Theme信息等，只要是多个处理器都需要的即可使用拦截器实现。|
|5、OpenSessionInView：如Hibernate，在进入处理器打开Session，在完成后关闭Session。…………本质也是AOP（面向切面编程），也就是说符合横切关注点的所有功能都可以放入拦截器实现。|

实现方式  
* 1、引入spring-boot-starter-web
在pom.xml 中引入spring-boot-starter-web包。
```
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;
        &lt;/dependency&gt;
```
* 2、建立拦截器
preHandle ：在DispatcherServlet之前执行。
postHandle：在controller执行之后的DispatcherServlet之后执行。
afterCompletion：在页面渲染完成返回给客户端之前执行。
```
public class PiceaInterceptor implements HandlerInterceptor {
    /**
     *在DispatcherServlet之前执行
     * @param request
     * @param response
     * @param handler
     * @return
     * @throws Exception
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("我是在DispatcherServlet之前执行的方法");
        return true;
    }

    /**
     * 在controller执行之后的DispatcherServlet之后执行
     * @param request
     * @param response
     * @param handler
     * @param modelAndView
     * @throws Exception
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("在controller执行之后的DispatcherServlet之后执行");
    }

    /**
     * 在页面渲染完成返回给客户端之前执行
     * @param request
     * @param response
     * @param handler
     * @param ex
     * @throws Exception
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("在页面渲染完成返回给客户端之前执行");
    }
}
```
* 3、建立WebAppConfigurer类
这个类的主要作用是注册上我们配置的拦截器。
```
@Configuration
public class PiceaWebAppConfigurer implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authenticationInterceptor())//增加过滤的方法类
                .addPathPatterns("/**");//定义过滤的范围
    }

    @Bean
    public PiceaInterceptor authenticationInterceptor() {
        return new PiceaInterceptor();
    }
}
```
* 4、建立Contoller类
这个类比较简单，不做特别说明
```
@RestController
public class PiceaContoller {

    @RequestMapping("/query")
    public void asyncTask() throws Exception {
        System.out.println("我是控制类里面的方法，我正在思考...............");
    }
}
```
* 5、测试结果  
在浏览中输入：http://localhost:2001/query
这个时候控制台的输入为如下图片。


Spring-boot-fi-interceptor.png
