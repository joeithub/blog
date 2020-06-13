title: waiting for headers
author: Joe Tong
tags:
  - UBUNTU
  - TERMUX
categories:  
  - SYSTEM
date: 2020-05-30 21:37:34
---


## waiting for headers

 
Debian\Unbutu卡在“waiting for headers”怎么办？
在安装软件的过程中，出现 [waiting for headers] ，并且卡住一直没反应。这可能是源的问题，也可能是上一次缓存不完全导致的，以下提供了一些措施来帮你缓解。

rm /var/lib/apt/lists/*

rm /var/lib/apt/lists/partial/*

上述是清理上一次缓存不完全导致的，直接清空，通过 update 即可重新更新，过程中保持网络良好，不要中断。

还不能解决，尝试：

1.删除/var/cache/apt/archives/下的所有文件，可能是上次没有成功导致遗留了部分文件。

2.检查域名能不能解析，不能解析要将sources.list中的源地址换成ip。

3.直接换源试试，比如中科大的源、163的源，实在不行，那就用官方的源。

转载地址：https://www.xuepaijie.com/html/technology/skills/872.html


