title: security 短信登录
author: Joe Tong
tags:
  - SPRINGBOOT
  - SECURITY
  - JAVAEE
categories:  
  - IT
date: 2020-03-11 18:14:52
---
1[入门程序]https://blog.csdn.net/yuanlaijike/article/details/80249235
2[自动登录]https://blog.csdn.net/yuanlaijike/article/details/80249869
3[异常处理]https://blog.csdn.net/yuanlaijike/article/details/80250389
4[自定义表单登录]https://blog.csdn.net/yuanlaijike/article/details/80253922
5[权限控制]https://blog.csdn.net/yuanlaijike/article/details/80327880
6[登陆管理]https://blog.csdn.net/yuanlaijike/article/details/84638745
7[认证流程]https://blog.csdn.net/yuanlaijike/article/details/84703690
8[短信验证码登录]https://blog.csdn.net/yuanlaijike/article/details/86164160
9[解决 UserNotFoundException 不抛出问题]https://blog.csdn.net/yuanlaijike/article/details/95104553
10[角色继承]https://blog.csdn.net/yuanlaijike/article/details/101565313
[Spring Security OAuth2 开发指南中文版]https://blog.csdn.net/xqhys/article/details/87178824

[微信登录]https://blog.csdn.net/baidu_34389984/article/details/85778310
https://blog.csdn.net/qq_35222232/article/details/83783830

**Exception**
UsernameNotFoundException（用户不存在）
DisabledException（用户已被禁用）
BadCredentialsException（坏的凭据）
LockedException（账户锁定）
AccountExpiredException （账户过期）
CredentialsExpiredException（证书过期）



|Alias|	Filter Class|	Namespace Element or Attribute|
|:--|:--|:--|
|CHANNEL_FILTER|	ChannelProcessingFilter|	http/intercept-url@requires-channel|
|SECURITY_CONTEXT_FILTER|	SecurityContextPersistenceFilter|	http
|CONCURRENT_SESSION_FILTER|	ConcurrentSessionFilter|	session-management/concurrency-control
|HEADERS_FILTER|	HeaderWriterFilter|	http/headers
|CSRF_FILTER|	CsrfFilter|	http/csrf
|LOGOUT_FILTER|	LogoutFilter|	http/logout
|X509_FILTER|	X509AuthenticationFilter|	http/x509
|PRE_AUTH_FILTER|	AbstractPreAuthenticatedProcessingFilter|	N/A
|CAS_FILTER|	CasAuthenticationFilter|	N/A
|FORM_LOGIN_FILTER|	UsernamePasswordAuthenticationFilter|	http/form-login
|BASIC_AUTH_FILTER|	BasicAuthenticationFilter|	http/http-basic
|SERVLET_API_SUPPORT_FILTER|	SecurityContextHolderAwareRequestFilter|	http/@servlet-api-provision
|JAAS_API_SUPPORT_FILTER|	JaasApiIntegrationFilter|	http/@jaas-api-provision
|REMEMBER_ME_FILTER|	RememberMeAuthenticationFilter|	http/remember-me
|ANONYMOUS_FILTER|	AnonymousAuthenticationFilter|	http/anonymous
|SESSION_MANAGEMENT_FILTER|	SessionManagementFilter|	session-management
|EXCEPTION_TRANSLATION_FILTER|	ExceptionTranslationFilter|	http
|FILTER_SECURITY_INTERCEPTOR|	FilterSecurityInterceptor|	http
|SWITCH_USER_FILTER|	SwitchUserFilter|	N/A








