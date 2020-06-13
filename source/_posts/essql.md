title: es 使用SQL查询
tags:
  - SQL
categories:
  - IT
author: Joe Tong
date: 2019-06-22 07:24:00
---
可视化项目中使用esagent代理用sql查询
使用SQL查询的语句例子：
```
select avg(response_time) AS `metric_1`,  
max(response_time) AS `metric_2`,  
min(response_time) AS `metric_3`  
from `res*`   
where @timestamp >= `2019-06-12T10:53:47+08:00`   
AND @timestamp <= `2019-06-12T11:08:47+08:00`   
GROUP BY date_histogram(`@timestamp`,1d) AS `bucket_1`  
LIMIT 5
```
