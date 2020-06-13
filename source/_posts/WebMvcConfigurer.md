title: WebMvcConfigurer
author: Joe Tong
tags:
  - JAVAEE
  - SPRING
categories:
  - IT
date: 2019-08-29 15:58:00
---
WebMvcConfigurer配置类其实是Spring内部的一种配置方式，采用JavaBean的形式来代替传统的xml配置文件形式进行针对框架个性化定制。基于java-based方式的spring mvc配置，需要创建一个配置类并实现WebMvcConfigurer&nbsp;接口，WebMvcConfigurerAdapter&nbsp;抽象类是对WebMvcConfigurer接口的简单抽象（增加了一些默认实现），但在在SpringBoot2.0及Spring5.0中WebMvcConfigurerAdapter已被废弃 。官方推荐直接实现WebMvcConfigurer或者直接继承WebMvcConfigurationSupport，方式一实现WebMvcConfigurer接口（推荐），方式二继承WebMvcConfigurationSupport类，具体实现可看这篇文章。https://blog.csdn.net/fmwind/article/details/82832758

```
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//
 
package org.springframework.web.servlet.config.annotation;
 
import java.util.List;
import org.springframework.format.FormatterRegistry;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.validation.MessageCodesResolver;
import org.springframework.validation.Validator;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.HandlerMethodReturnValueHandler;
import org.springframework.web.servlet.HandlerExceptionResolver;
 
public interface WebMvcConfigurer {
    void configurePathMatch(PathMatchConfigurer var1);
 
    void configureContentNegotiation(ContentNegotiationConfigurer var1);
 
    void configureAsyncSupport(AsyncSupportConfigurer var1);
 
    void configureDefaultServletHandling(DefaultServletHandlerConfigurer var1);
 
    void addFormatters(FormatterRegistry var1);
 
    void addInterceptors(InterceptorRegistry var1);
 
    void addResourceHandlers(ResourceHandlerRegistry var1);
 
    void addCorsMappings(CorsRegistry var1);
 
    void addViewControllers(ViewControllerRegistry var1);
 
    void configureViewResolvers(ViewResolverRegistry var1);
 
    void addArgumentResolvers(List&lt;HandlerMethodArgumentResolver&gt; var1);
 
    void addReturnValueHandlers(List&lt;HandlerMethodReturnValueHandler&gt; var1);
 
    void configureMessageConverters(List&lt;HttpMessageConverter&lt;?&gt;&gt; var1);
 
    void extendMessageConverters(List&lt;HttpMessageConverter&lt;?&gt;&gt; var1);
 
    void configureHandlerExceptionResolvers(List&lt;HandlerExceptionResolver&gt; var1);
 
    void extendHandlerExceptionResolvers(List&lt;HandlerExceptionResolver&gt; var1);
 
    Validator getValidator();
 
    MessageCodesResolver getMessageCodesResolver();
}
```

接下来我们着重找几个方法讲解一下：

```
 /* 拦截器配置 */
void addInterceptors(InterceptorRegistry var1);
/* 视图跳转控制器 */
void addViewControllers(ViewControllerRegistry registry);
/**
     *静态资源处理
**/
void addResourceHandlers(ResourceHandlerRegistry registry);
/* 默认静态资源处理器 */
void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer);
/**
     * 这里配置视图解析器
 **/
void configureViewResolvers(ViewResolverRegistry registry);
/* 配置内容裁决的一些选项*/
void configureContentNegotiation(ContentNegotiationConfigurer configurer);
```

1、addInterceptors(InterceptorRegistry registry)
此方法用来专门注册一个Interceptor，如HandlerInterceptorAdapter

```

@Configuration
public class MyWebMvcConfigurer implements WebMvcConfigurer { 
@Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new MyInterceptor()).addPathPatterns("/**").excludePathPatterns("/emp/toLogin","/emp/login","/js/**","/css/**","/images/**");
    }
}
```

addPathPatterns("/**")对所有请求都拦截，但是排除了/toLogin和/login请求的拦截。

当spring boot版本升级为2.x时，访问静态资源就会被HandlerInterceptor拦截,网上有很多处理办法都是如下写法

.excludePathPatterns("/index.html","/","/user/login","/static/**");
可惜本人在使用时一直不起作用，查看请求的路径里并没有/static/如图：


![upload successful](/images/pasted-103.png)

于是我改成了"/js/**","/css/**","/images/**"这样页面内容就可以正常访问了，我的项目结构如下：


![upload successful](/images/pasted-104.png)

2. 页面跳转addViewControllers
以前写SpringMVC的时候，如果需要访问一个页面，必须要写Controller类，然后再写一个方法跳转到页面，感觉好麻烦，其实重写WebMvcConfigurer中的addViewControllers方法即可达到效果了

