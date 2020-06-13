title: springboot aop
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - AOP
categories:
  - IT
date: 2019-07-15 13:32:00
---
【SpringBoot】SpingBoot整合AOP  
Spring的AOP是通过JDK的动态代理和CGLIB实现的。  

说起spring，我们知道其最核心的两个功能就是AOP（面向切面）和IOC（控制反转），这边文章来总结一下SpringBoot如何整合使用AOP。

一、AOP的术语：  
aop 有一堆术语，非常难以理解，简单说一下  

通知(有的地方叫增强)(Advice)  
需要完成的工作叫做通知，就是你写的业务逻辑中需要比如事务、日志等先定义好，然后需要的地方再去用  

连接点(Join point)  
就是spring中允许使用通知的地方，基本上每个方法前后抛异常时都可以是连接点  

切点(Poincut)  
其实就是筛选出的连接点，一个类中的所有方法都是连接点，但又不全需要，会筛选出某些作为连接点做为切点。如果说通知定义了切面的动作或者执行时机的话，切点则定义了执行的地点  

切面(Aspect)  
其实就是通知和切点的结合，通知和切点共同定义了切面的全部内容，它是干什么的，什么时候在哪执行  
引入(Introduction)  
在不改变一个现有类代码的情况下，为该类添加属性和方法,可以在无需修改现有类的前提下，让它们具有新的行为和状态。其实就是把切面（也就是新方法属性：通知定义的）用到目标类中去  

目标(target)  
被通知的对象。也就是需要加入额外代码的对象，也就是真正的业务逻辑被组织织入切面。  

织入(Weaving)  
把切面加入程序代码的过程。切面在指定的连接点被织入到目标对象中，在目标对象的生命周期里有多个点可以进行织入：  

编译期：切面在目标类编译时被织入，这种方式需要特殊的编译器  
类加载期：切面在目标类加载到JVM时被织入，这种方式需要特殊的类加载器，它可以在目标类被引入应用之前增强该目标类的字节码  
运行期：切面在应用运行的某个时刻被织入，一般情况下，在织入切面时，AOP容器会为目标对象动态创建一个代理对象，Spring AOP就是以这种方式织入切面的。 

例：

```
public class UserService{
    void save(){}
    List list(){}
    ....
}
```

在UserService中的save()方法前需要开启事务，在方法后关闭事务，在抛异常时回滚事务。
那么,UserService中的所有方法都是连接点(JoinPoint),save()方法就是切点(Poincut)。需要在save()方法前后执行的方法就是通知(Advice)，切点和通知合起来就是一个切面(Aspect)。save()方法就是目标(target)。把想要执行的代码动态的加入到save()方法前后就是织入(Weaving)。
有的地方把通知称作增强是有道理的，在业务方法前后加上其它方法，其实就是对该方法的增强。

二、常用AOP通知(增强)类型  

before(前置通知)：  在方法开始执行前执行  
after(后置通知)：  在方法执行后执行  
afterReturning(返回后通知)：   在方法返回后执行  
afterThrowing(异常通知)： 在抛出异常时执行  
around(环绕通知)：  在方法执行前和执行后都会执行  

三、执行顺序  
around &gt; before &gt; around &gt; after &gt; afterReturning

四、先说一下SpringAop非常霸道又用的非常少的功能 --引入(Introduction)  

配置类:
```
@Aspect
@Component
public class IntroductionAop {

    @DeclareParents(value = "com.jiuxian..service..*", defaultImpl = DoSthServiceImpl.class)
    public DoSthService doSthService;

}
```
service代码:

```
public interface DoSthService {

    void doSth();
}

@Service
public class DoSthServiceImpl implements DoSthService {

    @Override
    public void doSth() {
        System.out.println("do sth ....");
    }
    
}

public interface UserService {

    void testIntroduction();
}

@Service
public class UserServiceImpl implements UserService {

    @Override
    public void testIntroduction() {
        System.out.println("do testIntroduction");
    }
}

```
测试代码  

```
@Test
public void testIntroduction() {
    userService.testIntroduction();
    //Aop 让UserService方法拥有 DoSthService的方法
    DoSthService doSthService = (DoSthService) userService;
    doSthService.doSth();
}

```

结果

```
do testIntroduction
do sth ....
```
五、五种通知（增强）代码实现  

配置类  
(1) 对方法

