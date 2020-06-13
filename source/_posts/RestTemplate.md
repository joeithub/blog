title: RestTemplate
author: Joe Tong
tags:
  - JAVAEE
  - RESTTEMPLATE
  - WEBClIENT
  - SPRINGBOOT
categories:
  - IT
date: 2019-07-18 00:00:00
---
SpringBoot26 RestTemplate、WebClient
Springboot — 用更优雅的方式发HTTP请求(RestTemplate详解)
RestTemplate是Spring提供的用于访问Rest服务的客户端，RestTemplate提供了多种便捷访问远程Http服务的方法,能够大大提高客户端的编写效率。

我之前的HTTP开发是用apache的HttpClient开发，代码复杂，还得操心资源回收等。代码很复杂，冗余代码多，稍微截个图，这是我封装好的一个post请求工具：

本教程将带领大家实现Spring生态内RestTemplate的Get请求和Post请求还有exchange指定请求类型的实践和RestTemplate核心方法源码的分析，看完你就会用优雅的方式来发HTTP请求。

1.简述RestTemplate

是Spring用于同步client端的核心类，简化了与http服务的通信，并满足RestFul原则，程序代码可以给它提供URL，并提取结果。默认情况下，RestTemplate默认依赖jdk的HTTP连接工具。当然你也可以 通过setRequestFactory属性切换到不同的HTTP源，比如Apache HttpComponents、Netty和OkHttp。

RestTemplate能大幅简化了提交表单数据的难度，并且附带了自动转换JSON数据的功能，但只有理解了HttpEntity的组成结构（header与body），且理解了与uriVariables之间的差异，才能真正掌握其用法。这一点在Post请求更加突出，下面会介绍到。

该类的入口主要是根据HTTP的六个方法制定：

此外，exchange和excute可以通用上述方法。

在内部，RestTemplate默认使用HttpMessageConverter实例将HTTP消息转换成POJO或者从POJO转换成HTTP消息。默认情况下会注册主mime类型的转换器，但也可以通过setMessageConverters注册其他的转换器。

其实这点在使用的时候是察觉不到的，很多方法有一个responseType 参数，它让你传入一个响应体所映射成的对象，然后底层用HttpMessageConverter将其做映射

```
HttpMessageConverterExtractor&lt;T&gt; responseExtractor =
                new HttpMessageConverterExtractor&lt;&gt;(responseType, getMessageConverters(), logger);
　```

HttpMessageConverter.java源码：

```
public interface HttpMessageConverter&lt;T&gt; {
        //指示此转换器是否可以读取给定的类。
    boolean canRead(Class&lt;?&gt; clazz, @Nullable MediaType mediaType);
 
        //指示此转换器是否可以写给定的类。
    boolean canWrite(Class&lt;?&gt; clazz, @Nullable MediaType mediaType);
 
        //返回List&lt;MediaType&gt;
    List&lt;MediaType&gt; getSupportedMediaTypes();
 
        //读取一个inputMessage
    T read(Class&lt;? extends T&gt; clazz, HttpInputMessage inputMessage)
            throws IOException, HttpMessageNotReadableException;
 
        //往output message写一个Object
    void write(T t, @Nullable MediaType contentType, HttpOutputMessage outputMessage)
            throws IOException, HttpMessageNotWritableException;
 
}

```

在内部，RestTemplate默认使用SimpleClientHttpRequestFactory和DefaultResponseErrorHandler来分别处理HTTP的创建和错误，但也可以通过setRequestFactory和setErrorHandler来覆盖。

2.get请求实践

2.1.getForObject()方法
```
public &lt;T&gt; T getForObject(String url, Class&lt;T&gt; responseType, Object... uriVariables){}
public &lt;T&gt; T getForObject(String url, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables)
public &lt;T&gt; T getForObject(URI url, Class&lt;T&gt; responseType)
``` 
getForObject()其实比getForEntity()多包含了将HTTP转成POJO的功能，但是getForObject没有处理response的能力。因为它拿到手的就是成型的pojo。省略了很多response的信息。

2.1.1 POJO:

```
public class Notice {
    private int status;
    private Object msg;
    private List&lt;DataBean&gt; data;
}
public  class DataBean {
  private int noticeId;
  private String noticeTitle;
  private Object noticeImg;
  private long noticeCreateTime;
  private long noticeUpdateTime;
  private String noticeContent;
}

```

