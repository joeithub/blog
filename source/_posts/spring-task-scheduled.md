title: spring task @scheduled
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGTASK
categories:
  - IT
date: 2019-07-16 18:50:00
---
Spring 4.x Task 和 Schedule 概述  
摘要
在很多业务场景中，系统都需要用到任务调度系统。例如定期地清理Redis 缓存，周期性地检索某一条件并更新系统的资源等。在现代的应用系统中，快速地响应用户的请求，是用户体验最主要的因素之一。因此在Web 系统中异步地执行任务，也会在很多场景中经常涉及到。本文对任务调度和异步执行的Java 实现进行了总结，主要讲述一下内容：  
Java 对异步执行和任务调度的支持  
Spring 4.X 的异步执行和任务调度实现  
Java 对异步执行和任务调度的支持  
异步执行和任务调度底层的语言支撑都是Java 的多线程技术。线程是系统进行独立运行和调度的基本单位。拥有了多线程，系统就拥有了同时处理多项任务的能力。  
Java 实现异步调用  
在Java 中要实现多线程有实现Runnable 接口和扩展Thread 类两种方式。只要将需要异步执行的任务放在run() 方法中，在主线程中启动要执行任务的子线程就可以实现任务的异步执行。如果需要实现基于时间点触发的任务调度，就需要在子线程中循环的检查系统当前的时间跟触发条件是否一致，然后触发任务的执行。该内容属于Java 多线程的基础知识，此处略过不讲。  
Java Timer 和 TimeTask 实现任务调度  
为了便于开发者快速地实现任务调度，Java JDK 对任务调度的功能进行了封装，实现了Timer 和TimerTask 两个工具类。  
TimerTask 类   
由上图，我们可以看出TimeTask 抽象类在实现Runnable 接口的基础上增加了任务cancel() 和任务scheduledExecuttionTime() 两个方法。  
Timer 类   
上图为调度类Timer 的实现。从Timer类的源码，可以看到其采用TaskQueue 来实现对多个TimeTask 的管理。TimerThread 集成自Thread 类，其mainLoop() 用来对任务进行调度。而Timer 类提供了四种重载的schedule() 方法和重载了两种sheduleAtFixedRate() 方法来实现几种基本的任务调度类型。下面的代码是采用Timer 实现的定时系统时间打印程序。
```
public class PrintTimeTask extends TimerTask {
    @Override
        public void run() {
            System.out.println(new Date().toString());
        }
                    
    public static void main(String[] args) {
        Timer timer = new Timer("hello");
        timer.schedule(new PrintTimeTask(), 1000L, 2000L);
    }
}
```
Spring 4.x 中的异步执行和任务调度  
Spring 4.x 中的异步执行  
Spring 作为一站式框架，为开发者提供了异步执行和任务调度的抽象接口TaskExecutor 和TaskScheduler。Spring 对这些接口的实现类支持线程池(Thread Pool) 和代理。  
Spring 提供了对JDK 中Timer和开源的流行任务调度框架Quartz的支持。Spring 通过将关联的Schedule 转化为FactoryBean 来实现。通过Spring 调度框架，开发者可以快速地通过MethodInvokingFactoryBean 来实现将POJO 类的方法转化为任务。  
Spring TaskExecutor  
TaskExecutor 接口扩展自java.util.concurrent.Executor 接口。TaskExecutor 被创建来为其他组件提供线程池调用的抽象。  
ThreadPoolTaskExecutor 是TaskExecutor 的最主要实现类之一。该类的核心继承关系如下图所示。  
ThreadPooltaskexecutor 类   
ThreadPoolTaskExecutor 接口扩展了重多的接口，让其具备了更多的能力。要实现异步需要标注@Async 注解：  
AsyncTaskExecutor 增加了返回结果为Future 的submit() 方法，该方法的参数为Callable 接口。相比Runnable 接口，多了将执行结果返回的功能。  
AsyncListenableTaskExecutor 接口允许返回拥有回调功能的ListenableFuture 接口，这样在结果执行完毕是，能够直接回调处理。  
```
public class ListenableTask {
    @Async
    public ListenableFuture&lt;Integer&gt; compute(int n) {
        int sum = 0;
        for (int i = 0; i &lt; n; i++) {
            sum += i;
        }
        return new AsyncResult&lt;&gt;(sum);
    }

    static class CallBackImpl implements 
        ListenableFutureCallback&lt;Integer&gt; {
        @Override
        public void onFailure(Throwable ex) {
            System.out.println(ex.getMessage());
        }

        @Override
        public void onSuccess(Integer result) {
            System.out.println(result);
        }
    }

    public static void main(String[] args) {
        ListenableTask listenableTask = new ListenableTask();
        ListenableFuture&lt;Integer&gt; listenableFuture = 
            listenableTask.compute(10);
        listenableFuture.addCallback(new CallBackImpl());
    }
}
```
ThreadFactory 定义了创建线程的工厂方法，可以扩展该方法实现对Thread 的改造。
基于Java Config
基于注解 当采用基于Java Config 注解配置时，只需要在主配置添加@EnableAsync 注解，Spring 会自动的创建基于ThreadPoolTaskExecutor 实例注入到上下文中。
```
@Configuration
@EnableAsync
public class AppConfig {
}
```
基于AsyncConfigurer接口自定义 开发者可以自定义Executor 的类型，并且注册异常处理器。
```
@Configuration
public class TaskConfig implements AsyncConfigurer {
    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setMaxPoolSize(100);
        executor.setCorePoolSize(10);
        return executor;
    }

    @Override
    public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {
        return new AsyncUncaughtExceptionHandler() {
            @Override
            public void handleUncaughtException(Throwable ex, 
                                                Method method, Object... params) {
                System.out.println(ex.getMessage());
            }
        };
    }
}
```
基于XML Config
基于传统XML的配置 基于XML 的形式，采用传统的Java Bean的形式配置ThreadPoolTaskExecutor。然后采用自动注入(autowire, resource,name)的可以直接在Spring Component 中注入Executor。以编程的形式实现异步任务。
```
&lt;bean id="taskExecutor" class="org.springframework.scheduling.concurrent.
    ThreadPoolTaskExecutor"&gt;
    &lt;property name="corePoolSize" value="5" /&gt;
    &lt;property name="maxPoolSize" value="10" /&gt;
    &lt;property name="queueCapacity" value="25" /&gt;
&lt;/bean&gt;
```
基于task 命名空间的配置 Spring 为任务的执行提供了便利的task 命名空间。当采用基于XML 配置时Spring 会自动地为开发者创建Executor。同时可以在annotation-driven 标签上注册实现了AsyncUncaughtExceptionHandler 接口的异常处理器。
```
&lt;!-- config exception handler  --&gt;
&lt;bean id="taskAsyncExceptionHandler" class="org.zzy.spring4.application.schedulie.TaskAsyncExceptionHandler"/&gt;
&lt;task:annotation-driven exception-handler="taskAsyncExceptionHandler" scheduler="scheduler" executor="executor"/&gt;
```
异步执行的异常处理
除了上文提到的两种异常处理方式，Spring 还提供了基于SimpleApplicationEventMulticaster 类的异常处理方式。
```
@Bean
public SimpleApplicationEventMulticaster eventMulticaster(TaskExecutor taskExecutor) {
    SimpleApplicationEventMulticaster eventMulticaster = new SimpleApplicationEventMulticaster();
    eventMulticaster.setTaskExecutor(taskExecutor);
    eventMulticaster.setErrorHandler(new ErrorHandler() {
        @Override
        public void handleError(Throwable t) {
            System.out.println(t.getMessage());
        }
    });
    return eventMulticaster;
}
```
Spring 4.x 中任务调度实现
Spring 的任务调度主要基于TaskScheduler 接口。ThreadPoolTaskScheduler 是Spring 任务调度的核心实现类。该类提供了大量的重载方法进行任务调度。Trigger 定义了任务被执行的触发条件。Spring 提供了基于Corn 表达式的CornTrigger实现。TaskScheduler 如下图所示。