```
@Aspect
@Component
public class TransactionAop {

    @Pointcut("execution(* com.jiuxian..service.*.*(..))")
    public void pointcut() {
    }

    @Before("pointcut()")
    public void beginTransaction() {
        System.out.println("before beginTransaction");
    }

    @After("pointcut()")
    public void commit() {
        System.out.println("after commit");
    }

    @AfterReturning("pointcut()", returning = "returnObject")
    public void afterReturning(JoinPoint joinPoint, Object returnObject) {
        System.out.println("afterReturning");
    }

    @AfterThrowing("pointcut()")
    public void afterThrowing() {
        System.out.println("afterThrowing afterThrowing  rollback");
    }

    @Around("pointcut()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        try {
            System.out.println("around");
            return joinPoint.proceed();
        } catch (Throwable e) {
            e.printStackTrace();
            throw e;
        } finally {
            System.out.println("around");
        }
    }
}
```
(2) 对注解

```
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Log {
    String value() default "";
}
```

```
@Aspect
@Component
public class AnnotationAop {

    @Pointcut(value = "@annotation(log)", argNames = "log")
    public void pointcut(Log log) {
    }

    @Around(value = "pointcut(log)", argNames = "joinPoint,log")
    public Object around(ProceedingJoinPoint joinPoint, Log log) throws Throwable {
        try {
            System.out.println(log.value());
            System.out.println("around");
            return joinPoint.proceed();
        } catch (Throwable throwable) {
            throw throwable;
        } finally {
            System.out.println("around");
        }
    }
}

  @Before("@annotation(com.jiuxian.annotation.Log)")
    public void before(JoinPoint joinPoint) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        Log log = method.getAnnotation(Log.class);
        System.out.println("注解式拦截 " + log.value());
    }

```
service 方法实现

```
public interface UserService {

    String save(String user);

    void testAnnotationAop();
}


@Service
public class UserServiceImpl implements UserService {

    @Override
    public String save(String user) {
        System.out.println("保存用户信息");
        if ("a".equals(user)) {
            throw new RuntimeException();
        }
        return user;
    }

    @Log(value = "test")
    @Override
    public void testAnnotationAop() {
        System.out.println("testAnnotationAop");
    }
}

```
测试类

```
@RunWith(SpringRunner.class)
@SpringBootTest
public class SpringbootAopApplicationTests {

    @Resource
    private UserService userService;

    @Test
    public void testAop1() {
        userService.save("张三");
        Assert.assertTrue(true);
    }

    @Test
    public void testAop2() {
        userService.save("a");
    }
    
    @Test
    public void testAop3() {
        userService.testAnnotationAop();
    }
}
```

结果
执行testAop1时

```
around
before beginTransaction
保存用户信息
around
after commit
afterReturning :: 张三
```
执行testAop2时

```
around
before beginTransaction
保存用户信息
around
after commit
afterThrowing  rollback
```
执行testAop3时

```
test
around
testAnnotationAop
around
```
pom文件

```
 &lt;dependency&gt;
    &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
    &lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;
&lt;/dependency&gt;

&lt;dependency&gt;
    &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
    &lt;artifactId&gt;spring-boot-starter-aop&lt;/artifactId&gt;
&lt;/dependency&gt;

&lt;dependency&gt;
    &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
    &lt;artifactId&gt;spring-boot-starter-test&lt;/artifactId&gt;
    &lt;scope&gt;test&lt;/scope&gt;
&lt;/dependency&gt;

```
六、最常用的execution解释  

`例: execution(* com.jiuxian..service.*.*(..))`


execution 表达式的主体  
第一个* 代表任意的返回值  
com.jiuxian aop所横切的包名  
包后面.. 表示当前包及其子包  
第二个* 表示类名，代表所有类  
.*(..) 表示任何方法,括号代表参数 .. 表示任意参数  


例:` execution(* com.jiuxian..service.*Service.add*(String))`   

表示： com.jiuxian 包及其子包下的service包下，类名以Service结尾，方法以add开头，参数类型为String的方法的切点。

七、特别的用法  
```
@Pointcut("execution(public * *(..))")
private void anyPublicOperation() {} 

@Pointcut("within(com.xyz.someapp.trading..*)")
private void inTrading() {} 

@Pointcut("anyPublicOperation() &amp;&amp; inTrading()")
private void tradingOperation() {}
```
可以使用 &amp;&amp;, ||, ! 运算符来定义切点