```
/**
     * 以前要访问一个页面需要先创建个Controller控制类，再写方法跳转到页面
     * 在这里配置后就不需要那么麻烦了，直接访问http://localhost:8080/toLogin就跳转到login.jsp页面了
     * @param registry
     */
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/toLogin").setViewName("login");
        }
        
```

值的指出的是，在这里重写addViewControllers方法，并不会覆盖WebMvcAutoConfiguration中的addViewControllers（在此方法中，Spring Boot将“/”映射至index.html），这也就意味着我们自己的配置和Spring Boot的自动配置同时有效，这也是我们推荐添加自己的MVC配置的方式。

3. 自定义资源映射addResourceHandlers
比如，我们想自定义静态资源映射目录的话，只需重写addResourceHandlers方法即可。

注：如果继承WebMvcConfigurationSupport类实现配置时必须要重写该方法，具体见其它文章

```
@Configuration
public class MyWebMvcConfigurerAdapter implements WebMvcConfigurer {
    /**
     * 配置静态访问资源
     * @param registry
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/my/**").addResourceLocations("classpath:/my/");
       
    }
   }

```

通过addResourceHandler添加映射路径，然后通过addResourceLocations来指定路径。我们访问自定义my文件夹中的elephant.jpg 图片的地址为 http://localhost:8080/my/elephant.jpg

如果你想指定外部的目录也很简单，直接addResourceLocations指定即可，代码如下：

```
@Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/my/**").addResourceLocations("file:E:/my/");
}
```


addResourceLocations指的是文件放置的目录，addResoureHandler指的是对外暴露的访问路径

4. configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer)
　　用法：
  

```
 @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
        configurer.enable("defaultServletName");
```


此时会注册一个默认的Handler：DefaultServletHttpRequestHandler，这个Handler也是用来处理静态文件的，它会尝试映射/。当DispatcherServelt映射/时（/ 和/ 是有区别的），并且没有找到合适的Handler来处理请求时，就会交给DefaultServletHttpRequestHandler 来处理。注意：这里的静态资源是放置在web根目录下，而非WEB-INF 下。
　　可能这里的描述有点不好懂（我自己也这么觉得），所以简单举个例子，例如：在webroot目录下有一个图片：1.png 我们知道Servelt规范中web根目录（webroot）下的文件可以直接访问的，但是由于DispatcherServlet配置了映射路径是：/ ，它几乎把所有的请求都拦截了，从而导致1.png 访问不到，这时注册一个DefaultServletHttpRequestHandler 就可以解决这个问题。其实可以理解为DispatcherServlet破坏了Servlet的一个特性（根目录下的文件可以直接访问），DefaultServletHttpRequestHandler是帮助回归这个特性的。

5、configureViewResolvers(ViewResolverRegistry registry)
　　从方法名称我们就能看出这个方法是用来配置视图解析器的，该方法的参数ViewResolverRegistry 是一个注册器，用来注册你想自定义的视图解析器等。ViewResolverRegistry 常用的几个方法：

&nbsp;&nbsp;&nbsp;１)．enableContentNegotiation()
      
      
```
 /** 启用内容裁决视图解析器*/
public void enableContentNegotiation(View... defaultViews) {
    initContentNegotiatingViewResolver(defaultViews);
    }
```

该方法会创建一个内容裁决解析器ContentNegotiatingViewResolver ，该解析器不进行具体视图的解析，而是管理你注册的所有视图解析器，所有的视图会先经过它进行解析，然后由它来决定具体使用哪个解析器进行解析。具体的映射规则是根据请求的media types来决定的。  
2). 　UrlBasedViewResolverRegistration()

```
         public UrlBasedViewResolverRegistration jsp(String prefix, String suffix) {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix(prefix);
        resolver.setSuffix(suffix);
        this.viewResolvers.add(resolver);
        return new UrlBasedViewResolverRegistration(resolver);
```

该方法会注册一个内部资源视图解析器InternalResourceViewResolver 显然访问的所有jsp都是它进行解析的。该方法参数用来指定路径的前缀和文件后缀，如：　　

`registry.jsp("/WEB-INF/jsp/", ".jsp");`

对于以上配置，假如返回的视图名称是example，它会返回/WEB-INF/jsp/example.jsp给前端，找不到则报404。　　

3). 　beanName()

```
public void beanName() {
        BeanNameViewResolver resolver = new BeanNameViewResolver();
        this.viewResolvers.add(resolver);
```

该方法会注册一个BeanNameViewResolver 视图解析器，这个解析器是干嘛的呢？它主要是将视图名称解析成对应的bean。什么意思呢？假如返回的视图名称是example，它会到spring容器中找有没有一个叫example的bean，并且这个bean是View.class类型的？如果有，返回这个bean。　　

