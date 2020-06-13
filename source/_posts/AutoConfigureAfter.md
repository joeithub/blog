title: '@AutoConfigureAfter'
author: Joe Tong
tags:
  - JAVAEE
  - SPRING
categories:
  - IT
date: 2019-08-29 15:43:00
---
@AutoConfigureAfter 在加载配置的类之后再加载当前类  
它的value 是一个数组 一般配合着**@import** 注解使用 ，在使用import时必须要让这个类先被spring ioc 加载好  
所以@AutoConfigureAfter必不可少  

```
@Configuration
public class ClassA {	//在加载DemoConfig之前加载ClassA类

}

@Configuration
@AutoConfigureAfter(ClassA.class)
@Import(ClassA.class)
public class DemoConfig {

}

@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.TYPE })
public @interface AutoConfigureAfter {

	/**
	 * The auto-configure classes that should have already been applied.
	 * @return the classes
	 */
	Class&amp;lt;?&amp;gt;[] value() default {};

	/**
	 * The names of the auto-configure classes that should have already been applied.
	 * @return the class names
	 * @since 1.2.2
	 */
	String[] name() default {};

}

```
注意： spring只对spring.factory文件下的配置类进行排序

