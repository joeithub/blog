title: computer and network
author: Joe Tong
tags:
  - JAVAEE
  - TCP/IP
categories:
  - IT
date: 2019-07-17 10:55:00
---
计算机网络基本知识汇总  

概述  
OSI分层（7层）  
物理层、数据链路层、网络层、运输层、会话层、表示层、应用层  
TCP/IP分层（4层）  
网络接口层、网络层、运输层、应用层  
五层协议（5层）  
物理层、数据链路层、网络层、运输层、应用层  
五层结构的概述  
应用层：通过应用进程间的交互来完成特定网络应用   
数据：报文  
协议：HTTP, SMTP(邮件), FTP(文件传送)  
运输层：向两个主机进程之间的通信提供通用的数据传输服务。   
数据：TCP:报文段，UDP:用户数据报  
协议：TCP, UDP  
网络层：为分组交换网上的不同主机提供通信服务   
数据：包或IP数据报  
协议：IP  
数据链路层：   
数据：帧  
物理层：   
数据：比特  
ARP地址解析协议:用来获取目标IP地址所对应的MAC地址的  
各层协议  
应用层  
域名系统DNS  
例：某用户通过主机A浏览西安交大的主页 www.xjtu.edu.cn   
1. A向本地域名服务器DNS查询   
2. 如果DNS上有www.xjtu.edu.cn的记录，就立即返回IP地址给主机A   
3. 如果DNS上没有该域名记录，则DNS向根域名服务器发出查询请求   
4. 根域名服务器把负责cn域的顶级域名服务器B的IP地址告诉DNS   
5. DNS向B查询获得二级域名服务器C的IP地址，最终迭代查询到www.xjtu.edu.cn的ip直接返回DNS  
HTTP  
请求报文  

常用的 HTTP 请求方法有GET、POST、HEAD、PUT、DELETE、OPTIONS、TRACE、CONNECT;  
GET：当客户端要从服务器中读取某个资源时，使用GET 方法。GET 方法要求服务器将URL 定位的资源放在响应报文的部分，回送给客户端，即向服务器请求某个资源。使用GET 方法时，请求参数和对应的值附加在 URL 后面，利用一个问号(“?”)代表URL 的结尾与请求参数的开始，传递参数长度受限制。例如，/index.jsp?id=100&amp;op=bind。  
POST：当客户端给服务器提供信息较多时可以使用POST 方法，POST 方法向服务器提交数据，比如完成表单数据的提交，将数据提交给服务器处理。GET 一般用于获取/查询资源信息，POST 会附带用户数据，一般用于更新资源信息。POST 方法将请求参数封装在HTTP 请求数据中，以名称/值的形式出现，可以传输大量数据;  
请求头部：请求头部由关键字/值对组成，每行一对，关键字和值用英文冒号“:”分隔。请求头部通知服务器有关于客户端请求的信息，典型的请求头有：  
User-Agent：产生请求的浏览器类型;  
Accept：客户端可识别的响应内容类型列表;星号 “ * ” 用于按范围将类型分组，用 “ / ” 指示可接受全部类型，用“ type/* ”指示可接受 type 类型的所有子类型;  
Accept-Language：客户端可接受的自然语言;  
Accept-Encoding：客户端可接受的编码压缩格式;  
Accept-Charset：可接受的应答的字符集;  
Host：请求的主机名，允许多个域名同处一个IP 地址，即虚拟主机;  
connection：连接方式(close 或 keepalive);  
Cookie：存储于客户端扩展字段，向同一域名的服务端发送属于该域的cookie;  
GET /search?hl=zh-CN&amp;source=hp&amp;q=domety&amp;aq=f&amp;oq= HTTP/1.1  
Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, 
application/msword, application/x-silverlight, application/x-shockwave-flash, */*  
Referer: &lt;a href="http://www.google.cn/"&gt;http://www.google.cn/&lt;/a&gt;  
Accept-Language: zh-cn  
Accept-Encoding: gzip, deflate  
User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; TheWorld)  
Host: &lt;a href="http://www.google.cn"&gt;www.google.cn&lt;/a&gt;  
Connection: Keep-Alive  
Cookie: PREF=ID=80a06da87be9ae3c:U=f7167333e2c3b714:NW=1:TM=1261551909:LM=1261551917:S=ybYcq2wpfefs4V9g; 
NID=31=ojj8d-IygaEtSxLgaJmqSjVhCspkviJrB6omjamNrSm8lZhKy_yMfO2M4QMRKcH1g0iQv9u-2hfBW7bUFwVh7pGaRUb0RnHcJU37y-
FxlRugatx63JLv7CWMD6UB_O_r  

