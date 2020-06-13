title: springboot 日志
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - LOG
categories:
  - IT
date: 2019-09-19 15:11:00
---
SpringBoot默认日志框架配置
今天来介绍下Spring Boot如何配置日志logback,我刚学习的时候，是带着下面几个问题来查资料的，你呢

如何引入日志？

日志输出格式以及输出方式如何配置？

代码中如何使用？

正文
Spring Boot在所有内部日志中使用Commons Logging，但是默认配置也提供了对常用日志的支持，如：Java Util Logging，Log4J, Log4J2和Logback。每种Logger都可以通过配置使用控制台或者文件输出日志内容。

默认日志Logback
SLF4J——Simple Logging Facade For Java，它是一个针对于各类Java日志框架的统一Facade抽象。Java日志框架众多——常用的有java.util.logging, log4j, logback，commons-logging, Spring框架使用的是Jakarta Commons Logging API (JCL)。而SLF4J定义了统一的日志抽象接口，而真正的日志实现则是在运行时决定的——它提供了各类日志框架的binding。

Logback是log4j框架的作者开发的新一代日志框架，它效率更高、能够适应诸多的运行环境，同时天然支持SLF4J。

默认情况下，Spring Boot会用Logback来记录日志，并用INFO级别输出到控制台。在运行应用程序和其他例子时，你应该已经看到很多INFO级别的日志了。


![upload successful](/images/pasted-144.png)

从上图可以看到，日志输出内容元素具体如下：

时间日期：精确到毫秒

日志级别：ERROR, WARN, INFO, DEBUG or TRACE

进程ID

分隔符：--- 标识实际日志的开始

线程名：方括号括起来（可能会截断控制台输出）

Logger名：通常使用源代码的类名  

日志内容  

默认配置属性支持  

Spring Boot为我们提供了很多默认的日志配置，所以，只要将spring-boot-starter-logging作为依赖加入到当前应用的classpath，则“开箱即用”。

下面介绍几种在application.properties就可以配置的日志相关属性。

控制台输出

日志级别从低到高分为TRACE &lt; DEBUG &lt; INFO &lt; WARN &lt; ERROR &lt; FATAL，如果设置为WARN，则低于WARN的信息都不会输出。

Spring Boot中默认配置ERROR、WARN和INFO级别的日志输出到控制台。您还可以通过启动您的应用程序--debug标志来启用“调试”模式（开发的时候推荐开启）,以下两种方式皆可：

在运行命令后加入--debug标志，如：$ java -jar springTest.jar --debug

在application.properties中配置debug=true，该属性置为true的时候，核心Logger（包含嵌入式容器、hibernate、spring）会输出更多内容，但是你自己应用的日志并不会输出为DEBUG级别。

文件输出

默认情况下，Spring Boot将日志输出到控制台，不会写到日志文件。如果要编写除控制台输出之外的日志文件，则需在application.properties中设置logging.file或logging.path属性。

logging.file，设置文件，可以是绝对路径，也可以是相对路径。如：logging.file=my.log

logging.path，设置目录，会在该目录下创建spring.log文件，并写入日志内容，如：logging.path=/var/log  

如果只配置 logging.file，会在项目的当前路径下生成一个 xxx.log 日志文件。  

如果只配置 logging.path，在 /var/log文件夹生成一个日志文件为 spring.log  

注：二者不能同时使用，如若同时使用，则只有logging.file生效  

默认情况下，日志文件的大小达到10MB时会切分一次，产生新的日志文件，默认级别为：ERROR、WARN、INFO

级别控制  
所有支持的日志记录系统都可以在Spring环境中设置记录级别（例如在application.properties中）

格式为：'logging.level.* = LEVEL'

logging.level：日志级别控制前缀，*为包名或Logger名

LEVEL：选项TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF

举例：

logging.level.com.dudu=DEBUG：com.dudu包下所有class以DEBUG级别输出

logging.level.root=WARN：root日志以WARN级别输出

