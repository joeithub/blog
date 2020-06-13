title: ES返回值数量
author: Joe Tong
tags:
  - ES
categories:  
  - IT
date: 2020-01-16 18:57:02
---

ES返回值数量超过10000条解决方式
&gt; ES默认返回数据量为10000条， 当分页的from超过10000条的时候，es就会如下报错：

```
Result window is too large, from + size must be less than or equal to:[10000] but was [10500]. See the scroll api for a more efficient way to requestlarge data sets. This limit can be set by changing the[index.max_result_window] index level parameter
```
解决方案:
&gt;通过设置index 的设置参数max_result_window的值
eg：

```
curl -XPUT http://es-ip:9200/_settings -d '{ "index" : { "max_result_window" : 100000000}}
```

2.修改集群配置config/elasticsearch.yml 文件
增加如下配置

max_result_window: 100000

