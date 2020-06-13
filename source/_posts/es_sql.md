title: es_sql
author: Joe Tong
tags:
  - ES
categories:  
  - IT
date: 2019-12-30 14:05:01
---

通过 elasticsearch-sql 使用 SQL 语句聚合查询 Elasticsearch 获取各种 metrics 度量值

Elasticsearch 的 metrics（度量）包含 count、sum、avg、max、min、percentiles (百分位数)、Unique count（基数 || 去重计数）、Median（中位数）、扩展度量（含方差、平方和、标准差、标准差界限）、Percentile ranks（百分位等级）

## count（数量）：

`SELECT count(log_date.d) AS Count FROM INDEX-2017-12`
```
{
  "from" : 0,
  "size" : 0,
  "_source" : {
    "includes" : [ "COUNT" ],
    "excludes" : [ ]
  },
  "aggregations" : {
    "Count" : {
      "value_count" : {
        "field" : "log_date.d"
      }
    }
  }
}
```
## sum（和）：
`SELECT sum(log_date.d) AS SUM FROM INDEX-2017-12`
```
{
  "from" : 0,
  "size" : 0,
  "_source" : {
    "includes" : [ "SUM" ],
    "excludes" : [ ]
  },
  "aggregations" : {
    "SUM" : {
      "sum" : {
        "field" : "log_date.d"
      }
    }
  }
}
```
## avg（平均数）：
`SELECT avg(log_date.d) AS AVG FROM INDEX-2017-12`
```
{
  "from" : 0,
  "size" : 0,
  "_source" : {
    "includes" : [ "AVG" ],
    "excludes" : [ ]
  },
  "aggregations" : {
    "AVG" : {
      "avg" : {
        "field" : "log_date.d"
      }
    }
  }
}
```
max（最大值）：
`SELECT max(log_date.d) AS MAX FROM INDEX-2017-12`
```
{
  "from" : 0,
  "size" : 0,
  "_source" : {
    "includes" : [ "MAX" ],
    "excludes" : [ ]
  },
  "aggregations" : {
    "MAX" : {
      "max" : {
        "field" : "log_date.d"
      }
    }
  }
}
```
## min（最小值）：
`SELECT min(log_date.d) AS MIN FROM INDEX-2017-12`
```
{
  "from" : 0,
  "size" : 0,
  "_source" : {
    "includes" : [ "MIN" ],
    "excludes" : [ ]
  },
  "aggregations" : {
    "MIN" : {
      "min" : {
        "field" : "log_date.d"
      }
    }
  }
}
```
## percentiles（百分位数）：
`SELECT percentiles(log_date.d,1.0,15.0,31.0) AS Percentiles FROM INDEX-2017-12`
```
{
  "from" : 0,
  "size" : 0,
  "_source" : {
    "includes" : [ "percentiles" ],
    "excludes" : [ ]
  },
  "aggregations" : {
    "Percentiles" : {
      "percentiles" : {
        "field" : "log_date.d",
        "percents" : [ 1.0, 15.0, 31.0 ]
      }
    }
  }
}
```
## Unique count（基数 || 去重计数，就是 SQL 中的 distinct ）：
`SELECT count(distinct(log_date.d)) AS UniqueCount FROM INDEX-2017-12`
```
{
  "from" : 0,
  "size" : 0,
  "_source" : {
    "includes" : [ "COUNT" ],
    "excludes" : [ ]
  },
  "aggregations" : {
    "UniqueCount" : {
      "cardinality" : {
        "field" : "log_date.d",
        "precision_threshold" : 40000
      }
    }
  }
}
```
## Median（中位数）：
中位数没找到单独的获取方法，不过在 Kibana 中看到获取中位数时请求中的参数，其实就是获取的某个字段50的百分位数，所以可能有：中位数=50的百分位数
`SELECT percentiles(log_date.d,50.0) AS percentiles FROM INDEX-2017-12`
```
{
  "from" : 0,
  "size" : 0,
  "_source" : {
    "includes" : [ "percentiles" ],
    "excludes" : [ ]
  },
  "aggregations" : {
    "percentiles" : {
      "percentiles" : {
        "field" : "log_date.d",
        "percents" : [ 50.0 ]
      }
    }
  }
}
````
方差、平方和、标准差、标准差界限：
这几个度量没有单独方法去获取，都是用 EXTENDED_STATS 一个请求全部获取下来，然后从中取自己需要的结果
`SELECT EXTENDED_STATS(log_date.d) AS EXTENDED_STATS FROM INDEX-2017-12`

```
{
  "from" : 0,
  "size" : 0,
  "_source" : {
    "includes" : [ "EXTENDED_STATS" ],
    "excludes" : [ ]
  },
  "aggregations" : {
    "EXTENDED_STATS" : {
      "extended_stats" : {
        "field" : "log_date.d"
      }
    }
  }
}
```
EXTENDED_STATS 查询结果包含：方差、平方和、标准差、标准差界限以及最大值、平均数等基础度量，具体如下：

```
"aggregations": {
    "1": {
      "count": 15304326,
      "min": 1,
      "max": 31,
      "avg": 15.068216202399244,
      "sum": 230608893,
      "sum_of_squares": 4588588661,
      "variance": 72.7718426201877,
      "std_deviation": 8.530641395591992,
      "std_deviation_bounds": {
        "upper": 32.129498993583226,
        "lower": -1.9930665887847407
      }
    }
  }
  
```
  
## Percentile ranks（百分位等级）
暂时没找到求百分位等级的 SQL 语句，只能用原生 ES 查询语句获取了；
ES原生查询语句如下：
```
{
  "size": 0,
  ......
  "aggs": {
    "1": {
      "percentile_ranks": {
        "field": "log_date.d",
        "values": [
          6,
          15,
          31
        ],
        "keyed": false
      }
    }
  }
}
```


