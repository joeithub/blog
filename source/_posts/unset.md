title: unset
author: Joe Tong
tags:
  - LINUX
  - SHELL
categories:
  - IT
date: 2019-06-27 15:59:00
---
####  Shell删除数组元素（也可以删除整个数组）
&lt; Shell数组拼接Shell关联数组 &gt;
《Linux就该这么学》是一本基于最新Linux系统编写的入门必读书籍，内容面向零基础读者，由浅入深渐进式教学，销量保持国内第一，年销售量预期超过10万本。点此免费在线阅读。
在 Shell 中，使用 unset 关键字来删除数组元素，具体格式如下：
unset array_name[index]
其中，array_name 表示数组名，index 表示数组下标。

如果不写下标，而是写成下面的形式：  
**`unset array_name`**  
***那么就是删除整个数组，所有元素都会消失。***

下面我们通过具体的代码来演示：
纯文本复制
```
#!/bin/bash
arr=(23 56 99 "http://c.biancheng.net/shell/")
unset arr[1]
echo ${arr[@]}
unset arr
echo ${arr[*]}
```
运行结果：
23 99 http://c.biancheng.net/shell/
 
注意最后的空行，它表示什么也没输出，因为数组被删除了，所以输出为空。
