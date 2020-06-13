title: springboot配置mvc和静态资源路径
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - SPRING MVC
categories:
  - IT
date: 2019-09-20 17:05:00
---
```
spring:  
#配置控制台允许彩色输出 ANSI是一种字符代码，为使计算机支持更多语言，通常使用 0x00~0x7f 范围的1 个字节来表示 1 个英文字符。超出此范围的使用0x80~0xFFFF来编码，即扩展的ASCII编码。
 &nbsp;output:
    ansi:
      enabled: ALWAYS
  jackson:  
    time-zone: GMT+8 
    date-format: yyyy-MM-dd HH:mm:ss
  gson:
    date-format: yyyy-MM-dd HH:mm:ss
  pid:
    file: /var/run/ensbrain/server.pid
  mvc:
    static-path-pattern: /**
 &nbsp;#指定静态资源存放的地址放前端打包的东西
 &nbsp;resources:
 &nbsp;  static-locations: file:/usr/local/ensbrain/www/
```
自定义日志等级高亮颜色
ANSI 简单输出测试
```
 public static void main(String[] args) {
        System.out.println("\033[32m test  \033[39m 时间");
    }
 ```
![upload successful](/images/pasted-156.png)
 
ASNI 颜色编码说明 


|ANSIConstants|ASNI|颜色|  
|:--|:--|:--|  
|ESC_START|\\033\[|编码开始标识|  
|BLACK_FG|30|BLACK_FG|  
|RED_FG|31|RED_FG|  
|GREEN_FG|32|GREEN_FG|
|YELLOW_FG|33|YELLOW_FG|
|BLUE_FG|34|BLUE_FG|
|MAGENTA_FG|35|	MAGENTA_FG|
|CYAN_FG|36|CYAN_FG|
|WHITE_FG|37|WHITE_FG|
|DEFAULT_FG|39|	DEFAULT_FG|
|ESC_END|m|	编码结束标识|



