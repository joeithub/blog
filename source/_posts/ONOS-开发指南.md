title: ONOS 开发指南
author: Joe Tong
tags:
  - JAVAEE
  - ONOS
categories:
  - IT
date: 2019-07-30 09:30:00
---

### 搭建环境
可以用官方提供的虚拟机  
viturebox https://www.virtualbox.org/  
ONOS tutorial OVA https://drive.google.com/open?id=1JcGUJJDTtbHNnbFzC7SUK52RmMDBVUry  

### 重要命令的提示
onos> //表示你现在在onos的命令行
mininet> //表示现在的位置是在mininet下

### 设置集群
点击桌面 Setup ONOS Cluster 图标

### Launch ONOS GUI
点击提供的ONOS GUI 图标
ip:8181/onos/ui

username: onos
password：rocks

### CLI AND SERVICE 
如果我们像提供服务给其他接口，我们需要先定义服务接口然后让其他模块实现接口
1.定义一个接口官方案例写在了core工程下net里
```
package org.onosproject.net.apps;
 
import java.util.Map;
 
import org.onosproject.net.HostId;
 
/**
 * A demonstrative service for the intent reactive forwarding application to
 * export.
 */
public interface ForwardingMapService {
 
    /**
     * Get the endpoints of the host-to-host intents that were installed.
     *
     * @return maps of source to destination
     */
    public Map<HostId, HostId> getEndPoints();
 
}
```
2.实现接口  
@Component(immediate = true)  启动时加载为组件
@Service                      注册为服务 有了这个注解别的服务就可以通过
@Reference(cardinality = ReferenceCardinality.MANDATORY_UNARY) 这个注解来引用了


```
package org.onosproject.ifwd;
 
import java.util.Collections;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
 
import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Deactivate;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.ReferenceCardinality;
import org.apache.felix.scr.annotations.Service;
import org.onosproject.core.ApplicationId;
import org.onosproject.core.CoreService;
import org.onosproject.net.Host;
import org.onosproject.net.HostId;
import org.onosproject.net.PortNumber;
import org.onosproject.net.apps.ForwardingMapService;
import org.onosproject.net.flow.DefaultTrafficSelector;
import org.onosproject.net.flow.DefaultTrafficTreatment;
import org.onosproject.net.flow.TrafficSelector;
import org.onosproject.net.flow.TrafficTreatment;
import org.onosproject.net.host.HostService;
import org.onosproject.net.intent.HostToHostIntent;
import org.onosproject.net.intent.IntentService;
import org.onosproject.net.packet.DefaultOutboundPacket;
import org.onosproject.net.packet.InboundPacket;
import org.onosproject.net.packet.OutboundPacket;
import org.onosproject.net.packet.PacketContext;
import org.onosproject.net.packet.PacketProcessor;
import org.onosproject.net.packet.PacketService;
import org.onosproject.net.topology.TopologyService;
import org.onlab.packet.Ethernet;
import org.slf4j.Logger;
 
import static org.slf4j.LoggerFactory.getLogger;
 
@Component(immediate = true)
@Service
public class IntentReactiveForwarding implements ForwardingMapService {
 
    private final Logger log = getLogger(getClass());
 
    @Reference(cardinality = ReferenceCardinality.MANDATORY_UNARY)
    protected CoreService coreService;
 
    // ...<snip>...
  
    // Install a rule forwarding the packet to the specified port.
    private void setUpConnectivity(PacketContext context, HostId srcId, HostId dstId) {
        TrafficSelector selector = DefaultTrafficSelector.builder().build();
        TrafficTreatment treatment = DefaultTrafficTreatment.builder().build();
        HostToHostIntent intent = new HostToHostIntent(appId, srcId, dstId,
                                                       selector, treatment);
        intentService.submit(intent);
    }
  
    // the new service method, to be filled out
    @Override
    public Map<HostId, HostId> getEndPoints() {
        return null;
    }
}

```
实现这个服务
```
@Component(immediate = true)
@Service
public class IntentReactiveForwarding implements ForwardingMapService {
 
    // ...<snip>...
    private ApplicationId appId;
 
    // Map for storing found endpoints, for our service. It is protected
    // so that process() can access it.
    protected final ConcurrentMap<HostId, HostId> endPoints = new ConcurrentHashMap<>();
 
    // ...<snip>...
    /**
     * Packet processor responsible for forwarding packets along their paths.
     */
    private class ReactivePacketProcessor implements PacketProcessor {
 
        @Override
        public void process(PacketContext context) {
            // Stop processing if the packet has been handled, since we
            // can't do any more to it.
            if (context.isHandled()) {
             
            // ...<snip>...
             
            if (dst == null) {
                flood(context);
                return;
            }
            // Add found endpoints to map.
            endPoints.put(srcId, dstId);
 
            // Otherwise forward and be done with it.
            setUpConnectivity(context, srcId, dstId);
            forwardPacketToDst(context, dst);
        }
    }
 
    // ...<snip>...
 
    @Override
    public Map<HostId, HostId> getEndPoints() {
        // Return our map as a read-only structure.
        return Collections.unmodifiableMap(endPoints);
    }
}

```
### 创建命令  
一般命令定义在${ONOS_ROOT}/cli/下命令分为两种：  
1系统配置和监控相关  
2网络配置和监控相关  
 
