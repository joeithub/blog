title: Springboot整合Logback日志
author: Joe Tong
tags:
  - JAVAEE
  - SPINTBOOT
  - LOGBACK
categories:
  - IT
date: 2019-09-20 09:28:00
---
（一）添加依赖
  Springboot2.0自动整合了logback和log4j2，所以无需引入相关依赖。

（二）创建logback配置文件
  首先，官方推荐使用的xml名字的格式为：logback-spring.xml而不是logback.xml，至于为什么，因为带spring后缀的可以使用&lt;springProfile&gt;这个标签（PS：这个标签用于切换“开发环境”和“生产环境”）。

```
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!-- 日志级别从低到高分为TRACE &lt; DEBUG &lt; INFO &lt; WARN &lt; ERROR &lt; FATAL，如果设置为WARN，则低于WARN的信息都不会输出 --&gt;
&lt;!-- scan:当此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认值为true --&gt;
&lt;!-- scanPeriod:设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。当scan为true时，此属性生效。默认的时间间隔为1分钟。 --&gt;
&lt;!-- debug:当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。 --&gt;
&lt;configuration  scan="true" scanPeriod="10 seconds"&gt;

    &lt;contextName&gt;logback&lt;/contextName&gt;
    &lt;!-- name的值是变量的名称，value的值时变量定义的值。通过定义的值会被插入到logger上下文中。定义变量后，可以使“${}”来使用变量。 --&gt;
    &lt;!-- 日志文件的输出路径 --&gt;
    &lt;property name="log.path" value="E:/log" /&gt;

    &lt;!-- 彩色日志 --&gt;
    &lt;!-- 彩色日志依赖的渲染类 --&gt;
    &lt;conversionRule conversionWord="clr" converterClass="org.springframework.boot.logging.logback.ColorConverter" /&gt;
    &lt;conversionRule conversionWord="wex" converterClass="org.springframework.boot.logging.logback.WhitespaceThrowableProxyConverter" /&gt;
    &lt;conversionRule conversionWord="wEx" converterClass="org.springframework.boot.logging.logback.ExtendedWhitespaceThrowableProxyConverter" /&gt;
    &lt;!-- 彩色日志格式 --&gt;
    &lt;property name="CONSOLE_LOG_PATTERN" value="${CONSOLE_LOG_PATTERN:-%clr(%d{yyyy-MM-dd HH:mm:ss.SSS}){faint} %clr(${LOG_LEVEL_PATTERN:-%5p}) %clr(${PID:- }){magenta} %clr(---){faint} %clr([%15.15t]){faint} %clr(%-40.40logger{39}){cyan} %clr(:){faint} %m%n${LOG_EXCEPTION_CONVERSION_WORD:-%wEx}}"/&gt;


    &lt;!--输出到控制台--&gt;
    &lt;appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender"&gt;
        &lt;!--此日志appender是为开发使用，只配置最底级别，控制台输出的日志级别是大于或等于此级别的日志信息--&gt;
        &lt;filter class="ch.qos.logback.classic.filter.ThresholdFilter"&gt;
            &lt;level&gt;debug&lt;/level&gt;
        &lt;/filter&gt;
        &lt;encoder&gt;
            &lt;!--彩色日志--&gt;
            &lt;!--&lt;Pattern&gt;${CONSOLE_LOG_PATTERN}&lt;/Pattern&gt;--&gt;
            &lt;!--普通日志--&gt;
            &lt;Pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n&lt;/Pattern&gt;
            &lt;!-- 设置字符集 --&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt;
        &lt;/encoder&gt;
    &lt;/appender&gt;


    &lt;!--输出到文件--&gt;

    &lt;!-- 时间滚动输出 level为 DEBUG 日志 --&gt;
    &lt;appender name="DEBUG_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"&gt;
        &lt;!-- 正在记录的日志文件的路径及文件名 --&gt;
        &lt;file&gt;${log.path}/log_debug.log&lt;/file&gt;
        &lt;!--日志文件输出格式--&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n&lt;/pattern&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt; &lt;!-- 设置字符集 --&gt;
        &lt;/encoder&gt;
        &lt;!-- 日志记录器的滚动策略，按日期，按大小记录 --&gt;
        &lt;rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"&gt;
            &lt;!-- 日志归档 --&gt;
            &lt;fileNamePattern&gt;${log.path}/debug/log-debug-%d{yyyy-MM-dd}.%i.log&lt;/fileNamePattern&gt;
            &lt;timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP"&gt;
                &lt;maxFileSize&gt;100MB&lt;/maxFileSize&gt;
            &lt;/timeBasedFileNamingAndTriggeringPolicy&gt;
            &lt;!--日志文件保留天数--&gt;
            &lt;maxHistory&gt;15&lt;/maxHistory&gt;
        &lt;/rollingPolicy&gt;
        &lt;!-- 此日志文件只记录debug级别的 --&gt;
        &lt;filter class="ch.qos.logback.classic.filter.LevelFilter"&gt;
            &lt;level&gt;debug&lt;/level&gt;
            &lt;onMatch&gt;ACCEPT&lt;/onMatch&gt;
            &lt;onMismatch&gt;DENY&lt;/onMismatch&gt;
        &lt;/filter&gt;
    &lt;/appender&gt;

    &lt;!-- 时间滚动输出 level为 INFO 日志 --&gt;
    &lt;appender name="INFO_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"&gt;
        &lt;!-- 正在记录的日志文件的路径及文件名 --&gt;
        &lt;file&gt;${log.path}/log_info.log&lt;/file&gt;
        &lt;!--日志文件输出格式--&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n&lt;/pattern&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt;
        &lt;/encoder&gt;
        &lt;!-- 日志记录器的滚动策略，按日期，按大小记录 --&gt;
        &lt;rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"&gt;
            &lt;!-- 每天日志归档路径以及格式 --&gt;
            &lt;fileNamePattern&gt;${log.path}/info/log-info-%d{yyyy-MM-dd}.%i.log&lt;/fileNamePattern&gt;
            &lt;timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP"&gt;
                &lt;maxFileSize&gt;100MB&lt;/maxFileSize&gt;
            &lt;/timeBasedFileNamingAndTriggeringPolicy&gt;
            &lt;!--日志文件保留天数--&gt;
            &lt;maxHistory&gt;15&lt;/maxHistory&gt;
        &lt;/rollingPolicy&gt;
        &lt;!-- 此日志文件只记录info级别的 --&gt;
        &lt;filter class="ch.qos.logback.classic.filter.LevelFilter"&gt;
            &lt;level&gt;info&lt;/level&gt;
            &lt;onMatch&gt;ACCEPT&lt;/onMatch&gt;
            &lt;onMismatch&gt;DENY&lt;/onMismatch&gt;
        &lt;/filter&gt;
    &lt;/appender&gt;

    &lt;!-- 时间滚动输出 level为 WARN 日志 --&gt;
    &lt;appender name="WARN_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"&gt;
        &lt;!-- 正在记录的日志文件的路径及文件名 --&gt;
        &lt;file&gt;${log.path}/log_warn.log&lt;/file&gt;
        &lt;!--日志文件输出格式--&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n&lt;/pattern&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt; &lt;!-- 此处设置字符集 --&gt;
        &lt;/encoder&gt;
        &lt;!-- 日志记录器的滚动策略，按日期，按大小记录 --&gt;
        &lt;rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"&gt;
            &lt;fileNamePattern&gt;${log.path}/warn/log-warn-%d{yyyy-MM-dd}.%i.log&lt;/fileNamePattern&gt;
            &lt;timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP"&gt;
                &lt;maxFileSize&gt;100MB&lt;/maxFileSize&gt;
            &lt;/timeBasedFileNamingAndTriggeringPolicy&gt;
            &lt;!--日志文件保留天数--&gt;
            &lt;maxHistory&gt;15&lt;/maxHistory&gt;
        &lt;/rollingPolicy&gt;
        &lt;!-- 此日志文件只记录warn级别的 --&gt;
        &lt;filter class="ch.qos.logback.classic.filter.LevelFilter"&gt;
            &lt;level&gt;warn&lt;/level&gt;
            &lt;onMatch&gt;ACCEPT&lt;/onMatch&gt;
            &lt;onMismatch&gt;DENY&lt;/onMismatch&gt;
        &lt;/filter&gt;
    &lt;/appender&gt;


    &lt;!-- 时间滚动输出 level为 ERROR 日志 --&gt;
    &lt;appender name="ERROR_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"&gt;
        &lt;!-- 正在记录的日志文件的路径及文件名 --&gt;
        &lt;file&gt;${log.path}/log_error.log&lt;/file&gt;
        &lt;!--日志文件输出格式--&gt;
        &lt;encoder&gt;
            &lt;pattern&gt;%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n&lt;/pattern&gt;
            &lt;charset&gt;UTF-8&lt;/charset&gt; &lt;!-- 此处设置字符集 --&gt;
        &lt;/encoder&gt;
        &lt;!-- 日志记录器的滚动策略，按日期，按大小记录 --&gt;
        &lt;rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"&gt;
            &lt;fileNamePattern&gt;${log.path}/error/log-error-%d{yyyy-MM-dd}.%i.log&lt;/fileNamePattern&gt;
            &lt;timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP"&gt;
                &lt;maxFileSize&gt;100MB&lt;/maxFileSize&gt;
            &lt;/timeBasedFileNamingAndTriggeringPolicy&gt;
            &lt;!--日志文件保留天数--&gt;
            &lt;maxHistory&gt;15&lt;/maxHistory&gt;
        &lt;/rollingPolicy&gt;
        &lt;!-- 此日志文件只记录ERROR级别的 --&gt;
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
    --&gt;
    &lt;!--&lt;logger name="org.pc.web" level="info"/&gt;--&gt;
    &lt;!--&lt;logger name="org.pc.scheduling.annotation.ScheduledAnnotationBeanPostProcessor" level="INFO"/&gt;--&gt;
    &lt;!--
        使用mybatis的时候，sql语句是debug下才会打印，而这里我们只配置了info，所以想要查看sql语句的话，有以下两种操作：
        第一种把&lt;root level="info"&gt;改成&lt;root level="DEBUG"&gt;这样就会打印sql，不过这样日志那边会出现很多其他消息
        第二种就是单独给dao下目录配置debug模式，代码如下，这样配置sql语句会打印，其他还是正常info级别：
     --&gt;
    &lt;!--&lt;logger name="org.pc.dao" level="info"/&gt;--&gt;

    &lt;!--开发环境:打印控制台 start--&gt;
    &lt;springProfile name="dev"&gt;
        &lt;logger name="org.pc" level="debug"/&gt;
    &lt;/springProfile&gt;
    &lt;!--
        root节点是必选节点，用来指定最基础的日志输出级别，只有一个level属性
        level:用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，
        不能设置为INHERITED或者同义词NULL。默认是DEBUG
        可以包含零个或多个元素，标识这个appender将会添加到这个logger。
    --&gt;
    &lt;root level="info"&gt;
        &lt;appender-ref ref="CONSOLE" /&gt;
        &lt;appender-ref ref="DEBUG_FILE" /&gt;
        &lt;appender-ref ref="INFO_FILE" /&gt;
        &lt;appender-ref ref="WARN_FILE" /&gt;
        &lt;appender-ref ref="ERROR_FILE" /&gt;
    &lt;/root&gt;
    &lt;!--开发环境:打印控制台 end--&gt;


    &lt;!--生产环境:输出到文件--&gt;
    &lt;!--&lt;springProfile name="pro"&gt;--&gt;
    &lt;!--&lt;root level="info"&gt;--&gt;
    &lt;!--&lt;appender-ref ref="CONSOLE" /&gt;--&gt;
    &lt;!--&lt;appender-ref ref="DEBUG_FILE" /&gt;--&gt;
    &lt;!--&lt;appender-ref ref="INFO_FILE" /&gt;--&gt;
    &lt;!--&lt;appender-ref ref="ERROR_FILE" /&gt;--&gt;
    &lt;!--&lt;appender-ref ref="WARN_FILE" /&gt;--&gt;
    &lt;!--&lt;/root&gt;--&gt;
    &lt;!--&lt;/springProfile&gt;--&gt;

&lt;/configuration&gt;
```

定义好几种级别的日志分别输出到哪些文件中，然后在root标签里加入