八、更多详细介绍请参阅官网  
[springAOP官网地址](https://link.juejin.im/?target=https%3A%2F%2Fdocs.spring.io%2Fspring%2Fdocs%2Fcurrent%2Fspring-framework-reference%2Fcore.html%23aop-pointcuts)

一、示例应用场景：对所有的web请求做切面来记录日志。
* 1、pom中引入SpringBoot的web模块和使用AOP相关的依赖： 
 ```
         &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;
        &lt;/dependency&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.aspectj&lt;/groupId&gt;
            &lt;artifactId&gt;aspectjrt&lt;/artifactId&gt;
            &lt;version&gt;1.6.11&lt;/version&gt;
        &lt;/dependency&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.aspectj&lt;/groupId&gt;
            &lt;artifactId&gt;aspectjweaver&lt;/artifactId&gt;
            &lt;version&gt;1.6.11&lt;/version&gt;
        &lt;/dependency&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;cglib&lt;/groupId&gt;
            &lt;artifactId&gt;cglib&lt;/artifactId&gt;
            &lt;version&gt;2.1&lt;/version&gt;
        &lt;/dependency&gt;
 ```
 

其中：   
cglib包是用来动态代理用的,基于类的代理；   
aspectjrt和aspectjweaver是与aspectj相关的包,用来支持切面编程的；   
aspectjrt包是aspectj的runtime包；   
aspectjweaver是aspectj的织入包；  
* 2、实现一个简单的web请求入口（实现传入name参数，返回“hello xxx”的功能）： 

注意：在完成了引入AOP依赖包后，一般来说并不需要去做其他配置。使用过Spring注解配置方式的人会问是否需要在程序主类中增加@EnableAspectJAutoProxy来启用，实际并不需要。
因为在AOP的默认配置属性中，spring.aop.auto属性默认是开启的，也就是说只要引入了AOP依赖后，默认已经增加了@EnableAspectJAutoProxy。  

* 3、定义切面类，实现web层的日志切面   

** 要想把一个类变成切面类，需要两步 **  

① 在类上使用 @Component 注解 把切面类加入到IOC容器中     
② 在类上使用 @Aspect 注解 使之成为切面类  

```
package com.example.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;

/**
 * Created by lmb on 2018/9/5.
 */
@Aspect
@Component
public class WebLogAcpect {

    private Logger logger = LoggerFactory.getLogger(WebLogAcpect.class);

    /**
     * 定义切入点，切入点为com.example.aop下的所有函数
     */
    @Pointcut("execution(public * com.example.aop..*.*(..))")
    public void webLog(){}

    /**
     * 前置通知：在连接点之前执行的通知
     * @param joinPoint
     * @throws Throwable
     */
    @Before("webLog()")
    public void doBefore(JoinPoint joinPoint) throws Throwable {
        // 接收到请求，记录请求内容
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();

        // 记录下请求内容
        logger.info("URL : " + request.getRequestURL().toString());
        logger.info("HTTP_METHOD : " + request.getMethod());
        logger.info("IP : " + request.getRemoteAddr());
        logger.info("CLASS_METHOD : " + joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName());
        logger.info("ARGS : " + Arrays.toString(joinPoint.getArgs()));
    }

    @AfterReturning(returning = "ret",pointcut = "webLog()")
    public void doAfterReturning(Object ret) throws Throwable {
        // 处理完请求，返回内容
        logger.info("RESPONSE : " + ret);
    }
}
```
以上的切面类通过 @Pointcut定义的切入点为com.example.aop包下的所有函数做切入，通过 @Before实现切入点的前置通知，通过 @AfterReturning记录请求返回的对象。
访问http://localhost:8004/hello?name=lmb得到控制台输出如下： 

https://github.com/LiuMengBing/demo-web/tree/master/src/main/java/com/example/aop
二、AOP支持的通知   

* 1、前置通知@Before：在某连接点之前执行的通知，除非抛出一个异常，否则这个通知不能阻止连接点之前的执行流程。  

```
/** 
 * 前置通知，方法调用前被调用 
 * @param joinPoint/null
 */  
@Before(value = POINT_CUT)
public void before(JoinPoint joinPoint){
    logger.info("前置通知");
    //获取目标方法的参数信息  
    Object[] obj = joinPoint.getArgs();  
    //AOP代理类的信息  
    joinPoint.getThis();  
    //代理的目标对象  
    joinPoint.getTarget();  
    //用的最多 通知的签名  
    Signature signature = joinPoint.getSignature();  
    //代理的是哪一个方法  
    logger.info("代理的是哪一个方法"+signature.getName());  
    //AOP代理类的名字  
    logger.info("AOP代理类的名字"+signature.getDeclaringTypeName());  
    //AOP代理类的类（class）信息  
    signature.getDeclaringType();  
    //获取RequestAttributes  
    RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();  
    //从获取RequestAttributes中获取HttpServletRequest的信息  
    HttpServletRequest request = (HttpServletRequest) requestAttributes.resolveReference(RequestAttributes.REFERENCE_REQUEST);  
    //如果要获取Session信息的话，可以这样写：  
    //HttpSession session = (HttpSession) requestAttributes.resolveReference(RequestAttributes.REFERENCE_SESSION);  
    //获取请求参数
    Enumeration&lt;String&gt; enumeration = request.getParameterNames();  
    Map&lt;String,String&gt; parameterMap = Maps.newHashMap();  
    while (enumeration.hasMoreElements()){  
        String parameter = enumeration.nextElement();  
        parameterMap.put(parameter,request.getParameter(parameter));  
    }  
    String str = JSON.toJSONString(parameterMap);  
    if(obj.length &gt; 0) {  
        logger.info("请求的参数信息为："+str);
    }  
}
```

注意：这里用到了JoinPoint和RequestContextHolder。 
1）通过JoinPoint可以获得通知的签名信息，如目标方法名、目标方法参数信息等； 
2）通过RequestContextHolder来获取请求信息，Session信息；

* 2、后置通知@AfterReturning：在某连接点之后执行的通知，通常在一个匹配的方法返回的时候执行（可以在后置通知中绑定返回值）。

```
/** 
 * 后置返回通知 
 * 这里需要注意的是: 
 *      如果参数中的第一个参数为JoinPoint，则第二个参数为返回值的信息 
 *      如果参数中的第一个参数不为JoinPoint，则第一个参数为returning中对应的参数 
 *       returning：限定了只有目标方法返回值与通知方法相应参数类型时才能执行后置返回通知，否则不执行，
 *       对于returning对应的通知方法参数为Object类型将匹配任何目标返回值 
 * @param joinPoint 
 * @param keys 
 */  
@AfterReturning(value = POINT_CUT,returning = "keys")  
public void doAfterReturningAdvice1(JoinPoint joinPoint,Object keys){  
    logger.info("第一个后置返回通知的返回值："+keys);  
}  

@AfterReturning(value = POINT_CUT,returning = "keys",argNames = "keys")  
public void doAfterReturningAdvice2(String keys){  
    logger.info("第二个后置返回通知的返回值："+keys);  
}
```
* 3、后置异常通知@AfterThrowing：在方法抛出异常退出时执行的通知。

```
/** 
 * 后置异常通知 
 *  定义一个名字，该名字用于匹配通知实现方法的一个参数名，当目标方法抛出异常返回后，将把目标方法抛出的异常传给通知方法； 
 *  throwing:限定了只有目标方法抛出的异常与通知方法相应参数异常类型时才能执行后置异常通知，否则不执行， 
 *           对于throwing对应的通知方法参数为Throwable类型将匹配任何异常。 
 * @param joinPoint 
 * @param exception 
 */  
@AfterThrowing(value = POINT_CUT,throwing = "exception")  
public void doAfterThrowingAdvice(JoinPoint joinPoint,Throwable exception){  
    //目标方法名：  
    logger.info(joinPoint.getSignature().getName());  
    if(exception instanceof NullPointerException){  
        logger.info("发生了空指针异常!!!!!");  
    }  
}
```

* 4、后置最终通知@After：当某连接点退出时执行的通知（不论是正常返回还是异常退出）。
```
/** 
 * 后置最终通知（目标方法只要执行完了就会执行后置通知方法） 
 * @param joinPoint 
 */  
@After(value = POINT_CUT)  
public void doAfterAdvice(JoinPoint joinPoint){ 
    logger.info("后置最终通知执行了!!!!");  
}
```

* 5、环绕通知@Around：包围一个连接点的通知，如方法调用等。这是最强大的一种通知类型。环绕通知可以在方法调用前后完成自定义的行为，它也会选择是否继续执行连接点或者直接返回它自己的返回值或抛出异常来结束执行。

环绕通知最强大，也最麻烦，是一个对方法的环绕，具体方法会通过代理传递到切面中去，切面中可选择执行方法与否，执行几次方法等。环绕通知使用一个代理ProceedingJoinPoint类型的对象来管理目标对象，所以此通知的第一个参数必须是ProceedingJoinPoint类型。在通知体内调用ProceedingJoinPoint的proceed()方法会导致后台的连接点方法执行。proceed()方法也可能会被调用并且传入一个`Object[]`对象，该数组中的值将被作为方法执行时的入参。

```
/** 
 * 环绕通知： 
 *   环绕通知非常强大，可以决定目标方法是否执行，什么时候执行，执行时是否需要替换方法参数，执行完毕是否需要替换返回值。 
 *   环绕通知第一个参数必须是org.aspectj.lang.ProceedingJoinPoint类型 
 */  
@Around(value = POINT_CUT)  
public Object doAroundAdvice(ProceedingJoinPoint proceedingJoinPoint){  
    logger.info("环绕通知的目标方法名："+proceedingJoinPoint.getSignature().getName());  
    try {  
        Object obj = proceedingJoinPoint.proceed();  
        return obj;  
    } catch (Throwable throwable) {  
        throwable.printStackTrace();  
    }  
    return null;  
} 
```

* 6、有时候我们定义切面的时候，切面中需要使用到目标对象的某个参数，如何使切面能得到目标对象的参数呢？可以使用args来绑定。如果在一个args表达式中应该使用类型名字的地方使用一个参数名字，那么当通知执行的时候对象的参数值将会被传递进来。

```
@Before("execution(* findById*(..)) &amp;&amp;" + "args(id,..)")
    public void twiceAsOld1(Long id){
        System.err.println ("切面before执行了。。。。id==" + id);

    }
 ```
 
** 注意：任何通知方法都可以将第一个参数定义为org.aspectj.lang.JoinPoint类型（环绕通知需要定义第一个参数为ProceedingJoinPoint类型，它是 JoinPoint 的一个子类）。 **  
JoinPoint接口提供了一系列有用的方法，比如: 
- [] getArgs()（返回方法参数）、
- [] getThis()（返回代理对象）、
- [] getTarget()（返回目标）、
- [] getSignature()（返回正在被通知的方法相关信息）和 
- [] toString()（打印出正在被通知的方法的有用信息）。

三、切入点表达式   
定义切入点的时候需要一个包含名字和任意参数的签名，还有一个切入点表达式，如:  execution(public * com.example.aop...(..))    
** 切入点表达式的格式：execution([可见性]返回类型[声明类型].方法名(参数)[异常]) **   
其中`[]`内的是可选的，其它的还支持通配符的使用：   

1) *：匹配所有字符   
2) ..：一般用于匹配多个包，多个参数   
3) +：表示类及其子类   
4)运算符有：&amp;&amp;,||,!  