@Command  
@Argument  
@Option  

```
package org.onosproject.cli.net;
 
import org.apache.karaf.shell.commands.Argument;
import org.apache.karaf.shell.commands.Command;
import org.onosproject.cli.AbstractShellCommand;
import org.onosproject.net.HostId;
import org.onosproject.net.apps.ForwardingMapService;
 
/**
 * A demo service that lists the endpoints for which intents are installed.
 */
@Command(scope = "onos", name = "fwdmap",
        description = "Lists the endpoints for which intents are installed")
public class ForwardingMapCommand extends AbstractShellCommand {
  
    @Argument(index = 0, name = "hostId", description = "Host ID of source",
            required = false, multiValued = false)
    private HostId hostId = null;
 
    @Override
    protected void execute() {
    }
}

```
合并新服务
```
package org.onosproject.cli.net;
 
import java.util.Map;
 
import org.apache.karaf.shell.commands.Argument;
import org.apache.karaf.shell.commands.Command;
import org.onosproject.cli.AbstractShellCommand;
import org.onosproject.net.HostId;
import org.onosproject.net.apps.ForwardingMapService;
 
/**
 * A demo service that lists the endpoints for which intents are installed.
 */
@Command(scope = "onos", name = "fwdmap",
        description = "Lists the endpoints for which intents are installed")
public class ForwardingMapCommand extends AbstractShellCommand {
  
    // formatted string for output to CLI
    private static final String FMT = "src=%s, dst=%s";
 
    // the String to hold the optional argument
    @Argument(index = 0, name = "hostId", description = "Host ID of source",
            required = false, multiValued = false)
    private String hostId = null;
 
    // reference to our service
    private ForwardingMapService service;
    // to hold the service's response
    private Map<HostId, HostId> hmap;
 
    @Override
    protected void execute() {
        // get a reference to our service
        service = get(ForwardingMapService.class);
 
        /*
         * getEndPoints() returns an empty map even if it contains nothing, so
         * we don't need to check for null hmap here.
         */
        hmap = service.getEndPoints();
 
        // check for an argument, then display information accordingly
        if (hostId != null) {
            // we were given a hostId to filter on, print only those that match
            HostId host = HostId.hostId(hostId);
            for (Map.Entry<HostId, HostId> el : hmap.entrySet()) {
                if (el.getKey().equals(hostId)) {
                    print(FMT, el.getKey(), el.getValue());
                }
            }
        } else {
            // print everything we have
            for (Map.Entry<HostId, HostId> el : hmap.entrySet()) {
                print(FMT, el.getKey(), el.getValue());
            }
        }
    }
}
```

注册命令到karaf
${ONOS_ROOT}/cli/src/main/resources/OSGI-INF/blueprint/  shell-config.xml中  
```
<command>
    <!--Our command implementation's FQDN-->
    <action class="org.onosproject.cli.net.ForwardingMapCommand"/>
    <!--A command completer for Host IDs-->
    <completers>
        <ref component-id="hostIdCompleter"/>
        <null/>
    </completers>
</command>

```
重新编译启动ONOS
```
$ cd ${ONOS_ROOT}
$ mvn clean install
$ karaf clean
```
测试

### 应用模板教程
onos-create-app工具
可以创建基础应用、命令、REST API 和GUI
1选 ONOS 版本
`export ONOS_POM_VERSION=2.0.0`

