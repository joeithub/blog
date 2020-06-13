title: python读取数据库
author: Joe Tong
tags:
  - PYTHON
categories:  
  - IT 
date: 2019-10-24 10:08:59
---

```
# -*- coding: UTF-8 -*-
import MySQLdb

# 打开数据库连接
db = MySQLdb.connect(host="localhost", user="root", passwd="123456", db="study", charset='utf8' )

# 使用cursor()方法获取操作游标 
cursor = db.cursor()

# SQL 查询语句
sql = "SELECT * FROM student"
try:
   # 执行SQL语句
   cursor.execute(sql)
   # 获取所有记录列表
   results = cursor.fetchall()
   print ("学号 姓名 年龄")
   for it in results:
	   for i in range(len(it)):
		   print it[i],
	   print ('\n')
except:
   print "Error: unable to fecth data"

# 关闭数据库连接
cursor.close()
db.close()
```

