title: ribbon loadbalanced
author: Joe Tong
tags:
  - JAVAEE
  - RIBBON
  - LOADBALANCED
categories:
  - IT
date: 2019-07-17 13:47:00
---
由springcloud ribbon的 @LoadBalanced注解的使用理解  

在使用springcloud ribbon客户端负载均衡的时候，可以给RestTemplate bean 加一个@LoadBalanced注解，就能让这个RestTemplate在请求时拥有客户端负载均衡的能力：
```
 @Bean
    @LoadBalanced
    RestTemplate restTemplate() {
        return new RestTemplate();
    }
```
是不是很神奇?打开@LoadBalanced的注解源码，并没有什么特殊的东东:
```
package org.springframework.cloud.client.loadbalancer;
 
import org.springframework.beans.factory.annotation.Qualifier;
 
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
 
/**
 * Annotation to mark a RestTemplate bean to be configured to use a LoadBalancerClient
 * @author Spencer Gibb
 */
@Target({ ElementType.FIELD, ElementType.PARAMETER, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@Qualifier
public @interface LoadBalanced {
}
```
唯一不同的地方就是多了一个@Qulifier注解.

搜索@LoadBalanced注解的使用地方，发现只有一处使用了,在LoadBalancerAutoConfiguration这个自动装配类中：
```
@LoadBalanced
@Autowired(required = false)
private List&lt;RestTemplate&gt; restTemplates = Collections.emptyList();
@Bean
public SmartInitializingSingleton loadBalancedRestTemplateInitializer(
      final List&lt;RestTemplateCustomizer&gt; customizers) {
   return new SmartInitializingSingleton() {
      @Override
      public void afterSingletonsInstantiated() {
         for (RestTemplate restTemplate : LoadBalancerAutoConfiguration.this.restTemplates) {
            for (RestTemplateCustomizer customizer : customizers) {
               customizer.customize(restTemplate);
            }
         }
      }
   };
}
 
@Autowired(required = false)
private List&lt;LoadBalancerRequestTransformer&gt; transformers = Collections.emptyList();
@Bean
@ConditionalOnMissingBean
public LoadBalancerRequestFactory loadBalancerRequestFactory(
      LoadBalancerClient loadBalancerClient) {
   return new LoadBalancerRequestFactory(loadBalancerClient, transformers);
}
 
@Configuration
@ConditionalOnMissingClass("org.springframework.retry.support.RetryTemplate")
static class LoadBalancerInterceptorConfig {
   @Bean
   public LoadBalancerInterceptor ribbonInterceptor(
         LoadBalancerClient loadBalancerClient,
         LoadBalancerRequestFactory requestFactory) {
      return new LoadBalancerInterceptor(loadBalancerClient, requestFactory);
   }
 
   @Bean
   @ConditionalOnMissingBean
   public RestTemplateCustomizer restTemplateCustomizer(
         final LoadBalancerInterceptor loadBalancerInterceptor) {
      return new RestTemplateCustomizer() {
         @Override
         public void customize(RestTemplate restTemplate) {
            List&lt;ClientHttpRequestInterceptor&gt; list = new ArrayList&lt;&gt;(
                  restTemplate.getInterceptors());
            list.add(loadBalancerInterceptor);
            restTemplate.setInterceptors(list);
         }
      };
   }
}
```
这段自动装配的代码的含义不难理解，就是利用了RestTempllate的拦截器，使用RestTemplateCustomizer对所有标注了@LoadBalanced的RestTemplate Bean添加了一个LoadBalancerInterceptor拦截器，而这个拦截器的作用就是对请求的URI进行转换获取到具体应该请求哪个服务实例ServiceInstance。


