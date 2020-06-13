title: springboot+jpa
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - JPA
categories:
  - IT
date: 2019-07-08 21:40:00
---
SpringBoot+JPA进行增删改查


最近公司领导要求让用SpringBoot+JPA进行项目开发。所以安排我搭建项目框架。  
第一步.POM文件的配置
```
&lt;parent&gt;  

        &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;  

        &lt;artifactId&gt;spring-boot-starter-parent&lt;/artifactId&gt;  

        &lt;version&gt;1.4.1.RELEASE&lt;/version&gt;  

    &lt;/parent&gt;  

    &lt;dependencies&gt;  

        &lt;dependency&gt;  

            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;  

            &lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;

            &lt;!--去除 spring-boot-starter-web 自带的下方jar包--&gt;

			&lt;exclusions&gt;

				&lt;exclusion&gt;

					&lt;artifactId&gt;log4j-over-slf4j&lt;/artifactId&gt;

					&lt;groupId&gt;org.slf4j&lt;/groupId&gt;

				&lt;/exclusion&gt;

				&lt;exclusion&gt;

					&lt;artifactId&gt;org.springframework.boot&lt;/artifactId&gt;

					&lt;groupId&gt;spring-boot-starter-logging&lt;/groupId&gt;

				&lt;/exclusion&gt;

			&lt;/exclusions&gt;  

        &lt;/dependency&gt;  

        &lt;!--jpa 相关jar包 --&gt;  

        &lt;dependency&gt;  

            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;  

            &lt;artifactId&gt;spring-boot-starter-data-jpa&lt;/artifactId&gt;  

        &lt;/dependency&gt;  

        &lt;!-- MySql 相关JAR包 --&gt;  

        &lt;dependency&gt;  

            &lt;groupId&gt;mysql&lt;/groupId&gt;  

            &lt;artifactId&gt;mysql-connector-java&lt;/artifactId&gt;  

        &lt;/dependency&gt;

        &lt;!--spring-boot整合redis包--&gt;

		&lt;dependency&gt;

			&lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;

			&lt;artifactId&gt;spring-boot-starter-data-redis&lt;/artifactId&gt;

		&lt;/dependency&gt;  

		&lt;!--添加spring整合shiro的jar包--&gt;

		&lt;dependency&gt;

			&lt;groupId&gt;org.apache.shiro&lt;/groupId&gt;

			&lt;artifactId&gt;shiro-spring&lt;/artifactId&gt;

			&lt;version&gt;1.3.2&lt;/version&gt;

		&lt;/dependency&gt;

        &lt;dependency&gt;

            &lt;groupId&gt;com.google.code.gson&lt;/groupId&gt;

            &lt;artifactId&gt;gson&lt;/artifactId&gt;

        &lt;/dependency&gt;

        &lt;!--JSON.toJSONString()依赖的JSON jar包--&gt;

		&lt;dependency&gt;

			&lt;groupId&gt;com.alibaba&lt;/groupId&gt;

			&lt;artifactId&gt;fastjson&lt;/artifactId&gt;

			&lt;version&gt;1.2.37&lt;/version&gt;

		&lt;/dependency&gt;

		&lt;!-- httpClient的jar包 --&gt;

		&lt;dependency&gt;

		    &lt;groupId&gt;org.apache.httpcomponents&lt;/groupId&gt;

		    &lt;artifactId&gt;httpclient&lt;/artifactId&gt;

		&lt;/dependency&gt;

		&lt;!--log4j依赖--&gt;

		&lt;dependency&gt;

			&lt;groupId&gt;log4j&lt;/groupId&gt;

			&lt;artifactId&gt;log4j&lt;/artifactId&gt;

			&lt;version&gt;1.2.17&lt;/version&gt;

		&lt;/dependency&gt;

		&lt;!--log4j2日志依赖--&gt;

		&lt;dependency&gt;

			&lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;

			&lt;artifactId&gt;spring-boot-starter-log4j2&lt;/artifactId&gt;

		&lt;/dependency&gt;

		&lt;!-- 热部署的jar包 --&gt;

		&lt;dependency&gt;  

            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;  

            &lt;artifactId&gt;spring-boot-devtools&lt;/artifactId&gt;  

            &lt;optional&gt;true&lt;/optional&gt;  

  		&lt;/dependency&gt;

		&lt;dependency&gt;

            &lt;groupId&gt;io.springfox&lt;/groupId&gt;

            &lt;artifactId&gt;springfox-swagger2&lt;/artifactId&gt;

            &lt;version&gt;2.6.1&lt;/version&gt;

        &lt;/dependency&gt;

        &lt;dependency&gt;

            &lt;groupId&gt;io.springfox&lt;/groupId&gt;

            &lt;artifactId&gt;springfox-swagger-ui&lt;/artifactId&gt;

            &lt;version&gt;2.6.1&lt;/version&gt;

        &lt;/dependency&gt;

    &lt;/dependencies&gt; 

     &lt;!-- 添加SpringBoot热部署插件 --&gt;

    &lt;build&gt;

    	&lt;plugins&gt;

    		&lt;plugin&gt;

				&lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;

				&lt;artifactId&gt;spring-boot-maven-plugin &lt;/artifactId&gt;

				&lt;dependencies&gt; 

				  &lt;!--springloaded  hot deploy --&gt; 

				  &lt;dependency&gt; 

					  &lt;groupId&gt;org.springframework&lt;/groupId&gt; 

					  &lt;artifactId&gt;springloaded&lt;/artifactId&gt; 

					  &lt;version&gt;1.2.4.RELEASE&lt;/version&gt;

				  &lt;/dependency&gt; 

			   &lt;/dependencies&gt; 

			   &lt;executions&gt; 

				  &lt;execution&gt; 

					  &lt;goals&gt; 

						  &lt;goal&gt;repackage&lt;/goal&gt; 

					  &lt;/goals&gt; 

					  &lt;configuration&gt; 

						  &lt;classifier&gt;exec&lt;/classifier&gt; 

					  &lt;/configuration&gt; 

				  &lt;/execution&gt; 

				&lt;/executions&gt;

			&lt;/plugin&gt;

    	&lt;/plugins&gt;

    &lt;/build&gt;
```
第二步骤.
application.properties配置
```
spring.datasource.driver-class-name=com.mysql.jdbc.Driver

spring.datasource.url=jdbc:mysql://localhost:3306/test

spring.datasource.username=root

spring.datasource.password=admin

 

spring.jpa.hibernate.ddl-auto=update

spring.jpa.show-sql=true

spring.jackson.serialization.indent_output=true

#数据库方言

spring.jpa.database-platform=org.hibernate.dialect.MySQL5Dialect

########################################################

 ###Redis (Redis配置)

########################################################

 #设置使用哪一个redis数据库【redis默认有16个数据库0-15】

 spring.redis.database=1

 #redis主机IP

 spring.redis.host=127.0.0.1

 #redis端口

 spring.redis.port=6379

 #redis密码

 #spring.redis.password=

 spring.redis.pool.max-idle=8

 spring.redis.pool.min-idle=0

 spring.redis.pool.max-active=8

 spring.redis.pool.max-wait=-1

 #设置客户端闲置5s后关闭连接

 spring.redis.timeout=5000
```
第三步.
创建实体类。
```
import javax.persistence.Column;

import javax.persistence.Entity;

import javax.persistence.GeneratedValue;

import javax.persistence.Id;

import javax.persistence.Table;

 

@Entity

@Table(name="user2")

public class User2 {

	@Id

	@GeneratedValue

	private Integer id;

	@Column(name="name")

	private String name;

	@Column(name="password")

	private String password;

	public Integer getId() {

		return id;

	}

	public void setId(Integer id) {

		this.id = id;

	}

	public String getName() {

		return name;

	}

	public void setName(String name) {

		this.name = name;

	}

	public String getPassword() {

		return password;

	}

	public void setPassword(String password) {

		this.password = password;

	}

	public  User2(String name,String password) {

		this.password = password;

		this.name = name;

	}

	@Override

	public String toString() {

		return "User2 [id=" + id + ", name=" + name + ", password=" + password + "]";

	}

	public  User2() {

 

	}

}
```
第四步。创建Dao层集成JpaRepository
```
import java.util.List;

 

import org.springframework.data.domain.Page;

import org.springframework.data.domain.Pageable;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.jpa.repository.Modifying;

import org.springframework.data.jpa.repository.Query;

 

 

public interface User2JpaDao extends JpaRepository&lt;User2, Long&gt; {

	/*

	 * Jpa命名规范，查询

	 */

	User2 findByNameAndPasswordAndId(String name,String password,Integer id);

	/*

	 * (non-Javadoc)新增用户

	 * @see org.springframework.data.repository.CrudRepository#save(S)

	 */

	User2 save(User2 user2);

	//查询全部

	List&lt;User2&gt; findAll();

	//分页查询

	//Page&lt;User2&gt; findAll(PageRequest pageRequest);

	 Page&lt;User2&gt; findAll(Pageable pageable);	

	@Modifying

	@Query("update User2 as c set c.name = ?1 where c.password=?2")

	int updateNameByPassword(String name, String password);

	void delete(User2 entity);

	

	

}
```
第五步。创建Service层。
```
import java.util.List;

 

import org.springframework.data.domain.Page;

import org.springframework.data.domain.Pageable;

 

 

public interface User2Service {

 

	User2 findByNameAndPasswordAndId(String name,String password,Integer id);

	User2 save(User2 user2);

	List&lt;User2&gt; findAll();

	int updateNameByPassword(String name, String password);

	//Page&lt;User2&gt; findAll(PageRequest pageRequest);

	Page&lt;User2&gt; findAll(Pageable pageable);

	//删除用户

	void delete(User2 entity);

}
```