响应报文  

状态码由三位数字组成，第一位数字表示响应的类型，常用的状态码有五大类如下所示：  
1xx：表示服务器已接收了客户端请求，客户端可继续发送请求;  
2xx：表示服务器已成功接收到请求并进行处理;  
3xx：表示服务器要求客户端重定向;  
4xx：表示客户端的请求有非法内容;  
5xx：表示服务器未能正常处理客户端的请求而出现意外错误;  
200 OK：表示客户端请求成功;   
400 Bad Request：表示客户端请求有语法错误，不能被服务器所理解;  
401 Unauthonzed：表示请求未经授权，该状态代码必须与 WWW-Authenticate 报头域一起使用;  
403 Forbidden：表示服务器收到请求，但是拒绝提供服务，通常会在响应正文中给出不提供服务的原因;  
404 Not Found：请求的资源不存在，例如，输入了错误的URL;  
500 Internal Server   
Error：表示服务器发生不可预期的错误，导致无法完成客户端的请求;  
503 Service Unavailable：表示服务器当前不能够处理客户端的请求，在一段时间之后，服务器可能会恢复正常;  
响应头部：响应头可能包括：   
- Location：Location响应报头域用于重定向接受者到一个新的位置。例如：客户端所请求的页面已不存在原先的位置，为了让客户端重定向到这个页面新的位置，服务器端可以发回Location响应报头后使用重定向语句，让客户端去访问新的域名所对应的服务器上的资源; 
- Server：Server 响应报头域包含了服务器用来处理请求的软件信息及其版本。它和 User-Agent 请求报头域是相对应的，前者发送服务器端软件的信息，后者发送客户端软件(浏览器)和操作系统的信息。   
- Vary：指示不可缓存的请求头列表;   
- Connection：连接方式;  
对于请求来说：close(告诉WEB 服务器或者代理服务器，在完成本次请求的响应后，断开连接，不等待本次连接的后续请求了)。keepalive(告诉WEB服务器或者代理服务器，在完成本次请求的响应后，保持连接，等待本次连接的后续请求);  
对于响应来说：close(连接已经关闭); keepalive(连接保持着，在等待本次连接的后续请求); Keep-Alive：如果浏览器请求保持连接，则该头部表明希望WEB 服务器保持连接多长时间(秒);例如：Keep-Alive：300;  
WWW-Authenticate：WWW-Authenticate响应报头域必须被包含在401 (未授权的)响应消息中，这个报头域和前面讲到的Authorization 请求报头域是相关的，当客户端收到 401 响应消息，就要决定是否请求服务器对其进行验证。如果要求服务器对其进行验证，就可以发送一个包含了Authorization 报头域的请求;  
问题：   
1. Http1.1与Http1.0的区别   
http1.0使用非持久连接（短连接），而http1.1默认是持久连接（长连接），当然也可以配置成非持久连接。  
Cookie和Session的作用和工作原理  
FTP文件传送协议  
运输层  
使用UDP和TCP协议的各种应用和应用层协议  
应用  
应用层协议  
运输层协议  
名字转换  
DNS(域名系统)  
UDP  
文件传送  
TFTP(简单文件传送协议)  
UDP  
路由器选择协议  
RIP(路由信息协议)  
UDP  
IP地址配置  
DHCP(动态主机配置协议)  
UDP  
网络管理  
SNMP(简单网络管理协议)  
UDP  
远程服务器  
NFS(网络文件系统)  
UDP  
多播  
IGMP(网际组管理协议)  
UDP  
电子邮件  
SMTP(简单邮件传送协议)  
TCP  
远程终端  
TELNET(远程终端协议)  
TCP  
万维网  
HTTP(超文本传送协议)  
TCP  
文件传送  
FTP(文件传送协议)  
TCP  
- 端口   
TCP和UDP都需要有源端口和目的端口  
（端口：用16位来表示,即一个主机共有65536个端口.序号小于256的端口称为通用端口,如FTP是21端口,WWW是80端口等.端口用来标识一个服务或应用.一台主机可以同时提供多个服务和建立多个连接.端口(port)就是传输层的应用程序接口.应用层的各个进程是通过相应的端口才能与运输实体进行交互.服务器一般都是通过人们所熟知的端口号来识别的）  
服务端  
常用的熟知端口  
应用程序  
FTP  
TELNET  
SMTP  
DNS  
TFTP  
HTTP  
SNMP  
SNMP(trap)  
熟知端口  

