title: find
author: Joe Tong
tags:
  - SHELL
  - LINUX
categories:
  - IT
date: 2019-07-20 17:26:00
---
`# find &amp;lt;directory&amp;gt; -type f -name "*.c" | xargs grep "&amp;lt;strings&amp;gt;"&amp;lt;directory&amp;gt;`  
是你要找的文件夹；如果是当前文件夹可以省略-type f 说明，只找文件-name "*.c"  表示只找C语言写的代码，从而避免去查binary；也可以不写，表示找所有文件&amp;lt;strings&amp;gt;是你要找的某个字符串  
```
  find /your/path -type f -print | xargs grep MASQUERADEgrep -F MASQUERADE -R /path
```
  `find -name ".git"`
  
  