第六步。创建ServiceImpl层。
```
import java.util.List;

 

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.data.domain.Page;

import org.springframework.data.domain.Pageable;

import org.springframework.stereotype.Service;

@Service

public class User2ServiceImpl implements User2Service {

	@Autowired

	private User2JpaDao user2JpaDao;

 

	@Override

	public User2 findByNameAndPasswordAndId(String name, String password, Integer id) {

		// TODO Auto-generated method stub

		return user2JpaDao.findByNameAndPasswordAndId(name, password,id);

	}

	@Override

	public User2 save(User2 user2) {

		// TODO Auto-generated method stub

		return user2JpaDao.save(user2);

	}

	@Override

	public List&lt;User2&gt; findAll() {

		// TODO Auto-generated method stub

		return user2JpaDao.findAll();

	}

	@Override

	public int updateNameByPassword(String name, String password) {

		// TODO Auto-generated method stub

		return user2JpaDao.updateNameByPassword(name, password);

	}

	@Override

	public void delete(User2 entity) {

		// TODO Auto-generated method stub

		user2JpaDao.delete(entity);

	}

	@Override

	public Page&lt;User2&gt; findAll(Pageable pageable) {

		// TODO Auto-generated method stub

		return user2JpaDao.findAll(pageable);

	}

}
```
第七步 controller层
```
import java.util.ArrayList;

import java.util.List;

 

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.data.domain.Page;

import org.springframework.data.domain.PageRequest;

import org.springframework.data.domain.Pageable;

import org.springframework.data.domain.Sort;

import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;

 

 

 

@RestController

public class User2Controller {

	@Autowired

	private User2Service user2Service;

 

	@Autowired

	private RedisService redisService;

	

	@RequestMapping("/getRedis")

	public String getRedis(){

		String string2="zouyunke111111";

		redisService.set(string2, "nihao");

		String string=(String) redisService.get("zouyunke111111");

		return string;

	}

	@RequestMapping("/findByNameAndPasswordAndId")

	public User2 findByNameAndPassword(){

		User2 user2=user2Service.findByNameAndPasswordAndId("zouyunke", "yunke123", 3);

		//User2 user2=user2Service.findByNameAndPwdAndId("zouyunke", "yunke123",1);

		return user2;

	}

	@RequestMapping("/saveUser2")

	public List&lt;User2&gt; saveUser2(){

		List&lt;User2&gt; user3=new ArrayList&lt;User2&gt;();

		for (int i=0;i&lt;10;i++){

			User2 user2=new User2("zouyunke12"+i,"zouyunke12"+i);	

			user3.add(user2);

		}

		for (User2 user2 : user3) {

			User2 user=user2Service.save(user2);

		}

		

		//User2 user2=user2Service.findByNameAndPwdAndId("zouyunke", "yunke123",1);

		return user2Service.findAll();

	}

	@RequestMapping("/updateUser2")

	public User2 updateUser2(){

		User2 user2=new User2();

		user2.setId(1);

		user2.setName("zhaodanya");

		user2.setPassword("123");

		return user2Service.save(user2);

	}

	/**

	 * 分页查询

	 * @author Administrator

	 * 2018年4月22日

	 * @return

	 * TODO

	 */

	@RequestMapping("/deleteUser2")

	public void deleteUser2(){

		User2 user2=new User2();

		user2.setId(3);

		user2.setName("zouyunke120");

		user2.setPassword("zouyunke120");

		user2Service.delete(user2);

	}

	

	 @RequestMapping(value = "/pageUser2")  

	    public Page&lt;User2&gt; pageUser2() {  

	        Sort sort = new Sort(Sort.Direction.ASC,"id");  

	        Pageable pageable = new PageRequest(2,6,sort);  

	        Page&lt;User2&gt; page =  user2Service.findAll(pageable);  

	        return page;  

	    }  

}
```
至此，整合完毕。
上面写的都是jpa的东西。再写一点和jpa无关的东西。  
**自定义sql语句，由于项目的进展，需要一些自定义sql语句，所以封装了一个dao和一个实现类来自定义sql语句。**


