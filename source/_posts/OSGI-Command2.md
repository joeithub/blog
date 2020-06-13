title: OSGI Command2
author: Joe Tong
tags:
  - JAVAEE
  - OSGI
categories:
  - IT
date: 2019-07-27 10:48:00
---
OSGI中command的应用  

在上一篇博文中，我们讲解了osgi中的blueprint，但并没有对此作出具体的运用，在本文及以后将会在讲osgi中其他应用的时候将blueprint串进来讲解，本文将要讲讲解的是osgi中的command，在编写的应用中，可能涉及到数据迁移或者其他一些操作，如果这个通过调用接口来进行操作的话，如果非相关人员获取到相关接口调用方式，可能会带来一些危害，所以在不得已的情况下不会使用接口的方式，这个时候command的作用就体现出来了，如果自己编写数个命令，然后在运行容器的command中执行命令，就可以直接完成我们所需要的操作，下面我们就开始使用相关api完成我们所用的command。

相关程序

使用osgi的command必须在相关类中实现Action接口，这是felix提供的一个interface，具体为
`import org.apache.felix.gogo.commands.Action`   
在其实现的方法中写入我们所需要的程序逻辑，我们命令执行的内容都在这里，其中要提一下的是，并不只是可以s实现Action接口一种，还可以继承OsgiCommandSupport类，实现方法doExecute，也可以实现相同的效果，其中OsgiCommandSupport包名及类名为以下：  

`import org.apache.karaf.shell.console.OsgiCommandSupport`  
其实在这里面还有一种为:  
`org.apache.karaf.shell.api.action.Action`    
这个应该也是可以的，但是在使用的时候，karaf会报错，因此这个再次暂且不讲，等日后有机会搞清楚了再来说这个，我估计的话，现在最好实现的都是这一种，因为前两种都已经被不推荐使用了。
在实现相应的方法后，还需要在类上加上以下注解：  

```
@Service
@Log4j
@Command(scope = "test", name = "hello", description = "start for hello world")

```
@Log4j注解可有可无，在这主要是用来记录日志，加上@Service和@Command注解是必须的，标注为command和在karaf控制台中使用，里面具体参数使用可以查看到相应注解的源码，上面都有着详细的注释和说明。
commmand基本就是这么多东西，其中源码为：  
```
import lombok.extern.log4j.Log4j;
import org.apache.felix.gogo.commands.Action;
import org.apache.felix.service.command.CommandSession;
import org.apache.karaf.shell.api.action.Command;
import org.apache.karaf.shell.api.action.lifecycle.Service;

/**
 * Created by xiaxuan on 16/4/20.
 */
@Service
@Log4j
@Command(scope = "test", name = "hello", description = "start for hello world")
public class HelloCommand implements Action{

    public Object execute(CommandSession session) throws Exception {
        log.info("Hello word");
        return null;
    }
}

```
这个完成之后，还需要在blueprint.xml文件中配置command，如下所示：  
```
  <command-bundle xmlns="http://karaf.apache.org/xmlns/shell/v1.0.0">
        <command name="test/hello">
            <action class="cn.com.files.command.HelloCommand"></action>
        </command>
    </command-bundle>
```

程序运行
在启动容器之后，在命令行中，打开karaf客户端，为以下： 

![upload successful](/images/pasted-54.png)
首先输入list命令，确保bundle正常启动，本示例写在storage这个bundle中，为以下： 

![upload successful](/images/pasted-55.png)
id为13的bundle的状态为active，可以确定我们的bundle处于活跃状态，现在控制台输入test，为我们之前command的scope，按tab键，提示如下：

![upload successful](/images/pasted-56.png)
有多个提示，第一个可以不用理会，第二个即为我们编写的command命令，第三个为之后我将要讲述的。
控制台输入test:hello，查看控制台输出： 
![upload successful](/images/pasted-57.png)
控制台得到正常输出结果，hello world,命令执行正常。

使用规范及其他

   * 个人在使用command上，更多是使用在数据导入或者数据修复的时候使用，正常的业务逻辑一般不会使用command来实现。

   * 我在以上使用的command实现的接口或者继承的类中，两个都是已经过时的接口或者抽象类，现在一般通常使用的应该是karaf的那一个Action，但是在使用上可能会有些问题，个人认为可能是在配置上和当前有所区别，应该和注解无关，在@Service注解中的注释中，还提到了karaf的这一个Action类。但是本文在此没有使用这个Action，望有使用过的可以和我讨论一下。

   * command可以实现接口或者继承类来做到，也可以自定义自己的command，然后在blueprint做相关的配置即可，要比上述编写的command稍微简单点，用法也多样化一点。

   * 在上述command中，command可以传入参数，并且参数可以有多个，这个在下一篇博文中或许会有所提及。

   * 以上编写的command，都是基于karaf容器来运行的。
