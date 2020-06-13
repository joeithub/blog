title: Java代码里拼接SQL语句到mybatis的xml
author: Joe Tong
tags:
  - JAVAEE
  - MYBATIS
  - MYSQL
categories:
  - IT
date: 2019-09-24 00:15:00
---
##### Java代码里拼接SQL语句到mybatis的xml

关键语句：

StringBuilder whereSql = new StringBuilder();

whereSql.append("SQL语句");  //需要注意sql注入的问题

实现类：

```
	public List getList(Map&lt;String, Object&gt; map) {
		List&lt;Map&lt;String, Object&gt;&gt; rs = new ArrayList&lt;Map&lt;String, Object&gt;&gt;();
		try {
			StringBuilder whereSql = new StringBuilder();
 
			if (map.get("userName").toString().length()&gt;0) {
				whereSql.append(" AND a.userName in ('" + map.get("userName").toString().replaceAll(",", "\',\'") + "')");//不为空时加入查询条件
			}
			if (map.get("CURRENTPAGE").toString().length()&gt;0 &amp;&amp; map.get("PAGESIZE").toString().length()&gt;0) {//前端有传分页参数时就添加分页查询条件
				int currenpage = Integer.parseInt(map.get("CURRENTPAGE").toString());
				int pagesize = Integer.parseInt(map.get("PAGESIZE").toString());
				currenpage = ((currenpage - 1) * pagesize);
				whereSql.append(" limit " + currenpage + "," + pagesize);
			}
 
			rs = wmTblWorkorderMapper.getList(whereSql.toString());
			return rs;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
```

mapper：

```
List&lt;Map&lt;String,Object&gt;&gt; getList(@Param("whereSql") String whereSql);
```

mapper对应的xml：


```
&lt;select id="getList" resultType="HashMap"&gt;
		SELECT * FROM user a WHERE 1=1 ${whereSql}
&lt;/select&gt;
```


