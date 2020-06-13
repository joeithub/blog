title: java 动态代理
author: Joe Tong
tags:
  - JAVAEE
categories:
  - IT
date: 2019-07-25 18:01:00
---
retrofit是一个解耦性非常高的网络请求框架，最近在研究的时候发现了动态代理这个非常强大且实用的技术，这篇文章将作为retrofit的前置知识，让大家认识：动态代理有哪些应用场景,什么是动态代理，怎样使用，它的局限性在什么地方？

动态代理的应用场景

1. AOP—面向切面编程，程序解耦

简言之当你想要对一些类的内部的一些方法，在执行前和执行后做一些共同的的操作，而在方法中执行个性化操作的时候--用动态代理。在业务量庞大的时候能够降低代码量，增强可维护性。

2. 想要自定义第三放类库中的某些方法

我引用了一个第三方类库，但他的一些方法不满足我的需求，我想自己重写一下那几个方法，或在方法前后加一些特殊的操作--用动态代理。但需要注意的是，这些方法有局限性，我会在稍后说明。

什么是动态代理



以上的图太过于抽象，我们从生活中的例子开始切入。

假如你是一个大房东（被代理人），你有很多套房子想要出租，而你觉得找租客太麻烦，不愿意自己弄，因而你找一个人来代理你（代理人），帮打理这些东西，而这个人（代理人也就是中介）在帮你出租房屋的时候对你收取一些相应的中介费（对房屋出租的一些额外操作）。对于租客而言，中介就是房东，代理你做一些事情。

以上，就是一个代理的例子，而他为什么叫动态代理，“动态”两个字体现在什么地方？

我们可以这样想，如果你的每一套房子你都请一个代理人帮你打理，每当你想再出租一套房子的时候你得再请一个，这样你会请很多的代理人，花费高额的中介成本，这可以看作常说的“静态代理”。

但假如我们把所有的房子都交给一个中介来代理，让他在多套房子之间动态的切换身份，帮你应付每一个租客。这就是一个“动态代理”的过程。动态代理的一大特点就是编译阶段没有代理类在运行时才生成代理类。

我们用一段代码来看一下

房屋出租的操作
```
/**

*定义一个接口

**/

public interface RentHouse {

void rent();//房屋出租

void charge(String str);//出租费用收取

}
```
房东
```
public class HouseOwner implements RentHouse {

public void rent() {

System.out.println("I want to rent my house");

}

public void charge(String str) {

System.out.println("You get : " + str + " RMB HouseCharge.");

}

}
```
中介
```
public class DynamicProxy implements InvocationHandler {

// 这个就是我们要代理的真实对象，即房东

private Object subject;

// 构造方法，给我们要代理的真实对象赋初值

public DynamicProxy(Object subject) {

this.subject = subject;

}

@Override

public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {

// 在代理真实对象前我们可以添加一些自己的操作，中介收取中介费

System.out.println("before "+method.getName()+" house");

System.out.println("Method:" + method.getName());

// 如果方法是 charge 则中介收取100元中介费

if (method.getName().equals("charge")) {

method.invoke(subject, args);

System.out.println("I will get 100 RMB ProxyCharge.");

} else {

// 当代理对象调用真实对象的方法时，其会自动的跳转到代理对象关联的handler对象的invoke方法来进行调用

method.invoke(subject, args);

}

// 在代理真实对象后我们也可以添加一些自己的操作

System.out.println("after "+method.getName()+" house");

return null;

}

}
```
客人
```
public class Client {

public static void main(String[] args)

{

// 我们要代理的真实对象--房东

HouseOwner houseOwner = new HouseOwner();

// 我们要代理哪个真实对象，就将该对象传进去，最后是通过该真实对象来调用其方法的

InvocationHandler handler = new DynamicProxy(houseOwner);

/*

* 通过Proxy的newProxyInstance方法来创建我们的代理对象，我们来看看其三个参数

* 第一个参数 handler.getClass().getClassLoader() ，我们这里使用handler这个类的ClassLoader对象来加载我们的代理对象

* 第二个参数realSubject.getClass().getInterfaces()，我们这里为代理对象提供的接口是真实对象所实行的接口，表示我要代理的是该真实对象，这样我就能调用这组接口中的方法了

* 第三个参数handler， 我们这里将这个代理对象关联到了上方的 InvocationHandler 这个对象上

*/

RentHouse rentHouse = (RentHouse) Proxy.newProxyInstance(handler.getClass().getClassLoader(), houseOwner

.getClass().getInterfaces(), handler);//一个动态代理类，中介

System.out.println(rentHouse.getClass().getName());

rentHouse.rent();

rentHouse.charge("10000");

}

}
```
我们来看一下输出
```
com.sun.proxy.$Proxy0

before rent house

Method:rent

I want to rent my house

after rent house

before charge house

Method:charge

You get : 10000 RMB HouseCharge.

I will get 100 RMB ProxyCharge.

after charge house

Process finished with exit code 0
```
输出里有 before rent house以及after rent house，说明我们可以在方法的前后增加操作。再看输出 I will get 100 RMB ProxyCharge. 中介收取了100块的中介费，说明我们不仅可以增加操作，甚至可以替换该方法或者直接让该方法不执行。

