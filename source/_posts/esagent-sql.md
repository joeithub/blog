title: es查询代理sql用法
author: Joe Tong
tags:
  - ES
  - SQL
categories:
  - IT
date: 2019-06-25 02:30:00
---
一、图表数据接口参数格式说明
```
{
	"datasource": "`res-*`",
	"metrics": [],
	"buckets": [],
	"timeRange": { from : "", to: "", now: "" },
	"queryString": {},
	"filters": []
}
```
注意事项:
1. 前端传递的所有字段名、数据源名称、别名都需要使用``引起来。
2. 所有需要传别名的位置，前端默认添加别名字段，默认值：函数名 + "_" + 参数字段


二、图表数据接口参数格式说明
```
1. datasource: "`res-*`" ==&gt; FROM
2. metrics: [{  ==&gt; SELECT
		func: "count",
		params: [* || `a` || UNIQUE `@timestamp`]
		as: "aliasA"
	}, {
		func: "cardinality",
		params: [`a`]
		alias: "aliasA"
	},
	......
]
```
metrics中params允许接收多个字段，但是只有func为空时有效；count、cardinality等函数时默认取第一个值。
```
3. buckets: [  ==&gt; GROUP BY
	{
		func: "date_histogram",
		filed: "@timestamp",
		range: [12d, 0d],
		alias: "per12day",
		orderBy: "", ==&gt; orderBy字段为metrics中的字段别名(alias)
		limit: 5
	}, {
		func: "date_histogram"
		filed: "@timestamp",
		range: [12d, 0d],
		alias: "per12day"
		orderBy: "",
		limit: 5
	},
	......
] 
```
```
4. timeRange: { from : "", to: "", now: "" } ==&gt; WHERE
```
```
5. queryString: { type: "sql/dsl", value: "" }
当使用dsl时，使用如下内容："status:200 AND extension:PHP", ==&gt; WHERE( query_string(`QueryString`))
例如：select * from `res-*` where query_string(`bytes:3133 AND bytes_in:1387`) limit 100
```
```
6. filters: {
alias: "",
filters: [{  ==&gt; WHERE
	field: "@timestamp",
	operator: "",
	opValue: [],
	alias: "2"
}, {
	field: "@timestamp",
	operator: "",
	opValue: [],
	alias: "2"
},
......
]
}
应支持：range（&lt;、&lt;=、&gt;、&gt;=）、term（=）、must_not + term（!=）、terms（in）、wildcard（like/unlike）
对应operators：is between/is not between、is/is not、is one of/is not one of、exists/does not exists
注意：
	1）第6项中，只有当为范围和terms时，opValue中存在多个值；
	2）范围值判断，必须有两个值，第一个为from，第二个为to。
	3）以上需要别名的时，请前端创建参数时指定，默认为函数名_字段名，若用户指定了标签，则需要结果返回后，页面中替换为用户指定标签。
```


三、ESAgent模块提供SQL支持的函数及功能
SELECT
	所有字段 *
	指定字段 field1 as f1, field2 as f2, field3 as f3, 'field4' --一般不建议使用字符串作为字段名。
	脚本字段 select bytes_in, bytes_in + bytes_out &gt; 1000 AS gt1000, bytes from `res-*`
	函数：
	count(name) - 统计文档或值的个数
		参数：
		*                统计文档个数
		标识符（name)    name为桶时，返回每个桶内文档个数；name不为桶时，表示为值统计，等同于value_count()函数。
		UNIQUE name      唯一值（势）统计，等同于函数cardinality()。
	
	cardinality(name) - 唯一值（势）统计，参数为：字段name
	
	value_count(name) - 值统计，参数为：字段name
	
	max(name) - 最大值
	min(name) - 最小值
	sum(name) - 和
	avg(name) - 均值
	
	sum_of_squares(name) - 平方和
	variance(name) - 方差
	
	stdev(name) - 标准差
	stdev_upper(name) - 标准差上限
	stdev_lower(name) - 标准差下限

	len(name) - 指定字段值的长度
	script(scripts) - 该函数将给定的参数直接当做脚本交由ES处理，默认为painless脚本。
		参数：scripts - 脚本字段
		示例：select script(`doc["bytes_in"].value + doc["bytes_out"].value`) as c from `res-*`
		注意：1）脚本字段中所有请使用双引号。
			  2）脚本字段作为script函数的参数时，使用``符号引起来。