4). 　viewResolver()

```
 public void viewResolver(ViewResolver viewResolver) {
        if (viewResolver instanceof ContentNegotiatingViewResolver) {
            throw new BeanInitializationException(
                    "addViewResolver cannot be used to configure a ContentNegotiatingViewResolver. Please use the method enableContentNegotiation instead.");
        }
        this.viewResolvers.add(viewResolver);
}

```

这个方法想必看名字就知道了，它就是用来注册各种各样的视图解析器的，包括自己定义的。

6. configureContentNegotiation(ContentNegotiationConfigurer configurer)
　　上面我们讲了configureViewResolvers 方法，假如在该方法中我们启用了内容裁决解析器，那么configureContentNegotiation(ContentNegotiationConfigurer configurer) 这个方法是专门用来配置内容裁决的一些参数的。这个比较简单，我们直接通过一个例子看：

```
public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
       /* 是否通过请求Url的扩展名来决定media type */
        configurer.favorPathExtension(true)  
                 /* 不检查Accept请求头 */
                .ignoreAcceptHeader(true)
                .parameterName("mediaType")
                 /* 设置默认的media yype */
                .defaultContentType(MediaType.TEXT_HTML)
                 /* 请求以.html结尾的会被当成MediaType.TEXT_HTML*/
                .mediaType("html", MediaType.TEXT_HTML)
                /* 请求以.json结尾的会被当成MediaType.APPLICATION_JSON*/
                .mediaType("json", MediaType.APPLICATION_JSON);
}
```

到这里我们就可以举个例子来进一步熟悉下我们上面讲的知识了，假如我们MVC的配置如下：

```
@EnableWebMvc
    @Configuration
    public class MyWebMvcConfigurerAdapte extends WebMvcConfigurerAdapter {
 
        @Override
        public void configureViewResolvers(ViewResolverRegistry registry) {
            registry.jsp("/WEB-INF/jsp/", ".jsp");
            registry.enableContentNegotiation(new MappingJackson2JsonView());
        }
 
        @Override
        public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
            configurer.favorPathExtension(true)
                    .ignoreAcceptHeader(true)
                    .parameterName("mediaType")
                    .defaultContentType(MediaType.TEXT_HTML)
                    .mediaType("html", MediaType.TEXT_HTML)
                    .mediaType("json", MediaType.APPLICATION_JSON);
        }
}
```

controller的代码如下:

```
@Controller
    public class ExampleController {
         @RequestMapping("/test")
         public ModelAndView test() {
            Map&lt;String, String&gt; map = new HashMap();
            map.put("哈哈", "哈哈哈哈");
            map.put("呵呵", "呵呵呵呵");
            return new ModelAndView("test", map);
        }
```

在WEB-INF/jsp目录下创建一个test.jsp文件，内容随意。现在启动tomcat，在浏览器输入以下链接：http://localhost:8080/test.json，浏览器内容返回如下：

```
{
    "哈哈":"哈哈哈哈",
    "呵呵":"呵呵呵呵"
}
```

在浏览器输入http://localhost:8080/test 或者http://localhost:8080/test.html，内容返回如下：  
this is test.jsp 

显然，两次使用了不同的视图解析器，那么底层到底发生了什么？在配置里我们注册了两个视图解析器：ContentNegotiatingViewResolver 和 InternalResourceViewResolver，还有一个默认视图：MappingJackson2JsonView。controller执行完毕之后返回一个ModelAndView，其中视图的名称为example1。

```
1.返回首先会交给ContentNegotiatingViewResolver 进行视图解析处理，而ContentNegotiatingViewResolver 会先把视图名example1交给它持有的所有ViewResolver尝试进行解析（本实例中只有InternalResourceViewResolver），
2.根据请求的mediaType，再将example1.mediaType（这里是example1.json 和example1.html）作为视图名让所有视图解析器解析一遍，两步解析完毕之后会获得一堆候选的List&lt;View&gt; 再加上默认的MappingJackson2JsonView ，
3.根据请求的media type从候选的List&lt;View&gt; 中选择一个最佳的返回，至此视图解析完毕。
```

现在就可以理解上例中为何请求链接加上.json 和不.json 结果会不一样。当加上.json 时，表示请求的media type 为MediaType.APPLICATION_JSON，而InternalResourceViewResolver 解析出来的视图的ContentType与其不符，而与MappingJackson2JsonView 的ContentType相符，所以选择了MappingJackson2JsonView 作为视图返回。当不加.json 请求时，默认的media type 为MediaType.TEXT_HTML，所以就使用了InternalResourceViewResolver解析出来的视图作为返回值了。我想看到这里你已经大致可以自定义视图了。







