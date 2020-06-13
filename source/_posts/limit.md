title: limit 用法
tags:
  - SQL
categories:
  - IT
author: Joe Tong
date: 2019-06-22 07:17:00
---
### limit是限定查询结果的数量
(是mysql数据库中特有的语句)
(从表中记录0开始，查询数量为5）
select empno ,ename from emp limit 5;
+-------+--------+
| empno | ename  |
+-------+--------+
|  7369 | SMITH  |
|  7499 | ALLEN  |
|  7521 | WARD   |
|  7566 | JONES  |
|  7654 | MARTIM |
+-------+--------+
5 rows in set (0.00 sec)

2：1中sql语句还可以这样写（m,n)默认从0开始
 select empno ,ename from emp limit 0,5;
+-------+--------+
| empno | ename  |
+-------+--------+
|  7369 | SMITH  |
|  7499 | ALLEN  |
|  7521 | WARD   |
|  7566 | JONES  |
|  7654 | MARTIM |
+-------+--------+
5 rows in set (0.00 sec)

3：找出公司中工资前5名的员工（limit是在order by之后执行的)
 select * from emp order by sal desc limit 5;
+-------+-------+-----------+------+------------+---------+------+--------+
| EMPNO | ENAME | JOB       | MGR  | HIREDATE   | SAL     | COMM | DEPTNO |
+-------+-------+-----------+------+------------+---------+------+--------+
|  7839 | KING  | PRESIDENT | NULL | 2017-05-13 | 5000.00 | NULL |     10 |
|  7902 | FORD  | ANALYST   | 7566 | 2017-05-13 | 3000.00 | NULL |     20 |
|  7788 | SCOLL | ANALIST   | 7566 | 2017-05-13 | 3000.00 | NULL |     20 |
|  7566 | JONES | MANAGER   | 7839 | 2017-05-13 | 2975.00 | NULL |     20 |
|  7698 | BLAKE | MANAGER   | 7839 | 2017-05-13 | 2850.00 | NULL |     30 |
+-------+-------+-----------+------+------------+---------+------+--------+
5 rows in set (0.07 sec)




4:找出工资排名在3-9名的员工
select * from emp order by sal desc limit 2,7;
+-------+---------+-----------+------+------------+---------+--------+--------+
| EMPNO | ENAME   | JOB       | MGR  | HIREDATE   | SAL     | COMM   | DEPTNO |
+-------+---------+-----------+------+------------+---------+--------+--------+
|  7788 | SCOLL   | ANALIST   | 7566 | 2017-05-13 | 3000.00 |   NULL |     20 |
|  7566 | JONES   | MANAGER   | 7839 | 2017-05-13 | 2975.00 |   NULL |     20 |
|  7698 | BLAKE   | MANAGER   | 7839 | 2017-05-13 | 2850.00 |   NULL |     30 |
|  7782 | CLARK   | MANAGERAN | 7839 | 2017-05-13 | 2450.00 |   NULL |     10 |
|  7499 | ALLEN   | SALESMAN  | 7698 | 2017-05-13 | 1600.00 | 300.00 |     30 |
|  7844 | IUSRNER | SALESMAN  | 7698 | 2017-05-13 | 1500.00 |   NULL |     30 |
|  7934 | MILLER  | CLERY     | 7782 | 2017-05-13 | 1300.00 |   NULL |     10 |
+-------+---------+-----------+------+------------+---------+--------+--------+
7 rows in set (0.00 sec)



5：mysql中通用的分页语句page(每页显示3条记录)

第一页：起始下标，0,3

第二页: 起始下标，3,3

第三页:起始下标，6,3

第四页:起始下标，9,3

每页显示pageSize条记录

第pageNo页:(pageNo-1)*pageSize,pageSize  




### SQL优化之limit 1
在某些情况下,如果明知道查询结果只有一个,SQL语句中使用LIMIT 1会提高查询效率。 
　　例如下面的用户表(主键id,邮箱,密码): 
1 create table t_user( 2 　　id int primary key auto_increment, 3 　　email varchar(255), 4 　　password varchar(255) 5 ); 
　　每个用户的email是唯一的,如果用户使用email作为用户名登陆的话,就需要查询出email对应的一条记录。 
1 SELECT * FROM t_user WHERE email=?; 
　　上面的语句实现了查询email对应的一条用户信息,但是由于email这一列没有加索引,会导致全表扫描,效率会很低。 
1 SELECT * FROM t_user WHERE email=? LIMIT 1; 
　　加上LIMIT 1,只要找到了对应的一条记录,就不会继续向下扫描了,效率会大大提高。 LIMIT 1适用于查询结果为1条(也可能为0)会导致全表扫描的的SQL语句。 
　　如果email是索引的话,就不需要加上LIMIT 1,如果是根据主键查询一条记录也不需要LIMIT 1,主键也是索引。 
例如: 
1 SELECT * FROM t_user WHERE id=?; 
就不需要写成: 
1 SELECT * FROM t_user WHERE id=? LIMIT 1; 
二者效率没有区别。  
存储过程生成100万条数据: 
1 BEGIN  
2 DECLARE i INT;  
3 START TRANSACTION;  
4 SET i=0;  
5 WHILE i<1000000 DO  
6 INSERT INTO t_user VALUES(NULL,CONCAT(i+1,'@xxg.com'),i+1);  
7 SET i=i+1;  
8 END WHILE;  
9 COMMIT; 
10 END 
查询语句 
　　SELECT * FROM t_user WHERE email=' aliyunzixun@xxx.com';  
　　耗时0.56 s 
　　SELECT * FROM t_user WHERE email=' aliyunzixun@xxx.com' LIMIT 1;  
　　耗时0.00 s 
　　