2创建工程
 1） 创建基础工程
    `onos-create-app app org.foo foo-app 1.0-SNAPSHOT org.foo.app`
    编译安装激活
    ```
    $ cd foo-app
    $ mvn clean install
    $ onos-app localhost install! target/foo-app-1.0-SNAPSHOT.oar
    ```
    
 2) 创建带命令的工程
    `onos-create-app cli org.foo foo-app 1.0-SNAPSHOT org.foo.app`
    重新编译安装
    ```
    $ mvn clean install
    $ onos-app localhost reinstall! target/foo-app-1.0-SNAPSHOT.oar
    ```
    
 3) 创建REST API 工程
   `onos-create-app rest org.foo foo-app 1.0-SNAPSHOT org.foo.app`
   重新编译安装
   ```
   $ mvn clean install
   $ onos-app localhost reinstall! target/foo-app-1.0-SNAPSHOT.oar
   ```
   打包完会自动创建 swagger ui http://localhost:8181/v1/docs/
    
 4）创建ui工程
    `onos-create-app ui org.foo foo-app 1.0-SNAPSHOT org.foo.app`
    带表格视图
    `onos-create-app uitab org.foo foo-app 1.0-SNAPSHOT org.foo.app`
    带拓扑图
    `onos-create-app uitopo org.foo foo-app 1.0-SNAPSHOT org.foo.app`
    重新编译安装
    ```
     mvn clean install
     onos-app localhost reinstall! org.foo.app target/foo-app-1.0-SNAPSHOT.oar
    ```
发布到本地仓库
`onos-publish -l` 


CoreService 类

```
//核心应用名
String CORE_APP_NAME = "org.onosproject.core";
//核心“提供者”的标识符。 
ProviderId CORE_PROVIDER_ID = new ProviderId("core", CORE_APP_NAME);
//返回产品版本 
Version version();
//返回当前注册的应用程序标识符集。 
Set<ApplicationId> getAppIds();
//从给定的ID返回现有的应用程序ID。
ApplicationId getAppId(Short id);
//从给定的ID返回现有的应用程序ID。
ApplicationId getAppId(String name);
//根据名字注册一个新应用
ApplicationId registerApplication(String name, Runnable preDeactivate);
//返回给定主题的ID生成器。
IdGenerator getIdGenerator(String topic);


```
<font color="red"> 注意 </font>
如何获得一个AppId  
`appId = coreService.registerApplication(PROVIDER_ID);`  
根据PROVIDER_ID产生再从coreService的registerApplication方法中得到appId    
PROVIDER_ID  
`static final String PROVIDER_ID = "org.onosproject.provider.bgp.cfg";`

### 如何设置配置文件
首先自定义好配置类  
引入组件配置服务  

```
    @Reference(cardinality = ReferenceCardinality.MANDATORY)
    protected ComponentConfigService componentConfigService;
```
组件配置服务注册配置文件  

```
componentConfigService.registerProperties(getClass());
```
<hr/>
首先需要建立配置文件类
然后需要添加配置监听  
`private final NetworkConfigListener configListener = new InternalConfigListener();`
`configService.addListener(configListener);`  

通过配置工厂ConfigFactory configFactory
需要三个参数SubjectFactories.APP_SUBJECT_FACTORY, 配置类的字节码文件, key  

```
private final ConfigFactory configFactory =
            new ConfigFactory(SubjectFactories.APP_SUBJECT_FACTORY, BgpAppConfig.class, "bgpapp") {
                @Override
                public BgpAppConfig createConfig() {
                    return new BgpAppConfig();
                }
};
            
```

注册配置工厂
`configRegistry.registerConfigFactory(configFactory);`
读取配置
`readConfiguration();`  
<font color="red"> 注意 </font>  
以上方法需要在bundle初始化的时候执行即在activate（也有叫start）方法中执行：

```
@Activate
public void activate(ComponentContext context) {
    appId = coreService.registerApplication(PROVIDER_ID);
    configService.addListener(configListener);
    configRegistry.registerConfigFactory(configFactory);
    readConfiguration();//内部自己定义
    log.info("BGP cfg provider started");
}

```

当bundle关闭不再需要的时候可以在deactivate（也有叫stop）方法中取消注册  


```
@Deactivate
public void deactivate(ComponentContext context) {
    configRegistry.unregisterConfigFactory(configFactory);
    configService.removeListener(configListener);
}
  
```
2.net config  
配置类继承Config<String>
在组件中引入服务
```
@Reference
protected NetworkConfigRegistry configRegistry;
```
```
private final ConfigFactory configFactory = 
  new configFactory(SubjectFactories.APP_SUBJECT_FACTORY,配置类名,起个名字作为key){
    @Override
    public 配置类 create配置类(){
        return new 配置类();
    }
}
```
activate 方法里注册配置文件
```
configRegistry.registerConfigFactory(configFactory);
```
<hr/>

