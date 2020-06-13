title: 多种方式实现Spring的Bean注入
author: Joe Tong
tags:
  - JAVAEE 
  - SPRING
categories:  
  - IT 
date: 2019-12-12 15:27:49
---

多种方式实现Spring的Bean注入
2019.03.24 15:54 2093浏览
Spring的核心是控制反转（IoC）和面向切面（AOP）。

Spring就是一个大工厂（容器），可以将所有对象创建和依赖关系维护，交给Spring管理 。

Spring工厂是用于生成Bean，对Bean进行管理。

在Spring中，所有Bean的生命周期都交给Ioc容器管理。

Spring中，Spring可以通过Xml形式或注解的形式来管理Bean 。

下面基于注解的形式，采用多种方式实现Spring的Bean注入。具体如下：

一、通过方法注入Bean

1. 通过构造方法注入Bean

实例代码：

```
@Component("anotherBean1")
public class AnotherBean {
}


@Component
public class MyBean1 {

    private AnotherBean anotherBean1;

    public MyBean1(AnotherBean anotherBean1) {
        this.anotherBean1 = anotherBean1;
    }

    @Override
    public String toString() {
        return "MyBean1{" +
                "anotherBean1=" + anotherBean1 +
                '}';
    }
}
```
2.通过Set方法注入Bean

实例代码：

```
@Component
public class MyBean2 {

    private AnotherBean anotherBean2;

    @Autowired
    public void setAnotherBean2(AnotherBean anotherBean2) {
        this.anotherBean2 = anotherBean2;
    }

    @Override
    public String toString() {
        return "MyBean2{" +
                "anotherBean2=" + anotherBean2 +
                '}';
    }
}
```
二、通过属性注入Bean

```
@Component
public class MyBean3 {

    @Autowired
    private AnotherBean anotherBean3;

    @Override
    public String toString() {
        return "MyBean3{" +
                "anotherBean3=" + anotherBean3 +
                '}';
    }
}
```
三、通过集合类型注入Bean

1. 直接注入集合实例   

List集合注入Bean

```
@Component
public class MyBean4 {

    private List&lt;String&gt; stringList;

    public List&lt;String&gt; getStringList() {
        return stringList;
    }

    @Autowired
    public void setStringList(List&lt;String&gt; stringList) {
        this.stringList = stringList;
    }

    private List&lt;String&gt; stringList1;

    public List&lt;String&gt; getStringList1() {
        return stringList1;
    }

    @Autowired
    @Qualifier("stringList1")   //使用@Qualifier注解指定bean的Id，此处的Id与BeanConfiguration类中的stringList1方法的Bean 的Id要一致
    public void setStringList1(List&lt;String&gt; stringList1) {
        this.stringList1 = stringList1;
    }

    @Override
    public String toString() {
        return "MyBean4{" +
                "stringList=" + stringList +
                ", stringList1=" + stringList1 +
                '}';
    }
}
```

Map集合注入Bean

```
@Component
public class MyBean5 {

    private Map&lt;String, Integer&gt; integerMap;

    public Map&lt;String, Integer&gt; getIntegerMap() {
        return integerMap;
    }

    @Autowired  //加上@Autowired 注解是希望Spring帮我们完成注入
    public void setIntegerMap(Map&lt;String, Integer&gt; integerMap) {
        this.integerMap = integerMap;
    }

    @Override
    public String toString() {
        return "MyBean5{" +
                "integerMap=" + integerMap +
                '}';
    }
}
```

2. 将多个泛型的实例注入到集合     

(1)将多个泛型的实例注入到List     

(2)控制泛型实例在List中的顺序     

(3)将多个泛型的实例注入到Map

```
@Configuration
@ComponentScan("com.lhf.spring.bean")
public class BeanConfiguration {

    //方式一： List集合注入Bean
    @Bean   //告知这个Bean将会交给Spring进行管理
    public List&lt;String&gt; stringList(){
        //List集合有序可重复
        List&lt;String&gt; list = new ArrayList&lt;String&gt;();
        list.add("111");
        list.add("222");
        list.add("333");
        return list;
    }

    @Bean("stringList1")   //告知这个Bean将会交给Spring进行管理, 指定Bean的Id
    public List&lt;String&gt; stringList1(){
        //List集合有序可重复
        List&lt;String&gt; list = new ArrayList&lt;String&gt;();
        list.add("1111");
        list.add("2222");
        list.add("3333");
        return list;
    }

    //方式二：List集合注入Bean，   注意类型一定要与List集合的类型一致
    @Bean
    @Order(100)  //@Order注解指定顺序
    public String string1(){
        return "444";
    }
    @Bean
    @Order(1)
    public String string2(){
        return "555";
    }
    @Bean
    @Order(50)
    public String string3(){
        return "666";
    }

    //----------------------------------------------------------------//
    //方式一：Map集合注入Bean
    @Bean
    public Map&lt;String, Integer&gt; integerMap(){
        Map&lt;String, Integer&gt; map = new HashMap&lt;&gt;();
        map.put("aaa", 1111);
        map.put("bbb", 2222);
        map.put("ccc", 3333);
        return map;
    }

    //方式二：Map集合注入Bean,  注意类型一定要与Map集合的类型一致
    @Bean("int1")
    public Integer integer1(){
        return 10001;
    }
    @Bean("int2")
    public Integer integer2(){
        return 10002;
    }


}
```
四、简单类型（String、Integer)直接注入Bean

```
@Component
public class MyBean6 {


    private String string;

    private Integer integer;

    public String getString() {
        return string;
    }

    @Value("没有了你，万杯觥筹只不是是提醒寂寞罢了")  //使用@Value注解直接注入值
    public void setString(String string) {
        this.string = string;
    }

    public Integer getInteger() {
        return integer;
    }

    @Value("1314")
    public void setInteger(Integer integer) {
        this.integer = integer;
    }

    @Override
    public String toString() {
        return "MyBean6{" +
                "string='" + string + '\'' +
                ", integer=" + integer +
                '}';
    }
}

```
五、SpringIoc容器内置接口注入Bean

```
@Component
public class MyBean7 {

    private ApplicationContext context;

    public ApplicationContext getContext() {
        return context;
    }

    @Autowired
    public void setContext(ApplicationContext context) {
        this.context = context;
    }

    @Override
    public String toString() {
        return "Mybean7{" +
                "context=" + context +
                '}';
    }
}
```
在这里，除了可以直接将ApplicationContext注入进来之外，还可以注入BeanFactory、Environment、ResourceLoader、ApplicationEventPublisher、MessageSource及其实现类。



