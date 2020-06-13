title: python字符乱码问题
author: Joe Tong
tags:
  - PYTHON
categories:
  - IT
date: 2019-06-28 17:49:00
---
#### HTMLTestRunner解决UnicodeDecodeError: 'ascii' codec can't decode byte 0xe6 in position 36: ordinal not

报错提示如下：

UnicodeDecodeError: 'ascii' codec can't decode byte 0xe6 in position 36: ordinal not in range(128)

原因是：python的str默认是ascii编码，和unicode编码冲突，就会报这个标题错误


***解决的办法是，在开头添加如下代码：***
```
import sys
reload(sys)
sys.setdefaultencoding('utf8')
```


完美解决问题，对了，我使用的Python版本是Python2.7.13，HTMLTestRunner也是Python2的版本。