刚开始看代码你可能会有很多疑惑，我们通过以下的内容来看看动态代理应该怎么用。

动态代理该如何使用

在java的动态代理机制中，有两个重要的类和接口，一个是InvocationHandler(Interface)、另一个则是Proxy(Class)，这一个类和接口是实现我们动态代理所必须用到的。

每一个动态代理类都必须要实现InvocationHandler这个接口（代码中的中介），并且每个代理类的实例都关联到了一个handler，当我们通过代理对象调用一个方法的时候，这个方法的调用就会被转发为由InvocationHandler这个接口的invoke（对方法的增强就写在这里面） 方法来进行调用。

Object invoke(Object proxy, Method method, Object[] args) throws Throwable

我们看到这个方法一共接受三个参数，那么这三个参数分别代表什么呢？

Object invoke(Object proxy, Method method, Object[] args) throws Throwable

//proxy: 指代我们所代理的那个真实对象

//method: 指代的是我们所要调用真实对象的某个方法的Method对象

//args: 指代的是调用真实对象某个方法时接受的参数

接下来我们来看看Proxy这个类

public static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h) throws IllegalArgumentException

Proxy这个类的作用就是用来动态创建一个代理对象的类，它提供了许多的方法，但是我们用的最多的就是 newProxyInstance 这个方法：

public static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h) throws IllegalArgumentException

这个方法的作用就是得到一个动态的代理对象，其接收三个参数，我们来看看这三个参数所代表的含义

public static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h) throws IllegalArgumentException

//loader: 一个ClassLoader对象，定义了由哪个ClassLoader对象来对生成的代理对象进行加载

//interfaces: 一个Interface对象的数组，表示的是我将要给我需要代理的对象提供一组什么接口，如果我提供了一组接口给它，那么这个代理对象就宣称实现了该接口(多态)，这样我就能调用这组接口中的方法了

//h: 一个InvocationHandler对象，表示的是当我这个动态代理对象在调用方法的时候，会关联到哪一个InvocationHandler对象上

这样一来，结合上面给出的代码，我们就可以明白动态代理的使用方法了

动态代理的局限性

从动态代理的使用方法中我们看到其实可以被增强的方法都是实现了借口的（不实现借口的public方法也可以通过继承被代理类来使用），代码中的HouseOwner继承了RentHouse 。而对于private方法JDK的动态代理无能为力！

以上的动态代理是JDK的，对于java工程还有大名鼎鼎的CGLib，但遗憾的是CGLib并不能在android中使用，android虚拟机相对与jvm还是有区别的。

结束语

动态代理的使用场景远不止这些，内部原理会在以后的文章中介绍，但应用类反射临时生成代理类这一机制决定它对性能会有一定的影响。本文作为retrofit原理的前置文章并没有太过详尽，如有疏漏和错误，欢迎指正，如果觉得不错的朋友也请帮我点个关注，你的喜欢是我最大的动力~！