登记端口 1024~49151  
客户端  
端口号由客户进程动态选择。数值范围 49152~65535  
UDP  
特点  
无连接的（发送数据之前不需要建立连接，因此减少了开销和发送数据之前的时延）  
尽最大努力交付（不保证可靠支付，因此主机不需要维持复杂的连接状态表）  
面向报文的（UDP对应用层交下来的报文，添加完首部后就直接交付IP层。如果太长就会分 片）  
UDP没有拥塞控制  
UDP支持一对一、一对多、多对一和多对多的交互通信  
UDP的首部开销小（只有8个字节，TCP有20个字节）  
UDP报文  
 
- 源端口：2字节 = 16bit = 0 ~ 65535   
- 目的端口：2字节   
- 长度：2字节   
- 检验和：2字节  
如果接受方UDP发现收到的报文中的目的端口号不正确（不存在对应端口号的应用进程），就会丢弃报文，并有网际控制报文协议ICMP（ping某个地址就是用的ICMP）发送“端口不可达”差错报文给发送方。  
UDP用户数据报首部检验和计算时会在UDP用户数据报前增加12个字节的伪首部。  

TCP   
特点  
面向连接的运输层协议。  
点对点（一对一）通信。  
可靠交付。  
全双工通信（TCP连接的两端都设有发送缓存和接收缓存，用来临时存放双向通信的数据）。  
面向字节流。  
TCP与UDP在发送报文时所采用的方式完全不同。TCP具体发送的报文由接收方给出的窗口值和当前网络拥塞的程度来决定一个报文段包含多少字节。而UDP发送的报文长度由应用进程给出。  
TCP可靠传输工作原理  
TCP连接的端点叫做套接字(socket)或插口。套接字socket = (IP地址：端口号)  
停止等待协议  
 

每发送完一个分组就设置一个超时计时器。   
- 注意：   
1. 必须暂时保存已发送的分组的副本   
2. 分组和确认分组都必须编号   
3. 超市计时器设置的重传时间比数据在分组传输的平均时间更长一些  
确认丢失和确认迟到
   
 
如果接收方接收到数据发送确认没有被发送方接收到，那么发送方超时后会重新发送分组，并且接收方收到重复的分组会丢弃并重传确认。   
如果接收方收到的确认是已经接受过的，那么会无视这个确认。  
缺点  
停止等待协议（自动重传ARQ）虽然简单，但是信道利用率低。  

信道利用率U = TD / (TD + RTT + TA)  
连续ARQ协议和滑动窗口协议  


TCP报文格式

源端口和目的端口 各占2字节  
序号 4字节  
确认号 4字节期望收到对方下一个报文的第一个数据字节的序号  
数据偏移 4位  
保留 6字节  
紧急URG 当URG=1表示紧急指针有效  
确认ACK   
推送PSH   
复位RST 当RST = 1时，释放连接并重新建立连接  
同步SYN 当SYN = 1 ACK = 0时，表明这是一个连接请求报文段。  
终止FIN FIN = 1，请求释放连接。  
窗口  
检验和  
紧急指针  
选项  
TCP的三次握手  

