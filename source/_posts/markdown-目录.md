title: markdown 目录
author: Joe Tong
tags:
  - MARKDOWN
categories:
  - IT
date: 2019-07-24 18:29:00
---
markdown 实现页内跳转和自动生成目录

接上一篇 markdown 基本语法继续：

* 实现页内跳转


 1. 定义锚点   
`&lt;span id="jump"&gt;请点击跳转&lt;/span&gt;`  

 2. 使用markdown语法  
`[要跳转到的内容](#jump)`  




* 实现目录

在要生成目录的地方写：`[TOC]` 即可按照标题生成目录
有些markdown编辑器需要写： `@[TOC]`

案例：

```  

[TOC]

#  马什么梅
## 马冬梅
### 马冬什么
#### 马冬梅
##### 什么冬梅
###### 马冬梅
```  

生成的效果图：

![upload successful](/images/pasted-29.png)

