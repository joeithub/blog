title: 注解@ConfigurationProperties
author: Joe Tong
tags:
  - JAVAEE
categories:  
  - IT
date: 2020-04-14 11:37:36
---

@ConfigurationProperties 在Idea中冒红问题

冒红不影响正常的运行，如想结果按照以下步骤。

## pom.xml增加如下依赖
```
  &amp;amp;lt;dependency&amp;amp;gt;
            &amp;amp;lt;groupId&amp;amp;gt;org.springframework.boot&amp;amp;lt;/groupId&amp;amp;gt;
            &amp;amp;lt;artifactId&amp;amp;gt;spring-boot-configuration-processor&amp;amp;lt;/artifactId&amp;amp;gt;
            &amp;amp;lt;optional&amp;amp;gt;true&amp;amp;lt;/optional&amp;amp;gt;
        &amp;amp;lt;/dependency&amp;amp;gt;

```

```
@Configuration
@EnableConfigurationProperties({RedisConfig.class}) 
@ConfigurationProperties(prefix = "custom.redis")
public class RedisConfig {
    private String host;
    private int port;
    private int maxIdle;
    private int maxActive;
        public String getHost() {
        return host;
    }
    public void setHost(String host) {
        this.host = host;
    }
    public int getPort() {
        return port;
    }
    public void setPort(int port) {
        this.port = port;
    }
    public int getMaxIdle() {
        return maxIdle;
    }
    public void setMaxIdle(int maxIdle) {
        this.maxIdle = maxIdle;
    }
    public int getMaxActive() {
        return maxActive;
    }
    public void setMaxActive(int maxActive) {
        this.maxActive = maxActive;
    }
    }
```
&amp;amp;gt; 主要是增加
&amp;amp;gt; @EnableConfigurationProperties({RedisConfig.class})



