title: postman 接口文档
author: Joe Tong
tags:
  - JAVAEE
  - POSTMAN
categories:
  - IT
date: 2019-08-28 09:30:00
---
#### ensbrain/apis/sdp/user/controller

```
Introduction

What does your API do? 接口功能

Overview

Things that the developers should know about 开发者需要知道的事

Authentication

What is the preferred way of using the API? 怎样使用

Error Codes

What errors and status codes can a user expect? 什么错误和状态码使用者会遇到

Rate limit

Is there a limit to the number of requests an user can send? 是否有请求数量的限制
```

&lt;hr/&gt;

`ensbrain/apis/usergroup`  

```
PUT localhost:8282/ensbrain/apis/usergroup/add
localhost:8282/ensbrain/apis/usergroup/add
新增用户组usergroup

Headers

Content-Type	application/json
Bodyraw (application/json)
{
	"groupId": "3",
    "groupName": "sdptest3",
    "state": "ENABLED"
}
Example Requestlocalhost:8282/ensbrain/apis/usergroup/add
curl --location --request PUT "localhost:8282/ensbrain/apis/usergroup/add" \
  --header "Content-Type: application/json" \
  --data "{
	\"groupId\": \"3\",
    \"groupName\": \"sdptest3\",
    \"state\": \"ENABLED\"
}"
```
```
POST localhost:8282/ensbrain/apis/usergroup/update
localhost:8282/ensbrain/apis/usergroup/update
更新用户组usergroup

Headers

Content-Type	application/json
Bodyraw (application/json)
{
	"groupId": "4",
    "groupName": "sdp4",
    "state": "ENABLED"
}
Example Requestlocalhost:8282/ensbrain/apis/usergroup/update
curl --location --request POST "localhost:8282/ensbrain/apis/usergroup/update" \
  --header "Content-Type: application/json" \
  --data "{
	\"groupId\": \"4\",
    \"groupName\": \"sdp4\",
    \"state\": \"ENABLED\"
}"
```
```
GET localhost:8282/ensbrain/apis/usergroup/1
localhost:8282/ensbrain/apis/usergroup/1
根据id查找用户组

Headers

Content-Type	application/json
Bodyraw (application/json)
{
	"id" : "1"
}
Example Requestlocalhost:8282/ensbrain/apis/usergroup/1
curl --location --request GET "localhost:8282/ensbrain/apis/usergroup/1" \
  --header "Content-Type: application/json" \
  --data "{
	\"id\" : \"1\"
}"
```
```
POST localhost:8282/ensbrain/apis/usergroup/condition
localhost:8282/ensbrain/apis/usergroup/condition
按条件查询

Headers

Content-Type	application/json
Bodyraw (application/json)
{
	"condition" : {
		"groupName" : "sdptest"
	},
	"pageIndex" : 1,
	"pageSize"  : 10
}
Example Requestlocalhost:8282/ensbrain/apis/usergroup/condition
curl --location --request POST "localhost:8282/ensbrain/apis/usergroup/condition" \
  --header "Content-Type: application/json" \
  --data "{
	\"condition\" : {
		\"groupName\" : \"sdptest\"
	},
	\"pageIndex\" : 1,
	\"pageSize\"  : 10
}"
```
```
DELETE localhost:8282/ensbrain/apis/usergroup/delete
localhost:8282/ensbrain/apis/usergroup/delete
删除用户组

Headers

Content-Type	application/json
Bodyraw (application/json)
{
	"groupId": "4",
    "groupName": "sdp4",
    "state": "ENABLED"
}
Example Requestlocalhost:8282/ensbrain/apis/usergroup/delete
curl --location --request DELETE "localhost:8282/ensbrain/apis/usergroup/delete" \
  --header "Content-Type: application/json" \
  --data "{
	\"groupId\": \"4\",
    \"groupName\": \"sdp4\",
    \"state\": \"ENABLED\"
}"
```

&lt;hr/&gt;

`ensbrain/apis/userTerminal`