```	
FROM
	"res-*"，'res-*'，`res-*`
WHERE
```	
	last(interval) - 该函数用于设置”过去一段时间“的时间范围限制条件，过去是相对于当前时间而言。如果RDL中设置了全局变量”__now__“时，函数last()读取的当前时间为__now__所指定的时间，否则其读取的当前时间为系统当前时间。
		参数：interval - 时间间隔，支持天(d)、小时(h)、分钟(m)、秒(s)，不支持所列单位以外的单位。
	
	last_days(days, interval) - 该函数设置类似于“按天环比”的时间范围条件。
		参数: days - 整数类型，指定“环比”的天数。
			  interval - 时间间隔，支持天(d)、小时(h)、分钟(m)、秒(s)，不支持所列单位以外的单位。
		示例：SELECT avg(bytes) AS avg FROM 'res-*' WHERE last_days(30, 1m)
	
	last_workdays(days, interval) - 该函数提供搞得功能与last_days()类似，不同的是，last_workdays()函数将跳过用户在__workdays__全局变量以外的日期。
		参数: days - 整数类型，指定“环比”的天数。
		      interval - 时间间隔，支持天(d)、小时(h)、分钟(m)、秒(s)，不支持所列单位以外的单位。
			  
    last_weeks(weeks, interval) - 该函数提供另一个时间环比模型，按周环比。
		参数: days - 整数类型，指定“环比”的周数。
		      interval - 时间间隔，支持天(d)、小时(h)、分钟(m)、秒(s)，不支持所列单位以外的单位。
	
	ip_range(field, range[, range ....]) - 该函数提供对IP地址进行过滤的功能。
	    参数：field - 指定IP地址字段名。
		      range - IP地址范围，支持格式有："192.168.0.0/24"、"192.168.0.0 TO 192.168.0.255"、["192.168.0.0", "192.168.0.255"]
	    示例：
			SELECT avg(bytes) AS byte FROM `res-*` WHERE last(30d) AND ip_range(client_ip, [`192.168.32.0`, `192.168.32.255`]) GROUP BY client_ip LIMIT 10
			SELECT avg(bytes) AS byte FROM `res-*` WHERE last(30d) AND ip_range(client_ip, `192.168.32.0/24`) GROUP BY client_ip LIMIT 10
			SELECT avg(bytes) AS byte FROM `res-*` WHERE last(30d) AND ip_range(client_ip, `192.168.32.0 TO 192.168.32.255`) GROUP BY client_ip LIMIT 10
	
	ip_ranges(field, range_list[, range_list ....]) - 该函数提供IP地址进行过滤的功能，与ip_range()函数功能类似，但是参数不一致。
		参数：field - 指定IP地址字段名。
		      range_list - IP地址范围列表，该列表每一个元素为一个IP地址范围，IP地址范围支持格式有："192.168.0.0/24"、"192.168.0.0 TO 192.168.0.255"、["192.168.0.0", "192.168.0.255"]
		示例：SELECT avg(bytes) AS byte FROM `res-*` WHERE last(30d) AND ip_ranges(client_ip, [`183.206.20.0/24`, `192.168.32.0/24`]) GROUP BY client_ip LIMIT 10
		
	query_string(text) - 该函数用于支持ES支持的"迷你"查询语言（mini-language），将用户提供的参数当做"迷你"查询语言交由ES进行查询。
		参数：text - 字符串类型，该参数即为用户输出的"迷你"查询语言表达式。
		示例：SELECT avg(bytes) AS byte FROM `res-*` WHERE last(30d) AND query_string(`client_ip: 192.168.32.181`) GROUP BY client_ip LIMIT 10

