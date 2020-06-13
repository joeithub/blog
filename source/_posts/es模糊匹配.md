title: es模糊匹配
author: Joe Tong
tags:
  - ES
categories:  
  - IT
date: 2019-10-24 10:08:59
---

Elasticsearch查询（4）-模糊匹配和正则表达式

模糊查询前缀开始字符j

```
GET /mydb/_search
{
	"query": { 
	"prefix": { 
	"name": "j" 
} 
} 
}
```

模糊查询
&gt;  ?用来匹配1个任意字符，*用来匹配零个或者多个字符

```
GET /mydb/_search
 
{
"query": {
"wildcard": { 
"postcode": "c??"
} 
} 
}
```
模糊查询

&gt; ?用来匹配1个任意字符，*用来匹配零个或者多个字符

```
GET /mydb/_search
{
"query": { 
"wildcard": {
"name.keyword": "ch??g*y*" 
} 
} 
```

正则表达式 匹配c后面2个任意字符

```
GET /mydb/_search
 
{ 
"query": {
"regexp": {
"name.keyword": "c[a-z]{1,2}"
}
} 
}
```

