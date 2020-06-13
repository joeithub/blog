title: golang操作数据库
author: Joe Tong
tags:
  - GO
categories:  
  - IT
date: 2019-11-29 09:57:24 
---

一、安装驱动

在Git命令行中输入
`go get github.com/go-sql-driver/mysql`
回车之后等待一会，等提示可以再输入命令时，就说明驱动已经装好了。
二、导入mysql包
```
import(
"database/sql"
_ "github.com/go-sql-driver/mysql" 
}
```
三、对数据库的操作

1、数据库的连接
`db, err := sql.Open("mysql", "root:123456@tcp(127.0.0.1:3306)/test?charset=utf8");`

2、数据库查询
```
type info struct {
		id int `db:"id"`
		name string `db:"name"`
		age int `db:"age"`
		sex string `db:"sex"`
		salary int `db:"salary"`
		work string `db:"work"`
		inparty string `db:"inparty"`
}
```
首先可以先定义一个结构体用来保存读出的每条数据，当然如果只需要其中某些数据，也可以按照自己的需要修改结构体，这里用我自己创建的表来演示。
`rows,err:=db.Query("SELECT * FROM message")`
这条语句用来将表中所有的条无条件的读出保存到rows中。
接下来是数据的逐条输出：
```
for rows.Next(){
		var s info
		err=rows.Scan(&s.id,&s.name,&s.age,&s.sex,&s.salary,&s.work,&s.inparty,)
		fmt.Println(s)
}
```
for rows.next可以一直读到表格的末尾。

下面是完整的查询代码：

```
import (
	_"mysql"
	"database/sql"
	"fmt"
)
 
func check(err error){     //因为要多次检查错误，所以干脆自己建立一个函数。
	if err!=nil{
		fmt.Println(err)
	}
 
}
 
 
func main(){
	db,err:=sql.Open("mysql","root:123456@tcp(127.0.0.1:3306)/employee")
	check(err)
 
	//query
	type info struct {
		id int `db:"id"`
		name string `db:"name"`
		age int `db:"age"`
		sex string `db:"sex"`
		salary int `db:"salary"`
		work string `db:"work"`
		inparty string `db:"inparty"`
	}
	rows,err:=db.Query("SELECT * FROM message")
	check(err)
	for rows.Next(){
		var s info
		err=rows.Scan(&s.id,&s.name,&s.age,&s.sex,&s.salary,&s.work,&s.inparty,)
		check(err)
		fmt.Println(s)
	}
	rows.Close()
}
```
如果需要按条件查询的话，可以使用mysql语句的where：

```
rows,err:=db.Query("SELECT name,age FROM message where id=2")
	check(err)
	for rows.Next(){
		var s info
		err=rows.Scan(&s.name,&s.age)
		check(err)
		fmt.Println(s)
	}
```
3、数据库增加条目
```
result,err:=db.Exec("INSERT INTO message(id,name,age,sex,salary,work,inparty)VALUES (?,?,?,?,?,?,?)",7,"李白",80,"男",1000,"中","是")
	check(err)
```

4、数据库的更新

```
results,err:=db.Exec("UPDATE message SET salary=? where id=?",8900,3)
	check(err)
	fmt.Println(results.RowsAffected()) //更新的条目数
```

5、数据库的删除

删除指的是删除表格中某些条目。

###下面是完整的增删改查代码：
```
results,err:=db.Exec("DELETE FROM message where id=?",2)
	check(err)
	fmt.Println(results.RowsAffected())  //删除的条目数
```

```
package main
 
import (
	_"mysql"
	"database/sql"
	"fmt"
)
 
func check(err error){
	if err!=nil{
		fmt.Println(err)
	}
 
}
 
 
func main(){
	db,err:=sql.Open("mysql","root:123456@tcp(127.0.0.1:3306)/employee")
	check(err)
 
	//query
	type info struct {
		id int `db:"id"`
		name string `db:"name"`
		age int `db:"age"`
		sex string `db:"sex"`
		salary int `db:"salary"`
		work string `db:"work"`
		inparty string `db:"inparty"`
	}
	//query
	rows,err:=db.Query("SELECT * FROM message")
	for rows.Next(){
		var s info
		err=rows.Scan(&s.id,&s.name,&s.age,&s.sex,&s.salary,&s.work,&s.inparty)
		check(err)
		fmt.Println(s)
	}
	rows.Close()
 
 
	//insert
	db.Exec("INSERT INTO message(id,name,age,sex,salary,work,inparty)VALUES (?,?,?,?,?,?,?)",7,"李白",80,"男",1000,"中","是")
 
	//update
	results,err:=db.Exec("UPDATE message SET salary=? where id=?",8900,3)
	check(err)
	fmt.Println(results.RowsAffected())
 
 
	//delete
	results,err:=db.Exec("DELETE FROM message where id=?",2)
	check(err)
	fmt.Println(results.RowsAffected())
	
 
}
 

```
