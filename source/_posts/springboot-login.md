title: springboot login
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - LOGIN
categories:
  - IT
date: 2019-07-16 16:27:00
---
springboot系列（一）：初次使用与登录验证实现

听说过很多springboot如何流行，以及如何简化了我们的应用开发，却没有真正使用过springboot，现在终于要动手了！打算自己动手的这个项目，结果不会是促成某个真正的项目，学习为主，把学习过程分享出来。开篇探索以以下两个方面为主：  
1、从mvc经典框架到springboot  
2、最原始的方式实现登录验证  
一、建一个使用springboot的项目
springboot是建立在的spring生态的基础上的，以前看spring的时候，有两大概念是纠结了很久的，IOC（控制反转）以及AOP（面向切面的编程）。其实控制反转就是依赖注入，spring提供了一个IOC容器来初始化对象，解决对象间依赖管理和对象的使用，如@Bean、@Autowired等可以实现依赖注入，AOP目前理解是在一些日志框架场景中用到。  
平时我们常见的web项目开发，使用的mvc框架、maven管理在springboot依然使用到，springboot最明显的好处是简化了新建一个项目时的各种配置过程，就连tomcat都不用配置了。可以看到我新建一个maven项目大目录结构是这样的


跟着上图目录结构，我们来看看springboot是如何完成一个普通的web项目所需要做的事的
a.web容器：springboot内嵌了Tomcat,我们不需要手动配置tomcat以及以war包形式部署项目，启动入口为目录中App.java中的main函数，直接运行即可。

@SpringBootApplication
public class App {
public static void main(String[] args) {
SpringApplication.run(App.class,args);
}
}


b.依赖管理:spring提供了一系列的starter pom来简化Maven的依赖加载，如一个web项目pom.xm部分配置如下：
```
   &lt;parent&gt;
        &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
        &lt;artifactId&gt;spring-boot-starter-parent&lt;/artifactId&gt;
        &lt;version&gt;1.4.3.RELEASE&lt;/version&gt;
    &lt;/parent&gt;

    &lt;dependencies&gt;
        &lt;!--Spring Boot的核心启动器，包含了自动配置、日志和YAML--&gt;
        &lt;dependency&gt;
               &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
               &lt;artifactId&gt;spring-boot-starter&lt;/artifactId&gt;
        &lt;/dependency&gt;

        &lt;!--支持全栈式Web开发，包括Tomcat和spring-webmvc--&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;
        &lt;/dependency&gt;

    &lt;/dependencies&gt;

```
c.配置管理：目录中src/main/resource/application.properties为配置文件，springboot可以自动读取，或者使用java配置可以看到没有web.xml，没有spring相关的配置文件，整个项目看起来非常的简洁。

#数据库配置
spring.datasource.url=jdbc:mysql://localhost:3306/world?characterEncoding=UTF-8&amp;useUnicode=true
spring.datasource.username=darren
spring.datasource.password=darren123
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.jpa.properties.hibernate.hbm2ddl.auto=update
一个springboot web项目大概就包含这些 


二、原始方式实现登录验证
流程为：登录页面发起请求--&gt;拦截器拦截匹配的url判断session--&gt;后台验证/设置session--&gt;返回
a、这里主要通过自定义拦截器的方式，继承WebMvcConfigurerAdapter和HandlerInterceptorAdapter来实现拦截器对登录请求进行拦截和session的判断，我这里都写在WebSecurityConfig.java中
其中WebMvcConfigurerAdapter是Spring提供的基础类，可以通过重写 addInterceptors 方法添加注册拦截器来组成一个拦截链，以及用于添加拦截规则和排除不用的拦截，如下：
```
public void  addInterceptors(InterceptorRegistry registry){
    InterceptorRegistration addInterceptor = registry.addInterceptor(getSecurityInterceptor());

    addInterceptor.excludePathPatterns("/error");
    addInterceptor.excludePathPatterns("/login**");

    addInterceptor.addPathPatterns("/**");
}
```

其中HandlerInterceptorAdapter是spring mvc提供的适配器，继承此类，可以非常方便的实现自己的拦截器，它有三个方法：preHandle、postHandle、afterCompletion。preHandle在业务处理器处理请求之前被调用。预处理，可以进行编码、安全控制等处理；postHandle在业务处理器处理请求执行完成后，生成视图之前执行。afterCompletion在DispatcherServlet完全处理完请求后被调用，可用于清理资源等。我项目中只重写了preHandle,对请求进行session判断和跳转到自定义的页面，如下：
```
 private class SecurityInterceptor extends HandlerInterceptorAdapter{
        @Override
        public boolean preHandle(HttpServletRequest request, HttpServletResponse response,Object handler) throws IOException {
            HttpSession session = request.getSession();
            
//            判断是否已有该用户登录的session
            if(session.getAttribute(SESSION_KEY) != null){
                return true;
            }

//            跳转到登录页
            String url = "/login";
            response.sendRedirect(url);
            return false;
        }
    }
```
b.controller中对登录请求进行验证以及页面的跳转，如下 

```
@Controller
public class LoginController {

    @Autowired
    private LoginService loginService;

    @GetMapping("/")
    public String index(@SessionAttribute(WebSecurityConfig.SESSION_KEY)String account,Model model){
        
        return "index";
    }

    @GetMapping("/login")
    public String login(){
        return "login";
    }

    @PostMapping("/loginVerify")
    public String loginVerify(String username,String password,HttpSession session){
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);

        boolean verify = loginService.verifyLogin(user);
        if (verify) {
            session.setAttribute(WebSecurityConfig.SESSION_KEY, username);
            return "index";
        } else {
            return "redirect:/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session){
        session.removeAttribute(WebSecurityConfig.SESSION_KEY);
        return "redirect:/login";
    }
  ```
controller代码解释：loginVerify是对登录请求到数据库中进行验证用户名和密码，验证通过以后设置session，否则跳转到登录页面。@GetMapping是一个组合注解，是@RequestMapping(method = RequestMethod.GET)的缩写,@PostMapping同理。 

ps:实际项目登录验证会使用登录验证框架：spring security 、shiro等，以及登录过程密码加密传输保存等，这里仅仅用于了解。

