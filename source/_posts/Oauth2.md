title: Oauth2
author: Joe Tong
tags:
  - OAUTH2
categories:
  - IT
date: 2019-07-21 07:19:00
---
Oauth2授权模式

###### 授权码模式（Authorization Code）
###### 隐士授权模式（Implicit）  
###### 密码模式（Resource Owner Password Credentials）  
###### 客户端模式（Client Credentials） &nbsp;

授权码授权流程

![upload successful](/images/pasted-12.png)
客户端请求第三方授权
用户（资源有者）同意给客户端授权
客户端获取到授权码，请求认证服务器申请令牌
认证服务器向客户端响应令牌
客户端请求资源服务器的资源
资源服务器返回受保护资源

申请授权码
请求认证服务获取授权码
get请求：

![upload successful](/images/pasted-13.png)

客户端ID就是存到数据库里的client_id的值

Spring security 会去数据库中查有没有这个服务

校验令牌token
刷新令牌refresh_token 


JWT  (json web token)简化认证流程  

![upload successful](/images/pasted-16.png)      

实现方式是通过RSA(公钥/私钥)完成签名  
资源服务器和认证服务器之间通过公钥私钥的方式 &nbsp;
jwt格式包含三个部分：
* Header部分
```
{
 "":"",
 "typ":""
}
```
他会用base64url进行编码成字符串
* Payload部分（内容部分）
```
{
}
```
也会进行base64url进行编码  
* signature部分签名部分  
防止篡改  
```
HMACSHA256(
  base64urlEncode(header) + "." + 
  base64UrlEncode(payload),
  secret
)
```
secret:签名使用的密钥
整个再进行加密

生成密钥证书，采用rsa算法每个证书包含公钥和私钥   &nbsp;
生成私钥：
```
keytool -genkeypair -alias xxx(密钥的别名) -keyalg RSA（采用的算法） -keypass xxx(密匙的访问密码) -keystore xxx.keystore(密钥库文件即存储密钥的文件) -storepass xxx(密钥库的访问密码)
```
参数解析：  
-alias 密钥的别名 &nbsp;
-alias 密钥的别名 &nbsp;
-keyalg 使用的hash算法  
-keypass 密匙的访问密码  
-keystore 密匙库文件名  
-storepass 密匙库的访问密码 &nbsp;

导出公钥：
需要openssl来导出公钥信息
安装openssl
到证书所在目录执行如下命令：
```
keytool -list rfc --keystore xxx.keystore（密钥库文件名）| openssl x509 -inform pem -pubkey
```


springsecurityoauth2流程

![upload successful](/images/pasted-18.png)