### onos中的日志
onos通过slf4j 来记录日志  

`private static final Logger log = getLogger(本类的字节码);`

<hr/>

### onos命令行开发
主要用到几个注解 

|类上的| 
|:-|   
|@Service  |//标注此类为服务  |  
|@Component | //将此类作为组件加载 |  

|方法上 | 
|:-|
|@Option |//选项 | 
|@Argument |//参数 | 

scop 作用域一般为应用名  
name 命令名  
description 命令的描述  
detaileddescription 细节描述  

<hr/>

onos 的WEB 开发  
onos基于JAX-RS 做的 
传统的servlet rest 开发方式  
需要配置web.xml  
需配置servlet 和 servlet-mapping

一：配置web.xml 

`

<?xml version="1.0" encoding="UTF-8"?>

<!--
  ~ Copyright 2016-present Open Networking Foundation
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~     http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
  -->
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://java.sun.com/xml/ns/javaee"
         xmlns:web="http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
         id="ONOS" version="2.5">
    <display-name>Visual App REST API v1.0</display-name>

    <security-constraint>
        <web-resource-collection>
            <web-resource-name>Secured</web-resource-name>
            <url-pattern>/*</url-pattern>
        </web-resource-collection>
        <auth-constraint>
            <role-name>admin</role-name>

        </auth-constraint>
    </security-constraint>

    <security-role>
        <role-name>admin</role-name>

    </security-role>

    <login-config>
        <auth-method>BASIC</auth-method>
        <realm-name>karaf</realm-name>
    </login-config>

    <servlet>
        <servlet-name>JAX-RS Service</servlet-name>
        <servlet-class>org.glassfish.jersey.servlet.ServletContainer</servlet-class>
        <init-param>
            <param-name>javax.ws.rs.Application</param-name>
            <!--<param-name>jersey.config.server.provider.classnames</param-name>-->
            <param-value>org.onosproject.visual.rest.VisualWebApplication</param-value>
        </init-param>

        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>JAX-RS Service</servlet-name>
        <url-pattern>/*</url-pattern>
    </servlet-mapping>
</web-app>

`

2.BUILD文件里
```
osgi_jar_with_tests(
    api_description = "REST API for Visual",
    api_package = "org.onosproject.visual.rest",
    api_title = "Visual Management",
    api_version = "1.0",
    web_context = "/ensbrain/visual",
    karaf_command_packages = ["org.onosproject.visual"],
    deps = COMPILE_DEPS,
)

```  
必须要有的是web_context此值相当于访问路径的根  

3.必须要有一个Application类并继承AbstractWebApplication
例如访问类叫VisualWebResource
那么
VisualWebApplication：

```
public class VisualWebApplication extends AbstractWebApplication {
    @Override
    public Set<Class<?>> getClasses() {
        return getClasses(VisualWebResource.class);
    }
}

```

```
@Path("query")
public class VisualWebResource extends AbstractWebResource{

//    private VisualServerConfig esAgentConfig;

    @GET
    @Path("hello")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getHistogram() {
        String result = "hello welcome to enlink sdp visual of users' behaviour ";
        ObjectNode node = mapper().createObjectNode().put("response", result);
        return ok(node).build();
    }
```  
如果要传递对象到前台需要通过转成json字符串
需要   
1.实现JsonCodec<dto类>  
```  
1.dto类  
2.dto类的json转码类要继承JsonCodec<dto类>  
3.重写里面的转码方法其实就是把属性都拿出来重新放到objectNode类中
返回的就是objectNode  
4.如果是多个对象就转成ArrayNode json数组返回arrayNode  
```  

2.注册
在激活时将实体类与json转换类形成映射关系  
例如：  
```
@Component(immediate = true,service = VisualRegistryService.class)
public class VisualRegistryService {

    private static final Logger log = getLogger(VisualRegistryService.class);

    @Reference(cardinality = ReferenceCardinality.MANDATORY)
    protected CoreService coreService;

    @Reference(cardinality = ReferenceCardinality.MANDATORY)
    protected CodecService codecService;

    private ApplicationId appId;

    @Activate
    public void active(){
        appId = coreService.getAppId("org.onosproject.visual");
        codecService.registerCodec(SearchSQLDto.class,new SearchSQLDtoJsonCodec());
        log.info("visual started");
    }

    @Deactivate
    public void deactive(){
        log.info("Stopped");
    }
}
```


