title: security用户授权
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - SECURITY
categories:  
  - IT
date: 2020-03-04 15:38:04
---

https://segmentfault.com/a/1190000018369146

Spring Security 实现用户授权
spring-security授权安全
发布于 2019-03-03   约 18 分钟
引言
上一次，使用Spring Security与Angular实现了用户认证。Spring Security and Angular 实现用户认证

本次，我们通过Spring Security的授权机制，实现用户授权。

实现十分简单，大家认真听，都能听得懂。

实现
权限设计
前台实现了菜单的权限控制，但后台接口还没进行保护，只要用户登录成功，什么接口都可以调用。

我们希望实现：用户有什么菜单的权限，只能访问后台对应该菜单的接口。

比如，用户有计算机组管理的菜单，就可以访问计算机组相关的增删改查接口，但是其他的接口都不允许访问。

Spring Security的设计
依据Spring Security的设计，用户对应角色，角色对应后台接口。这是没什么问题的。

clipboard.png

示例

某接口添加@Secured注解，内部添加权限表达式。
```
@GetMapping
@Secured("ROLE_ADMIN")
public List&lt;Host&gt; getAll() {
    return hostService.getAll();
}
```
然后再为用户创建Spring Security中的角色。

这里我们为用户添加ROLE_ADMIN的角色授权，与getAll方法上的@Secured("ROLE_ADMIN")注解中的参数一致，表示该用户有权限访问该方法，这就是授权。
```
private UserDetails createUser(User user) {
    logger.debug("初始化授权列表");
    List&lt;SimpleGrantedAuthority&gt; authorities = new ArrayList&lt;&gt;();

    logger.debug("角色授权");
    authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));

    logger.debug("构建用户");
    return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), authorities);
}
```
&gt; 不足
作为一款优秀的安全框架而言，Spring Security这样设计是没有任何问题的，我们只需要简简单单的几行代码就能实现接口的授权管理。

但是却不符合我们的要求。

我们要求，在我们的系统中，用户对应多角色。

但是我们的角色是要求可以进行动态配置的，今天有一个系统管理员的角色，明天可能又加一个教师的角色。

在用户授权这方面，是可以实现动态配置的，因为用户的权限列表是一个List，我可以从数据库查当前用户的角色，然后add进去。
```
private UserDetails createUser(User user) {
    logger.debug("初始化授权列表");
    List&lt;SimpleGrantedAuthority&gt; authorities = new ArrayList&lt;&gt;();

    logger.debug("角色授权");
    authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));

    logger.debug("构建用户");
    return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), authorities);
}
```
但是在接口级别，就无法实现动态配置了。大家想想，注解里，要求的参数必须是常量，就是我们想动态配置，也实现不了啊？
```
@GetMapping
@Secured("ROLE_ADMIN")
public List&lt;Host&gt; getAll() {
    return hostService.getAll();
}
```
所以，我们总结，因为注解配置的限制，所以在Spring Security中角色是静态的。

重新设计
我们的角色是动态的，而Spring Security中的角色是静态的，所以不能将我们的角色直接映射到Spring Security中的角色，要映射也得拿一个我们系统中静态的对象与之对应。

角色是动态的，这个不行了。但是我们的菜单是静态的啊。

功能模块是我们开发的，菜单就这么固定的几个，用户管理、角色管理、系统设置啥的，在我们开发期间就已经固定下来了，我们是不是可以使用菜单结合Spring Security进行授权呢？

认真看这张图，看懂了这张图，你应该就明白了我的设计思想。

角色是动态的，我不用它授权，我使用静态的菜单进行授权。

静态的菜单对应Spring Security中静态的角色，角色再对应后台接口，如此设计，就实现了我们的设想：用户拥有哪个菜单的权限，就只拥有被该菜单调用的相应接口权限。

编码
设计好了，一起来写代码吧。

授权注解选择
Spring Security中有多种授权注解，个人经过对比之后选择@Secured注解，因为我觉得这个注解配置项更容易被人理解。

```
public @interface Secured {
    /**
     * Returns the list of security configuration attributes (e.g. ROLE_USER, ROLE_ADMIN).
     *
     * @return String[] The secure method attributes
     */
    public String[]value();
}
```
直接写一个角色的字符串数组传进去即可。

@Secured("ROLE_ADMIN")                      // 需要拥有`ROLE_ADMIN`角色才可访问
@Secured({"ROLE_ADMIN", "ROLE_TEACHER"})    // 用户拥有`ROLE_ADMIN`、`ROLE_TEACHER`二者之一即可访问
&gt; ** 注意：这里的字符串一定是以ROLE_开头，Spring Security才把它当成角色的配置，否则无效 **

启用@Secured注解
默认的Spring Security是不进行授权注解拦截的，添加注解@EnableGlobalMethodSecurity以启用@Secured注解的全局方法拦截。

@EnableGlobalMethodSecurity(securedEnabled = true) // 启用全局方法安全，采用@Secured方式

菜单角色映射
在菜单中新建一个字段securityRoleName来声明我们的系统菜单对应着哪个Spring Security角色。

// 该菜单在Spring Security环境下的角色名称
@Column(nullable = false)
private String securityRoleName;

建一个类，用于存放所有Spring Security角色的配置信息，供全局调用。

这里不能用枚举，@Secured注解中要求必须是String数组，如果是枚举，需要通过YunzhiSecurityRoleEnum.ROLE_MAIN.name()格式获取字符串信息，但很遗憾，注解中要求必须是常量。

还记得上次自定义HTTP状态码的时候，吃了枚举类无法扩展的亏，以后再也不用枚举了。就算用枚举，也会设计一个接口，枚举实现该接口，不用枚举声明方法的参数类型，而使用接口声明，方便扩展。