```

package cn.dao.base;

import java.util.List;
import java.util.Map; 

/**

* 类说明: 原生SQL操作数据库的Dao

* @author 邹运坷

* @version 创建时间：2018年4月26日 下午12:10:26

*/

public interface BaseDao {

	

	/**

	 * 公共查询方法【手动进行参数的拼接】

	 * @return

	 */

	List&lt;Map&gt; commonQueryMethod(String sql);

	

	/**

	 * 增删改共用方法【手动进行参数的拼接】

	 * @param sql

	 */

	int addOrDelOrUpdateMethod(String sql);

	

	/**

	 * 公共查询方法【传递参数集合自动绑定参数】参数集合中的key要和SQL中的命名参数名称一致

	 * @return

	 */

	List&lt;Map&gt; commonQueryMethod(String sql,Map&lt;String,Object&gt; param);

	

	/**

	 * 增删改共用方法【传递参数集合自动绑定参数】参数集合中的key要和SQL中的命名参数名称一致

	 * @param sql

	 */

	int addOrDelOrUpdateMethod(String sql,Map&lt;String,Object&gt; param);

}
```
```
package cn.dao.base.impl;

 

import java.util.List;

import java.util.Map;

 

import javax.persistence.EntityManager;

import javax.persistence.PersistenceContext;

 

import org.hibernate.Criteria;

import org.hibernate.Query;

import org.hibernate.Session;

import org.springframework.stereotype.Repository;

 

import cn.yuanyue.ycmusic.dao.base.BaseDao;

 

/**

* 类说明:BaseDao实现类

* @author 邹运坷

* @version 创建时间：2018年4月26日 下午12:13:18

*/

@Repository

public class BaseDaoImpl implements BaseDao {

	

	@PersistenceContext

	private EntityManager entityManager;

	

	

	/**

	 * 获取HibernateSession

	 */

	private Session getHibernateSession() {

		//获取Hibernate中的Session

		Session hibernateSession = entityManager.unwrap(org.hibernate.Session.class);

		return hibernateSession;

	}

	

	/**

	 * 公共查询方法【手动拼接参数到SQL中】

	 * @param sql 

	 */

	@Override

	public List&lt;Map&gt; commonQueryMethod(String sql) {

		//执行SQL查询【设置返回结果为Map】

		Query result = getHibernateSession().createSQLQuery(sql).setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);

		return result.list();

	}

	

	/**

	 * 增删改共用方法【手动拼接参数到SQL中】

	 * @param sql

	 */

	@Override

	public int addOrDelOrUpdateMethod(String sql) {

		Query result = getHibernateSession().createSQLQuery(sql);

		int executeUpdate = result.executeUpdate();

		return executeUpdate;

	}

	

	/**

	 * 公共查询方法【传递参数集合自动绑定参数】参数集合中的key要和SQL中的命名参数名称一致

	 * select * from xx where id = :key

	 * put("key",'1')

	 * @return

	 */

	@Override

	public List&lt;Map&gt; commonQueryMethod(String sql, Map&lt;String, Object&gt; param) {

		Query result = getHibernateSession().createSQLQuery(sql).setProperties(param).setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);

		return result.list();

	}

	

	/**

	 * 增删改共用方法【传递参数集合自动绑定参数】参数集合中的key要和SQL中的命名参数名称一致

	 * @param sql

	 */

	@Override

	public int addOrDelOrUpdateMethod(String sql, Map&lt;String, Object&gt; param) {

		Query result = getHibernateSession().createSQLQuery(sql).setProperties(param);

		int executeUpdate = result.executeUpdate();

		return executeUpdate;

	}

}
```
上面就是自定义sql的源码。一个dao一个实现类。使用的时候只需要在serviceimpl里注入就行了。
注入方式如下
```
@Autowired
private BaseDao baseDao;
String sql="select name from user";
List&lt;Map&gt;result=baseDao.commonQueryMethod(sql);
```
这样就实现了自定义sql语句的问题。
