title: SQLAlert 报警输出函数
tags:
  - SQLAlert
categories:
  - IT
author: Joe Tong
date: 2019-06-22 07:17:00
---
## 报警输出函数
本小节介绍 RDL 中报警输出函数。

### alert_es(list)
本函数将指定数组中的数据写入到 ES 的索引中。脚本中通过全局变量 \__es_host\__ 和 \__es_host_insert\__ 来指定 ES 服务器的配置，通过全局变量 \__alert_index\__ 指定输出的索引信息，该函数在搜索 ES 服务器配置时，优先使用变量 \__es_host_insert\__ 的值，如果该变量不存在，再使用 \__es_host\__ 的值，配置项如下：

> ~~~ {.id .cs .numberLines}
> __es_host__        = "localhost:9200";
> __es_index_alert__ = { "index": "alert-%Y-%M-%D", "type": "your type" };
> ~~~

输出索引配置中，index 表示索引名，可以使用 %Y、%M、%D 按 年、月、日 自动生成索引，type 为 ES 索引的数据类型。ES 索引相关内容请参阅 ES 官方相关文档。

函数 alert_es() 接收 1 个参数：

- list: 数组类型，数组中每个元素均为字典类型数据。需要导出的数据。

### alert_email(list)

### alert(list)