客户端TCP向服务端TCP发送一个特殊的TCP报文段，不包含应用层数据，报文中SYN=1，设置一个初始号client_isn,记录在报文段的序列号seq中。  
SYN报文段到达服务器后，为该TCP链接分配缓存和变量，并向客户端发送允许链接的报文段。其中，SYN = 1， ACK = client_isn+1，seq = server_isn;  
客户端收到允许连接的报文后，客户端也给连接分配缓存和变量，客户端向服务端发送一个报文段，其中ACK = server_isn+1，SYN = 0，并且由于连接已经建立所以现在可以携带应用层数据。  
TCP四次挥手  
 
1. 客户端发送连接释放报文段，报文中FIN = 1, seq = u;   
2. 服务端接收到连接释放报文后发出确认报文，其中ACK = 1; seq = v; ack = u + 1;   
3. 服务端在发送完数据后，发送连接释放报文FIN = 1, seq = w, ack = u + 1;并停止向客户端发送数据。   
4. 客户端收到连接释放报文后，发送确认报文， ACK = 1; seq = u + 1; ack = w + 1;并且进入等待2MSL，防止服务端没有接收到确认报文，重传报文。并且使连接产生的报文都消失。  
TCP协议的连接是全双工连接，一个TCP连接存在双向的读写通道。   
简单说来是 “先关读，后关写”，一共需要四个阶段。以客户机发起关闭连接为例：   
1. 服务器读通道关闭   
2. 客户机写通道关闭   
3. 客户机读通道关闭   
4. 服务器写通道关闭  
TCP拥塞控制  
拥塞控制和流量控制的区别  
流量控制针对的是点对点之间的（发送方和接收方）之间的速度匹配服务，因为接收方的应用程序读取的速度不一定很迅速，而接收方的缓存是有限的，就需要避免发送的速度过快而导致的问题。拥塞控制是由于网络中的路由和链路传输速度限制，要避免网络的过载和进行的控制。  
拥塞控制算法  
拥塞控制算法主要包含了三个部分：慢启动、拥塞避免和快速回复  

慢启动  
慢开始算法的思路就是，不要一开始就发送大量的数据，先探测一下网络的拥塞程度，也就是说由小到大逐渐增加拥塞窗口的大小。一般一开始为1个MSS，之后翻倍这样来增加，呈指数增长。其中1、慢启动过程有一个阈值ssthresh，一旦到达阈值就进入拥塞避免模式。这是第一种离开结束慢启动的方式2、如果收到了一个丢包提示，就将cwnd设为1并且重新开始慢启动过程，这时要把阈值ssthresh设为当前cwnd值的一半。3、如果收到了三次冗余的ACK，就执行一次快速重传并且进入快速恢复状态，这是最后一种结束慢启动的过程。  
拥塞避免  
进入拥塞避免说明cwnd值大约是上一次遇到拥塞是的一半，这时候不能翻倍，而是将cwnd的值每次增加一个MSS。结束的过程有两种可能：1、当出现超时时，将cwnd值设为1个MSS，并且将ssthresh阈值设为当前cwnd值的一半。2、当收到三个冗余ACK时，将ssthresh阈值设为当前cwnd值的一半，并且将cwnd值设为当前cwnd值的一半加3，即ssthresh阈值加3，并且进入快速恢复状态。  
快速恢复  
快速恢复就是指进入快速恢复前的一系列操作，即将ssthresh阈值设为当前cwnd值的一半，并且将cwnd值设为当前cwnd值的一半加3，即ssthresh阈值加3，之后进入拥塞避免状态，即每次cwnd的值加1个MSS。  
网络层  
协议  
地址解析协议 ARP  
网际控制报文协议 ICMP  
网际组管理协议 IGMP  
IP  
IP地址分类：   
A类:1.0.0.0~126.255.255.255,默认子网掩码/8,即255.0.0.0 (其中127.0.0.0~127.255.255.255为环回地址,用于本地环回测试等用途)；    
B类:128.0.0.0~191.255.255.255,默认子网掩码/16,即255.255.0.0；   
C类:192.0.0.0~223.255.255.255,默认子网掩码/24,即255.255.255.0；  
D类:224.0.0.0~239.255.255.255,一般于用组播  
E类:240.0.0.0~255.255.255.255(其中255.255.255.255为全网广播地址),E类地址一般用于研究用途  