示例：2.1.2 不带参的get请求
```
/**
     * 不带参的get请求
     */
    @Test
    public void restTemplateGetTest(){
        RestTemplate restTemplate = new RestTemplate();
        Notice notice = restTemplate.getForObject("http://xxx.top/notice/list/1/5"
                , Notice.class);
        System.out.println(notice);
    }
　　
```
控制台打印：


```
INFO 19076 --- [           main] c.w.s.c.w.c.HelloControllerTest         
: Started HelloControllerTest in 5.532 seconds (JVM running for 7.233)
 
Notice{status=200, msg=null, data=[DataBean{noticeId=21, noticeTitle='aaa', noticeImg=null,
noticeCreateTime=1525292723000, noticeUpdateTime=1525292723000, noticeContent='&lt;p&gt;aaa&lt;/p&gt;'},
DataBean{noticeId=20, noticeTitle='ahaha', noticeImg=null, noticeCreateTime=1525291492000,
noticeUpdateTime=1525291492000, noticeContent='&lt;p&gt;ah.......'

　
```
示例：2.1.3 带参数的get请求1

```
Notice notice = restTemplate.getForObject("http://fantj.top/notice/list/{1}/{2}"
                , Notice.class,1,5);
```                
明眼人一眼能看出是用了占位符{1}。

示例：2.1.4 带参数的get请求2

  
```
Map&lt;String,String&gt; map = new HashMap();
        map.put("start","1");
        map.put("page","5");
        Notice notice = restTemplate.getForObject("http://fantj.top/notice/list/"
                , Notice.class,map);
　　
```
明眼人一看就是利用map装载参数，不过它默认解析的是PathVariable的url形式。

2.2 getForEntity()方法
```
public &lt;T&gt; ResponseEntity&lt;T&gt; getForEntity(String url, Class&lt;T&gt; responseType, Object... uriVariables){}
public &lt;T&gt; ResponseEntity&lt;T&gt; getForEntity(String url, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables){}
public &lt;T&gt; ResponseEntity&lt;T&gt; getForEntity(URI url, Class&lt;T&gt; responseType){}
 ```
与getForObject()方法不同的是返回的是ResponseEntity对象，如果需要转换成pojo，还需要json工具类的引入，这个按个人喜好用。不会解析json的可以百度FastJson或者Jackson等工具类。然后我们就研究一下ResponseEntity下面有啥方法。

ResponseEntity、HttpStatus、BodyBuilder结构

ResponseEntity.java

public HttpStatus getStatusCode(){}
public int getStatusCodeValue(){}
public boolean equals(@Nullable Object other) {}
public String toString() {}
public static BodyBuilder status(HttpStatus status) {}
public static BodyBuilder ok() {}
public static &lt;T&gt; ResponseEntity&lt;T&gt; ok(T body) {}
public static BodyBuilder created(URI location) {}
...
　　

HttpStatus.java


public enum HttpStatus {
public boolean is1xxInformational() {}
public boolean is2xxSuccessful() {}
public boolean is3xxRedirection() {}
public boolean is4xxClientError() {}
public boolean is5xxServerError() {}
public boolean isError() {}
}
　　

BodyBuilder.java

```
public interface BodyBuilder extends HeadersBuilder&lt;BodyBuilder&gt; {
    //设置正文的长度，以字节为单位，由Content-Length标头
      BodyBuilder contentLength(long contentLength);
    //设置body的MediaType 类型
      BodyBuilder contentType(MediaType contentType);
    //设置响应实体的主体并返回它。
      &lt;T&gt; ResponseEntity&lt;T&gt; body(@Nullable T body);
｝
 ```
可以看出来，ResponseEntity包含了HttpStatus和BodyBuilder的这些信息，这更方便我们处理response原生的东西。

示例：

```
@Test
public void rtGetEntity(){
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity&lt;Notice&gt; entity = restTemplate.getForEntity("http://fantj.top/notice/list/1/5"
                , Notice.class);
 
        HttpStatus statusCode = entity.getStatusCode();
        System.out.println("statusCode.is2xxSuccessful()"+statusCode.is2xxSuccessful());
 
        Notice body = entity.getBody();
        System.out.println("entity.getBody()"+body);
 
 
        ResponseEntity.BodyBuilder status = ResponseEntity.status(statusCode);
        status.contentLength(100);
        status.body("我在这里添加一句话");
        ResponseEntity&lt;Class&lt;Notice&gt;&gt; body1 = status.body(Notice.class);
        Class&lt;Notice&gt; body2 = body1.getBody();
        System.out.println("body1.toString()"+body1.toString());
    }
  
 ```