GROUP BY  
```
range(filed, range [, range, ...]) - 桶函数，根据某字段的范围创建桶。
		参数：field - 字段名
			  range - 指定数值范围，支持的格式有："from TO to", [from , to]
		示例：SELECT avg(bytes) AS byte FROM `res-*` WHERE last(30d) group by range(bytes, `1 TO 100`, [100, 1000], [1000, 2000], [2000, 10000]) as range
		
	ip_range(field, range[, range ....]) - 该函数提供对IP地址进行过滤的功能。
	    参数：field - 指定IP地址字段名。
		      range - IP地址范围，支持格式有："192.168.0.0/24"、"192.168.0.0 TO 192.168.0.255"、["192.168.0.0", "192.168.0.255"]
	    示例：
			SELECT avg(bytes) AS byte FROM `res-*` WHERE last(30d) group by ip_range(client_ip, `192.168.0.0/24`, `192.168.32.0 TO 192.168.32.100`, [`192.168.32.100`, `192.168.32.255`]) as range
			
	date_range(field, fmt, range[, range ....])
		参数：field - （可选）指定日志范围的字段，默认为：@timestamp。
			  fmt - （可选）字符串类型，指定返回的时间格式。如果函数在调用时，只指定了一个字符串类型的参数，则认为是fmt。
			  range - 列表类型, [from, to]。 from与to支持的时间格式如下：
			  时间表达式格式：&lt;参考时间&gt; +/- &lt;间隔&gt;/&lt;单位&gt;
			  &lt;参考时间&gt; 可以是now或任意以双竖线（||）结尾的时间字符串；
			  &lt;间隔&gt;为有带单位的数字;
			  &lt;单位&gt;可以是：y(年)、M(月)、w(周)、d(天)、h(时)、m(分)、s(秒)
			  时间格式可以解释为：参考时间加（减）时间间隔，再四舍五入到某个时间单位，示例如下：
			  1. now+1h  ==&gt; 当前时间加上1小时，精确到毫秒。
			  2. now+1h+1m ==&gt; 当前时间加上1小时，再加上1分钟，精确到毫秒。
			  3. now+1h/d ==&gt; 当前时间加上1小时，并四舍五入到最近的天。
			  4. 2018-12-01||+1M/d ==&gt; 2018年12月1日加上1个月，并四舍五入到最近的天。
		示例：SELECT avg(bytes) AS byte FROM `res-*` WHERE last(30d) group by date_range(`@timestamp`, `yyyy-MM-dd`, [`2018-12-01||+1M/d`, `now-1m/m`]) as range
		
	histogram(field, interval) - 该函数按照指定字段，创建等分（直方）桶，又名直方图、柱状图等。
		参数：field - 标识符，字段名；
			  interval - 数值类型，指定等分间隔。
	    示例：SELECT avg(bytes) AS sum FROM `res-*` WHERE last(5m) GROUP BY histogram(bytes, 1000) AS bytes1

	date_histogram(field, interval) - 
		参数：field - 标识符，字段名；
			  interval - 数值类型，指定等分时间间隔。支持的单位：天（d）、小时（h）、分钟（m）、秒（s），不支持所列单位以外的时间间隔。
		示例：SELECT avg(bytes) AS sum FROM `res-*` WHERE last(30d) GROUP BY date_histogram(`@timestamp`, 1d) AS bytes1
		
	filters(filter[, filter, ...])
		参数：filter - SQL 表达式。必须为 &lt;expr&gt; AS &lt;name&gt; 的格式。例如：0 &lt; byte &lt; 10000 AS 'lt10000'。
		示例：SELECT avg(bytes) AS sum FROM `res-*` WHERE last(30d) 
			GROUP BY filters(
							ip_range(client_ip, `192.168.32.0 TO 192.168.32.100`) AS server, 
							ip_range(client_ip, `192.168.32.101 TO 192.168.32.200`) AS pc, 
							ip_range(client_ip, `192.168.32.201 TO 192.168.32.255`) AS cellphone) 
							AS machine
```
	
ORDER BY
	
	1. 按照查询字段进行排序。
		示例：select * from `res-*` order by bytes_in asc
	
	2. 按照桶分组进行排序
		示例：SELECT sum(bytes_in + bytes_out) AS bytes, sum(response_time) AS packets FROM `res-*` WHERE last(5m) GROUP BY user_group, user_type ORDER BY bytes DESC, packets DESC LIMIT 3, 3
		注意：
			1）默认按照文档个数进行倒序排列；
			2）默认排序方式为降序
			3）使用多个桶，只指定一个排序值时，所有桶都按照这个值进行排序；例如：order by a, b desc
			4）使用多个桶，且指定多个排序值，返回结果只在桶内有序，全部结果来看是无序的。
			5）指定排序值多于桶个数时，将被忽略。
	
LIMIT
	1. 限制查询数量
		示例：select * from `res-*` limit 30
	2. 限制桶内查询数量
		示例：SELECT sum(bytes_in + bytes_out) AS bytes, sum(response_time) AS packets FROM `res-*` WHERE last(5m) GROUP BY user_group, user_type ORDER BY bytes DESC, packets DESC LIMIT 3, 3
		注意:
			1）需要对每个桶内返回结果数进行限制；
			2）SQL中LIMIT指定的限制值，与桶之间按顺序一一对应。
	