那么为什么
```
@LoadBalanced
@Autowired(required = false)
private List&lt;RestTemplate&gt; restTemplates = Collections.emptyList();
```
这个restTemplates能够将所有标注了@LoadBalanced的RestTemplate自动注入进来呢？  
这就要说说@Autowired注解和@Qualifier这两个注解了。
大家日常使用很多都是用@Autowired来注入一个bean,其实@Autowired还可以注入List和Map,比如我定义两个Bean:
```
    @Bean("user1")
    User user1() {
        return new User("1", "a");
    }
 
    @Bean("user2"))
    User user2() {
        return new User("2", "b");
    }
```
然后我写一个Controller:
```
import com.example.demo.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
 
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
 
@RestController
public class MyController {
 
    @Autowired(required = false)
    private List&lt;User&gt; users = Collections.emptyList();
 
    @Autowired(required = false)
    private Map&lt;String,User&gt; userMap = new HashMap&lt;&gt;();
 
    @RequestMapping("/list")
    public Object listUsers() {
        return users;
    }
    @RequestMapping("/map")
    public Object mapUsers() {
        return userMap;
    }
}
```
在controller中通过:
```
    @Autowired(required = false)
    private List&lt;User&gt; users = Collections.emptyList();
 
    @Autowired(required = false)
    private Map&lt;String,User&gt; userMap = new HashMap&lt;&gt;();
```
就可以自动将两个bean注入进来，当注入map的时候，map的key必须是String类型，然后bean name将作为map的key,本例，map中将有两个key分别为user1和user2,value分别为对应的User Bean实例。
访问http://localhost:8080/map:
```
{
    "user1": {
        "id": "1",
        "name": "a"
    },
    "user2": {
        "id": "2",
        "name": "b"
    }
}
```
访问http://localhost:8080/list:
```
[
    {
        "id": "1",
        "name": "a"
    },
    {
        "id": "2",
        "name": "b"
    }
]
```
然后我们给user1和user2分别打上@Qualifier修饰符:
```
 @Bean("user1")
    @Qualifier("valid")
    User user1() {
        return new User("1", "a");
    }
 
    @Bean("user2")
    @Qualifier("invalid")
    User user2() {
        return new User("2", "b");
    }
```
然后将controller中的user list 和user map分别也打上@Qualifier修饰符:
```
import com.example.demo.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
 
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
 
@RestController
public class MyController {
 
    @Autowired(required = false)
    @Qualifier("valid")
    private List&lt;User&gt; users = Collections.emptyList();
 
    @Autowired(required = false)
    @Qualifier("invalid")
    private Map&lt;String,User&gt; userMap = new HashMap&lt;&gt;();
 
    @RequestMapping("/list")
    public Object listUsers() {
        return users;
    }
    @RequestMapping("/map")
    public Object mapUsers() {
        return userMap;
    }
}
```
那么所有标注了@Qualifier("valid")的user bean都会自动注入到List&lt;user&gt; users中去(本例是user1)，所有标注了@Qualifier("invalid")的user bean都会自动注入到Map&lt;String,User&gt; userMap中去（本例是user2），我们再次访问上面两个url:


访问http://localhost:8080/list:
```
[
    {
        "id": "1",
        "name": "a"
    }
]
```
访问http://localhost:8080/map:
```
{
    "user2": {
        "id": "2",
        "name": "b"
    }
}
```
看到这里我们可以理解@LoadBalanced的用处了，其实就是一个修饰符，和@Qualifier一样，比如我们给user1打上
@LoadBalanced:
```
    @Bean("user1")
    @LoadBalanced
    User user1() {
        return new User("1", "a");
    }
 
    @Bean("user2")
    User user2() {
        return new User("2", "b");
    }
```
然后controller中给List&lt;User&gt; users打上@LoadBalanced注解:

```
 @Autowired(required = false)
    @LoadBalanced
    private List&lt;User&gt; users = Collections.emptyList();
```
访问http://localhost:8080/list：
[
    {
        "id": "1",
        "name": "a"
    }
]

和@Qualifier注解效果一样，只有user1被注入进了List，user2没有修饰符，没有被注入进去。
另外当spring容器中有多个相同类型的bean的时候，可以通过@Qualifier来进行区分，以便在注入的时候明确表明你要注入具体的哪个bean,消除歧义。



































