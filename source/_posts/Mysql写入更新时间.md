title: Mysql数据库自动写入创建时间以及更新时间
author: Joe Tong
tags:
  - JAVAEE
  - MYSQL
categories:
  - IT
date: 2019-09-17 15:57:00
---
&lt;iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=420 height=180 src="../../Aplayer/index.html"&gt;&lt;/iframe&gt;

```
`create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
`update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
```
如上图,第一个是创建时间,第二个是更新时间,数据插入时 不需要在对象中设置对应的时间值,数据库会自动插入创建时间,修改时会自动更新 '更新时间',如果不放心 可以在代码中将这两个属性设置为null

```
//数据库自动增加时间
        tOrderFault.setCreateTime(null);
        tOrderFault.setUpdateTime(null);
```

如上图所示,也是可以的 创建时间 只有在该条数据插入后生成,更新时间只有当该条记录发生修改时数据库才会自动更新时间,第一次插入数据时,更新时间列会显示0000-00-00 00:00:00
需要注意的是mysql5.6以前的版本是不支持同时有两个timestamp的时间类型,如果报错可以检查下数据库的版本
