title: euraka 配置介绍
author: Joe Tong
tags:
  - JAVAEE
  - Eureka
categories:
  - IT
date: 2019-10-12 16:38:00
---
spring cloud eureka 参数配置

eureka.client.registry-fetch-interval-seconds  
表示eureka client间隔多久去拉取服务注册信息，默认为30秒，对于api-gateway，如果要迅速获取服务注册状态，可以缩小该值，比如5秒

eureka.instance.lease-expiration-duration-in-seconds  
leaseExpirationDurationInSeconds，表示eureka server至上一次收到client的心跳之后，等待下一次心跳的超时时间，在这个时间内若没收到下一次心跳，则将移除该instance。

默认为90秒
如果该值太大，则很可能将流量转发过去的时候，该instance已经不存活了。
如果该值设置太小了，则instance则很可能因为临时的网络抖动而被摘除掉。
该值至少应该大于leaseRenewalIntervalInSeconds
eureka.instance.lease-renewal-interval-in-seconds  
leaseRenewalIntervalInSeconds，表示eureka client发送心跳给server端的频率。如果在leaseExpirationDurationInSeconds后，server端没有收到client的心跳，则将摘除该instance。除此之外，如果该instance实现了HealthCheckCallback，并决定让自己unavailable的话，则该instance也不会接收到流量。

默认30秒
eureka.server.enable-self-preservation  
是否开启自我保护模式，默认为true。

默认情况下，如果Eureka Server在一定时间内没有接收到某个微服务实例的心跳，Eureka Server将会注销该实例（默认90秒）。但是当网络分区故障发生时，微服务与Eureka Server之间无法正常通信，以上行为可能变得非常危险了——因为微服务本身其实是健康的，此时本不应该注销这个微服务。

Eureka通过“自我保护模式”来解决这个问题——当Eureka Server节点在短时间内丢失过多客户端时（可能发生了网络分区故障），那么这个节点就会进入自我保护模式。一旦进入该模式，Eureka Server就会保护服务注册表中的信息，不再删除服务注册表中的数据（也就是不会注销任何微服务）。当网络故障恢复后，该Eureka Server节点会自动退出自我保护模式。

综上，自我保护模式是一种应对网络异常的安全保护措施。它的架构哲学是宁可同时保留所有微服务（健康的微服务和不健康的微服务都会保留），也不盲目注销任何健康的微服务。使用自我保护模式，可以让Eureka集群更加的健壮、稳定。

eureka.server.eviction-interval-timer-in-ms  
eureka server清理无效节点的时间间隔，默认60000毫秒，即60秒

测试环境参考配置
eureka server

```  
eureka:
  server:
    enable-self-preservation: false           # 关闭自我保护模式（缺省为打开）
    eviction-interval-timer-in-ms: 5000       # 续期时间，即扫描失效服务的间隔时间（缺省为60*1000ms）
```

eureka client

```
eureka:
  instance:
    lease-renewal-interval-in-seconds: 5      # 心跳时间，即服务续约间隔时间（缺省为30s）
    lease-expiration-duration-in-seconds: 10  # 发呆时间，即服务续约到期时间（缺省为90s）
  client:
    healthcheck:
      enabled: true                           # 开启健康检查（依赖spring-boot-starter-actuator）
```

zuul

```
eureka:
  client:
    registry-fetch-interval-seconds: 5 # 默认为30秒
```

client完整参数列表
~/.m2/repository/org/springframework/cloud/spring-cloud-netflix-eureka-client/1.2.3.RELEASE/spring-cloud-netflix-eureka-client-1.2.3.RELEASE.jar!/META-INF/spring-configuration-metadata.json

