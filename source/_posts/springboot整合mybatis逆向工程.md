title: springboot整合mybatis逆向工程
author: Joe Tong
tags:
  - JAVAEE
  - MYBATIS
categories:
  - IT
date: 2019-09-12 14:57:00
---
1.添加依赖

```
&lt;!--mysql依赖--&gt;
&lt;dependency&gt;
   &lt;groupId&gt;mysql&lt;/groupId&gt;
   &lt;artifactId&gt;mysql-connector-java&lt;/artifactId&gt;
&lt;/dependency&gt;

&lt;!-- SpringBoot - MyBatis --&gt;
&lt;dependency&gt;
   &lt;groupId&gt;org.mybatis.spring.boot&lt;/groupId&gt;
   &lt;artifactId&gt;mybatis-spring-boot-starter&lt;/artifactId&gt;
   &lt;version&gt;1.3.1&lt;/version&gt;
&lt;/dependency&gt;

&lt;!-- SpringBoot - MyBatis 逆向工程 --&gt;
&lt;dependency&gt;
   &lt;groupId&gt;org.mybatis.generator&lt;/groupId&gt;
   &lt;artifactId&gt;mybatis-generator-core&lt;/artifactId&gt;
   &lt;version&gt;1.3.5&lt;/version&gt;
&lt;/dependency&gt;
```

2.添加插件

```
&lt;!-- MyBatis 逆向工程 插件 --&gt;
&lt;plugin&gt;
   &lt;groupId&gt;org.mybatis.generator&lt;/groupId&gt;
   &lt;artifactId&gt;mybatis-generator-maven-plugin&lt;/artifactId&gt;
   &lt;version&gt;1.3.5&lt;/version&gt;
   &lt;configuration&gt;
      &lt;!--允许移动生成的文件 --&gt;
      &lt;verbose&gt;true&lt;/verbose&gt;
      &lt;!-- 是否覆盖 --&gt;
      &lt;overwrite&gt;true&lt;/overwrite&gt;
   &lt;/configuration&gt;

   &lt;dependencies&gt;
      &lt;dependency&gt;
         &lt;groupId&gt; mysql&lt;/groupId&gt;
         &lt;artifactId&gt; mysql-connector-java&lt;/artifactId&gt;
         &lt;version&gt;5.1.30&lt;/version&gt;
      &lt;/dependency&gt;
   &lt;/dependencies&gt;
&lt;/plugin&gt;
```

3.application配置mysql连接

```
spring:
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://127.0.0.1:3306/wechat
    username: root
    password: root
```

4.generatorConfig.xml配置文件

```
&lt;?xml version="1.0" encoding="UTF-8"?&gt;&lt;!DOCTYPE generatorConfiguration PUBLIC
        "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd"&gt;
&lt;generatorConfiguration&gt;
    &lt;context id="DB2Tables" targetRuntime="MyBatis3"&gt;
        &lt;!--去掉注释--&gt;
        &lt;commentGenerator&gt;
            &lt;property name="suppressAllComments" value="true"/&gt;
        &lt;/commentGenerator&gt;
        &lt;!--需要配置数据库连接--&gt;
        &lt;jdbcConnection driverClass="com.mysql.jdbc.Driver"
                        connectionURL="jdbc:mysql://****:3306/competition?characterEncoding=utf-8&amp;amp;useSSL=false"
                        userId="****"
                        password="****"&gt;
        &lt;/jdbcConnection&gt;
        &lt;javaTypeResolver &gt;
            &lt;property name="forceBigDecimals" value="false" /&gt;
        &lt;/javaTypeResolver&gt;

        &lt;!--指定entity生成的位置--&gt;
        &lt;javaModelGenerator targetPackage="com.example.competition.dao.entity" targetProject="./src/main/java"&gt;
            &lt;property name="enableSubPackages" value="true" /&gt;
            &lt;property name="trimStrings" value="true" /&gt;
        &lt;/javaModelGenerator&gt;

        &lt;!--sql映射文件生成的位置 mapper.xml--&gt;
        &lt;sqlMapGenerator targetPackage="mapper"  targetProject="./src/main/resources"&gt;
            &lt;property name="enableSubPackages" value="true" /&gt;
        &lt;/sqlMapGenerator&gt;

        &lt;!--指定DaoMapper生成的位置 mapper.java--&gt;
        &lt;javaClientGenerator type="XMLMAPPER" targetPackage="com.example.competition.dao.mapper" targetProject="./src/main/java"&gt;
            &lt;property name="enableSubPackages" value="true" /&gt;
        &lt;/javaClientGenerator&gt;

        &lt;!--table是指定每个表的生成策略--&gt;
        &lt;!--&lt;table tableName="department" domainObjectName="Department"&gt;&lt;/table&gt;--&gt;
        &lt;!--&lt;table tableName="group_teacher_rel" domainObjectName="Group_teacher_rel"&gt;&lt;/table&gt;--&gt;
        &lt;!--&lt;table tableName="groups" domainObjectName="Groups"&gt;&lt;/table&gt;--&gt;
        &lt;!--&lt;table tableName="specialty" domainObjectName="Specialty"&gt;&lt;/table&gt;--&gt;
        &lt;!--&lt;table tableName="student" domainObjectName="Student"&gt;&lt;/table&gt;--&gt;
        &lt;!--&lt;table tableName="teacher" domainObjectName="Teacher"&gt;&lt;/table&gt;--&gt;
        &lt;table tableName="test" domainObjectName="Test"&gt;&lt;/table&gt;
    &lt;/context&gt;
&lt;/generatorConfiguration&gt;
```

5.启动类Generator

```
public class Generator {
    public static void main(String[] args){
        List&lt;String&gt; warnings = new ArrayList&lt;&gt;();
        boolean overwrite = true;
        String genCfg = "/generatorConfig.xml";
        File configFile = new File(Generator.class.getResource(genCfg).getFile());
        ConfigurationParser cp = new ConfigurationParser(warnings);
        Configuration config = null;
        try {
            config = cp.parseConfiguration(configFile);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (XMLParserException e) {
            e.printStackTrace();
        }
        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = null;
        try {
            myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
        } catch (InvalidConfigurationException e) {
            e.printStackTrace();
        }
        try {
            myBatisGenerator.generate(null);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```


