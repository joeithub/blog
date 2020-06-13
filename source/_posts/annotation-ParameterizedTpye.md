title: annotation ParameterizedTpye
author: Joe Tong
tags:
  - JAVAEE
  - REFLECTION
categories:
  - IT
date: 2019-07-16 23:07:00
---
```
private static Map&lt;String,Mapper&gt; loadMapperAnnotation(String daoClassPath){
    //得到dao接口的字节码对象
    Class daoClass = Class.forName(daoClassPath);
    //得到dao接口中的方法数组
    Method[] methods = daoClass.getMethods();
    for(Method method : methods){
    //取出注解的属性值  
    Select xxxAnno = method.getAnnotation(xxx.class);  
    String queryString = xxxAnno.value();  
    mapper.setQueryString(queryString);  
    //获取返回值的泛型类型  
    Type type = method.getGenericReturnType();  
    //判断type是不是参数化的类型  
    if(type instanceof ParamerizedType){  
       //强转  
       ParamerizedType ptype = (ParamerizedType)type;  
       //参数化类型获取真实类型  
       Type[] types = ptype.getActualTypeArguments();  
       //取出第一个  
       Class domainClass = (Class)types[0];  
       String resultType = domainClass.getName();  
       mapper.setResultType(resultType);  
    }  
    String methodName = method.getName();  
    String ClassName = method.getDeclaringClass().getName();  
    String key = className + "." + methodName;  
    mappers.put(key,mapper);  
}
```
