title: security的过滤链
author: Joe Tong
tags:
  - JAVAEE
  - SECURITY
categories:  
  - IT
date: 2020-06-05 15:59:49
---

在前面的学习中，配置文件中的&lt;http&gt;...&lt;/http&gt;都是采用的auto-config="true"这种自动配置模式，根据Spring Security文档的说明:


auto-config Automatically registers a login form, BASIC authentication, logout services. If set to "true", all of these capabilities are added (although you can still customize the configuration of each by providing the respective element).

可以理解为:

```
&lt;http&gt;
    &lt;form-login /&gt;
    &lt;http-basic /&gt;
    &lt;logout /&gt;
&lt;/http&gt;
```

下面是Spring Security Filter Chain的列表:

| Alias                        | Filter Class                                         | Namespace Element or Attribute           |
| ---------------------------- | ---------------------------------------------------- | ---------------------------------------- |
| CHANNEL_FILTER               | `ChannelProcessingFilter`                            | `http/intercept-url@requires-channel`    |
| SECURITY_CONTEXT_FILTER      | `SecurityContextPersistenceFilter`                   | `http`                                   |
| CONCURRENT_SESSION_FILTER    | `ConcurrentSessionFilter`                            | `session-management/concurrency-control` |
| HEADERS_FILTER               | `HeaderWriterFilter`                                 | `http/headers`                           |
| CSRF_FILTER                  | `CsrfFilter`                                         | `http/csrf`                              |
| LOGOUT_FILTER                | `LogoutFilter`                                       | `http/logout`                            |
| X509_FILTER                  | `X509AuthenticationFilter`                           | `http/x509`                              |
| PRE_AUTH_FILTER              | `AstractPreAuthenticatedProcessingFilter` Subclasses | N/A                                      |
| CAS_FILTER                   | `CasAuthenticationFilter`                            | N/A                                      |
| FORM_LOGIN_FILTER            | `UsernamePasswordAuthenticationFilter`               | `http/form-login`                        |
| BASIC_AUTH_FILTER            | `BasicAuthenticationFilter`                          | `http/http-basic`                        |
| SERVLET_API_SUPPORT_FILTER   | `SecurityContextHolderAwareRequestFilter`            | `http/@servlet-api-provision`            |
| JAAS_API_SUPPORT_FILTER      | `JaasApiIntegrationFilter`                           | `http/@jaas-api-provision`               |
| REMEMBER_ME_FILTER           | `RememberMeAuthenticationFilter`                     | `http/remember-me`                       |
| ANONYMOUS_FILTER             | `AnonymousAuthenticationFilter`                      | `http/anonymous`                         |
| SESSION_MANAGEMENT_FILTER    | `SessionManagementFilter`                            | `session-management`                     |
| EXCEPTION_TRANSLATION_FILTER | `ExceptionTranslationFilter`                         | `http`                                   |
| FILTER_SECURITY_INTERCEPTOR  | `FilterSecurityInterceptor`                          | `http`                                   |
| SWITCH_USER_FILTER           | `SwitchUserFilter`                                   | N/A                                      |



其中红色标出的二个Filter对应的是 “注销、登录”，如果不使用auto-config=true，开发人员可以自行“重写”这二个Filter来达到类似的目的，比如：默认情况下，登录表单必须使用post方式提交，在一些安全性相对不那么高的场景中（比如：企业内网应用），如果希望通过类似 http://xxx/login?username=abc&amp;password=123的方式直接登录，可以参考下面的代码：

```
package com.cnblogs.yjmyzz;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

public class CustomLoginFilter extends UsernamePasswordAuthenticationFilter {

    public Authentication attemptAuthentication(HttpServletRequest request,
            HttpServletResponse response) throws AuthenticationException {

        // if (!request.getMethod().equals("POST")) {
        // throw new AuthenticationServiceException(
        // "Authentication method not supported: "
        // + request.getMethod());
        // }

        String username = obtainUsername(request).toUpperCase().trim();
        String password = obtainPassword(request);

        UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(
                username, password);

        setDetails(request, authRequest);
        return this.getAuthenticationManager().authenticate(authRequest);
    }
}
```

