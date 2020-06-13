title: Autowired(Value)注入与@PostConstruct调用顺序
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
categories:
  - IT
date: 2019-09-05 11:35:00
---
最近在项目开发中遇到这样一个需求，由于元数据在短时间内被客户端多次读取，因此希望直接将数据存储到内存，以减少网络开销，借助guava cache于是有了下面这个类  

```
/**
 * Created on 2018/10/18
 */
@Component
public class CacheUtil {

    @Autowired
    CaseGraphService caseGraphService;

    @Value("${cache.expire.duration}")
    long expireDuration;

    private Cache&amp;lt;Long, CaseGraphDTO&amp;gt; metaNodeCache = CacheBuilder
                .newBuilder()
                .maximumSize(1000)
                .expireAfterAccess(expireDuration, TimeUnit.MINUTES) //设置过期时间
                .build();

    public CaseGraphDTO getMetaNode(long caseId) throws ExecutionException {
        return metaNodeCache.get(caseId, () -&amp;gt; caseGraphService.getCaseGraph(caseId));
    }

    public void removeMetaNodeByKey(long caseId){
        metaNodeCache.invalidate(caseId);
    }

    public void removeMetaNodeAll(){
        metaNodeCache.invalidateAll();
    }
}
```

我们在另一个类中注入CacheUtil并调用它的getMetaNode方法，类似于这样：

```
@Component
public class TestComponent {
	@Autowired
	CacheUtil cacheUtil;

	public CaseGraphDTO getMetaData(long caseId){
		return cacheUtil.getMetaNode(caseId);
	}
}
```

当我们第一次调用getMetaNode时，cache使用caseGraphService获取元数据，而后将这一元数据存放的cache中，我们在CacheUtil的getMetaNode方法中添加两行代码来测试一下：

```
public CaseGraphDTO getMetaNode(long caseId) throws ExecutionException {
        //metaNodeCache的get方法，如果缓存中已有数据，直接返回数据，如果没有则通过Callable方法获取存入缓存再返回数据
        CaseGraphDTO caseGraphDTO = metaNodeCache.get(caseId, () -&amp;gt; caseGraphService.getCaseGraph
                (caseId));
        //getIfPresent方法，如果存在数据即返回
        CaseGraphDTO caseGraphDTO1 = metaNodeCache.getIfPresent(caseId);
        System.out.println(caseGraphDTO1);
        return caseGraphDTO;
    }
```

启动application， 打开断点调试：

![upload successful](/images/pasted-121.png)

可以看到caseGraphDTO1为null，而不是我们预想的元数据；metaNodeCache中localCache的大小为0，也就是根本没有缓存任何数据。

而后我采用另一种方式@PostConstruct的方式来初始化metaNodeCache, 代码如下：

```
@Component
public class CacheUtil {

    @Autowired
    CaseGraphService caseGraphService;

    @Value("${cache.expire.duration}")
    long expireDuration;

    private Cache&amp;lt;Long, CaseGraphDTO&amp;gt; metaNodeCache;

    @PostConstruct
    private void init(){
        metaNodeCache = CacheBuilder
                .newBuilder()
                .maximumSize(1000)
                .expireAfterAccess(expireDuration, TimeUnit.MINUTES)
                .build();
    }

    public CaseGraphDTO getMetaNode(long caseId) throws ExecutionException {
        //metaNodeCache的get方法，如果缓存中已有数据，直接返回数据，如果没有则通过Callable方法获取存入缓存再返回数据
        CaseGraphDTO caseGraphDTO = metaNodeCache.get(caseId, () -&amp;gt; caseGraphService.getCaseGraph
                (caseId));
        //getIfPresent方法，如果存在数据即返回
        CaseGraphDTO caseGraphDTO1 = metaNodeCache.getIfPresent(caseId);
        System.out.println(caseGraphDTO1);
        return caseGraphDTO;
    }

    public void removeMetaNodeByKey(long caseId){
        metaNodeCache.invalidate(caseId);
    }

    public void removeMetaNodeAll(){
        metaNodeCache.invalidateAll();
    }
}
```

再进行调试：


![upload successful](/images/pasted-122.png)

这时我们看到caseGraphDTO1中有了数据，并且metaNodeCache中localCache的大小也变成了1.

那么直接初始化成员变量和使用postConstruct来初始化二者的区别是什么呢？

要将对象p注入到对象a，那么首先就必须得生成对象p与对象a，才能执行注入。所以，如果一个类A中有个成员变量p被@Autowired注解，那么@Autowired注入是发生在A的构造方法执行完之后的。
如果想在生成对象时候完成某些初始化操作，而偏偏这些初始化操作又依赖于依赖注入，那么就无法在构造函数中实现。为此，可以使用@PostConstruct注解一个方法来完成初始化，@PostConstruct注解的方法将会在依赖注入完成后被自动调用。

事情似乎明朗起来了，虽然我们在初始化metaNodeCache时没有使用autowired进来的caseGraphService，但我们使用了@Value来注入缓存过期时间（配置中这个值为60）。让我们再来断点调试一下，当使用直接初始化成员变量的方式时，@Value("${cache.expire.duration}")注入的过期时间是多少，如下：



![upload successful](/images/pasted-124.png)

我们看到expireDuration的值为0，而不是配置中的60，对于cache的含义即为缓存中的数据被读取后0分钟使其失效，等同于立即失效。所以导致上文我们的缓存中始终没有数据。

让我们再来看看使用PostConstruct初始化时，这个过期时间的值：


![upload successful](/images/pasted-125.png)
此时看到expireDuration的值为60.

因此我们需要记住，构造函数，Autowired(Value)，PostConstruct的执行顺序为：

Constructor &amp;gt;&amp;gt; Autowired &amp;gt;&amp;gt; PostConstruct
如果初始化成员变量需要使用注入进来的对象或者值，那么应该放在被PostConstruct注解的方法中去做


