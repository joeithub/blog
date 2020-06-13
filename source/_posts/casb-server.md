title: casb server
author: Joe Tong
tags:
  - JAVAEE
  - ENLINK
categories:
  - IT
date: 2019-07-15 14:24:00
---
##### CASB 后台管理（管理端） &nbsp;
Java项目结构
```
-src
 - java
   - com
     - enlink
       - admin
         - aop
         - config
           - druid
         - constraint
         - core
           - dao
           - feature
           - pojos
           - service
           - timer
         - util
           - excel
         - web
           - controller
             - apps
             - auditmanage
             - auth
             - chargingsystem
             - external
             - firewall
             - ipsec
             - netconfig
             - rule
             - s2s
             - signaturemanage
             - sms
             - sysconfig
             - usermanager
             - BaseController
           - filter
         - ElinkAdminBackApplication 
 -libs
   - cn
   - com
   - org
 -resources
 &nbsp;- backup
  - mapper
  - sql 
  - application.properties
  - generatorConfig.xml
  - logback-spring.xml
  - mybatis-generator.xml
```


