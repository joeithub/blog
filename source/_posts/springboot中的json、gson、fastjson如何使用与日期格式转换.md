title: springboot中的json、gson、fastjson如何使用与日期格式转换
author: Joe Tong
tags:
  - JAVAEE
  - JSONUTILS
categories:
  - IT
date: 2019-09-19 18:34:00
---
关于如何引用json、gson、fastjson
srpngboot中默认用的是json格式，如果需要使用gson和fastjson其中一种格式的话，首先需要在pom文件中排除对json格式的依赖，再去引入你想要gson或者fastjson当中的一种。
代码如下：
下面这种是引入fastjson

```
&lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;
            &lt;!--排除对json格式的依赖--&gt;
            &lt;exclusions&gt;
                &lt;exclusion&gt;
                    &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
                    &lt;artifactId&gt;spring-boot-starter-json&lt;/artifactId&gt;
                &lt;/exclusion&gt;
            &lt;/exclusions&gt;
        &lt;/dependency&gt;
        &lt;!--引入gson格式的依赖--&gt;
        &lt;!-- &lt;dependency&gt;
                    &lt;groupId&gt;com.google.code.gson&lt;/groupId&gt;
                    &lt;artifactId&gt;gson&lt;/artifactId&gt;
             &lt;/dependency&gt;--&gt;
        &lt;!--引入fastjson格式的依赖--&gt;     
        &lt;dependency&gt;
            &lt;groupId&gt;com.alibaba&lt;/groupId&gt;
            &lt;artifactId&gt;fastjson&lt;/artifactId&gt;
            &lt;version&gt;1.2.49&lt;/version&gt;
        &lt;/dependency&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-test&lt;/artifactId&gt;
            &lt;scope&gt;test&lt;/scope&gt;
        &lt;/dependency&gt;
&lt;/dependency&gt; 

```

json格式日期转换
默认不处理传给前台的json格式形式如下：
![upload successful](/images/pasted-154.png)

第一种通过在实体类需要转换的日期属性上加上@JsonFormat(pattern = “yyyy-MM-dd”)。缺点就是如果有多个实体类都有日期属性都需要日期转换，那么都需要加。
第二种就是自定义一个WebMvcConfig类，类中加上自定义的bean。那么整个项目的json格式日期都会按照这个格式来转换。
如果就是有多个类中都有日期需要转换，但是已经在全局配置中定义转换格式，但是某个类中日期转换又不想用全局的日期转换格式，此时可以在这个类上加上@JsonFormat(pattern = “yyyy-MM-dd”)指明需要格式即可。
转换后如下：


![upload successful](/images/pasted-155.png)

```
@Configuration
public class WebMvcConfig {
    @Bean
    MappingJackson2HttpMessageConverter mappingJackson2HttpMessageConverter() {
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        ObjectMapper om = new ObjectMapper();
        om.setDateFormat(new SimpleDateFormat("yyyy/MM/dd"));
        converter.setObjectMapper(om);
        return converter;
    }
    }
```
gson下：需要排除json依赖，引入gson依赖
```
@Configuration
public class WebMvcConfig {
   @Bean
    GsonHttpMessageConverter gsonHttpMessageConverter() {
        GsonHttpMessageConverter converter = new GsonHttpMessageConverter();
        converter.setGson(new GsonBuilder().setDateFormat("yyyy/MM/dd").create());
        return converter;
    }
    @Bean
    Gson gson() {
        return new GsonBuilder().setDateFormat("yyyy/MM/dd").create();
    }
}    
```

fastjson下：需要排除json依赖，引入fastjson下

```
@Configuration
public class WebMvcConfig {
 @Bean
    FastJsonHttpMessageConverter fastJsonHttpMessageConverter() {
        FastJsonHttpMessageConverter converter = new FastJsonHttpMessageConverter();
        FastJsonConfig config = new FastJsonConfig();
        config.setDateFormat("yyyy-MM-dd");
        converter.setFastJsonConfig(config);
        return converter;
    }
}    
```