```
{
  "groups": [
    {
      "name": "eureka.client",
      "type": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.instance",
      "type": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    }
  ],
  "properties": [
    {
      "name": "eureka.client.allow-redirects",
      "type": "java.lang.Boolean",
      "description": "Indicates whether server can redirect a client request to a backup server/cluster.\n If set to false, the server will handle the request directly, If set to true, it\n may send HTTP redirect to the client, with a new server location.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.client.availability-zones",
      "type": "java.util.Map&lt;java.lang.String,java.lang.String&gt;",
      "description": "Gets the list of availability zones (used in AWS data centers) for the region in\n which this instance resides.\n\n The changes are effective at runtime at the next registry fetch cycle as specified\n by registryFetchIntervalSeconds.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.backup-registry-impl",
      "type": "java.lang.String",
      "description": "Gets the name of the implementation which implements BackupRegistry to fetch the\n registry information as a fall back option for only the first time when the eureka\n client starts.\n\n This may be needed for applications which needs additional resiliency for registry\n information without which it cannot operate.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.cache-refresh-executor-exponential-back-off-bound",
      "type": "java.lang.Integer",
      "description": "Cache refresh executor exponential back off related property. It is a maximum\n multiplier value for retry delay, in case where a sequence of timeouts occurred.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 10
    },
    {
      "name": "eureka.client.cache-refresh-executor-thread-pool-size",
      "type": "java.lang.Integer",
      "description": "The thread pool size for the cacheRefreshExecutor to initialise with",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 2
    },
    {
      "name": "eureka.client.client-data-accept",
      "type": "java.lang.String",
      "description": "EurekaAccept name for client data accept",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.decoder-name",
      "type": "java.lang.String",
      "description": "This is a transient config and once the latest codecs are stable, can be removed\n (as there will only be one)",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.disable-delta",
      "type": "java.lang.Boolean",
      "description": "Indicates whether the eureka client should disable fetching of delta and should\n rather resort to getting the full registry information.\n\n Note that the delta fetches can reduce the traffic tremendously, because the rate\n of change with the eureka server is normally much lower than the rate of fetches.\n\n The changes are effective at runtime at the next registry fetch cycle as specified\n by registryFetchIntervalSeconds",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.client.dollar-replacement",
      "type": "java.lang.String",
      "description": "Get a replacement string for Dollar sign &lt;code&gt;$&lt;\/code&gt; during\n serializing/deserializing information in eureka server.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": "_-"
    },
    {
      "name": "eureka.client.enabled",
      "type": "java.lang.Boolean",
      "description": "Flag to indicate that the Eureka client is enabled.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.client.encoder-name",
      "type": "java.lang.String",
      "description": "This is a transient config and once the latest codecs are stable, can be removed\n (as there will only be one)",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.escape-char-replacement",
      "type": "java.lang.String",
      "description": "Get a replacement string for underscore sign &lt;code&gt;_&lt;\/code&gt; during\n serializing/deserializing information in eureka server.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": "__"
    },
    {
      "name": "eureka.client.eureka-connection-idle-timeout-seconds",
      "type": "java.lang.Integer",
      "description": "Indicates how much time (in seconds) that the HTTP connections to eureka server can\n stay idle before it can be closed.\n\n In the AWS environment, it is recommended that the values is 30 seconds or less,\n since the firewall cleans up the connection information after a few mins leaving\n the connection hanging in limbo",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 30
    },
    {
      "name": "eureka.client.eureka-server-connect-timeout-seconds",
      "type": "java.lang.Integer",
      "description": "Indicates how long to wait (in seconds) before a connection to eureka server needs\n to timeout. Note that the connections in the client are pooled by\n org.apache.http.client.HttpClient and this setting affects the actual connection\n creation and also the wait time to get the connection from the pool.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 5
    },
    {
      "name": "eureka.client.eureka-server-d-n-s-name",
      "type": "java.lang.String",
      "description": "Gets the DNS name to be queried to get the list of eureka servers.This information\n is not required if the contract returns the service urls by implementing\n serviceUrls.\n\n The DNS mechanism is used when useDnsForFetchingServiceUrls is set to true and the\n eureka client expects the DNS to configured a certain way so that it can fetch\n changing eureka servers dynamically.\n\n The changes are effective at runtime.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.eureka-server-port",
      "type": "java.lang.String",
      "description": "Gets the port to be used to construct the service url to contact eureka server when\n the list of eureka servers come from the DNS.This information is not required if\n the contract returns the service urls eurekaServerServiceUrls(String).\n\n The DNS mechanism is used when useDnsForFetchingServiceUrls is set to true and the\n eureka client expects the DNS to configured a certain way so that it can fetch\n changing eureka servers dynamically.\n\n The changes are effective at runtime.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.eureka-server-read-timeout-seconds",
      "type": "java.lang.Integer",
      "description": "Indicates how long to wait (in seconds) before a read from eureka server needs to\n timeout.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 8
    },
    {
      "name": "eureka.client.eureka-server-total-connections",
      "type": "java.lang.Integer",
      "description": "Gets the total number of connections that is allowed from eureka client to all\n eureka servers.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 200
    },
    {
      "name": "eureka.client.eureka-server-total-connections-per-host",
      "type": "java.lang.Integer",
      "description": "Gets the total number of connections that is allowed from eureka client to a eureka\n server host.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 50
    },
    {
      "name": "eureka.client.eureka-server-u-r-l-context",
      "type": "java.lang.String",
      "description": "Gets the URL context to be used to construct the service url to contact eureka\n server when the list of eureka servers come from the DNS. This information is not\n required if the contract returns the service urls from eurekaServerServiceUrls.\n\n The DNS mechanism is used when useDnsForFetchingServiceUrls is set to true and the\n eureka client expects the DNS to configured a certain way so that it can fetch\n changing eureka servers dynamically. The changes are effective at runtime.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.eureka-service-url-poll-interval-seconds",
      "type": "java.lang.Integer",
      "description": "Indicates how often(in seconds) to poll for changes to eureka server information.\n Eureka servers could be added or removed and this setting controls how soon the\n eureka clients should know about it.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.client.fetch-registry",
      "type": "java.lang.Boolean",
      "description": "Indicates whether this client should fetch eureka registry information from eureka\n server.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.client.fetch-remote-regions-registry",
      "type": "java.lang.String",
      "description": "Comma separated list of regions for which the eureka registry information will be\n fetched. It is mandatory to define the availability zones for each of these regions\n as returned by availabilityZones. Failing to do so, will result in failure of\n discovery client startup.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.filter-only-up-instances",
      "type": "java.lang.Boolean",
      "description": "Indicates whether to get the applications after filtering the applications for\n instances with only InstanceStatus UP states.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.client.g-zip-content",
      "type": "java.lang.Boolean",
      "description": "Indicates whether the content fetched from eureka server has to be compressed\n whenever it is supported by the server. The registry information from the eureka\n server is compressed for optimum network traffic.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.client.heartbeat-executor-exponential-back-off-bound",
      "type": "java.lang.Integer",
      "description": "Heartbeat executor exponential back off related property. It is a maximum\n multiplier value for retry delay, in case where a sequence of timeouts occurred.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 10
    },
    {
      "name": "eureka.client.heartbeat-executor-thread-pool-size",
      "type": "java.lang.Integer",
      "description": "The thread pool size for the heartbeatExecutor to initialise with",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 2
    },
    {
      "name": "eureka.client.initial-instance-info-replication-interval-seconds",
      "type": "java.lang.Integer",
      "description": "Indicates how long initially (in seconds) to replicate instance info to the eureka\n server",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 40
    },
    {
      "name": "eureka.client.instance-info-replication-interval-seconds",
      "type": "java.lang.Integer",
      "description": "Indicates how often(in seconds) to replicate instance changes to be replicated to\n the eureka server.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 30
    },
    {
      "name": "eureka.client.log-delta-diff",
      "type": "java.lang.Boolean",
      "description": "Indicates whether to log differences between the eureka server and the eureka\n client in terms of registry information.\n\n Eureka client tries to retrieve only delta changes from eureka server to minimize\n network traffic. After receiving the deltas, eureka client reconciles the\n information from the server to verify it has not missed out some information.\n Reconciliation failures could happen when the client has had network issues\n communicating to server.If the reconciliation fails, eureka client gets the full\n registry information.\n\n While getting the full registry information, the eureka client can log the\n differences between the client and the server and this setting controls that.\n\n The changes are effective at runtime at the next registry fetch cycle as specified\n by registryFetchIntervalSecondsr",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.client.on-demand-update-status-change",
      "type": "java.lang.Boolean",
      "description": "If set to true, local status updates via ApplicationInfoManager will trigger\n on-demand (but rate limited) register/updates to remote eureka servers",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.client.prefer-same-zone-eureka",
      "type": "java.lang.Boolean",
      "description": "Indicates whether or not this instance should try to use the eureka server in the\n same zone for latency and/or other reason.\n\n Ideally eureka clients are configured to talk to servers in the same zone\n\n The changes are effective at runtime at the next registry fetch cycle as specified\n by registryFetchIntervalSeconds",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.client.property-resolver",
      "type": "org.springframework.core.env.PropertyResolver",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.proxy-host",
      "type": "java.lang.String",
      "description": "Gets the proxy host to eureka server if any.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.proxy-password",
      "type": "java.lang.String",
      "description": "Gets the proxy password if any.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.proxy-port",
      "type": "java.lang.String",
      "description": "Gets the proxy port to eureka server if any.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.proxy-user-name",
      "type": "java.lang.String",
      "description": "Gets the proxy user name if any.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.region",
      "type": "java.lang.String",
      "description": "Gets the region (used in AWS datacenters) where this instance resides.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": "us-east-1"
    },
    {
      "name": "eureka.client.register-with-eureka",
      "type": "java.lang.Boolean",
      "description": "Indicates whether or not this instance should register its information with eureka\n server for discovery by others.\n\n In some cases, you do not want your instances to be discovered whereas you just\n want do discover other instances.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.client.registry-fetch-interval-seconds",
      "type": "java.lang.Integer",
      "description": "Indicates how often(in seconds) to fetch the registry information from the eureka\n server.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": 30
    },
    {
      "name": "eureka.client.registry-refresh-single-vip-address",
      "type": "java.lang.String",
      "description": "Indicates whether the client is only interested in the registry information for a\n single VIP.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.service-url",
      "type": "java.util.Map&lt;java.lang.String,java.lang.String&gt;",
      "description": "Map of availability zone to list of fully qualified URLs to communicate with eureka\n server. Each value can be a single URL or a comma separated list of alternative\n locations.\n\n Typically the eureka server URLs carry protocol,host,port,context and version\n information if any. Example:\n http://ec2-256-156-243-129.compute-1.amazonaws.com:7001/eureka/\n\n The changes are effective at runtime at the next service url refresh cycle as\n specified by eurekaServiceUrlPollIntervalSeconds.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.transport",
      "type": "com.netflix.discovery.shared.transport.EurekaTransportConfig",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean"
    },
    {
      "name": "eureka.client.use-dns-for-fetching-service-urls",
      "type": "java.lang.Boolean",
      "description": "Indicates whether the eureka client should use the DNS mechanism to fetch a list of\n eureka servers to talk to. When the DNS name is updated to have additional servers,\n that information is used immediately after the eureka client polls for that\n information as specified in eurekaServiceUrlPollIntervalSeconds.\n\n Alternatively, the service urls can be returned serviceUrls, but the users should\n implement their own mechanism to return the updated list in case of changes.\n\n The changes are effective at runtime.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaClientConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.instance.a-s-g-name",
      "type": "java.lang.String",
      "description": "Gets the AWS autoscaling group name associated with this instance. This information\n is specifically used in an AWS environment to automatically put an instance out of\n service after the instance is launched and it has been disabled for traffic..",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.app-group-name",
      "type": "java.lang.String",
      "description": "Get the name of the application group to be registered with eureka.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.appname",
      "type": "java.lang.String",
      "description": "Get the name of the application to be registered with eureka.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": "unknown"
    },
    {
      "name": "eureka.instance.data-center-info",
      "type": "com.netflix.appinfo.DataCenterInfo",
      "description": "Returns the data center this instance is deployed. This information is used to get\n some AWS specific instance information if the instance is deployed in AWS.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.default-address-resolution-order",
      "type": "java.lang.String[]",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": []
    },
    {
      "name": "eureka.instance.environment",
      "type": "org.springframework.core.env.Environment",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.health-check-url",
      "type": "java.lang.String",
      "description": "Gets the absolute health check page URL for this instance. The users can provide\n the healthCheckUrlPath if the health check page resides in the same instance\n talking to eureka, else in the cases where the instance is a proxy for some other\n server, users can provide the full URL. If the full URL is provided it takes\n precedence.\n\n &lt;p&gt;\n It is normally used for making educated decisions based on the health of the\n instance - for example, it can be used to determine whether to proceed deployments\n to an entire farm or stop the deployments without causing further damage. The full\n URL should follow the format http://${eureka.hostname}:7001/ where the value\n ${eureka.hostname} is replaced at runtime.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.health-check-url-path",
      "type": "java.lang.String",
      "description": "Gets the relative health check URL path for this instance. The health check page\n URL is then constructed out of the hostname and the type of communication - secure\n or unsecure as specified in securePort and nonSecurePort.\n\n It is normally used for making educated decisions based on the health of the\n instance - for example, it can be used to determine whether to proceed deployments\n to an entire farm or stop the deployments without causing further damage.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": "/health"
    },
    {
      "name": "eureka.instance.home-page-url",
      "type": "java.lang.String",
      "description": "Gets the absolute home page URL for this instance. The users can provide the\n homePageUrlPath if the home page resides in the same instance talking to eureka,\n else in the cases where the instance is a proxy for some other server, users can\n provide the full URL. If the full URL is provided it takes precedence.\n\n It is normally used for informational purposes for other services to use it as a\n landing page. The full URL should follow the format http://${eureka.hostname}:7001/\n where the value ${eureka.hostname} is replaced at runtime.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.home-page-url-path",
      "type": "java.lang.String",
      "description": "Gets the relative home page URL Path for this instance. The home page URL is then\n constructed out of the hostName and the type of communication - secure or unsecure.\n\n It is normally used for informational purposes for other services to use it as a\n landing page.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": "/"
    },
    {
      "name": "eureka.instance.host-info",
      "type": "org.springframework.cloud.commons.util.InetUtils$HostInfo",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.hostname",
      "type": "java.lang.String",
      "description": "The hostname if it can be determined at configuration time (otherwise it will be\n guessed from OS primitives).",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.hostname",
      "type": "java.lang.String",
      "description": "The hostname if it can be determined at configuration time (otherwise it will be\n guessed from OS primitives).",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.inet-utils",
      "type": "org.springframework.cloud.commons.util.InetUtils",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.initial-status",
      "type": "com.netflix.appinfo.InstanceInfo$InstanceStatus",
      "description": "Initial status to register with rmeote Eureka server.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.instance-enabled-onit",
      "type": "java.lang.Boolean",
      "description": "Indicates whether the instance should be enabled for taking traffic as soon as it\n is registered with eureka. Sometimes the application might need to do some\n pre-processing before it is ready to take traffic.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.instance.instance-id",
      "type": "java.lang.String",
      "description": "Get the unique Id (within the scope of the appName) of this instance to be\n registered with eureka.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.ip-address",
      "type": "java.lang.String",
      "description": "Get the IPAdress of the instance. This information is for academic purposes only as\n the communication from other instances primarily happen using the information\n supplied in {@link #getHostName(boolean)}.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.lease-expiration-duration-in-seconds",
      "type": "java.lang.Integer",
      "description": "Indicates the time in seconds that the eureka server waits since it received the\n last heartbeat before it can remove this instance from its view and there by\n disallowing traffic to this instance.\n\n Setting this value too long could mean that the traffic could be routed to the\n instance even though the instance is not alive. Setting this value too small could\n mean, the instance may be taken out of traffic because of temporary network\n glitches.This value to be set to atleast higher than the value specified in\n leaseRenewalIntervalInSeconds.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": 90
    },
    {
      "name": "eureka.instance.lease-renewal-interval-in-seconds",
      "type": "java.lang.Integer",
      "description": "Indicates how often (in seconds) the eureka client needs to send heartbeats to\n eureka server to indicate that it is still alive. If the heartbeats are not\n received for the period specified in leaseExpirationDurationInSeconds, eureka\n server will remove the instance from its view, there by disallowing traffic to this\n instance.\n\n Note that the instance could still not take traffic if it implements\n HealthCheckCallback and then decides to make itself unavailable.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": 30
    },
    {
      "name": "eureka.instance.metadata-map",
      "type": "java.util.Map&lt;java.lang.String,java.lang.String&gt;",
      "description": "Gets the metadata name/value pairs associated with this instance. This information\n is sent to eureka server and can be used by other instances.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.namespace",
      "type": "java.lang.String",
      "description": "Get the namespace used to find properties. Ignored in Spring Cloud.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": "eureka"
    },
    {
      "name": "eureka.instance.non-secure-port",
      "type": "java.lang.Integer",
      "description": "Get the non-secure port on which the instance should receive traffic.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": 80
    },
    {
      "name": "eureka.instance.non-secure-port-enabled",
      "type": "java.lang.Boolean",
      "description": "Indicates whether the non-secure port should be enabled for traffic or not.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.instance.prefer-ip-address",
      "type": "java.lang.Boolean",
      "description": "Flag to say that, when guessing a hostname, the IP address of the server should be\n used in prference to the hostname reported by the OS.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.instance.secure-health-check-url",
      "type": "java.lang.String",
      "description": "Gets the absolute secure health check page URL for this instance. The users can\n provide the secureHealthCheckUrl if the health check page resides in the same\n instance talking to eureka, else in the cases where the instance is a proxy for\n some other server, users can provide the full URL. If the full URL is provided it\n takes precedence.\n\n &lt;p&gt;\n It is normally used for making educated decisions based on the health of the\n instance - for example, it can be used to determine whether to proceed deployments\n to an entire farm or stop the deployments without causing further damage. The full\n URL should follow the format http://${eureka.hostname}:7001/ where the value\n ${eureka.hostname} is replaced at runtime.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.secure-port",
      "type": "java.lang.Integer",
      "description": "Get the Secure port on which the instance should receive traffic.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": 443
    },
    {
      "name": "eureka.instance.secure-port-enabled",
      "type": "java.lang.Boolean",
      "description": "Indicates whether the secure port should be enabled for traffic or not.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.instance.secure-virtual-host-name",
      "type": "java.lang.String",
      "description": "Gets the secure virtual host name defined for this instance.\n\n This is typically the way other instance would find this instance by using the\n secure virtual host name.Think of this as similar to the fully qualified domain\n name, that the users of your services will need to find this instance.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": "unknown"
    },
    {
      "name": "eureka.instance.status-page-url",
      "type": "java.lang.String",
      "description": "Gets the absolute status page URL path for this instance. The users can provide the\n statusPageUrlPath if the status page resides in the same instance talking to\n eureka, else in the cases where the instance is a proxy for some other server,\n users can provide the full URL. If the full URL is provided it takes precedence.\n\n It is normally used for informational purposes for other services to find about the\n status of this instance. Users can provide a simple HTML indicating what is the\n current status of the instance.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean"
    },
    {
      "name": "eureka.instance.status-page-url-path",
      "type": "java.lang.String",
      "description": "Gets the relative status page URL path for this instance. The status page URL is\n then constructed out of the hostName and the type of communication - secure or\n unsecure as specified in securePort and nonSecurePort.\n\n It is normally used for informational purposes for other services to find about the\n status of this instance. Users can provide a simple HTML indicating what is the\n current status of the instance.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": "/info"
    },
    {
      "name": "eureka.instance.virtual-host-name",
      "type": "java.lang.String",
      "description": "Gets the virtual host name defined for this instance.\n\n This is typically the way other instance would find this instance by using the\n virtual host name.Think of this as similar to the fully qualified domain name, that\n the users of your services will need to find this instance.",
      "sourceType": "org.springframework.cloud.netflix.eureka.EurekaInstanceConfigBean",
      "defaultValue": "unknown"
    }
  ],
  "hints": []
}
```

