title: springboot拦截器配置fastjson配置
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - INTERCEPTOR
  - FASTJSON
categories:
  - IT
date: 2019-09-19 17:11:00
---
为什么要集成fastjson而不是用springmvc内置的? &nbsp;

因为用fastjson 后，返回字符串时会在外面强制添加双引号 &nbsp;
例如:  
如果返回的字符串为 哈哈, 最终返回得到的数据是 "哈哈"
返回的字符串中包含双引号，例如{"name":"ethan"}，则 fastjson处理后，最终返回的结果是 "{\"name\":\"ethan\"}"

**要想得到原始字符串,解决办法:**  
添加配置字符串转换器StringHttpMessageConverter  

我们只需要加一个配置文件：WebMvcConfig.java:

```
package com.chinaedu.back.conf;

import java.util.List;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.alibaba.fastjson.serializer.SerializerFeature;
import com.alibaba.fastjson.support.config.FastJsonConfig;
import com.alibaba.fastjson.support.spring.FastJsonHttpMessageConverter;
import com.chinaedu.back.interceptor.LoginInterceptor;


@Configuration
public class WebMvcConfig extends WebMvcConfigurerAdapter {

    /**
     * 设置拦截器
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        // 多个拦截器组成一个拦截器链
        // addPathPatterns 用于添加拦截规则              excludePathPatterns 用户排除拦截

        // registry.addInterceptor(new LoginInterceptor()).addPathPatterns("/**").excludePathPatterns("/user/**");
 registry.addInterceptor(new LoginInterceptor()).addPathPatterns("/**").excludePathPatterns("/toLogin","/login","/js/**","/css/**","/images/**");
        super.addInterceptors(registry);
    }

    /**
     * 配置fastjson
     */
      @Override
      public void configureMessageConverters(List&lt;HttpMessageConverter&lt;?&gt;&gt; converters) {
        super.configureMessageConverters(converters);
        // 初始化转换器
        FastJsonHttpMessageConverter fastConvert = new FastJsonHttpMessageConverter();
        // 初始化一个转换器配置
        FastJsonConfig fastJsonConfig = new FastJsonConfig();
 &nbsp; &nbsp; &nbsp; &nbsp;fastJsonConfig.setDateFormat("yyyy-MM-dd HH:mm:ss");
&nbsp;fastJsonConfig.setSerializerFeatures(SerializerFeature.PrettyFormat);
        // 将配置设置给转换器并添加到HttpMessageConverter转换器列表中
        fastConvert.setFastJsonConfig(fastJsonConfig);
        converters.add(fastConvert);
      }

}
```

https://blog.csdn.net/weixin_34240520/article/details/91877728
