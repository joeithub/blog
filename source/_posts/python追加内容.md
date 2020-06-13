title: python追加内容
author: Joe Tong
tags:
  - PYTHON
categories:
  - IT
date: 2019-07-04 10:25:00
---
Python追加文件内容

开始用的如下的write()方法，发下会先把原文件的内容清空再写入新的东西，文件里面每次都是最新生成的一个账号
```
mobile = Method.createPhone()
file = r'D:\test.txt'
with open(file, 'w+') as f:
      f.write(mobile)
```
查了资料，关于open()的mode参数：
```
'r'：读

'w'：写

'a'：追加

'r+' == r+w（可读可写，文件若不存在就报错(IOError)）

'w+' == w+r（可读可写，文件若不存在就创建）

'a+' ==a+r（可追加可写，文件若不存在就创建）

对应的，如果是二进制文件，就都加一个b就好啦：

'rb'　　'wb'　　'ab'　　'rb+'　　'wb+'　　'ab+'
```
　　

发现方法用错了，像这种不断生成新账号 增加写入的，应该用追加‘a’

改为如下后，解决：
```
mobile = Method.createPhone()
file = r'D:\test.txt'
with open(file, 'a+') as f:
 &nbsp; &nbsp; f.write(mobile+'\n') &nbsp; ***#加\n换行显示***
```