server完整参数列表
~/.m2/repository/org/springframework/cloud/spring-cloud-netflix-eureka-server/1.2.3.RELEASE/spring-cloud-netflix-eureka-server-1.2.3.RELEASE.jar!/META-INF/spring-configuration-metadata.json

```
{
  "groups": [
    {
      "name": "eureka.dashboard",
      "type": "org.springframework.cloud.netflix.eureka.server.EurekaDashboardProperties",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaDashboardProperties"
    },
    {
      "name": "eureka.instance.registry",
      "type": "org.springframework.cloud.netflix.eureka.server.InstanceRegistryProperties",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.InstanceRegistryProperties"
    },
    {
      "name": "eureka.server",
      "type": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    }
  ],
  "properties": [
    {
      "name": "eureka.dashboard.enabled",
      "type": "java.lang.Boolean",
      "description": "Flag to enable the Eureka dashboard. Default true.",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaDashboardProperties",
      "defaultValue": true
    },
    {
      "name": "eureka.dashboard.path",
      "type": "java.lang.String",
      "description": "The path to the Eureka dashboard (relative to the servlet path). Defaults to \"/\".",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaDashboardProperties",
      "defaultValue": "/"
    },
    {
      "name": "eureka.instance.registry.default-open-for-traffic-count",
      "type": "java.lang.Integer",
      "description": "Value used in determining when leases are cancelled, default to 1 for standalone.\n Should be set to 0 for peer replicated eurekas",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.InstanceRegistryProperties",
      "defaultValue": 1
    },
    {
      "name": "eureka.instance.registry.expected-number-of-renews-per-min",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.InstanceRegistryProperties",
      "defaultValue": 1
    },
    {
      "name": "eureka.server.a-s-g-cache-expiry-timeout-ms",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.a-s-g-query-timeout-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 300
    },
    {
      "name": "eureka.server.a-s-g-update-interval-ms",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.a-w-s-access-id",
      "type": "java.lang.String",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    },
    {
      "name": "eureka.server.a-w-s-secret-key",
      "type": "java.lang.String",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    },
    {
      "name": "eureka.server.batch-replication",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.server.binding-strategy",
      "type": "com.netflix.eureka.aws.AwsBindingStrategy",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    },
    {
      "name": "eureka.server.delta-retention-timer-interval-in-ms",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.disable-delta",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.server.disable-delta-for-remote-regions",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.server.disable-transparent-fallback-to-other-region",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.server.e-i-p-bind-rebind-retries",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 3
    },
    {
      "name": "eureka.server.e-i-p-binding-retry-interval-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.e-i-p-binding-retry-interval-ms-when-unbound",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.enable-replicated-request-compression",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.server.enable-self-preservation",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.server.eviction-interval-timer-in-ms",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.g-zip-content-from-remote-region",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.server.json-codec-name",
      "type": "java.lang.String",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    },
    {
      "name": "eureka.server.list-auto-scaling-groups-role-name",
      "type": "java.lang.String",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": "ListAutoScalingGroups"
    },
    {
      "name": "eureka.server.log-identity-headers",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.server.max-elements-in-peer-replication-pool",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 10000
    },
    {
      "name": "eureka.server.max-elements-in-status-replication-pool",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 10000
    },
    {
      "name": "eureka.server.max-idle-thread-age-in-minutes-for-peer-replication",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 15
    },
    {
      "name": "eureka.server.max-idle-thread-in-minutes-age-for-status-replication",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 10
    },
    {
      "name": "eureka.server.max-threads-for-peer-replication",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 20
    },
    {
      "name": "eureka.server.max-threads-for-status-replication",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 1
    },
    {
      "name": "eureka.server.max-time-for-replication",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 30000
    },
    {
      "name": "eureka.server.min-threads-for-peer-replication",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 5
    },
    {
      "name": "eureka.server.min-threads-for-status-replication",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 1
    },
    {
      "name": "eureka.server.number-of-replication-retries",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 5
    },
    {
      "name": "eureka.server.peer-eureka-nodes-update-interval-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.peer-eureka-status-refresh-time-interval-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.peer-node-connect-timeout-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 200
    },
    {
      "name": "eureka.server.peer-node-connection-idle-timeout-seconds",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 30
    },
    {
      "name": "eureka.server.peer-node-read-timeout-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 200
    },
    {
      "name": "eureka.server.peer-node-total-connections",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 1000
    },
    {
      "name": "eureka.server.peer-node-total-connections-per-host",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 500
    },
    {
      "name": "eureka.server.prime-aws-replica-connections",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.server.property-resolver",
      "type": "org.springframework.core.env.PropertyResolver",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    },
    {
      "name": "eureka.server.rate-limiter-burst-size",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 10
    },
    {
      "name": "eureka.server.rate-limiter-enabled",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.server.rate-limiter-full-fetch-average-rate",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 100
    },
    {
      "name": "eureka.server.rate-limiter-privileged-clients",
      "type": "java.util.Set&lt;java.lang.String&gt;",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    },
    {
      "name": "eureka.server.rate-limiter-registry-fetch-average-rate",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 500
    },
    {
      "name": "eureka.server.rate-limiter-throttle-standard-clients",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": false
    },
    {
      "name": "eureka.server.registry-sync-retries",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.registry-sync-retry-wait-ms",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.remote-region-app-whitelist",
      "type": "java.util.Map&lt;java.lang.String,java.util.Set&lt;java.lang.String&gt;&gt;",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    },
    {
      "name": "eureka.server.remote-region-connect-timeout-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 1000
    },
    {
      "name": "eureka.server.remote-region-connection-idle-timeout-seconds",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 30
    },
    {
      "name": "eureka.server.remote-region-fetch-thread-pool-size",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 20
    },
    {
      "name": "eureka.server.remote-region-read-timeout-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 1000
    },
    {
      "name": "eureka.server.remote-region-registry-fetch-interval",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 30
    },
    {
      "name": "eureka.server.remote-region-total-connections",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 1000
    },
    {
      "name": "eureka.server.remote-region-total-connections-per-host",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 500
    },
    {
      "name": "eureka.server.remote-region-trust-store",
      "type": "java.lang.String",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": ""
    },
    {
      "name": "eureka.server.remote-region-trust-store-password",
      "type": "java.lang.String",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": "changeit"
    },
    {
      "name": "eureka.server.remote-region-urls",
      "type": "java.lang.String[]",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    },
    {
      "name": "eureka.server.remote-region-urls-with-name",
      "type": "java.util.Map&lt;java.lang.String,java.lang.String&gt;",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    },
    {
      "name": "eureka.server.renewal-percent-threshold",
      "type": "java.lang.Double",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0.85
    },
    {
      "name": "eureka.server.renewal-threshold-update-interval-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.response-cache-auto-expiration-in-seconds",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 180
    },
    {
      "name": "eureka.server.response-cache-update-interval-ms",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.retention-time-in-m-s-in-delta-queue",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.route53-bind-rebind-retries",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 3
    },
    {
      "name": "eureka.server.route53-binding-retry-interval-ms",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.route53-domain-t-t-l",
      "type": "java.lang.Long",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 30
    },
    {
      "name": "eureka.server.sync-when-timestamp-differs",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.server.use-read-only-response-cache",
      "type": "java.lang.Boolean",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": true
    },
    {
      "name": "eureka.server.wait-time-in-ms-when-sync-empty",
      "type": "java.lang.Integer",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean",
      "defaultValue": 0
    },
    {
      "name": "eureka.server.xml-codec-name",
      "type": "java.lang.String",
      "sourceType": "org.springframework.cloud.netflix.eureka.server.EurekaServerConfigBean"
    }
  ],
  "hints": []
}
```
