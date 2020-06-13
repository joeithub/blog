title: springboot+jpa2
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - JPA
categories:
  - IT
date: 2019-08-31 14:11:00
---
这里以用户表User作为基本的操作数据库的实体类为例。

导入pom.xml的依赖
```
&lt;dependency&gt;
   &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
    &lt;artifactId&gt;spring-boot-starter-data-jpa&lt;/artifactId&gt;
&lt;/dependency&gt;
```

如果你是jdk8或者10，可能会遇到一个问题，javax/xml/bind/JAXBException，具体查看这篇文章解决javax/xml/bind/JAXBException

编写一个实体类（bean）和数据表进行映射，并且配置好映射关系

```
/**
 * @author 欧阳思海
 * @date 2018/7/26 16:09
 */
//使用JPA注解配置映射关系
@Entity //告诉JPA这是一个实体类（和数据表映射的类）
@Table(name = "user") //@Table来指定和哪个数据表对应;如果省略默认表名就是user；
public class User {

    @Id //这是一个主键
    @GeneratedValue(strategy = GenerationType.IDENTITY)//自增主键
    private Integer id;

    @Column(name = "username",length = 50) //这是和数据表对应的一个列
    private String username;

    @Column(name = "password",length = 50) //这是和数据表对应的一个列
    private String password;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
```

关于注解的意义，在上面的注释中都注明了。如果要查看更加详细的解释，查看我的另外的文章。

编写一个Dao接口来操作实体类对应的数据表（Repository）

```
/**
 * @author 欧阳思海
 * @date 2018/7/27 9:39
 */
public interface UserDao extends JpaRepository&lt;User,Integer&gt; {
}
```


解释：这个JpaRepository里面已经包括了基本的crud方法，我们可以看一下源代码。
![upload successful](/images/pasted-108.png)

我们可以发现这个借口，已经实现了我们需要的基本的crud，给我们带来了很大的方便。

我们再看看他的整体的类的结构

![upload successful](/images/pasted-110.png)


事实上JpaRepository继承自PagingAndSortingRepository，我们也可以很方便的实现分页的功能，这样对于我们开发来说还是省了不少事。

数据源application.properties配置

```
spring.datasource.url=jdbc:mysql://localhost:3306/test
spring.datasource.username=root
spring.datasource.password=0911SIHAI
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```

创建service进行简单的测试

```
/**
 * @author 欧阳思海
 * @date 2018/7/26 16:11
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public void add(String username, String password) {
        User user = new User();
        user.setPassword(password);
        user.setUsername(username);
        userDao.save(user);
    }

    @Override
    public void deleteByName(String userName) {
        User user = new User();
        user.setUsername(userName);
        userDao.delete(user);
    }

    @Override
    public List&lt;User&gt; getAllUsers() {
        List&lt;User&gt; users = userDao.findAll();
        return users;
    }
}
```

测试类

```
/**
 * @author 欧阳思海
 * @date 2018/7/26 16:22
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class UserTest {

    @Autowired
    private UserService userService;

    @Test
    public void testAdd(){

        userService.add("sihai","abc");
        userService.add("yan","abc");
    }

    @Test
    public void testDelete(){
        userService.deleteByName("sihai");
    }

    @Test
    public void testQuery(){

        List&lt;User&gt; users = userService.getAllUsers();

        Assert.assertEquals(2, users.size());
    }
}
```
到这里关于springboot整合jpa的基本操作已经完成了，关于更加复杂的jpa的操作可以查看jpa官网，或者查看jpa简单教程

后续也会有jpa的相关教程，敬请查看!

