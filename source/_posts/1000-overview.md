title: SQLAlert 概述
tags:
  - SQLAlert
categories:
  - IT
author: Joe Tong
date: 2019-06-21 23:17:00
---
# 概述
SQLAlert 是一个基于 ES（Elasticsearch）的异常检测与报警输出引擎，该引擎支持用户使用脚本定义报警检测规则。用户可以在脚本中使用 SQL 语句查询 ES，通过计算及过滤等得出报警数据，再将报警数据写回 ES 或者通过邮件输出。

本文档主要介绍 SQLAlert 支持的脚本语言 RDL（Rule Description Language）的语法，及其提供的库函数的使用方法。本文档需要读者对其他至少一门编程语言的语法有一定的了解，例如：C/C++/Java/JS/PHP 等，编程语言的基础知识不在本文档的描述范围之内。

## 说明
SQLAlert 支持的 RDL 脚本是一种函数式脚本语言，不支持面向对象，其设计目的是为了弥补静态配置的不足。RDL 脚本在设计时充分考虑了应用场景，功能强大且语法简单、灵活。支持（1）JSON 数据类型；（2）算术与逻辑运算；（3）无类型的变量；（4）函数数定义；（5）相关库函数。

RDL 脚本库函数提供了常用计算模型，来制定复杂的报警规则，同时用户还可以通过函数定义，来实现更加复杂的规则。

## 执行脚本
SQLAlert 使用 Go 语言开发，有非常高的执行效率。由于 RDL 脚本在解释执行时不进行编译，所以不建议在脚本中定义时间复杂度很高的算法或操作。RDL 的执行依赖其解释器 SQLAlert，请确保系统中已经存在。SQLAlert 的安装及使用，不在本文档的介绍范围内。SQLAlert 在解释执行 RDL 脚本文件时，约定其需以 .rule 结尾，下面通过 “Hello World” 示例来介绍 RDL 脚本是如何执行的：

> ~~~ {.cs}
> print("hello world");
> ~~~

将上述内容保存到以  .rule 结尾的文件（例如 hello.rule）中，使用如下命令来执行：

> ~~~ {.cs}
> sqlalert -t hello.rule
> ~~~

上述脚本代码中，通过 print() 函数来打印 "Hello World" 字符串，该语句以分号（;）结束。执行完该脚本后，会在终端上打印出 Hello World 信息。

RDL 脚本支持 UTF-8 编码，但其变量、操作符等均仅支持英文格式。用户可以使用 sqlalert -h/--help 查看 sqlalert 的更多选项。
