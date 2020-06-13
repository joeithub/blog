title: logininterceptor（mycatdemo里的）
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - INTERCEPTOR
categories:
  - IT
date: 2019-09-28 17:30:00
---
```
public class LoginInterceptor extends HandlerInterceptorAdapter {

 &nbsp; &nbsp;//不需要拦截的url集合
 &nbsp; &nbsp;private List&lt;String&gt; IGNORE_URI;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //获取URI后缀
        String requestUri = request.getServletPath();

        if(requestUri.equalsIgnoreCase("/"))    return true;

        //过滤不需要拦截的地址
        for (String uri : IGNORE_URI) {
            if (requestUri.startsWith(uri)) {
                return true;
            }
        }
        HttpSession session = request.getSession();
 &nbsp; &nbsp; &nbsp; &nbsp;//session中包含登录状态放行
 &nbsp; &nbsp; &nbsp; &nbsp;if(session != null &amp;&amp; session.getAttribute("login_status") != null){
            return true;
        }else{
            response.sendRedirect("/user/login?timeout=true");
            return false;
        }
    }

    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        super.postHandle(request, response, handler, modelAndView);
    }

    public List&lt;String&gt; getIGNORE_URI() {
        return IGNORE_URI;
    }

    public void setIGNORE_URI(List&lt;String&gt; IGNORE_URI) {
        this.IGNORE_URI = IGNORE_URI;
    }
}
```
