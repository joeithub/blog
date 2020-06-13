title: MYBATIS select注解in的使用 
author: Joe Tong
tags:
  - JAVAEE
  - MYBATIS
categories:  
  - IT
date: 2020-05-29 15:53:20
---

使用@Select注解时使用in传入ids数组作为参数

展开
最近用到Mybatis的注解sql方式，结果发现在传入多个id作为参数跟xml的用法不太一样，到网上搜罗了一些方法，很多都会报错，最后如下方法调通了，重点是script标签，和参数的名字：
```
@Select({
            "&amp;lt;script&amp;gt;",
            "select",
            "c.cust_id, plat_cust_id, plat_cust_name, cust_map_id, cust_type, is_merchant, ",
            "create_time, create_opt_id, p.cust_name, p.tel, p.id_type, p.id_no ",
            "from personal_customer p",
            "left join customer c",
            "on c.cust_id = p.cust_id",
            "where p.cust_id in ",
                "&amp;lt;foreach item='item' index='index' collection='ids'",
                "open='(' separator=',' close=')'&amp;gt;",
                "#{item}",
                "&amp;lt;/foreach&amp;gt;",
            "&amp;lt;/script&amp;gt;"
    })
    @ResultMap("com.cloud.customer.dao.PersonalCustomerMapper.PersonDOResultMap")
    List&amp;lt;PersonInfoDO&amp;gt; selectRecordsByIds(@Param("ids") String[] ids);
}
```
在sql语句两头用script标签包起来，然后中间用foreach正常编辑，参数注入一个String数组，就可以完成查询了