```
PUT localhost:8282/ensbrain/apis/userTerminal/add
localhost:8282/ensbrain/apis/userTerminal/add
增加userTerminal

Headers

Content-Type	application/json
Bodyraw (application/json)
{
				"terminalId": "123",
                "name": "term-test",
                "type": "PC",
                "description": "测试终端",
                "icon": "e4U=",
                "state": "ENABLED"
}
Example Requestlocalhost:8282/ensbrain/apis/userTerminal/add
curl --location --request PUT "localhost:8282/ensbrain/apis/userTerminal/add" \
  --header "Content-Type: application/json" \
  --data "{
				\"terminalId\": \"123\",
                \"name\": \"term-test\",
                \"type\": \"PC\",
                \"description\": \"测试终端\",
                \"icon\": \"e4U=\",
                \"state\": \"ENABLED\"
}"
```
```
DELETE localhost:8282/ensbrain/apis/userTerminal/delete
localhost:8282/ensbrain/apis/userTerminal/delete
删除userTerminal

Headers

Content-Type	application/json
Bodyraw (application/json)
{
				"terminalId": "123",
                "name": "term-test",
                "type": "PC",
                "description": "测试终端",
                "icon": "e4U=",
                "state": "ENABLED"
}
Example Requestlocalhost:8282/ensbrain/apis/userTerminal/delete
curl --location --request DELETE "localhost:8282/ensbrain/apis/userTerminal/delete" \
  --header "Content-Type: application/json" \
  --data "{
				\"terminalId\": \"123\",
                \"name\": \"term-test\",
                \"type\": \"PC\",
                \"description\": \"测试终端\",
                \"icon\": \"e4U=\",
                \"state\": \"ENABLED\"
}"
```
```
POST localhost:8282/ensbrain/apis/userTerminal/condition
localhost:8282/ensbrain/apis/userTerminal/condition
条件查询userTerminal

Headers

Content-Type	application/json
Bodyraw (application/json)
{
	"condition" : {
		"name" : "term-test"
	},
	"pageIndex" : 1,
	"pageSize"  : 10
}
Example Requestlocalhost:8282/ensbrain/apis/userTerminal/condition
curl --location --request POST "localhost:8282/ensbrain/apis/userTerminal/condition" \
  --header "Content-Type: application/json" \
  --data "{
	\"condition\" : {
		\"name\" : \"term-test\"
	},
	\"pageIndex\" : 1,
	\"pageSize\"  : 10
}"
GET localhost:8282/ensbrain/apis/userTerminal/123
localhost:8282/ensbrain/apis/userTerminal/123
根据id查找userTerminal

Headers

Content-Type	application/json
Bodyraw (application/json)
{
	"terminalId": "123",
    "name": "term-test",
    "type": "PC",
    "description": "测试终端",
    "icon" : [123,133],
    "state": "ENABLED"
}
Example Requestlocalhost:8282/ensbrain/apis/userTerminal/123
curl --location --request GET "localhost:8282/ensbrain/apis/userTerminal/123" \
  --header "Content-Type: application/json" \
  --data "{
	\"terminalId\": \"123\",
    \"name\": \"term-test\",
    \"type\": \"PC\",
    \"description\": \"测试终端\",
    \"icon\" : [123,133],
    \"state\": \"ENABLED\"
}"
```
```
POST localhost:8282/ensbrain/apis/userTerminal/update
localhost:8282/ensbrain/apis/userTerminal/update
更新userTerminal

Headers

Content-Type	application/json
Bodyraw (application/json)
{
	"terminalId": "123",
    "name": "term-test",
    "type": "PC",
    "description": "测试终端",
    "icon" : [123,133],
    "state": "ENABLED"
}
Example Requestlocalhost:8282/ensbrain/apis/userTerminal/update
curl --location --request POST "localhost:8282/ensbrain/apis/userTerminal/update" \
  --header "Content-Type: application/json" \
  --data "{
	\"terminalId\": \"123\",
    \"name\": \"term-test\",
    \"type\": \"PC\",
    \"description\": \"测试终端\",
    \"icon\" : [123,133],
    \"state\": \"ENABLED\"
}"
```
