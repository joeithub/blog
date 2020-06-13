title: OSGI Command3
author: Joe Tong
tags:
  - JAVAEE
  - OSGI
  - KARAF
categories:
  - IT
date: 2019-07-29 13:06:00
---
OSGI中自定义command
前文

在上一篇博文中，我们讲述了什么是OSGI中的command，同时写了一个简单的command，这个command实现了org.apache.felix.gogo.commands.Action这个接口，同样可以实现相同功能的还有
org.apache.karaf.shell.console.OsgiCommandSupport这一个抽象类，但是在本程序中，这两个接口或者抽象类上都标注了@Deprecated，因此已经不推荐使用了，而当前推荐使用的则是karaf中的一个接口，为org.apache.karaf.shell.api.action.Action，但是这个在使用过程中会出现一定的问题，这个稍后再说，本文主要讲解的是，不再使用karaf提供的@Service,@Command和继承或者实现相关接口来编写Command，而是在blueprint.xml的方式配置一个Command，这个文字不太好描述，下面就直接用相关程序来讲解本次编写的command。  
自定义command
首先不多说，新建一个类，命名为SampleCommand，里面分别写三个方法，两个无参方法，一个有参，为以下：  
```
public void first() {
        System.out.println("first");
    }

    public void second() {
        System.out.println("second");
    }

    public void hello(String name) {
        System.out.println("hello " + name);
    }
```
以上，等会再控制台中显示，上述两个无参方法，就是普通命令，而有参方法则是可以传入一个参数，并且会在控制台中打出，在以上完成之后，还要在blueprint.xml中配置相关命令，blueprint.xml中内容如下：  
```
&lt;bean class="cn.com.files.command.SampleCommand" id="sampleCommand"/&gt;
    &lt;service auto-export="all-classes" ref="sampleCommand"&gt;
        &lt;service-properties&gt;
            &lt;entry key="osgi.command.scope"&gt;
                &lt;!-- define the prefix for you commands --&gt;
                &lt;value&gt;sample&lt;/value&gt;
            &lt;/entry&gt;
            &lt;entry key="osgi.command.function"&gt;
                &lt;!-- declare the list of all the methods you want to expose --&gt;
                &lt;array value-type="java.lang.String"&gt;
                    &lt;value&gt;first&lt;/value&gt;
                    &lt;value&gt;second&lt;/value&gt;
                    &lt;value&gt;hello&lt;/value&gt;
                &lt;/array&gt;
            &lt;/entry&gt;
        &lt;/service-properties&gt;
    &lt;/service&gt;
```

我们首先进行了一个bean的配置，即将SampleCommand配置为bean，其次我们配置了一个service，并在osgi.command.scope中的value中指定值为sample，这就是我们先前写的scope，而在指定的osgi.command.function中指定的数组中的值，即为我们编写的几个方法名，如此配置完成之后，我们的command就基本完成了，现在只需要重新在控制台mvn clean install -U -DskipTests之后，再次打开karaf的控制台，观察当前bundle的启动状态，以及我们编写的command。    
运行  
打开karaf控制台，输入list，bundle运行状态如下所示： 

![upload successful](/images/pasted-58.png)

其中ID为13的，name为Storage的这一个state为Active，说明Bundle正常启动，现在尝试运行我们编写的命令，输入sample，这是我们之前定义的scope，按下tab键，有以下提示: 

![upload successful](/images/pasted-59.png)  

在提示中，三个方法依次提示出来，我们执行sample:first,sample:second都将会在控制台中打出内容，如下所示：   


![upload successful](/images/pasted-60.png)  

以上依次执行我们方法中的内容，现在开始我们的方法3即sample:hello,在输入以上命令后，按下tab键，此时并没有什么提示，但是我们却是需要输入一个参数，这个提示在上一篇中的command的定义方法，并指定一个参数，并编写相关方法后确实是有提示的这个稍后再提，在我们输入sample:hello world后，控制台打出的内容为：   


![upload successful](/images/pasted-61.png)  

如此，带有参数的命令也正常执行了。

其他实现

其实在实现带有参数的命令中，还有另外一种实现，在此可以说一下，这里提供了另外一种注解，即为@Argument,将这个加在我们在命令中的参数上，就像是以下这样：
```
@Argument(index = 0, name = "arg", description = "the command argument", required = false, multiValued = false)
String arg;
```  
然后还需要一个completer类，在这作为对参数的提示，我编写的如下所示：  
```
/**
 * Created by xiaxuan on 16/7/6.
 * a simple Completer
 */
public class SimpleCompeter implements Completer {

    public int complete(String buffer, int cursor, List&lt;String&gt; candidates) {
        StringsCompleter delegate = new StringsCompleter();
        delegate.getStrings().add("one");
        delegate.getStrings().add("two");
        delegate.getStrings().add("three");
        return delegate.complete(buffer, cursor, candidates);
    }
}
```
同时还需在blueprint.xml中的命令中配置相关的completer，如下：
```
&lt;command-bundle xmlns="http://karaf.apache.org/xmlns/shell/v1.0.0"&gt;
        &lt;command name="test/args"&gt;
            &lt;action class="cn.com.files.command.ArgsCommand"&gt;
            &lt;/action&gt;
            &lt;completers&gt;
                &lt;ref component-id="simpleCompleter"/&gt;
                &lt;null/&gt;
            &lt;/completers&gt;
        &lt;/command&gt;
    &lt;/command-bundle&gt;
```
如此也是完成了一个带有参数的命令，但是问题在于，我在karaf控制台中执行这个命令的时候，按下tab键的时候确实是有相关的提示，就是我们在completer中编写的one、two、three。但是输入其中任何一个，在控制台中输出的始终是null，我在看karaf源码的时候，karaf中的任意一个模块基本都是使用了大量的命令，我使用的方法和他们的类似，但是输出却是出了一定的问题，这个如果有过研究的人希望能与我探讨一下这个问题。

总结

   * 其实这种命令，在更多上，是属于自己的扩展，应用于制作第三方的客户端的较多，在平常应用的编写中，这种command编写的还是比较少，因为在生产环境中，多半已经把ssh登录限制了，所以基本不可能远程登录karaf控制台来执行自己的命令。

   * 在命令的使用上，更多还是使用后续讲解这一种命令较好，这种官方提供更多的支持，并且提供了许多种注解可以使用，可以加上@Argument,@Option等等。

   * 命令更多的只是对我们的应用程序的一种辅助，在真正的生产环境中，建议还是不要大量的运用这种命令，该用接口的还是使用接口实现。

