title: SQLAlert 类型函数
tags:
  - SQLAlert
categories:
  - IT
author: Joe Tong
date: 2019-06-21 23:17:00
---
## 类型函数
本小节描述 RDL 中的数据类型相关函数。

### is_num(v)
本函数检测给定的值是否是一个数（包括整数和浮点数），如果给定的参数是一个数，则返回 true，否则返回 false，该函数接收 1 个参数：

- v: 任意类型，需要检测的值或变量。

该函数代码示例如下：

> ~~~ {.id .cs .numberLines}
> a = 123;
> print(a, "is number:", is_num(a));
> 
> a = 123.456;
> print(a, "is number:", is_num(a));
> 
> a = "zhang";
> print(a, "is number:", is_num(a));
> ~~~

示例代码的输出内容如下：

> ~~~ {.id .cs}
> 123 is number: true
> 123.456 is number: true
> zhang is number: false
> ~~~

### is_int(v)
本函数检测给定的值是否是一个整数，如果给定的参数是一个整数，则返回 true，否则返回 false，该函数接收 1 个参数：

- v: 任意类型，需要检测的值或变量。

该函数代码示例如下：

> ~~~ {.id .cs .numberLines}
> a = 123;
> print(a, "is int:", is_int(a));
> 
> a = 123.456;
> print(a, "is int:", is_int(a));
> 
> a = "zhang";
> print(a, "is int:", is_int(a));
> ~~~

示例代码的输出内容如下：

> ~~~ {.id .cs}
> 123 is int: true
> 123.456 is int: false
> zhang is int: false
> ~~~

### is_float(v)
本函数检测给定的值是否是一个浮点数，如果给定的参数是一个浮点数，则返回 true，否则返回 false，该函数接收 1 个参数：

- v: 任意类型，需要检测的值或变量。

该函数代码示例如下：

> ~~~ {.id .cs .numberLines}
> a = 123;
> print(a, "is float:", is_float(a));
> 
> a = 123.456;
> print(a, "is float:", is_float(a));
> 
> a = "zhang";
> print(a, "is float:", is_float(a));
> ~~~

示例代码的输出内容如下：

> ~~~ {.id .cs}
> 123 is float: false
> 123.456 is float: true
> zhang is float: false
> ~~~

### is_str(v)
本函数检测给定的值是否是一个字符串，如果给定的参数是一个字符串，则返回 true，否则返回 false，该函数接收 1 个参数：

- v: 任意类型，需要检测的值或变量。

该函数代码示例如下：

> ~~~ {.id .cs .numberLines}
> a = 123;
> print(a, "is str:", is_str(a));
> 
> a = 123.456;
> print(a, "is str:", is_str(a));
> 
> a = "zhang";
> print(a, "is str:", is_str(a));
> ~~~

示例代码的输出内容如下：

> ~~~ {.id .cs}
> 123 is str: false
> 123.456 is str: false
> zhang is str: true
> ~~~

### is_list(v)
本函数检测给定的值是否是一个数组（List），如果给定的参数是一个数组，则返回 true，否则返回 false，该函数接收 1 个参数：

- v: 任意类型，需要检测的值或变量。

该函数代码示例如下：

> ~~~ {.id .cs .numberLines}
> a = 123;
> print(a, "is list:", is_list(a));
> 
> a = [1, 2, 3 ];
> print(a, "is list:", is_list(a));
> 
> a = { "name": "zhang" };
> print(a, "is list:", is_list(a));
> ~~~

示例代码的输出内容如下：

> ~~~ {.id .cs}
> 123 is list: false
> [1,2,3] is list: true
> {"name":"zhang"} is list: false
> ~~~

### is_dict(v)
本函数检测给定的值是否是一个字典（Dict），如果给定的参数是一个字典，则返回 true，否则返回 false，该函数接收 1 个参数：

- v: 任意类型，需要检测的值或变量。

该函数代码示例如下：

> ~~~ {.id .cs .numberLines}
> a = 123;
> print(a, "is dict:", is_dict(a));
> 
> a = [1, 2, 3 ];
> print(a, "is dict:", is_dict(a));
> 
> a = { "name": "zhang" };
> print(a, "is dict:", is_dict(a));
> ~~~

示例代码的输出内容如下：

> ~~~ {.id .cs}
> 123 is dict: false
> [1,2,3] is dict: false
> {"name":"zhang"} is dict: true
> ~~~

### is_func(v)
本函数检测是否存在指定的函数，如果指定的函数存在，则返回 true，否则返回 false，该函数接收 1 个参数：

- v: 字段串类型，需要检测的函数名。

该函数代码示例如下：

> ~~~ {.id .cs .numberLines}
> print("print is func:", is_func("print"));
> print("xxxxx is func:", is_func("xxxxx"));
> ~~~

示例代码的输出内容如下：

> ~~~ {.id .cs}
> print is func: true
> xxxxx is func: false
> ~~~

### is_null(v)
本函数检测给定的值是否为 null（未赋值的变量即为 null）如指定的参数值为 null，则返回 true，否则返回 false，该函数接收 1 个参数：

- v: 任意类型，需要检测的值或变量。

该函数代码示例如下：

> ~~~ {.id .cs .numberLines}
> print("null is null", is_null(null));
> 
> a = null;
> print("a %(a) is null:", is_null(a));
> 
> a = 0;
> print("a %(a) is null:", is_null(a));
> ~~~

示例代码的输出内容如下：

> ~~~ {.id .cs}
> null is null true
> a null is null: true
> a 0 is null: false
> ~~~
