title: abstract interface
author: Joe Tong
tags:
  - JAVASE
categories:
  - IT
date: 2019-07-27 07:56:00
---
abstract interface区别  

含有 abstract 修饰符 class 即为抽象类，抽象类不能创建实际对象，含有抽象方法的抽象类必须定义为 abstract class。  

接口可以说成是一种特殊的抽象类，接口中的所有方法都必须是抽象的，接口中的方法定义默认为 public abstract 类型，接口中的成员产量类型默认为 public static final。  

两者的区别:  

a. 抽象类可以有构造方法，接口中不能有构造方法。  

b. 抽象类中可以有普通成员变量，接口中没有普通成员变量。  

c. 抽象类中可以包含非抽象普通方法，接口中的所有方法必须都是抽象的，不能有非抽象的方法。  

d. 抽象类中的抽象方法的访问权限可以是 public、protected 和(默认类型，虽然 eclipse 不报错，但也不能用，默认类型子类不能继承)，接口中的抽象方法只能是 public 类型的，并且默认即为 public abstract 类型。  

e. 抽象类中可以包含静态方法，在 JDK1.8 之前接口中不能不包含静态方法，JDK1.8 以后可以包含。  

f. 抽象类和接口中都可以包含静态成员变量，抽象类中的静态成员变量的访问权限可以是任意的，但接口中定义的变量只能是 public static final 类型的，并且默认即为 public static final 类型。  

g. 一个类可以实现多个接口，用逗号隔开，但只能继承一个抽象类，接口不可以实现接口，但可以继承接口，并且可以继承多个接口，用逗号隔开。  