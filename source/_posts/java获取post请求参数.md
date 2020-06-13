title: java获取post请求参数
author: Joe Tong
tags:
  - JAVAEE
categories:  
  - IT 
date: 2019-11-15 14:22:15 
---
```
// 获取post请求参数（getParameter）

@RequestMapping(value="saveUser", method=RequestMethod.POST)

public String saveUser(HttpServletRequest request){

String username= request.getParameter("username");

Integer age = Integer.parseInt(request.getParameter("age"));

String phone = request.getParameter("phone");

String city = request.getParameter("city");

String[] interests = request.getParameterValues("interests");

Integer sex = Integer.parseInt(request.getParameter("sex"));

System.out.println("username : " + username);

System.out.println("age : " + age);

System.out.println("phone : " + phone);

System.out.println("city : " + city);

System.out.println("interests : ");

for(String interest: interests){

System.out.println("    interest : " + interest);

}

System.out.println("sex : " + sex);

return "login/welcome";

}
```