自定义日志配置
由于日志服务一般都在ApplicationContext创建前就初始化了，它并不是必须通过Spring的配置文件控制。因此通过系统属性和传统的Spring Boot外部配置文件依然可以很好的支持日志控制和管理。

根据不同的日志系统，你可以按如下规则组织配置文件名，就能被正确加载：

Logback：logback-spring.xml, logback-spring.groovy, logback.xml, logback.groovy

Log4j：log4j-spring.properties, log4j-spring.xml, log4j.properties, log4j.xml

Log4j2：log4j2-spring.xml, log4j2.xml

JDK (Java Util Logging)：logging.properties

Spring Boot官方推荐优先使用带有-spring的文件名作为你的日志配置（如使用logback-spring.xml，而不是logback.xml），命名为logback-spring.xml的日志配置文件，spring boot可以为它添加一些spring boot特有的配置项（下面会提到）。

上面是默认的命名规则，并且放在src/main/resources下面即可。

如果你即想完全掌控日志配置，但又不想用logback.xml作为Logback配置的名字，可以通过logging.config属性指定自定义的名字：

logging.config=classpath:logging-config.xml
虽然一般并不需要改变配置文件的名字，但是如果你想针对不同运行时Profile使用不同的日

志配置，这个功能会很有用。

下面我们来看看一个普通的logback-spring.xml例子


![upload successful](/images/pasted-145.png)

根节点&lt;configuration&gt;包含的属性
scan:当此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认值为true。

scanPeriod:设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。当scan为true时，此属性生效。默认的时间间隔为1分钟。

debug:当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。

根节点&lt;configuration&gt;的子节点：

&lt;configuration&gt;下面一共有2个属性，3个子节点，分别是：

属性一：设置上下文名称&lt;contextName&gt;
每个logger都关联到logger上下文，默认上下文名称为“default”。但可以使用&lt;contextName&gt;设置成其他名字，用于区分不同应用程序的记录。一旦设置，不能修改,可以通过%contextName来打印日志上下文名称。

&lt;contextName&gt;logback&lt;/contextName&gt;
属性二：设置变量&lt;property&gt;
用来定义变量值的标签，&lt;property&gt; 有两个属性，name和value；其中name的值是变量的名称，value的值时变量定义的值。通过&lt;property&gt;定义的值会被插入到logger上下文中。定义变量后，可以使“${}”来使用变量。

&lt;property name="log.path" value="E:\\logback.log" /&gt;
子节点一&lt;appender&gt;
appender用来格式化日志输出节点，有俩个属性name和class，class用来指定哪种输出策略，常用就是控制台输出策略和文件输出策略。

控制台输出ConsoleAppender：


![upload successful](/images/pasted-146.png)

&lt;encoder&gt;表示对日志进行编码：

%d{HH: mm:ss.SSS}——日志输出时间

%thread——输出日志的进程名字，这在Web应用以及异步任务处理中很有用

%-5level——日志级别，并且使用5个字符靠左对齐

%logger{36}——日志输出者的名字

%msg——日志消息

%n——平台的换行符

ThresholdFilter为系统定义的拦截器，例如我们用ThresholdFilter来过滤掉ERROR级别以下的日志不输出到文件中。如果不用记得注释掉，不然你控制台会发现没日志~

输出到文件RollingFileAppender
另一种常见的日志输出到文件，随着应用的运行时间越来越长，日志也会增长的越来越多，将他们输出到同一个文件并非一个好办法。RollingFileAppender用于切分文件日志：


![upload successful](/images/pasted-147.png)

其中重要的是rollingPolicy的定义，上例中&lt;fileNamePattern&gt;logback.%d{yyyy-MM-dd}.log&lt;/fileNamePattern&gt;定义了日志的切分方式——把每一天的日志归档到一个文件中，&lt;maxHistory&gt;30&lt;/maxHistory&gt;表示只保留最近30天的日志，以防止日志填满整个磁盘空间。同理，可以使用%d{yyyy-MM-dd_HH-mm}来定义精确到分的日志切分方式。&lt;totalSizeCap&gt;1GB&lt;/totalSizeCap&gt;用来指定日志文件的上限大小，例如设置为1GB的话，那么到了这个值，就会删除旧的日志。