切入点表达式关键词用例： 
```
1）execution：用于匹配子表达式。 
//匹配com.cjm.model包及其子包中所有类中的所有方法，返回类型任意，方法参数任意 
@Pointcut(“execution(* com.cjm.model...(..))”) 
public void before(){}
2）within：用于匹配连接点所在的Java类或者包。 
//匹配Person类中的所有方法 
@Pointcut(“within(com.cjm.model.Person)”) 
public void before(){} 
//匹配com.cjm包及其子包中所有类中的所有方法 
@Pointcut(“within(com.cjm..*)”) 
public void before(){}
3） this：用于向通知方法中传入代理对象的引用。 
@Before(“before() &amp;&amp; this(proxy)”) 
public void beforeAdvide(JoinPoint point, Object proxy){ 
//处理逻辑 
}
4）target：用于向通知方法中传入目标对象的引用。 
@Before(“before() &amp;&amp; target(target) 
public void beforeAdvide(JoinPoint point, Object proxy){ 
//处理逻辑 
}
5）args：用于将参数传入到通知方法中。 
@Before(“before() &amp;&amp; args(age,username)”) 
public void beforeAdvide(JoinPoint point, int age, String username){ 
//处理逻辑 
}
6）@within ：用于匹配在类一级使用了参数确定的注解的类，其所有方法都将被匹配。 
@Pointcut(“@within(com.cjm.annotation.AdviceAnnotation)”) 
－ 所有被@AdviceAnnotation标注的类都将匹配 
public void before(){}
7）@target ：和@within的功能类似，但必须要指定注解接口的保留策略为RUNTIME。 
@Pointcut(“@target(com.cjm.annotation.AdviceAnnotation)”) 
public void before(){}
8）@args ：传入连接点的对象对应的Java类必须被@args指定的Annotation注解标注。 
@Before(“@args(com.cjm.annotation.AdviceAnnotation)”) 
public void beforeAdvide(JoinPoint point){ 
//处理逻辑 
}
9）@annotation ：匹配连接点被它参数指定的Annotation注解的方法。也就是说，所有被指定注解标注的方法都将匹配。 
@Pointcut(“@annotation(com.cjm.annotation.AdviceAnnotation)”) 
public void before(){}
10）bean：通过受管Bean的名字来限定连接点所在的Bean。该关键词是Spring2.5新增的。 
@Pointcut(“bean(person)”) 
public void before(){}
```
