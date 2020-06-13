title: linux 后台运行python脚本
author: Joe Tong
tags:
  - LINUX
  - SHELL
categories:
  - IT
date: 2019-06-29 01:40:00
---
#### linux 下后台运行python脚本
这两天要在服务器端一直运行一个Python脚本，当然就想到了在命令后面加&amp;符号



$ python /data/python/server.py &gt;python.log &amp;  
说明：     
1、 &gt; 表示把标准输出（STDOUT）重定向到 那个文件，这里重定向到了python.log      
2、 &amp; 表示在后台执行脚本  
这样可以到达目的，但是，我们退出shell窗口的时候，必须用exit命令来退出，否则，退出之后，该进程也会随着shell的消失而消失（退出、关闭）
 

&lt;u&gt;***使用nohup(not hang up)：***&lt;/u&gt;

$ nohup python /data/python/server.py &gt; python.log3 2&gt;&amp;1 &amp;  
说明：  
1、1是标准输出（STDOUT）的文件描述符，2是标准错误（STDERR）的文件描述符
1&gt; python.log 简化为 &gt; python.log，表示把标准输出重定向到python.log这个文件
2、2&gt;&amp;1 表示把标准错误重定向到标准输出，这里&amp;1表示标准输出  
为什么需要将标准错误重定向到标准输出的原因，是因为标准错误没有缓冲区，而STDOUT有。  
这就会导致  commond &gt; python.log  2&gt; python.log 文件python.log被两次打开，而STDOUT和             STDERR将会竞争覆盖，这肯定不是我门想要的  
3、好了，我们现在可以直接关闭shell窗口（我用的是SecureCRT，用的比较多的还有Xshell），而不用再输入exit这个命令来退出shell了  
$ ps aux|grep python  
tomener 1885  0.1  0.4  13120  4528 pts/0    S    15:48   0:00 python /data/python/server.py  tomener 1887  0.0  0.0   5980   752 pts/0    S+   15:48   0:00 grep python
 

现在当我们直接关闭shell窗口，再连接上服务器，查看Python的进程，发现进程还在

 
但是，在python运行中却查看不到输出！

因为：

python的输出有缓冲，导致python.log3并不能够马上看到输出。

使用-u参数，使得python不启用缓冲。

所以改正命令，就可以正常使用了

$ **`nohup python -u test.py &gt; out.log 2&gt;&amp;1 &amp;`**
　　

 
