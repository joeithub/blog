title: spring task
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGTASK
categories:
  - IT
date: 2019-07-16 18:39:00
---
基于Spring Task的定时任务调度器实现  
在很多时候，我们会需要执行一些定时任务 ，Spring团队提供了Spring Task模块对定时任务的调度提供了支持，基于注解式的任务使用也非常方便。
只要跟需要定时执行的方法加上类似 @Scheduled(cron = "0 1 * *  *  *") 的注解就可以实现方法的定时执行。  
cron 是一种周期的表达式，六位从右至左分别对应的是年、月、日、时、分、秒，数字配合各种通配符可以表达种类丰富的定时执行周期。  
```
/**
* Cron Example patterns:
* &lt;li&gt;"0 0 * * * *" = the top of every hour of every day.&lt;/li&gt;
* &lt;li&gt;"0 0 8-10 * * *" = 8, 9 and 10 o'clock of every day.&lt;/li&gt;
* &lt;li&gt;"0 0/30 8-10 * * *" = 8:00, 8:30, 9:00, 9:30 and 10 o'clock every day.&lt;/li&gt;
* &lt;li&gt;"0 0 9-17 * * MON-FRI" = on the hour nine-to-five weekdays&lt;/li&gt;
* &lt;li&gt;"0 0 0 25 12 ?" = every Christmas Day at midnight&lt;/li&gt;
*/
基于注解的使用案列：

import org.springframework.stereotype.Component; 
   
@Component(“task”) 
public class Task { 
    @Scheduled(cron = "0 1 * * * *")  // 每分钟执行一次
    public void job1() { 
        System.out.println(“任务进行中。。。”); 
    } 
}

 ```
基于注解方式的定时任务，启动会依赖于系统的启动。如果需要通过代码或前台操作触发定时任务，就需要进行包装了。
下面是一个可以直接提供业务代码调用的定时任务调度器。调用 schedule(Runnable task, String cron) 传入要执行的任务
task和定时周期cron就可以了。注：基于注解方式需要在注解扫描范围内。
```
package com.louis.merak.schedule;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;
 
@Component
public class MerakTaskScheduler {
     
    @Autowired
    private ThreadPoolTaskScheduler threadPoolTaskScheduler;
     
    @Bean
    public ThreadPoolTaskScheduler threadPoolTaskScheduler(){
        return new ThreadPoolTaskScheduler();
    }
     
    /**
     * Cron Example patterns:
     * &lt;li&gt;"0 0 * * * *" = the top of every hour of every day.&lt;/li&gt;
     * &lt;li&gt;"0 0 8-10 * * *" = 8, 9 and 10 o'clock of every day.&lt;/li&gt;
     * &lt;li&gt;"0 0/30 8-10 * * *" = 8:00, 8:30, 9:00, 9:30 and 10 o'clock every day.&lt;/li&gt;
     * &lt;li&gt;"0 0 9-17 * * MON-FRI" = on the hour nine-to-five weekdays&lt;/li&gt;
     * &lt;li&gt;"0 0 0 25 12 ?" = every Christmas Day at midnight&lt;/li&gt;
     */
    public void schedule(Runnable task, String cron){
        if(cron == null || "".equals(cron)) {
            cron = "0 * * * * *";
        }
        threadPoolTaskScheduler.schedule(task, new CronTrigger(cron));
    }
     
    /**
     * shutdown and init
     * @param task
     * @param cron
     */
    public void reset(){
        threadPoolTaskScheduler.shutdown();
        threadPoolTaskScheduler.initialize();
    }
    
    /**
     * shutdown before a new schedule operation
     * @param task
     * @param cron
     */
    public void resetSchedule(Runnable task, String cron){
        shutdown();
        threadPoolTaskScheduler.initialize();
        schedule(task, cron);
    }
    
    /**
     * shutdown
     */
    public void shutdown(){
        threadPoolTaskScheduler.shutdown();
    }
}
```
 
如果是需要通过前台操作调用RESTful执行定时任务的调度，使用以下Controller即可。
```
package com.louis.merak.common.schedule;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MerakTaskSchedulerController {
    
    @Autowired
    MerakTaskScheduler taskScheduler;
    
    @RequestMapping("/schedule")
    public String schedule(@RequestParam String cron) {
　　　　 if(cron == null) {
　　　　　　 cron = "0/5 * * * * *";
        }
        Runnable runnable = new Runnable() {
            public void run() {
                String time = new SimpleDateFormat("yy-MM-dd HH:mm:ss").format(new Date());
                System.out.println("Test GETaskScheduler Success at "  + time);
            }
        };

        taskScheduler.schedule(runnable, cron);
        return "Test TaskScheduler Interface.";
    }
}
```
