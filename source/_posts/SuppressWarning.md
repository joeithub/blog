title: '@SuppressWarning'
author: Joe Tong
tags:
  - JAVAEE
  - ANNOTATION
categories:
  - IT
date: 2019-07-25 13:15:00
---
@SuppressWarnings("rawtypes") 是什么含义

简介：java.lang.SuppressWarnings是J2SE 5.0中标准的Annotation之一。可以标注在类、字段、方法、参数、构造方法，以及局部变量上。    
作用：告诉编译器忽略指定的警告，不用在编译完成后出现警告信息。  
使用：  
@SuppressWarnings(“”)  
@SuppressWarnings({})  
@SuppressWarnings(value={})  
根据sun的官方文档描述：  
value - 将由编译器在注释的元素中取消显示的警告集。允许使用重复的名称。忽略第二个和后面出现的名称。出现未被识别的警告名不是 错误：编译器必须忽略无法识别的所有警告名。但如果某个注释包含未被识别的警告名，那么编译器可以随意发出一个警告。  
各编译器供应商应该将它们所支持的警告名连同注释类型一起记录。鼓励各供应商之间相互合作，确保在多个编译器中使用相同的名称。
示例：  
·   @SuppressWarnings("unchecked")  
告诉编译器忽略 unchecked 警告信息，如使用List，ArrayList等未进行参数化产生的警告信息。  
·   @SuppressWarnings("serial")  
如果编译器出现这样的警告信息：The serializable class WmailCalendar does not declare a static final serialVersionUID field of type long  
       使用这个注释将警告信息去掉。  
·   @SuppressWarnings("deprecation")  
如果使用了使用@Deprecated注释的方法，编译器将出现警告信息。  
       使用这个注释将警告信息去掉。  
·   @SuppressWarnings("unchecked", "deprecation")
告诉编译器同时忽略unchecked和deprecation的警告信息。  
·   @SuppressWarnings(value={"unchecked", "deprecation"})  
等同于@SuppressWarnings("unchecked", "deprecation")  

SuppressWarnings压制警告，即去除警告   
rawtypes是说传参时也要传递带泛型的参数  
@SuppressWarnings("unchecked")  
告诉编译器忽略 unchecked 警告信息，如使用List，ArrayList等未进行参数化产生的警告信息。  

