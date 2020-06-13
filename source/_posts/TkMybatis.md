title: TkMybatis
author: Joe Tong
tags:
  - JAVAEE 
categories:  
  - IT 
date: 2020-03-02 20:34:08
---

https://www.cnblogs.com/panchanggui/p/10748986.html

前提:

基于SpringBoot项目,正常集成Mybatis后,为了简化sql语句的编写,甚至达到无mapper.xml文件。
在本篇总结教程,不在进行SpringBoot集成Mybatis的概述。
如有需要,请查看我另一篇文章 SpringBoot集成MyBatis，这里不再赘述。

一. 实现步骤
1. 引入TkMybatis的Maven依赖
2. 实体类的相关配置,@Id,@Table
3. Mapper继承tkMabatis的Mapper接口
4. 启动类Application或自定义Mybatis配置类上使用@MapperScan注解扫描Mapper接口
5. 在application.properties配置文件中,配置mapper.xml文件指定的位置[可选]
6. 使用TkMybatis提供的sql执行方法

PS : 
    1. TkMybatis默认使用继承Mapper接口中传入的实体类对象去数据库寻找对应的表,因此如果表名与实体类名不满足对应规则时,会报错,这时使用@Table为实体类指定表。(这种对应规则为驼峰命名规则)
    2. 使用TkMybatis可以无xml文件实现数据库操作,只需要继承tkMybatis的Mapper接口即可。
    3. 如果有自定义特殊的需求,可以添加mapper.xml进行自定义sql书写,但路径必须与步骤4对应。
    
6. 如有需要,实现mapper.xml自定义sql语句
二. 实现细节
2.1 引入TkMybatis的Maven依赖
        <!-- https://mvnrepository.com/artifact/tk.mybatis/mapper -->
        <dependency>
            <groupId>tk.mybatis</groupId>
            <artifactId>mapper</artifactId>
            <version>4.0.3</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/tk.mybatis/mapper-spring-boot-starter -->
        <dependency>
            <groupId>tk.mybatis</groupId>
            <artifactId>mapper-spring-boot-starter</artifactId>
            <version>2.0.3</version>
        </dependency>
2.2 实体类的配置
TkMybatis默认使用继承Mapper接口中传入的实体类对象去数据库寻找对应的表,因此如果表名与实体类名不满足对应规则时,会报错,这时使用@Table为实体类指定表。(这种对应规则为驼峰命名规则)
下面以一个实体类Custoemr为例：

package cn.invengo.middleware.base.model;

import java.util.Date;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

// @Table指定该实体类对应的表名,如表名为base_customer,类名为BaseCustomer可以不需要此注解
@Table(name = "t_base_customer")
public class Customer {

    // @Id表示该字段对应数据库表的主键id
    // @GeneratedValue中strategy表示使用数据库自带的主键生成策略.
    // @GeneratedValue中generator配置为"JDBC",在数据插入完毕之后,会自动将主键id填充到实体类中.类似普通mapper.xml中配置的selectKey标签
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY,generator = "JDBC")
    private Long id;

    private String name;

    private String code;

    private String status;

    private String linkman;

    private String linkmanPhone;

    private String remark;

    private String attr01;

    private String attr02;

    private String attr03;

    private Date createDate;

    private Date lastUpdate;

    private Long creater;

    private Long lastUpdateMan;

    getter(),setter()方法省略...
}
2.3 Mapper继承tkMabatis的Mapper接口
import cn.base.model.Customer;
import tk.mybatis.mapper.common.Mapper;

/**   
 * @ClassName:  CustomerMapper   
 * @Description:TODO(Customer数据库操作层)   
 * @author: wwj
 * @date:   2018年8月31日 上午10:12:20   
 */  
public interface CustomerMapper extends Mapper<Customer> {
}
 

01.png
2.4 启动类Application或自定义Mybatis配置类上使用@MapperScan注解扫描Mapper接口
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.web.SpringBootServletInitializer;

import tk.mybatis.spring.annotation.MapperScan;

@SuppressWarnings("deprecation")
@SpringBootApplication
@MapperScan("cn.base.mapper")
public class MiddlewareApplication extends SpringBootServletInitializer {

    private static Logger logger = LoggerFactory.getLogger(MiddlewareApplication.class);

    public static void main(String[] args) {

        SpringApplication.run(MiddlewareApplication.class, args);
        logger.info("Application Start Success!");
    }
    
    // 当SpringBoot项目打成war包发布时,需要继承SpringBootServletInitializer接口实现该方法
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(Application.class);
    }
}
2.5 application.properties配置mapper.xml配置文件的扫描路径
mybatis.mapperLocations=classpath*:cn/base/mapper/*.xml
2.6 使用TkMybatis提供的sql执行方法
import java.util.List;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.invengo.middleware.base.mapper.CustomerMapper;
import cn.invengo.middleware.base.model.Customer;
import cn.invengo.middleware.base.service.BaseCustomerService;
import tk.mybatis.mapper.entity.Example;
import tk.mybatis.mapper.entity.Example.Criteria;

@Service
@Transactional
public class BaseCustomerServiceImpl implements BaseCustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<Customer> selectByEntity(Customer customer) {
        if(Objects.isNull(customer)) {
            customer = new Customer();
        }
        Example example = new Example(Customer.class);
        Criteria criteria = example.createCriteria();
        criteria.andEqualTo(customer);
        return customerMapper.selectByExample(example);
    }

    @Override
    public int insertSelective(Customer customer) {
        return customerMapper.insertSelective(customer);
    }

    @Override
    public int updateSelectiveById(Customer record) {
        return customerMapper.updateByPrimaryKeySelective(record);
    }
}
 

02.png
2.7 如有需要,自定义mapper.xml配置文件,完成自定义sql编写
ps:
1. 大多数复杂的需求,都能通过TkMyBatis的组合完成操作。这里以联表查询为例,自定义mapper.xml的sql编写。
2. 该mapper.xml与以往普通方式的mapper.xml文件不同之处在于,这里不需要使用resultMap进行字段的映射。当然如果想在返回的Map中新增返回字段映射直接添加新的字段即可。
    使用tkmybatis,在数据模型修改之后,修改代码也较为简便,只需要修改对应实体类中的字段即可。

eg:
ContainerMapper.xml:

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="cn.invengo.middleware.base.mapper.ContainerMapper">
    <select
        id="selectCodeByDeviceId"
        parameterType="java.lang.Long"
        resultType="java.lang.String">
        SELECT c.`code` FROM
        `t_base_container`
        c LEFT OUTER JOIN
        t_base_device
        d ON c.id =
        d.container_id
        WHERE d.id = #{deviceId,jdbcType=BIGINT};
    </select>
</mapper>

ps:这里需要注意的是,不要自己在mapper.xml中在书写tkMybatis已经有的一些基础方法了,否则会报错提示方法重复。
本篇总结到此结束。

