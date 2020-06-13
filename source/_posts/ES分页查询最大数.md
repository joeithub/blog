title: ES分页查询最大数
author: Joe Tong
tags:
  - ES
categories: 
  - IT
date: 2020-05-09 11:30:31
---


elasticsearch 分页查询最大存储数

```
curl -X PUT http://localhost:9200/_cluster/settings -H 'Content-Type: application/json' -d'{
    "persistent" : {
        "search.max_open_scroll_context": 5000
    },
    "transient": {
        "search.max_open_scroll_context": 5000
    }
}
```