ThreadPoolTaskExecutor 类 
实现TaskScheduler 接口的ThreadPoolTaskExecutor 继承关系。

ThreadPoolTaskExecutor 类 
基于Java Config
基于注解的配置 当采用基于Java Config 注解配置时，只需要在主配置添加@EnableScheduling 注解，Spring 会自动的创建基于ThreadPoolTaskExecutor 实例注入到上下文中。
```
@Configuration
@EnableScheduling
public class AppConfig {
}
基于SchedulingConfigurer接口自定义
@Configuration
public class ScheduleConfig implements SchedulingConfigurer {
    @Override
    public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
        taskRegistrar.setTaskScheduler(new ThreadPoolTaskScheduler());
        taskRegistrar.getScheduler().schedule(new Runnable() {
            @Override
            public void run() {
                System.out.println("hello");
            }
        }, new CronTrigger("0 15 9-17 * * MON-FRI"));
    }
}
```
基于XML Config
&lt;task:annotation-driven scheduler="myScheduler"/&gt;
&lt;task:scheduler id="myScheduler" pool-size="10"/&gt;
@Scheduled 注解的使用
当某个Bean 由Spring 管理生命周期时，就可以方便的使用@Shcheduled 注解将该Bean 的方法准换为基于任务调度的策略。
```
@Scheduled(initialDelay=1000, fixedRate=5000)
public void doSomething() {
    // something that should execute periodically
}

@Scheduled(cron="*/5 * * * * MON-FRI")
public void doSomething() {
    // something that should execute on weekdays only
}
```
task 命名空间中的task:scheduled-tasks
该元素能够实现快速地将一个普通Bean 的方法转换为Scheduled 任务的途径。具体如下：
```
&lt;task:scheduled-tasks scheduler="myScheduler"&gt;
    &lt;task:scheduled ref="beanA" method="methodA" fixed-delay="5000" initial-delay="1000"/&gt;
    &lt;task:scheduled ref="beanB" method="methodB" fixed-rate="5000"/&gt;
    &lt;task:scheduled ref="beanC" method="methodC" cron="*/5 * * * * MON-FRI"/&gt;
&lt;/task:scheduled-tasks&gt;
&lt;task:scheduler id="myScheduler" pool-size="10"/&gt;
```
总结
本文着重介绍了JDK 为任务调度提供的基础类Timer。并在此基础上详细介绍了Spring 4.x 的异步执行和任务调度的底层接口设计。并针对常用的模式进行了讲解，并附带了源代码。第三方开源的Quartz 实现了更为强大的任务调度系统，Spring 也对集成Quartz 提供了转换。之后会择机再详细的介绍Quartz 的应用和设计原理。同时，Servlet 3.x 为Web 的异步调用提供了AsyncContext，对基于Web 的异步调用提供了原生的支持，后续的文章也会对此有相应的介绍。