即：从UsernamePasswordAuthenticationFilter继承一个类，然后把关于POST方式判断的代码注释掉即可。默认情况下，Spring Security的用户名是区分大小写，如果觉得没必要，上面的代码同时还演示了如何在Filter中自动将其转换成大写。

默认情况下，登录成功后，Spring Security有自己的handler处理类，如果想在登录成功后，加一点自己的处理逻辑，可参考下面的代码：

```
package com.cnblogs.yjmyzz;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

public class CustomLoginHandler extends
        SavedRequestAwareAuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
            HttpServletResponse response, Authentication authentication)
            throws ServletException, IOException {
        super.onAuthenticationSuccess(request, response, authentication);

        //这里可以追加开发人员自己的额外处理
        System.out
                .println("CustomLoginHandler.onAuthenticationSuccess() is called!");
    }

}
```

类似的，要自定义LogoutFilter，可参考下面的代码：

```
package com.cnblogs.yjmyzz;

import org.springframework.security.web.authentication.logout.LogoutFilter;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

public class CustomLogoutFilter extends LogoutFilter {

    public CustomLogoutFilter(String logoutSuccessUrl, LogoutHandler[] handlers) {
        super(logoutSuccessUrl, handlers);
    }

    public CustomLogoutFilter(LogoutSuccessHandler logoutSuccessHandler,
            LogoutHandler[] handlers) {
        super(logoutSuccessHandler, handlers);
    }

}
```
即：从LogoutFilter继承一个类，如果还想在退出后加点自己的逻辑（比如注销后，清空额外的Cookie之类\记录退出时间、地点之类），可重写doFilter方法，但不建议这样，有更好的做法，自行定义logoutSuccessHandler，然后在运行时，通过构造函数注入即可。

下面是自定义退出成功处理的handler示例：
```
package com.cnblogs.yjmyzz;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutHandler;

public class CustomLogoutHandler implements LogoutHandler {

    public CustomLogoutHandler() {
    }

    @Override
    public void logout(HttpServletRequest request,
            HttpServletResponse response, Authentication authentication) {
        System.out.println("CustomLogoutSuccessHandler.logout() is called!");

    }

}
```

用户输入“用户名、密码”，并点击完登录后，最终实现校验的是AuthenticationProvider，而且一个webApp中可以同时使用多个Provider，下面是一个自定义Provider的示例代码:

```
package com.cnblogs.yjmyzz;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.dao.AbstractUserDetailsAuthenticationProvider;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;

public class CustomAuthenticationProvider extends
        AbstractUserDetailsAuthenticationProvider {

    @Override
    protected void additionalAuthenticationChecks(UserDetails userDetails,
            UsernamePasswordAuthenticationToken authentication)
            throws AuthenticationException {
        //如果想做点额外的检查,可以在这个方法里处理,校验不通时,直接抛异常即可
        System.out
                .println("CustomAuthenticationProvider.additionalAuthenticationChecks() is called!");
    }

    @Override
    protected UserDetails retrieveUser(String username,
            UsernamePasswordAuthenticationToken authentication)
            throws AuthenticationException {

        System.out
                .println("CustomAuthenticationProvider.retrieveUser() is called!");

        String[] whiteLists = new String[] { "ADMIN", "SUPERVISOR", "JIMMY" };

        // 如果用户在白名单里,直接放行(注:仅仅只是演示,千万不要在实际项目中这么干!)
        if (Arrays.asList(whiteLists).contains(username)) {
            Collection&lt;GrantedAuthority&gt; authorities = new ArrayList&lt;GrantedAuthority&gt;();
            authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
            UserDetails user = new User(username, "whatever", authorities);
            return user;
        }

        return new User(username, "no-password", false, false, false, false,
                new ArrayList&lt;GrantedAuthority&gt;());

    }

}
```