statusCode.is2xxSuccessful()true
entity.getBody()Notice{status=200, msg=null, data=[DataBean{noticeId=21, noticeTitle='aaa', ...
body1.toString()&lt;200 OK,class com.waylau.spring.cloud.weather.pojo.Notice,{Content-Length=[100]}&gt;

　

当然，还有getHeaders()等方法没有举例。

3. post请求实践

同样的,post请求也有postForObject和postForEntity。

```
public &lt;T&gt; T postForObject(String url, @Nullable Object request, Class&lt;T&gt; responseType, Object... uriVariables)
            throws RestClientException {}
public &lt;T&gt; T postForObject(String url, @Nullable Object request, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables)
            throws RestClientException {}
public &lt;T&gt; T postForObject(URI url, @Nullable Object request, Class&lt;T&gt; responseType) throws RestClientException {}

```
示例

我用一个验证邮箱的接口来测试。

```

@Test
public void rtPostObject(){
    RestTemplate restTemplate = new RestTemplate();
    String url = "http://47.xxx.xxx.96/register/checkEmail";
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
    MultiValueMap&lt;String, String&gt; map= new LinkedMultiValueMap&lt;&gt;();
    map.add("email", "844072586@qq.com");
 
    HttpEntity&lt;MultiValueMap&lt;String, String&gt;&gt; request = new HttpEntity&lt;&gt;(map, headers);
    ResponseEntity&lt;String&gt; response = restTemplate.postForEntity( url, request , String.class );
    System.out.println(response.getBody());
}
　
```
执行结果：

{"status":500,"msg":"该邮箱已被注册","data":null}
Springboot -- 用更优雅的方式发HTTP请求(RestTemplate详解)

代码中，MultiValueMap是Map的一个子类，它的一个key可以存储多个value，简单的看下这个接口：

public interface MultiValueMap&lt;K, V&gt; extends Map&lt;K, List&lt;V&gt;&gt; {...}
 
为什么用MultiValueMap?因为HttpEntity接受的request类型是它。

public HttpEntity(@Nullable T body, @Nullable MultiValueMap&lt;String, String&gt; headers){}
//我这里只展示它的一个construct,从它可以看到我们传入的map是请求体，headers是请求头。
　　

为什么用HttpEntity是因为restTemplate.postForEntity方法虽然表面上接收的request是@Nullable Object request类型，但是你追踪下去会发现，这个request是用HttpEntity来解析。核心代码如下：

```
if (requestBody instanceof HttpEntity) {
    this.requestEntity = (HttpEntity&lt;?&gt;) requestBody;
}else if (requestBody != null) {
    this.requestEntity = new HttpEntity&lt;&gt;(requestBody);
}else {
    this.requestEntity = HttpEntity.EMPTY;
}
　
```
我曾尝试用map来传递参数，编译不会报错，但是执行不了，是无效的url request请求(400 ERROR)。其实这样的请求方式已经满足post请求了，cookie也是属于header的一部分。可以按需求设置请求头和请求体。其它方法与之类似。

4.使用exchange指定调用方式

exchange()方法跟上面的getForObject()、getForEntity()、postForObject()、postForEntity()等方法不同之处在于它可以指定请求的HTTP类型。


但是你会发现exchange的方法中似乎都有@Nullable HttpEntity requestEntity这个参数，这就意味着我们至少要用HttpEntity来传递这个请求体，之前说过源码所以建议就使用HttpEntity提高性能。

示例
```
@Test
    public void rtExchangeTest() throws JSONException {
        RestTemplate restTemplate = new RestTemplate();
        String url = "http://xxx.top/notice/list";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("start",1);
        jsonObj.put("page",5);
 
        HttpEntity&lt;String&gt; entity = new HttpEntity&lt;&gt;(jsonObj.toString(), headers);
        ResponseEntity&lt;JSONObject&gt; exchange = restTemplate.exchange(url,
                                          HttpMethod.GET, entity, JSONObject.class);
        System.out.println(exchange.getBody());
    }
 ```
这次可以看到，我使用了JSONObject对象传入和返回。
当然，HttpMethod方法还有很多，用法类似。

5.excute()指定调用方式

excute()的用法与exchange()大同小异了，它同样可以指定不同的HttpMethod，不同的是它返回的对象是响应体所映射成的对象，而不是ResponseEntity。

需要强调的是，execute()方法是以上所有方法的底层调用。随便看一个：

```    
@Override
    @Nullable
    public &lt;T&gt; T postForObject(String url, @Nullable Object request, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables)
            throws RestClientException {
 
        RequestCallback requestCallback = httpEntityCallback(request, responseType);
        HttpMessageConverterExtractor&lt;T&gt; responseExtractor =
                new HttpMessageConverterExtractor&lt;&gt;(responseType, getMessageConverters(), logger);
        return execute(url, HttpMethod.POST, requestCallback, responseExtractor, uriVariables);
    }
```
 
### 1 RestTemplate  
　　RestTemplate是在客户端访问 Restful 服务的一个核心类；RestTemplate通过提供回调方法和允许配置信息转换器来实现个性化定制RestTemplate的功能，通过RestTemplate可以封装请求对象，也可以对响应对象进行解析。
 &nbsp;
![upload successful](/images/rst.png)
技巧01：RestTemplate默认使用JDK提供的包去建立HTTP连接，当然，开发者也可以使用诸如 Apache HttpComponents, Netty, and OkHttp 去建立HTTP连接。  
　　技巧02：RestTemplate内部默认使用HttpMessageConverter来实现HTTTP messages 和 POJO 之间的转换，可以通过RestTemplate的成员方  法&nbsp;setMessageConverters(java.util.List&lt;org.springframework.http.converter.HttpMessageConverter&lt;?&gt;&gt;). 去修改默认的转换器。  
　　技巧03：RestTemplate内部默认使用SimpleClientHttpRequestFactory and&nbsp;DefaultResponseErrorHandler 去创建HTTP连接和处理HTTP错误，可以通过HttpAccessor.setRequestFactory(org.springframework.http.client.ClientHttpRequestFactory)&nbsp;and&nbsp;setErrorHandler(org.springframework.web.client.ResponseErrorHandler)去做相应的修改。 
　　##### 1.1 RestTemplate中方法概览  
　　　　RestTemplate为每种HTTP请求都实现了相关的请求封装方法  
技巧01：这些方法的命名是有讲究的，方法名的第一部分表示HTTP请求类型，方法名的第二部分表示响应类型  
  例如：getForObject 表示执行GET请求并将响应转化成一个Object类型的对象　
  
技巧02：利用RestTemplate封装客户端发送HTTP请求时，如果出现异常就会抛出&nbsp;RestClientException&nbsp;类型的异常；可以通过在创建RestTemplate对象的时候指定一个ResponseErrorHandler类型的异常处理类来处理这个异常 

技巧03：exchange 和 excute 这两个方法是通用的HTTP请求方法，而且这两个方法还支持额外的HTTP请求类型【PS: 前提是使用的HTTP连接包也支持这些额外的HTTP请求类型】 &nbsp;

![upload successful](/images/htt.png)
　技巧04：每种方法都有3个重载方法，其中两个接收String类型的请求路径和响应类型、参数；另外一个接收URI类型的请求路径和响应类型。  
 
![upload successful](/images/ty.png)
技巧05：使用String类型的请求路径时，RestTemplate会自动进行一次编码，所以为了避免重复编码问题最好使用URI类型的请求路径  
例如：restTemplate.getForObject("http://example.com/hotel list")&nbsp;becomes"http://example.com/hotel%20list"  
技巧06：URI 和URL 知识点扫盲
 
 
![upload successful](/images/ecd.png)
技巧06：利用接收URI参数的RestTemplate.getForObject方法发送Get请求

![upload successful](/images/gt.png)
　##### 1.2 常用构造器  
　　　　技巧01：利用无参构造器创建RestTemplate实例时，什么都是使用默认的【即：使用HttpMessageConverter来实现HTTTP messages 和 POJO 之间的转换、使用SimpleClientHttpRequestFactory and&nbsp;DefaultResponseErrorHandler 去创建HTTP连接和处理HTTP错误】  
　　　　技巧02：利用&nbsp;RestTemplate(ClientHttpRequestFactory requestFactory) 创建RestTemplate实例时使用自定义的requestFactory去创建HTTP连接  
　　　　技巧03：利用&nbsp;RestTemplate(java.util.List&lt;HttpMessageConverter&lt;?&gt;&gt;&nbsp;messageConverters)&nbsp;&nbsp;创建RestTemplate实例时使用自定义的转换器列表实现HTTTP messages 和 POJO 之间的转换  
 &nbsp; &nbsp;
![upload successful](/images/cnst.png)
 ##### 1.3 GET相关方法  
　　　　技巧01：本博文使用的是SpringBoot项目，利用了一个配置文件来将RestTemplate注入的容器中 
    
 #######1.3.1&nbsp;public &lt;T&gt; T getForObject(String url, Class&lt;T&gt; responseType, Object... uriVariables)  
1》远程服务代码【不带请求参数的】
 &nbsp;
![upload successful](/images/rm.png)  
1》模拟客户端代码【不带请求参数的】
 &nbsp; &nbsp; &nbsp; &nbsp;
![upload successful](/images/cl.png)
2》远程服务代码【带请求参数的】  
　技巧01：HTTP请求中url路径？后面的参数就是请求参数格式以 key=value 的形式传递；后台需要用@RequestParam注解，如果前端的 key 和 后台方法的参数名称一致时可以不用@RequestParam注解【因为@RequestParam注解时默认的参数注解】  
　技巧02：对于请求参数，最好在服务端利用@RequestParam注解设置该请求参数为非必传参数并设定默认值  
 
![upload successful](/images/dc.png)
2》模拟客户端代码【带请求参数的】

![upload successful](/images/mn.png)
3》远程服务代码【带路径参数的】  
　技巧01：HTTP请求的路径可以成为路径参数，前提是服务端进行路径配置【即：需要配合@RequestMapping和@PathVariable一起使用】  
　技巧02：由于路径参数不能设置默认是，所以在后台通过@PathVariable将路径参数设置成必传可以减少出错率  
　技巧03：@PathVariable可以设置正则表达式【详情参见：https://www.cnblogs.com/NeverCtrl-C/p/8185576.html】  
 
![upload successful](/images/lj.png)
3》模拟客户端代码【带路径参数的】

![upload successful](/images/lj2.png)
4》远程服务代码【带路径参数和请求参数的】  
　技巧01： @PathVariable和@RequestParam都可以设定是否必传【默认必传】  
　技巧02：@PathVariable不可以设定默认值，@RequestParam可以设定默认值【默认值就是不传入的时候代替的值】  
　技巧03：&nbsp;@PathVariable如果设置必传为true，前端不传入时就会报错【技巧：开启必传】  
　技巧04：@RequestParam如果设置必传为true，前端不传入还是也会报错【技巧：关闭必传，开启默认值】  
　技巧05：@PathVariable可以设置正则表达式【详情参见：https://www.cnblogs.com/NeverCtrl-C/p/8185576.html】  
 
![upload successful](/images/dlhc.png)
4》模拟客户端代码【带路径参数和请求参数的】

![upload successful](/images/lc.png)  


#######     1.3.2&nbsp; public &lt;T&gt; T getForObject(String url, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables)
&nbsp;　　　　　　1》远程服务代码【带请求参数的】
 &nbsp;
![upload successful](/images/dqcs.png)
1》模拟客户端代码【带请求参数的】

![upload successful](/images/kc.png)
#######　1.3.3&nbsp;public &lt;T&gt; ResponseEntity&lt;T&gt; getForEntity(String url, Class&lt;T&gt; responseType, Object... uriVariables)  
技巧01：getForObject 和 getForEntity 的区别：后者可以获取到更多的响应信息，前者这可以获取到响应体的数据  
1》远程服务代码【不带请求参数的】

![upload successful](/images/bdc.png)
　1》模拟客户端代码【不带请求参数的】

![upload successful](/images/mncbd.png)
  2》远程服务代码【带请求参数的】

![filename already exists, renamed](/images/pasted-0.png)
2》模拟客户端代码【带请求参数的】

![upload successful](/images/pasted-1.png)
3》远程服务代码【带路径参数的】
![upload successful](/images/pasted-2.png)
3》模拟客户端代码【带路径参数的】
![upload successful](/images/pasted-3.png)
4》远程服务代码【带路径参数和请求参数的】
![upload successful](/images/pasted-4.png)
4》模拟客户端代码【带路径参数和请求参数的】
![upload successful](/images/pasted-5.png)
#######　　1.3.4 public &lt;T&gt; ResponseEntity&lt;T&gt; getForEntity(String url, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables)  
1》远程服务代码【带请求参数的】  
  
![upload successful](/images/pasted-6.png)
 1》模拟客户端代码【带请求参数的】
 
![upload successful](/images/pasted-7.png)

#####　1.4 POST
服务端源代码：点击前往
#######　1.4.1&nbsp;public &lt;T&gt; T postForObject(String url, @Nullable Object request, Class&lt;T&gt; responseType, Object... uriVariables)    
　　　　　　参数解释：  
　　　　　　　　url -&gt; String类型的请求路径  
　　　　　　　　request -&gt; 请求体对象 
　　　　　　　　responseType -&gt; 响应数据类型   
　　　　　　　　uriVariables -&gt; 请求参数  
#######　　　　1.4.2&nbsp;public &lt;T&gt; T postForObject(String url, @Nullable Object request, Class&lt;T&gt; responseType, Map&lt;String, ?&gt; uriVariables)    
　　　　　　参数解释：  
　　　　　　　　url -&gt; String类型的请求路径  
　　　　　　　　request -&gt; 请求体对象  
　　　　　　　　responseType&nbsp;-&gt; 响应数据类型  
　　　　　　　　uriVariables -&gt; 请求参数  
#######　　　　1.4.3&nbsp;public &lt;T&gt; T postForObject(URI url, @Nullable Object request, Class&lt;T&gt; responseType)    
　　　　　　参数解释：  
　　　　　　　　url -&gt; URI类型的请求路径  
　　　　　　　　request -&gt; 请求体对象   
　　　　　　　　responseType&nbsp;-&gt; 响应数据类型  
#######　　　　1.4.4 请求体对象说明  
　技巧01：请求体对象（@Nullable Object request）可以直接传一个实体，服务端利用@RequestBody接收这个实体即可  
　技巧02：请求体对象（@Nullable Object request）也可以传入一个&nbsp;&nbsp;HttpEntity 的实例，服务端的代码不变；创建&nbsp;HttpEntity 实例时可以设定请求体数据和请求头数据（详情请参见 HttpEntity 的相关构造函数）  
 &nbsp;
![upload successful](/images/pasted-8.png)
##### 1.5 其他请求和GET、POST类似 
　　　　待更新......  
&nbsp;
### 2 WebClient  
　　WebClient 是一个非阻塞、响应式的HTTP客户端，它以响应式被压流的方式执行HTTP请求；WebClient默认使用&nbsp;Reactor Netty 作为HTTP连接器，当然也可以通过 ClientHttpConnector修改其它的HTTP连接器。  
　　技巧01：使用WebClient需要进入Spring5的相关依赖，如果使用的是SpringBoot项目的话直接引入下面的依赖就可以啦 
  ```
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-webflux&lt;/artifactId&gt;
        &lt;/dependency&gt;
 ```
&nbsp;WebClient源码    
　　##### 2.1 创建WebClient实例的方式    
　　　　技巧01：从WebClient的源码中可以看出，WebClient接口提供了三个静态方法来创建WebClient实例
    
    
@Bean注入

```
 @Bean
    public RestTemplate restTemplate(){
        RestTemplate restTemplate = new RestTemplate();;
        restTemplate.setRequestFactory(new HttpComponentsClientHttpRequestFactory());
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        converter.setSupportedMediaTypes(Collections.singletonList(MediaType.ALL));
        restTemplate.getMessageConverters().add(converter);
        return restTemplate;
    }
 ```
 
 
 使用：
 
 ```
  MultiValueMap&lt;String, Object&gt; headers = new LinkedMultiValueMap&lt;String, Object&gt;();
 headers.add("Accept", "application/json");
 headers.add("Content-Type", "application/json");
 HttpEntity request = new HttpEntity(requestBody, headers);
 Object sqlResult = restTemplate.postForObject(logConf.getAccessAddr() + "/_sql", request, Object.class);
```



