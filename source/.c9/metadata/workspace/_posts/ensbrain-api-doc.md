{"changed":false,"filter":false,"title":"ensbrain-api-doc.md","tooltip":"/_posts/ensbrain-api-doc.md","undoManager":{"mark":60,"position":60,"stack":[[{"start":{"row":0,"column":0},"end":{"row":262,"column":2},"action":"insert","lines":["ensbrain/apis/sdp/user/controller(0)","Introduction","","What does your API do? 接口功能","","Overview","","Things that the developers should know about 开发者需要知道的事","","Authentication","","What is the preferred way of using the API? 怎样使用","","Error Codes","","What errors and status codes can a user expect? 什么错误和状态码使用者会遇到","","Rate limit","","Is there a limit to the number of requests an user can send? 是否有请求数量的限制","","ensbrain/apis/usergroup","","PUT localhost:8282/ensbrain/apis/usergroup/add(0)","localhost:8282/ensbrain/apis/usergroup/add","新增用户组usergroup","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"groupId\": \"3\",","    \"groupName\": \"sdptest3\",","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/add","curl --location --request PUT \"localhost:8282/ensbrain/apis/usergroup/add\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"groupId\\\": \\\"3\\\",","    \\\"groupName\\\": \\\"sdptest3\\\",","    \\\"state\\\": \\\"ENABLED\\\"","}\"","POST localhost:8282/ensbrain/apis/usergroup/update(0)","localhost:8282/ensbrain/apis/usergroup/update","更新用户组usergroup","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"groupId\": \"4\",","    \"groupName\": \"sdp4\",","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/update","curl --location --request POST \"localhost:8282/ensbrain/apis/usergroup/update\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"groupId\\\": \\\"4\\\",","    \\\"groupName\\\": \\\"sdp4\\\",","    \\\"state\\\": \\\"ENABLED\\\"","}\"","GET localhost:8282/ensbrain/apis/usergroup/1(0)","localhost:8282/ensbrain/apis/usergroup/1","根据id查找用户组","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"id\" : \"1\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/1","curl --location --request GET \"localhost:8282/ensbrain/apis/usergroup/1\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"id\\\" : \\\"1\\\"","}\"","POST localhost:8282/ensbrain/apis/usergroup/condition(0)","localhost:8282/ensbrain/apis/usergroup/condition","按条件查询","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"condition\" : {","\t\t\"groupName\" : \"sdptest\"","\t},","\t\"pageIndex\" : 1,","\t\"pageSize\"  : 10","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/condition","curl --location --request POST \"localhost:8282/ensbrain/apis/usergroup/condition\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"condition\\\" : {","\t\t\\\"groupName\\\" : \\\"sdptest\\\"","\t},","\t\\\"pageIndex\\\" : 1,","\t\\\"pageSize\\\"  : 10","}\"","DELETE localhost:8282/ensbrain/apis/usergroup/delete(0)","localhost:8282/ensbrain/apis/usergroup/delete","删除用户组","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"groupId\": \"4\",","    \"groupName\": \"sdp4\",","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/delete","curl --location --request DELETE \"localhost:8282/ensbrain/apis/usergroup/delete\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"groupId\\\": \\\"4\\\",","    \\\"groupName\\\": \\\"sdp4\\\",","    \\\"state\\\": \\\"ENABLED\\\"","}\"","ensbrain/apis/userTerminal","","PUT localhost:8282/ensbrain/apis/userTerminal/add(0)","localhost:8282/ensbrain/apis/userTerminal/add","增加userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\t\t\t\"terminalId\": \"123\",","                \"name\": \"term-test\",","                \"type\": \"PC\",","                \"description\": \"测试终端\",","                \"icon\": \"e4U=\",","                \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/add","curl --location --request PUT \"localhost:8282/ensbrain/apis/userTerminal/add\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\t\t\t\\\"terminalId\\\": \\\"123\\\",","                \\\"name\\\": \\\"term-test\\\",","                \\\"type\\\": \\\"PC\\\",","                \\\"description\\\": \\\"测试终端\\\",","                \\\"icon\\\": \\\"e4U=\\\",","                \\\"state\\\": \\\"ENABLED\\\"","}\"","DELETE localhost:8282/ensbrain/apis/userTerminal/delete(0)","localhost:8282/ensbrain/apis/userTerminal/delete","删除userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\t\t\t\"terminalId\": \"123\",","                \"name\": \"term-test\",","                \"type\": \"PC\",","                \"description\": \"测试终端\",","                \"icon\": \"e4U=\",","                \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/delete","curl --location --request DELETE \"localhost:8282/ensbrain/apis/userTerminal/delete\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\t\t\t\\\"terminalId\\\": \\\"123\\\",","                \\\"name\\\": \\\"term-test\\\",","                \\\"type\\\": \\\"PC\\\",","                \\\"description\\\": \\\"测试终端\\\",","                \\\"icon\\\": \\\"e4U=\\\",","                \\\"state\\\": \\\"ENABLED\\\"","}\"","POST localhost:8282/ensbrain/apis/userTerminal/condition(0)","localhost:8282/ensbrain/apis/userTerminal/condition","条件查询userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"condition\" : {","\t\t\"name\" : \"term-test\"","\t},","\t\"pageIndex\" : 1,","\t\"pageSize\"  : 10","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/condition","curl --location --request POST \"localhost:8282/ensbrain/apis/userTerminal/condition\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"condition\\\" : {","\t\t\\\"name\\\" : \\\"term-test\\\"","\t},","\t\\\"pageIndex\\\" : 1,","\t\\\"pageSize\\\"  : 10","}\"","GET localhost:8282/ensbrain/apis/userTerminal/123(0)","localhost:8282/ensbrain/apis/userTerminal/123","根据id查找userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"terminalId\": \"123\",","    \"name\": \"term-test\",","    \"type\": \"PC\",","    \"description\": \"测试终端\",","    \"icon\" : [123,133],","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/123","curl --location --request GET \"localhost:8282/ensbrain/apis/userTerminal/123\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"terminalId\\\": \\\"123\\\",","    \\\"name\\\": \\\"term-test\\\",","    \\\"type\\\": \\\"PC\\\",","    \\\"description\\\": \\\"测试终端\\\",","    \\\"icon\\\" : [123,133],","    \\\"state\\\": \\\"ENABLED\\\"","}\"","POST localhost:8282/ensbrain/apis/userTerminal/update(0)","localhost:8282/ensbrain/apis/userTerminal/update","更新userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"terminalId\": \"123\",","    \"name\": \"term-test\",","    \"type\": \"PC\",","    \"description\": \"测试终端\",","    \"icon\" : [123,133],","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/update","curl --location --request POST \"localhost:8282/ensbrain/apis/userTerminal/update\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"terminalId\\\": \\\"123\\\",","    \\\"name\\\": \\\"term-test\\\",","    \\\"type\\\": \\\"PC\\\",","    \\\"description\\\": \\\"测试终端\\\",","    \\\"icon\\\" : [123,133],","    \\\"state\\\": \\\"ENABLED\\\"","}\""],"id":1}],[{"start":{"row":0,"column":36},"end":{"row":1,"column":0},"action":"insert","lines":["",""],"id":2}],[{"start":{"row":3,"column":0},"end":{"row":3,"column":1},"action":"insert","lines":["`"],"id":3},{"start":{"row":3,"column":1},"end":{"row":3,"column":2},"action":"insert","lines":["`"]},{"start":{"row":3,"column":2},"end":{"row":3,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":21,"column":0},"end":{"row":21,"column":1},"action":"insert","lines":["`"],"id":4},{"start":{"row":21,"column":1},"end":{"row":21,"column":2},"action":"insert","lines":["`"]},{"start":{"row":21,"column":2},"end":{"row":21,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":22,"column":0},"end":{"row":22,"column":1},"action":"insert","lines":["`"],"id":5}],[{"start":{"row":22,"column":24},"end":{"row":22,"column":25},"action":"insert","lines":["`"],"id":6}],[{"start":{"row":23,"column":0},"end":{"row":23,"column":1},"action":"insert","lines":["`"],"id":7},{"start":{"row":23,"column":1},"end":{"row":23,"column":2},"action":"insert","lines":["`"]},{"start":{"row":23,"column":2},"end":{"row":23,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":44,"column":2},"end":{"row":45,"column":0},"action":"insert","lines":["",""],"id":8},{"start":{"row":45,"column":0},"end":{"row":45,"column":1},"action":"insert","lines":["`"]},{"start":{"row":45,"column":1},"end":{"row":45,"column":2},"action":"insert","lines":["`"]},{"start":{"row":45,"column":2},"end":{"row":45,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":45,"column":3},"end":{"row":46,"column":0},"action":"insert","lines":["",""],"id":9},{"start":{"row":46,"column":0},"end":{"row":46,"column":1},"action":"insert","lines":["`"]},{"start":{"row":46,"column":1},"end":{"row":46,"column":2},"action":"insert","lines":["`"]},{"start":{"row":46,"column":2},"end":{"row":46,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":67,"column":2},"end":{"row":68,"column":0},"action":"insert","lines":["",""],"id":10},{"start":{"row":68,"column":0},"end":{"row":68,"column":1},"action":"insert","lines":["`"]},{"start":{"row":68,"column":1},"end":{"row":68,"column":2},"action":"insert","lines":["`"]},{"start":{"row":68,"column":2},"end":{"row":68,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":68,"column":3},"end":{"row":69,"column":0},"action":"insert","lines":["",""],"id":11},{"start":{"row":69,"column":0},"end":{"row":69,"column":1},"action":"insert","lines":["`"]},{"start":{"row":69,"column":1},"end":{"row":69,"column":2},"action":"insert","lines":["`"]},{"start":{"row":69,"column":2},"end":{"row":69,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":86,"column":2},"end":{"row":87,"column":0},"action":"insert","lines":["",""],"id":12},{"start":{"row":87,"column":0},"end":{"row":87,"column":1},"action":"insert","lines":["`"]},{"start":{"row":87,"column":1},"end":{"row":87,"column":2},"action":"insert","lines":["`"]},{"start":{"row":87,"column":2},"end":{"row":87,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":87,"column":3},"end":{"row":88,"column":0},"action":"insert","lines":["",""],"id":13},{"start":{"row":88,"column":0},"end":{"row":88,"column":1},"action":"insert","lines":["`"]},{"start":{"row":88,"column":1},"end":{"row":88,"column":2},"action":"insert","lines":["`"]},{"start":{"row":88,"column":2},"end":{"row":88,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":113,"column":2},"end":{"row":114,"column":0},"action":"insert","lines":["",""],"id":14},{"start":{"row":114,"column":0},"end":{"row":114,"column":1},"action":"insert","lines":["`"]},{"start":{"row":114,"column":1},"end":{"row":114,"column":2},"action":"insert","lines":["`"]},{"start":{"row":114,"column":2},"end":{"row":114,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":114,"column":3},"end":{"row":115,"column":0},"action":"insert","lines":["",""],"id":15},{"start":{"row":115,"column":0},"end":{"row":115,"column":1},"action":"insert","lines":["`"]},{"start":{"row":115,"column":1},"end":{"row":115,"column":2},"action":"insert","lines":["`"]},{"start":{"row":115,"column":2},"end":{"row":115,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":136,"column":2},"end":{"row":137,"column":0},"action":"insert","lines":["",""],"id":16},{"start":{"row":137,"column":0},"end":{"row":137,"column":1},"action":"insert","lines":["`"]},{"start":{"row":137,"column":1},"end":{"row":137,"column":2},"action":"insert","lines":["`"]},{"start":{"row":137,"column":2},"end":{"row":137,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":138,"column":0},"end":{"row":138,"column":1},"action":"insert","lines":["`"],"id":17}],[{"start":{"row":138,"column":27},"end":{"row":138,"column":28},"action":"insert","lines":["`"],"id":18}],[{"start":{"row":139,"column":0},"end":{"row":140,"column":0},"action":"insert","lines":["",""],"id":19},{"start":{"row":140,"column":0},"end":{"row":140,"column":1},"action":"insert","lines":["`"]},{"start":{"row":140,"column":1},"end":{"row":140,"column":2},"action":"insert","lines":["`"]},{"start":{"row":140,"column":2},"end":{"row":140,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":167,"column":2},"end":{"row":168,"column":0},"action":"insert","lines":["",""],"id":20},{"start":{"row":168,"column":0},"end":{"row":168,"column":1},"action":"insert","lines":["`"]},{"start":{"row":168,"column":1},"end":{"row":168,"column":2},"action":"insert","lines":["`"]},{"start":{"row":168,"column":2},"end":{"row":168,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":168,"column":3},"end":{"row":169,"column":0},"action":"insert","lines":["",""],"id":21},{"start":{"row":169,"column":0},"end":{"row":169,"column":1},"action":"insert","lines":["`"]},{"start":{"row":169,"column":1},"end":{"row":169,"column":2},"action":"insert","lines":["`"]},{"start":{"row":169,"column":2},"end":{"row":169,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":196,"column":2},"end":{"row":197,"column":0},"action":"insert","lines":["",""],"id":22},{"start":{"row":197,"column":0},"end":{"row":197,"column":1},"action":"insert","lines":["`"]},{"start":{"row":197,"column":1},"end":{"row":197,"column":2},"action":"insert","lines":["`"]},{"start":{"row":197,"column":2},"end":{"row":197,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":197,"column":3},"end":{"row":198,"column":0},"action":"insert","lines":["",""],"id":23},{"start":{"row":198,"column":0},"end":{"row":198,"column":1},"action":"insert","lines":["`"]},{"start":{"row":198,"column":1},"end":{"row":198,"column":2},"action":"insert","lines":["`"]},{"start":{"row":198,"column":2},"end":{"row":198,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":250,"column":2},"end":{"row":251,"column":0},"action":"insert","lines":["",""],"id":24},{"start":{"row":251,"column":0},"end":{"row":251,"column":1},"action":"insert","lines":["`"]},{"start":{"row":251,"column":1},"end":{"row":251,"column":2},"action":"insert","lines":["`"]},{"start":{"row":251,"column":2},"end":{"row":251,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":251,"column":3},"end":{"row":252,"column":0},"action":"insert","lines":["",""],"id":25},{"start":{"row":252,"column":0},"end":{"row":252,"column":1},"action":"insert","lines":["`"]},{"start":{"row":252,"column":1},"end":{"row":252,"column":2},"action":"insert","lines":["`"]},{"start":{"row":252,"column":2},"end":{"row":252,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":279,"column":2},"end":{"row":280,"column":0},"action":"insert","lines":["",""],"id":26},{"start":{"row":280,"column":0},"end":{"row":280,"column":1},"action":"insert","lines":["`"]},{"start":{"row":280,"column":1},"end":{"row":280,"column":2},"action":"insert","lines":["`"]},{"start":{"row":280,"column":2},"end":{"row":280,"column":3},"action":"insert","lines":["`"]}],[{"start":{"row":21,"column":3},"end":{"row":22,"column":0},"action":"insert","lines":["",""],"id":27},{"start":{"row":22,"column":0},"end":{"row":22,"column":1},"action":"insert","lines":["<"]},{"start":{"row":22,"column":1},"end":{"row":22,"column":2},"action":"insert","lines":[">"]}],[{"start":{"row":22,"column":1},"end":{"row":22,"column":2},"action":"insert","lines":["h"],"id":28},{"start":{"row":22,"column":2},"end":{"row":22,"column":3},"action":"insert","lines":["r"]},{"start":{"row":22,"column":3},"end":{"row":22,"column":4},"action":"insert","lines":["/"]}],[{"start":{"row":138,"column":3},"end":{"row":139,"column":0},"action":"insert","lines":["",""],"id":29},{"start":{"row":139,"column":0},"end":{"row":139,"column":1},"action":"insert","lines":["<"]},{"start":{"row":139,"column":1},"end":{"row":139,"column":2},"action":"insert","lines":[">"]}],[{"start":{"row":139,"column":1},"end":{"row":139,"column":2},"action":"insert","lines":["h"],"id":30},{"start":{"row":139,"column":2},"end":{"row":139,"column":3},"action":"insert","lines":["r"]},{"start":{"row":139,"column":3},"end":{"row":139,"column":4},"action":"insert","lines":["/"]}],[{"start":{"row":21,"column":3},"end":{"row":22,"column":0},"action":"insert","lines":["",""],"id":31}],[{"start":{"row":23,"column":5},"end":{"row":24,"column":0},"action":"insert","lines":["",""],"id":32}],[{"start":{"row":140,"column":3},"end":{"row":141,"column":0},"action":"insert","lines":["",""],"id":33}],[{"start":{"row":142,"column":5},"end":{"row":143,"column":0},"action":"insert","lines":["",""],"id":34}],[{"start":{"row":2,"column":0},"end":{"row":2,"column":12},"action":"remove","lines":["Introduction"],"id":35}],[{"start":{"row":3,"column":3},"end":{"row":4,"column":0},"action":"insert","lines":["",""],"id":36}],[{"start":{"row":4,"column":0},"end":{"row":4,"column":12},"action":"insert","lines":["Introduction"],"id":37}],[{"start":{"row":4,"column":12},"end":{"row":5,"column":0},"action":"insert","lines":["",""],"id":38}],[{"start":{"row":0,"column":0},"end":{"row":1,"column":0},"action":"insert","lines":["",""],"id":39},{"start":{"row":1,"column":0},"end":{"row":2,"column":0},"action":"insert","lines":["",""]},{"start":{"row":2,"column":0},"end":{"row":3,"column":0},"action":"insert","lines":["",""]},{"start":{"row":3,"column":0},"end":{"row":4,"column":0},"action":"insert","lines":["",""]}],[{"start":{"row":0,"column":0},"end":{"row":8,"column":3},"action":"insert","lines":["title: ONOS 开发教程","author: Joe Tong","tags:","  - JAVAEE","  - ONOS","categories:","  - IT","date: 2019-08-10 09:30:00","---"],"id":40}],[{"start":{"row":0,"column":7},"end":{"row":0,"column":16},"action":"remove","lines":["ONOS 开发教程"],"id":41},{"start":{"row":0,"column":7},"end":{"row":0,"column":8},"action":"insert","lines":["p"]},{"start":{"row":0,"column":8},"end":{"row":0,"column":9},"action":"insert","lines":["o"]},{"start":{"row":0,"column":9},"end":{"row":0,"column":10},"action":"insert","lines":["s"]},{"start":{"row":0,"column":10},"end":{"row":0,"column":11},"action":"insert","lines":["t"]},{"start":{"row":0,"column":11},"end":{"row":0,"column":12},"action":"insert","lines":["m"]},{"start":{"row":0,"column":12},"end":{"row":0,"column":13},"action":"insert","lines":["a"]},{"start":{"row":0,"column":13},"end":{"row":0,"column":14},"action":"insert","lines":["n"]}],[{"start":{"row":0,"column":14},"end":{"row":0,"column":15},"action":"insert","lines":[" "],"id":42},{"start":{"row":0,"column":15},"end":{"row":0,"column":16},"action":"insert","lines":["j"]},{"start":{"row":0,"column":16},"end":{"row":0,"column":17},"action":"insert","lines":["i"]},{"start":{"row":0,"column":17},"end":{"row":0,"column":18},"action":"insert","lines":["e"]}],[{"start":{"row":0,"column":17},"end":{"row":0,"column":18},"action":"remove","lines":["e"],"id":43},{"start":{"row":0,"column":16},"end":{"row":0,"column":17},"action":"remove","lines":["i"]},{"start":{"row":0,"column":15},"end":{"row":0,"column":16},"action":"remove","lines":["j"]}],[{"start":{"row":0,"column":15},"end":{"row":0,"column":19},"action":"insert","lines":["接口文档"],"id":55}],[{"start":{"row":4,"column":4},"end":{"row":4,"column":8},"action":"remove","lines":["ONOS"],"id":56}],[{"start":{"row":4,"column":4},"end":{"row":4,"column":9},"action":"insert","lines":["s d p"],"id":59}],[{"start":{"row":4,"column":8},"end":{"row":4,"column":9},"action":"remove","lines":["p"],"id":60},{"start":{"row":4,"column":7},"end":{"row":4,"column":8},"action":"remove","lines":[" "]},{"start":{"row":4,"column":6},"end":{"row":4,"column":7},"action":"remove","lines":["d"]},{"start":{"row":4,"column":5},"end":{"row":4,"column":6},"action":"remove","lines":[" "]}],[{"start":{"row":4,"column":5},"end":{"row":4,"column":6},"action":"insert","lines":["d"],"id":61},{"start":{"row":4,"column":6},"end":{"row":4,"column":7},"action":"insert","lines":["p"]}],[{"start":{"row":4,"column":6},"end":{"row":4,"column":7},"action":"remove","lines":["p"],"id":62},{"start":{"row":4,"column":5},"end":{"row":4,"column":6},"action":"remove","lines":["d"]},{"start":{"row":4,"column":4},"end":{"row":4,"column":5},"action":"remove","lines":["s"]}],[{"start":{"row":4,"column":4},"end":{"row":4,"column":5},"action":"insert","lines":["p"],"id":63},{"start":{"row":4,"column":5},"end":{"row":4,"column":6},"action":"insert","lines":["o"]},{"start":{"row":4,"column":6},"end":{"row":4,"column":7},"action":"insert","lines":["s"]},{"start":{"row":4,"column":7},"end":{"row":4,"column":8},"action":"insert","lines":["t"]}],[{"start":{"row":4,"column":4},"end":{"row":4,"column":8},"action":"remove","lines":["post"],"id":64},{"start":{"row":4,"column":4},"end":{"row":4,"column":11},"action":"insert","lines":["postman"]}],[{"start":{"row":12,"column":0},"end":{"row":12,"column":1},"action":"insert","lines":["#"],"id":65},{"start":{"row":12,"column":1},"end":{"row":12,"column":2},"action":"insert","lines":["#"]},{"start":{"row":12,"column":2},"end":{"row":12,"column":3},"action":"insert","lines":["#"]},{"start":{"row":12,"column":3},"end":{"row":12,"column":4},"action":"insert","lines":["#"]}],[{"start":{"row":12,"column":4},"end":{"row":12,"column":5},"action":"insert","lines":[" "],"id":66}],[{"start":{"row":10,"column":0},"end":{"row":11,"column":0},"action":"remove","lines":["",""],"id":67},{"start":{"row":9,"column":0},"end":{"row":10,"column":0},"action":"remove","lines":["",""]}],[{"start":{"row":10,"column":41},"end":{"row":11,"column":0},"action":"remove","lines":["",""],"id":68}],[{"start":{"row":7,"column":15},"end":{"row":7,"column":16},"action":"remove","lines":["0"],"id":69},{"start":{"row":7,"column":14},"end":{"row":7,"column":15},"action":"remove","lines":["1"]}],[{"start":{"row":7,"column":14},"end":{"row":7,"column":15},"action":"insert","lines":["2"],"id":70},{"start":{"row":7,"column":15},"end":{"row":7,"column":16},"action":"insert","lines":["8"]}],[{"start":{"row":10,"column":0},"end":{"row":297,"column":3},"action":"remove","lines":["#### ensbrain/apis/sdp/user/controller(0)","","```","Introduction","","What does your API do? 接口功能","","Overview","","Things that the developers should know about 开发者需要知道的事","","Authentication","","What is the preferred way of using the API? 怎样使用","","Error Codes","","What errors and status codes can a user expect? 什么错误和状态码使用者会遇到","","Rate limit","","Is there a limit to the number of requests an user can send? 是否有请求数量的限制","```","","<hr/>","","`ensbrain/apis/usergroup`","```","PUT localhost:8282/ensbrain/apis/usergroup/add(0)","localhost:8282/ensbrain/apis/usergroup/add","新增用户组usergroup","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"groupId\": \"3\",","    \"groupName\": \"sdptest3\",","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/add","curl --location --request PUT \"localhost:8282/ensbrain/apis/usergroup/add\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"groupId\\\": \\\"3\\\",","    \\\"groupName\\\": \\\"sdptest3\\\",","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","POST localhost:8282/ensbrain/apis/usergroup/update(0)","localhost:8282/ensbrain/apis/usergroup/update","更新用户组usergroup","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"groupId\": \"4\",","    \"groupName\": \"sdp4\",","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/update","curl --location --request POST \"localhost:8282/ensbrain/apis/usergroup/update\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"groupId\\\": \\\"4\\\",","    \\\"groupName\\\": \\\"sdp4\\\",","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","GET localhost:8282/ensbrain/apis/usergroup/1(0)","localhost:8282/ensbrain/apis/usergroup/1","根据id查找用户组","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"id\" : \"1\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/1","curl --location --request GET \"localhost:8282/ensbrain/apis/usergroup/1\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"id\\\" : \\\"1\\\"","}\"","```","```","POST localhost:8282/ensbrain/apis/usergroup/condition(0)","localhost:8282/ensbrain/apis/usergroup/condition","按条件查询","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"condition\" : {","\t\t\"groupName\" : \"sdptest\"","\t},","\t\"pageIndex\" : 1,","\t\"pageSize\"  : 10","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/condition","curl --location --request POST \"localhost:8282/ensbrain/apis/usergroup/condition\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"condition\\\" : {","\t\t\\\"groupName\\\" : \\\"sdptest\\\"","\t},","\t\\\"pageIndex\\\" : 1,","\t\\\"pageSize\\\"  : 10","}\"","```","```","DELETE localhost:8282/ensbrain/apis/usergroup/delete(0)","localhost:8282/ensbrain/apis/usergroup/delete","删除用户组","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"groupId\": \"4\",","    \"groupName\": \"sdp4\",","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/delete","curl --location --request DELETE \"localhost:8282/ensbrain/apis/usergroup/delete\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"groupId\\\": \\\"4\\\",","    \\\"groupName\\\": \\\"sdp4\\\",","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```","","<hr/>","","`ensbrain/apis/userTerminal`","","```","PUT localhost:8282/ensbrain/apis/userTerminal/add(0)","localhost:8282/ensbrain/apis/userTerminal/add","增加userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\t\t\t\"terminalId\": \"123\",","                \"name\": \"term-test\",","                \"type\": \"PC\",","                \"description\": \"测试终端\",","                \"icon\": \"e4U=\",","                \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/add","curl --location --request PUT \"localhost:8282/ensbrain/apis/userTerminal/add\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\t\t\t\\\"terminalId\\\": \\\"123\\\",","                \\\"name\\\": \\\"term-test\\\",","                \\\"type\\\": \\\"PC\\\",","                \\\"description\\\": \\\"测试终端\\\",","                \\\"icon\\\": \\\"e4U=\\\",","                \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","DELETE localhost:8282/ensbrain/apis/userTerminal/delete(0)","localhost:8282/ensbrain/apis/userTerminal/delete","删除userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\t\t\t\"terminalId\": \"123\",","                \"name\": \"term-test\",","                \"type\": \"PC\",","                \"description\": \"测试终端\",","                \"icon\": \"e4U=\",","                \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/delete","curl --location --request DELETE \"localhost:8282/ensbrain/apis/userTerminal/delete\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\t\t\t\\\"terminalId\\\": \\\"123\\\",","                \\\"name\\\": \\\"term-test\\\",","                \\\"type\\\": \\\"PC\\\",","                \\\"description\\\": \\\"测试终端\\\",","                \\\"icon\\\": \\\"e4U=\\\",","                \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","POST localhost:8282/ensbrain/apis/userTerminal/condition(0)","localhost:8282/ensbrain/apis/userTerminal/condition","条件查询userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"condition\" : {","\t\t\"name\" : \"term-test\"","\t},","\t\"pageIndex\" : 1,","\t\"pageSize\"  : 10","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/condition","curl --location --request POST \"localhost:8282/ensbrain/apis/userTerminal/condition\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"condition\\\" : {","\t\t\\\"name\\\" : \\\"term-test\\\"","\t},","\t\\\"pageIndex\\\" : 1,","\t\\\"pageSize\\\"  : 10","}\"","GET localhost:8282/ensbrain/apis/userTerminal/123(0)","localhost:8282/ensbrain/apis/userTerminal/123","根据id查找userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"terminalId\": \"123\",","    \"name\": \"term-test\",","    \"type\": \"PC\",","    \"description\": \"测试终端\",","    \"icon\" : [123,133],","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/123","curl --location --request GET \"localhost:8282/ensbrain/apis/userTerminal/123\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"terminalId\\\": \\\"123\\\",","    \\\"name\\\": \\\"term-test\\\",","    \\\"type\\\": \\\"PC\\\",","    \\\"description\\\": \\\"测试终端\\\",","    \\\"icon\\\" : [123,133],","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","POST localhost:8282/ensbrain/apis/userTerminal/update(0)","localhost:8282/ensbrain/apis/userTerminal/update","更新userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"terminalId\": \"123\",","    \"name\": \"term-test\",","    \"type\": \"PC\",","    \"description\": \"测试终端\",","    \"icon\" : [123,133],","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/update","curl --location --request POST \"localhost:8282/ensbrain/apis/userTerminal/update\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"terminalId\\\": \\\"123\\\",","    \\\"name\\\": \\\"term-test\\\",","    \\\"type\\\": \\\"PC\\\",","    \\\"description\\\": \\\"测试终端\\\",","    \\\"icon\\\" : [123,133],","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```"],"id":71}],[{"start":{"row":10,"column":0},"end":{"row":297,"column":3},"action":"insert","lines":["#### ensbrain/apis/sdp/user/controller(0)","","```","Introduction","","What does your API do? 接口功能","","Overview","","Things that the developers should know about 开发者需要知道的事","","Authentication","","What is the preferred way of using the API? 怎样使用","","Error Codes","","What errors and status codes can a user expect? 什么错误和状态码使用者会遇到","","Rate limit","","Is there a limit to the number of requests an user can send? 是否有请求数量的限制","```","","<hr/>","","`ensbrain/apis/usergroup`","```","PUT localhost:8282/ensbrain/apis/usergroup/add(0)","localhost:8282/ensbrain/apis/usergroup/add","新增用户组usergroup","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"groupId\": \"3\",","    \"groupName\": \"sdptest3\",","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/add","curl --location --request PUT \"localhost:8282/ensbrain/apis/usergroup/add\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"groupId\\\": \\\"3\\\",","    \\\"groupName\\\": \\\"sdptest3\\\",","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","POST localhost:8282/ensbrain/apis/usergroup/update(0)","localhost:8282/ensbrain/apis/usergroup/update","更新用户组usergroup","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"groupId\": \"4\",","    \"groupName\": \"sdp4\",","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/update","curl --location --request POST \"localhost:8282/ensbrain/apis/usergroup/update\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"groupId\\\": \\\"4\\\",","    \\\"groupName\\\": \\\"sdp4\\\",","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","GET localhost:8282/ensbrain/apis/usergroup/1(0)","localhost:8282/ensbrain/apis/usergroup/1","根据id查找用户组","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"id\" : \"1\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/1","curl --location --request GET \"localhost:8282/ensbrain/apis/usergroup/1\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"id\\\" : \\\"1\\\"","}\"","```","```","POST localhost:8282/ensbrain/apis/usergroup/condition(0)","localhost:8282/ensbrain/apis/usergroup/condition","按条件查询","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"condition\" : {","\t\t\"groupName\" : \"sdptest\"","\t},","\t\"pageIndex\" : 1,","\t\"pageSize\"  : 10","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/condition","curl --location --request POST \"localhost:8282/ensbrain/apis/usergroup/condition\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"condition\\\" : {","\t\t\\\"groupName\\\" : \\\"sdptest\\\"","\t},","\t\\\"pageIndex\\\" : 1,","\t\\\"pageSize\\\"  : 10","}\"","```","```","DELETE localhost:8282/ensbrain/apis/usergroup/delete(0)","localhost:8282/ensbrain/apis/usergroup/delete","删除用户组","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"groupId\": \"4\",","    \"groupName\": \"sdp4\",","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/usergroup/delete","curl --location --request DELETE \"localhost:8282/ensbrain/apis/usergroup/delete\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"groupId\\\": \\\"4\\\",","    \\\"groupName\\\": \\\"sdp4\\\",","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```","","<hr/>","","`ensbrain/apis/userTerminal`","","```","PUT localhost:8282/ensbrain/apis/userTerminal/add(0)","localhost:8282/ensbrain/apis/userTerminal/add","增加userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\t\t\t\"terminalId\": \"123\",","                \"name\": \"term-test\",","                \"type\": \"PC\",","                \"description\": \"测试终端\",","                \"icon\": \"e4U=\",","                \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/add","curl --location --request PUT \"localhost:8282/ensbrain/apis/userTerminal/add\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\t\t\t\\\"terminalId\\\": \\\"123\\\",","                \\\"name\\\": \\\"term-test\\\",","                \\\"type\\\": \\\"PC\\\",","                \\\"description\\\": \\\"测试终端\\\",","                \\\"icon\\\": \\\"e4U=\\\",","                \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","DELETE localhost:8282/ensbrain/apis/userTerminal/delete(0)","localhost:8282/ensbrain/apis/userTerminal/delete","删除userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\t\t\t\"terminalId\": \"123\",","                \"name\": \"term-test\",","                \"type\": \"PC\",","                \"description\": \"测试终端\",","                \"icon\": \"e4U=\",","                \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/delete","curl --location --request DELETE \"localhost:8282/ensbrain/apis/userTerminal/delete\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\t\t\t\\\"terminalId\\\": \\\"123\\\",","                \\\"name\\\": \\\"term-test\\\",","                \\\"type\\\": \\\"PC\\\",","                \\\"description\\\": \\\"测试终端\\\",","                \\\"icon\\\": \\\"e4U=\\\",","                \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","POST localhost:8282/ensbrain/apis/userTerminal/condition(0)","localhost:8282/ensbrain/apis/userTerminal/condition","条件查询userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"condition\" : {","\t\t\"name\" : \"term-test\"","\t},","\t\"pageIndex\" : 1,","\t\"pageSize\"  : 10","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/condition","curl --location --request POST \"localhost:8282/ensbrain/apis/userTerminal/condition\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"condition\\\" : {","\t\t\\\"name\\\" : \\\"term-test\\\"","\t},","\t\\\"pageIndex\\\" : 1,","\t\\\"pageSize\\\"  : 10","}\"","GET localhost:8282/ensbrain/apis/userTerminal/123(0)","localhost:8282/ensbrain/apis/userTerminal/123","根据id查找userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"terminalId\": \"123\",","    \"name\": \"term-test\",","    \"type\": \"PC\",","    \"description\": \"测试终端\",","    \"icon\" : [123,133],","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/123","curl --location --request GET \"localhost:8282/ensbrain/apis/userTerminal/123\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"terminalId\\\": \\\"123\\\",","    \\\"name\\\": \\\"term-test\\\",","    \\\"type\\\": \\\"PC\\\",","    \\\"description\\\": \\\"测试终端\\\",","    \\\"icon\\\" : [123,133],","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```","```","POST localhost:8282/ensbrain/apis/userTerminal/update(0)","localhost:8282/ensbrain/apis/userTerminal/update","更新userTerminal","","Headers","","Content-Type\tapplication/json","Bodyraw (application/json)","{","\t\"terminalId\": \"123\",","    \"name\": \"term-test\",","    \"type\": \"PC\",","    \"description\": \"测试终端\",","    \"icon\" : [123,133],","    \"state\": \"ENABLED\"","}","Example Requestlocalhost:8282/ensbrain/apis/userTerminal/update","curl --location --request POST \"localhost:8282/ensbrain/apis/userTerminal/update\" \\","  --header \"Content-Type: application/json\" \\","  --data \"{","\t\\\"terminalId\\\": \\\"123\\\",","    \\\"name\\\": \\\"term-test\\\",","    \\\"type\\\": \\\"PC\\\",","    \\\"description\\\": \\\"测试终端\\\",","    \\\"icon\\\" : [123,133],","    \\\"state\\\": \\\"ENABLED\\\"","}\"","```"],"id":72}],[{"start":{"row":36,"column":25},"end":{"row":37,"column":0},"action":"insert","lines":["",""],"id":73}],[{"start":{"row":36,"column":25},"end":{"row":36,"column":26},"action":"insert","lines":[" "],"id":74},{"start":{"row":36,"column":26},"end":{"row":36,"column":27},"action":"insert","lines":[" "]}]]},"ace":{"folds":[],"scrolltop":5401.5,"scrollleft":0,"selection":{"start":{"row":5,"column":11},"end":{"row":5,"column":11},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":283,"state":["githubblock",[],["","```",""],"start"],"mode":"ace/mode/markdown"}},"timestamp":1566988417779}