```
package club.yunzhi.huasoft.security;

/**
 * @author zhangxishuo on 2019-03-02
 * Yunzhi Security 角色
 * 该角色对应菜单
 */
public class YunzhiSecurityRole {

    public static final String ROLE_MAIN = "ROLE_MAIN";

    public static final String ROLE_HOST = "ROLE_HOST";

    public static final String ROLE_GROUP = "ROLE_GROUP";

    public static final String ROLE_USER = "ROLE_USER";

    public static final String ROLE_ROLE = "ROLE_ROLE";

    public static final String ROLE_SETTING = "ROLE_SETTING";

}
```
示例
```
@GetMapping
@Secured({YunzhiSecurityRole.ROLE_HOST, YunzhiSecurityRole.ROLE_GROUP})
public List&lt;Host&gt; getAll() {
    return hostService.getAll();
}
```
用户授权
代码体现授权思路：遍历当前用户的菜单，根据菜单中对应的Security角色名进行授权。
```
private UserDetails createUser(User user) {
    logger.debug("获取用户的所有授权菜单");
    Set&lt;WebAppMenu&gt; menus = webAppMenuService.getAllAuthMenuByUser(user);

    logger.debug("初始化授权列表");
    List&lt;SimpleGrantedAuthority&gt; authorities = new ArrayList&lt;&gt;();

    logger.debug("遍历授权菜单，进行角色授权");
    for (WebAppMenu menu : menus) {
        authorities.add(new SimpleGrantedAuthority(menu.getSecurityRoleName()));
    }

    logger.debug("构建用户");
    return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), authorities);
}
```

注：这里遇到了Hibernate惰性加载引起的错误，启用事务防止Hibernate关闭Session，深层原理目前还在研究。

单元测试
单元测试很简单，供写相同功能的人参考。

```
@Test
public void authTest() throws Exception {
    logger.debug("获取基础菜单");
    WebAppMenu hostMenu = webAppMenuRepository.findByRoute("/host");
    WebAppMenu groupMenu = webAppMenuRepository.findByRoute("/group");
    WebAppMenu settingMenu = webAppMenuRepository.findByRoute("/setting");

    logger.debug("构造角色");
    List&lt;Role&gt; roleList = new ArrayList&lt;&gt;();

    Role roleHost = new Role();
    roleHost.setWebAppMenuList(Collections.singletonList(hostMenu));
    roleList.add(roleHost);

    Role roleGroup = new Role();
    roleGroup.setWebAppMenuList(Collections.singletonList(groupMenu));
    roleList.add(roleGroup);

    Role roleSetting = new Role();
    roleSetting.setWebAppMenuList(Collections.singletonList(settingMenu));
    roleList.add(roleSetting);

    logger.debug("保存角色");
    roleRepository.saveAll(roleList);

    logger.debug("构造用户");
    User user = userService.getOneUnSavedUser();

    logger.debug("获取用户名和密码");
    String username = user.getUsername();
    String password = user.getPassword();

    logger.debug("保存用户");
    userRepository.save(user);

    logger.debug("用户登录");
    String token = this.loginWithUsernameAndPassword(username, password);

    logger.debug("无授权用户访问host，断言403");
    this.mockMvc.perform(MockMvcRequestBuilders.get(HOST_URL)
            .header(TOKEN_KEY, token))
            .andExpect(status().isForbidden());

    logger.debug("用户授权Host菜单");
    user.getRoleList().clear();
    user.getRoleList().add(roleHost);
    userRepository.save(user);

    logger.debug("重新登录, 重新授权");
    token = this.loginWithUsernameAndPassword(username, password);

    logger.debug("授权Host用户访问，断言200");
    this.mockMvc.perform(MockMvcRequestBuilders.get(HOST_URL)
            .header(TOKEN_KEY, token))
            .andExpect(status().isOk());

    logger.debug("用户授权Group菜单");
    user.getRoleList().clear();
    user.getRoleList().add(roleGroup);
    userRepository.save(user);

    logger.debug("重新登录, 重新授权");
    token = this.loginWithUsernameAndPassword(username, password);

    logger.debug("授权Group用户访问，断言200");
    this.mockMvc.perform(MockMvcRequestBuilders.get(HOST_URL)
            .header(TOKEN_KEY, token))
            .andExpect(status().isOk());

    logger.debug("用户授权Setting菜单");
    user.getRoleList().clear();
    user.getRoleList().add(roleSetting);
    userRepository.save(user);

    logger.debug("重新登录, 重新授权");
    token = this.loginWithUsernameAndPassword(username, password);

    logger.debug("授权Setting用户访问，断言403");
    this.mockMvc.perform(MockMvcRequestBuilders.get(HOST_URL)
            .header(TOKEN_KEY, token))
            .andExpect(status().isForbidden());
}

private String loginWithUsernameAndPassword(String username, String password) throws Exception {
    logger.debug("用户登录");
    byte[] encodedBytes = Base64.encodeBase64((username + ":" + password).getBytes());
    MvcResult mvcResult = this.mockMvc.perform(MockMvcRequestBuilders.get(LOGIN_URL)
            .header("Authorization", "Basic " + new String(encodedBytes)))
            .andExpect(status().isOk())
            .andReturn();

    logger.debug("从返回体中获取token");
    String json = mvcResult.getResponse().getContentAsString();
    JSONObject jsonObject = JSON.parseObject(json);
    return jsonObject.getString("token");
}
```

总结
感谢开源社区，感谢Spring Security。
五行代码(不算注释)，一个注解。就解决了一直以来困扰我们的权限问题。

