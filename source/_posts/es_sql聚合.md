title: ES聚合
author: Joe Tong
tags:
  - ES
categories:  
  - IT
date: 2019-12-31 14:54:16
---

HISTOGRAMedit
Synopsis:
```
HISTOGRAM(
    numeric_exp,        
    numeric_interval)   
```
```
HISTOGRAM(
    date_exp,           
    date_time_interval) 
```
Input:


numeric expression (typically a field)


numeric interval


date/time expression (typically a field)


date/time interval

Output: non-empty buckets or groups of the given expression divided according to the given interval

DescriptionThe histogram function takes all matching values and divides them into buckets with fixed size matching the given interval, using (roughly) the following formula:

bucket_key = Math.floor(value / interval) * interval
NOTE
The histogram in SQL does NOT return empty buckets for missing intervals as the traditional histogram and date histogram. Such behavior does not fit conceptually in SQL which treats all missing values as NULL; as such the histogram places all missing values in the NULL group.
Histogram can be applied on either numeric fields:

`SELECT HISTOGRAM(salary, 5000) AS h FROM emp GROUP BY h;
`
```
 h
---------------
25000
30000
35000
40000
45000
50000
55000
60000
65000
70000
```
or date/time fields:

`SELECT HISTOGRAM(birth_date, INTERVAL 1 YEAR) AS h, COUNT(*) AS c FROM emp GROUP BY h;`

```
           h            |       c
------------------------+---------------
null                    |10
1952-01-01T00:00:00.000Z|8
1953-01-01T00:00:00.000Z|11
1954-01-01T00:00:00.000Z|8
1955-01-01T00:00:00.000Z|4
1956-01-01T00:00:00.000Z|5
1957-01-01T00:00:00.000Z|4
1958-01-01T00:00:00.000Z|7
1959-01-01T00:00:00.000Z|9
1960-01-01T00:00:00.000Z|8
1961-01-01T00:00:00.000Z|8
1962-01-01T00:00:00.000Z|6
1963-01-01T00:00:00.000Z|7
1964-01-01T00:00:00.000Z|4
1965-01-01T00:00:00.000Z|1
```
Expressions inside the histogram are also supported as long as the return type is numeric:

`SELECT HISTOGRAM(salary % 100, 10) AS h, COUNT(*) AS c FROM emp GROUP BY h;`

```

       h       |       c
---------------+---------------
0              |10
10             |15
20             |10
30             |14
40             |9
50             |9
60             |8
70             |13
80             |3
90             |9

```
Do note that histograms (and grouping functions in general) allow custom expressions but cannot have any functions applied to them in the GROUP BY. In other words, the following statement is NOT allowed:

SELECT MONTH(HISTOGRAM(birth_date), 2)) AS h, COUNT(*) as c FROM emp GROUP BY h ORDER BY h DESC;
as it requires two groupings (one for histogram followed by a second for applying the function on top of the histogram groups).

Instead one can rewrite the query to move the expression on the histogram inside of it:

`SELECT HISTOGRAM(MONTH(birth_date), 2) AS h, COUNT(*) as c FROM emp GROUP BY h ORDER BY h DESC;`

```

       h       |       c
---------------+---------------
12             |7
10             |17
8              |16
6              |16
4              |18
2              |10
0              |6
null           |10
```