子节点二&lt;root&gt;
root节点是必选节点，用来指定最基础的日志输出级别，只有一个level属性。

level:用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，不能设置为INHERITED或者同义词NULL，默认是DEBUG。

&lt;root&gt;可以包含零个或多个&lt;appender-ref&gt;元素，标识这个appender将会添加到这个loger。


![upload successful](/images/pasted-148.png)

子节点三&lt;loger&gt;
&lt;loger&gt;用来设置某一个包或者具体的某一个类的日志打印级别、以及指定&lt;appender&gt;。&lt;loger&gt;仅有一个name属性，一个可选的level和一个可选的addtivity属性。

name:用来指定受此loger约束的某一个包或者具体的某一个类。

level:用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，还有一个特俗值INHERITED或者同义词NULL，代表强制执行上级的级别。如果未设置此属性，那么当前loger将会继承上级的级别。

addtivity:是否向上级loger传递打印信息。默认是true。

loger在实际使用的时候有两种情况，先来看一看代码中如何使用：


![upload successful](/images/pasted-149.png)

这是一个登录的判断的方法，我们引入日志，并且打印不同级别的日志，然后根据logback-spring.xml中的配置来看看打印了哪几种级别日志。

第一种：带有loger的配置，不指定级别，不指定appender
&lt;logger name="com.dudu.controller"/&gt;
&lt;logger name="com.dudu.controller" /&gt;将控制controller包下的所有类的日志的打印，但是并没用设置打印级别，所以继承他的上级&lt;root&gt;的日志级别“info”；

没有设置addtivity，默认为true，将此loger的打印信息向上级传递；

没有设置appender，此loger本身不打印任何信息。

&lt;root level="info"&gt;将root的打印级别设置为“info”，指定了名字为“console”的appender。

当执行com.dudu.controller.LearnController类的login方法时，LearnController 在包com.dudu.controller中，所以首先执行&lt;logger name="com.dudu.controller"/&gt;，将级别为“info”及大于“info”的日志信息传递给root，本身并不打印；

root接到下级传递的信息，交给已经配置好的名为“console”的appender处理，“console”appender将信息打印到控制台；

打印结果如下：


![upload successful](/images/pasted-150.png)

第二种：带有多个loger的配置，指定级别，指定appender


![upload successful](/images/pasted-151.png)

控制com.dudu.controller.LearnController类的日志打印，打印级别为“WARN”

additivity属性为false，表示此loger的打印信息不再向上级传递

指定了名字为“console”的appender

这时候执行com.dudu.controller.LearnController类的login方法时，先执行&lt;logger name="com.dudu.controller.LearnController" level="WARN" additivity="false"&gt;,

将级别为“WARN”及大于“WARN”的日志信息交给此loger指定的名为“console”的appender处理，在控制台中打出日志，不再向上级root传递打印信息。

打印结果如下：


![upload successful](/images/pasted-152.png)

当然如果你把additivity="false"改成additivity="true"的话，就会打印两次，因为打印信息向上级传递，logger本身打印一次，root接到后又打印一次。

多环境日志输出
据不同环境（prod:生产环境，test:测试环境，dev:开发环境）来定义不同的日志输出，在 logback-spring.xml中使用 springProfile 节点来定义，方法如下：

文件名称不是logback.xml，想使用spring扩展profile支持，要以logback-spring.xml命名


![upload successful](/images/pasted-153.png)

可以启动服务的时候指定 profile （如不指定使用默认），如指定prod 的方式为：

java -jar xxx.jar --spring.profiles.active=prod

关于多环境配置可以参考

Spring Boot干货系列：（二）配置文件解析

总结
到此为止终于介绍完日志框架了，平时使用的时候推荐用自定义logback-spring.xml来配置，代码中使用日志也很简单，类里面添加private Logger logger = LoggerFactory.getLogger(this.getClass());即可。


