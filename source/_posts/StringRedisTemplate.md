title: StringRedisTemplate  &amp; redisTemplate
author: Joe Tong
tags:
  - SPRINGBBOT
  - REDIS
  - REDISTEMPLATE
  - STRINGREDISTEMPLATE
categories:
  - IT
date: 2019-07-17 22:31:00
---
##### RedisTemplate和StringRedisTemplate的区别


1. 两者的关系是StringRedisTemplate继承RedisTemplate。

2. 两者的数据是&lt;font color="red"&gt;不共通的&lt;/font&gt;；也就是说StringRedisTemplate只能管理StringRedisTemplate里面的数据，RedisTemplate只能管理RedisTemplate中的数据。

3. SDR默认采用的序列化策略有两种，一种是String的序列化策略，一种是JDK的序列化策略。

StringRedisTemplate默认采用的是String的序列化策略，保存的key和value都是采用此策略序列化保存的。

RedisTemplate默认采用的是JDK的序列化策略，保存的key和value都是采用此策略序列化保存的。



RedisTemplate使用的序列类在在操作数据的时候，比如说存入数据会将数据先序列化成字节数组然后在存入Redis数据库，这个时候打开Redis查看的时候，你会看到你的数据不是以可读的形式展现的，而是以字节数组显示，类似下面



当然从Redis获取数据的时候也会默认将数据当做字节数组转化，这样就会导致一个问题，当需要获取的数据不是以字节数组存在redis当中而是正常的可读的字符串的时候，比如说下面这种形式的数据



注：使用的软件是RedisDesktopManager

RedisTemplate就无法获取到数据，这个时候获取到的值就是NULL。这个时候StringRedisTempate就派上了用场。



**当Redis当中的数据值是以可读的形式显示出来的时候，只能使用StringRedisTemplate才能获取到里面的数据。**

所以当你使用RedisTemplate获取不到数据的时候请检查一下是不是Redis里面的数据是可读形式而非字节数组



另外我在测试的时候即使把StringRedisTemplate的序列化类修改成RedisTemplate的JdkSerializationRedisSerializer

最后还是无法获取被序列化的对象数据，即使是没有转化为对象的字节数组，代码如下
```
@Test  
public void testRedisSerializer(){  
    User u = new User();  
    u.setName("java");  
    u.setSex("male");  
    redisTemplate.opsForHash().put("user:","1",u);  
    /*查看redisTemplate 的Serializer*/  
    System.out.println(redisTemplate.getKeySerializer());  
    System.out.println(redisTemplate.getValueSerializer());  
    
    /*查看StringRedisTemplate 的Serializer*/  
    System.out.println(stringRedisTemplate.getValueSerializer());  
    System.out.println(stringRedisTemplate.getValueSerializer());  
    
    /*将stringRedisTemplate序列化类设置成RedisTemplate的序列化类*/  
    stringRedisTemplate.setKeySerializer(new JdkSerializationRedisSerializer());  
    stringRedisTemplate.setValueSerializer(new JdkSerializationRedisSerializer());  
    
    /*即使在更换stringRedisTemplate的的Serializer和redisTemplate一致的 
    * JdkSerializationRedisSerializer 
    * 最后还是无法从redis中获取序列化的数据 
    * */  
    System.out.println(stringRedisTemplate.getValueSerializer());  
    System.out.println(stringRedisTemplate.getValueSerializer());  
    
    User user = (User)  redisTemplate.opsForHash().get("user:","1");  
    User  user2 = (User) stringRedisTemplate.opsForHash().get("user:","1");  
    System.out.println("dsd");  
}
```
Debug结果


&lt;table&gt;&lt;td&gt;
总结：  

当你的redis数据库里面本来存的是字符串数据或者你要存取的数据就是字符串类型数据的时候，那么你就使用StringRedisTemplate即可，但是如果你的数据是复杂的对象类型，而取出的时候又不想做任何的数据转换，直接从Redis里面取出一个对象，那么使用RedisTemplate是更好的选择。
&lt;/td&gt;&lt;/table&gt;