```
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!-- 日志级别从低到高分为TRACE &lt; DEBUG &lt; INFO &lt; WARN &lt; ERROR &lt; FATAL，如果设置为WARN，则低于WARN的信息都不会输出 --&gt;
&lt;!-- scan:当此属性设置为true时，配置文档如果发生改变，将会被重新加载，默认值为true --&gt;
&lt;!-- scanPeriod:设置监测配置文档是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。
                 当scan为true时，此属性生效。默认的时间间隔为1分钟。 --&gt;
&lt;!-- debug:当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。 --&gt;
&lt;configuration  scan="true" scanPeriod="10 seconds"&gt;
    &lt;contextName&gt;logback&lt;/contextName&gt;
 
    &lt;!-- name的值是变量的名称，value的值时变量定义的值。通过定义的值会被插入到logger上下文中。定义后，可以使“${}”来使用变量。 --&gt;
    &lt;property name="log.path" value="G:/logs/pmp" /&gt;
 
    &lt;!--0. 日志格式和颜色渲染 --&gt;
    &lt;!-- 彩色日志依赖的渲染类 --&gt;
    &lt;conversionRule conversionWord="clr" converterClass="org.springframework.boot.logging.logback.ColorConverter" /&gt;
    &lt;conversionRule conversionWord="wex" converterClass="org.springframework.boot.logging.logback.WhitespaceThrowableProxyConverter" /&gt;
    &lt;conversionRule conversionWord="wEx" converterClass="org.springframework.boot.logging.logback.ExtendedWhitespaceThrowableProxyConverter" /&gt;
    &lt;!-- 彩色日志格式 --&gt;
    &lt;property name="CONSOLE_LOG_PATTERN" value="${CONSOLE_LOG_PATTERN:-%clr(%d{yyyy-MM-dd HH:mm:ss.SSS}){faint} %clr(${LOG_LEVEL_PATTERN:-%5p}) %clr(${PID:- }){magenta} %clr(---){faint} %clr([%15.15t]){faint} %clr(%-40.40logger{39}){cyan} %clr(:){faint} %m%n${LOG_EXCEPTION_CONVERSION_WORD:-%wEx}}"/&gt;
 
    &lt;!--1. 输出到控制台--&gt;
    &lt;appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender"&gt;
        &lt;!--此日志appender是为开发使用，只配置最底级别，控制台输出的日志级别是大于或等于此级别的日志信息--&gt;
        &lt;filter class="ch.qos.logback.classic.filter.ThresholdFilter"&gt;
            &lt;level&gt;info&lt;/level&gt;
        &lt;/filter&gt;
        &lt;encoder&gt;
            &lt;Pattern&gt;${CONSOLE_LOG_PATTERN}&lt;/Pattern&gt;
            &lt;!-- 设置字符集 --&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt;
        &lt;/encoder&gt;
    &lt;/appender&gt;
 
    &lt;!--2. 输出到文档--&gt;
    &lt;!-- 2.1 level为 DEBUG 日志，时间滚动输出  --&gt;
    &lt;appender name="DEBUG_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"&gt;
        &lt;!-- 正在记录的日志文档的路径及文档名 --&gt;
        &lt;file&gt;${log.path}/web_debug.log&lt;/file&gt;
        &lt;!--日志文档输出格式--&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n&lt;/pattern&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt; &lt;!-- 设置字符集 --&gt;
        &lt;/encoder&gt;
        &lt;!-- 日志记录器的滚动策略，按日期，按大小记录 --&gt;
        &lt;rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"&gt;
            &lt;!-- 日志归档 --&gt;
            &lt;fileNamePattern&gt;${log.path}/web-debug-%d{yyyy-MM-dd}.%i.log&lt;/fileNamePattern&gt;
            &lt;timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP"&gt;
                &lt;maxFileSize&gt;100MB&lt;/maxFileSize&gt;
            &lt;/timeBasedFileNamingAndTriggeringPolicy&gt;
            &lt;!--日志文档保留天数--&gt;
            &lt;maxHistory&gt;15&lt;/maxHistory&gt;
        &lt;/rollingPolicy&gt;
        &lt;!-- 此日志文档只记录debug级别的 --&gt;
        &lt;filter class="ch.qos.logback.classic.filter.LevelFilter"&gt;
            &lt;level&gt;debug&lt;/level&gt;
            &lt;onMatch&gt;ACCEPT&lt;/onMatch&gt;
            &lt;onMismatch&gt;DENY&lt;/onMismatch&gt;
        &lt;/filter&gt;
    &lt;/appender&gt;
 
    &lt;!-- 2.2 level为 INFO 日志，时间滚动输出  --&gt;
    &lt;appender name="INFO_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"&gt;
        &lt;!-- 正在记录的日志文档的路径及文档名 --&gt;
        &lt;file&gt;${log.path}/web_info.log&lt;/file&gt;
        &lt;!--日志文档输出格式--&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n&lt;/pattern&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt;
        &lt;/encoder&gt;
        &lt;!-- 日志记录器的滚动策略，按日期，按大小记录 --&gt;
        &lt;rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"&gt;
            &lt;!-- 每天日志归档路径以及格式 --&gt;
            &lt;fileNamePattern&gt;${log.path}/web-info-%d{yyyy-MM-dd}.%i.log&lt;/fileNamePattern&gt;
            &lt;timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP"&gt;
                &lt;maxFileSize&gt;100MB&lt;/maxFileSize&gt;
            &lt;/timeBasedFileNamingAndTriggeringPolicy&gt;
            &lt;!--日志文档保留天数--&gt;
            &lt;maxHistory&gt;15&lt;/maxHistory&gt;
        &lt;/rollingPolicy&gt;
        &lt;!-- 此日志文档只记录info级别的 --&gt;
        &lt;filter class="ch.qos.logback.classic.filter.LevelFilter"&gt;
            &lt;level&gt;info&lt;/level&gt;
            &lt;onMatch&gt;ACCEPT&lt;/onMatch&gt;
            &lt;onMismatch&gt;DENY&lt;/onMismatch&gt;
        &lt;/filter&gt;
    &lt;/appender&gt;
 
    &lt;!-- 2.3 level为 WARN 日志，时间滚动输出  --&gt;
    &lt;appender name="WARN_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"&gt;
        &lt;!-- 正在记录的日志文档的路径及文档名 --&gt;
        &lt;file&gt;${log.path}/web_warn.log&lt;/file&gt;
        &lt;!--日志文档输出格式--&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n&lt;/pattern&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt; &lt;!-- 此处设置字符集 --&gt;
        &lt;/encoder&gt;
        &lt;!-- 日志记录器的滚动策略，按日期，按大小记录 --&gt;
        &lt;rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"&gt;
            &lt;fileNamePattern&gt;${log.path}/web-warn-%d{yyyy-MM-dd}.%i.log&lt;/fileNamePattern&gt;
            &lt;timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP"&gt;
                &lt;maxFileSize&gt;100MB&lt;/maxFileSize&gt;
            &lt;/timeBasedFileNamingAndTriggeringPolicy&gt;
            &lt;!--日志文档保留天数--&gt;
            &lt;maxHistory&gt;15&lt;/maxHistory&gt;
        &lt;/rollingPolicy&gt;
        &lt;!-- 此日志文档只记录warn级别的 --&gt;
        &lt;filter class="ch.qos.logback.classic.filter.LevelFilter"&gt;
            &lt;level&gt;warn&lt;/level&gt;
            &lt;onMatch&gt;ACCEPT&lt;/onMatch&gt;
            &lt;onMismatch&gt;DENY&lt;/onMismatch&gt;
        &lt;/filter&gt;
    &lt;/appender&gt;
 
    &lt;!-- 2.4 level为 ERROR 日志，时间滚动输出  --&gt;
    &lt;appender name="ERROR_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"&gt;
        &lt;!-- 正在记录的日志文档的路径及文档名 --&gt;
        &lt;file&gt;${log.path}/web_error.log&lt;/file&gt;
        &lt;!--日志文档输出格式--&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n&lt;/pattern&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt; &lt;!-- 此处设置字符集 --&gt;
        &lt;/encoder&gt;
        &lt;!-- 日志记录器的滚动策略，按日期，按大小记录 --&gt;
        &lt;rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"&gt;
            &lt;fileNamePattern&gt;${log.path}/web-error-%d{yyyy-MM-dd}.%i.log&lt;/fileNamePattern&gt;
            &lt;timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP"&gt;
                &lt;maxFileSize&gt;100MB&lt;/maxFileSize&gt;
            &lt;/timeBasedFileNamingAndTriggeringPolicy&gt;
            &lt;!--日志文档保留天数--&gt;
            &lt;maxHistory&gt;15&lt;/maxHistory&gt;
        &lt;/rollingPolicy&gt;
        &lt;!-- 此日志文档只记录ERROR级别的 --&gt;
        &lt;filter class="ch.qos.logback.classic.filter.LevelFilter"&gt;
            &lt;level&gt;ERROR&lt;/level&gt;
            &lt;onMatch&gt;ACCEPT&lt;/onMatch&gt;
            &lt;onMismatch&gt;DENY&lt;/onMismatch&gt;
        &lt;/filter&gt;
    &lt;/appender&gt;
 
    &lt;!--
        &lt;logger&gt;用来设置某一个包或者具体的某一个类的日志打印级别、
        以及指定&lt;appender&gt;。&lt;logger&gt;仅有一个name属性，
        一个可选的level和一个可选的addtivity属性。
        name:用来指定受此logger约束的某一个包或者具体的某一个类。
        level:用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，
              还有一个特俗值INHERITED或者同义词NULL，代表强制执行上级的级别。
              如果未设置此属性，那么当前logger将会继承上级的级别。
        addtivity:是否向上级logger传递打印信息。默认是true。
        &lt;logger name="org.springframework.web" level="info"/&gt;
        &lt;logger name="org.springframework.scheduling.annotation.ScheduledAnnotationBeanPostProcessor" level="INFO"/&gt;
    --&gt;
 
    &lt;!--
        使用mybatis的时候，sql语句是debug下才会打印，而这里我们只配置了info，所以想要查看sql语句的话，有以下两种操作：
        第一种把&lt;root level="info"&gt;改成&lt;root level="DEBUG"&gt;这样就会打印sql，不过这样日志那边会出现很多其他消息
        第二种就是单独给dao下目录配置debug模式，代码如下，这样配置sql语句会打印，其他还是正常info级别：
        【logging.level.org.mybatis=debug logging.level.dao=debug】
     --&gt;
 
    &lt;!--
        root节点是必选节点，用来指定最基础的日志输出级别，只有一个level属性
        level:用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，
        不能设置为INHERITED或者同义词NULL。默认是DEBUG
        可以包含零个或多个元素，标识这个appender将会添加到这个logger。
    --&gt;
 
    &lt;!-- 4. 最终的策略 --&gt;
    &lt;!-- 4.1 开发环境:打印控制台--&gt;
    &lt;springProfile name="dev"&gt;
        &lt;logger name="com.sdcm.pmp" level="debug"/&gt;
    &lt;/springProfile&gt;
 
    &lt;root level="info"&gt;
        &lt;appender-ref ref="CONSOLE" /&gt;
        &lt;appender-ref ref="DEBUG_FILE" /&gt;
        &lt;appender-ref ref="INFO_FILE" /&gt;
        &lt;appender-ref ref="WARN_FILE" /&gt;
        &lt;appender-ref ref="ERROR_FILE" /&gt;
    &lt;/root&gt;
 
    &lt;!-- 4.2 生产环境:输出到文档
    &lt;springProfile name="pro"&gt;
        &lt;root level="info"&gt;
            &lt;appender-ref ref="CONSOLE" /&gt;
            &lt;appender-ref ref="DEBUG_FILE" /&gt;
            &lt;appender-ref ref="INFO_FILE" /&gt;
            &lt;appender-ref ref="ERROR_FILE" /&gt;
            &lt;appender-ref ref="WARN_FILE" /&gt;
        &lt;/root&gt;
    &lt;/springProfile&gt; --&gt;
 
&lt;/configuration&gt;
```
