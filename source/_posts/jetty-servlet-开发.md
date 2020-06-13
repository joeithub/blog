title: jetty servlet 开发
author: Joe Tong
tags:
  - JAVAEE
  - JETTY
  - SERVLET
categories:
  - IT
date: 2019-08-08 15:02:00
---
Jetty开发指导：Jetty Websocket API
Jetty WebSocket API使用
Jetty提供了功能更强的WebSocket API，使用一个公共的核心API供WebSockets的服务端和客户端使用。
他是一个基于WebSocket消息的事件驱动的API。

WebSocket事件
每个WebSocket都能接收多种事件：

On Connect Event

表示WebSocket升级成功，WebSocket现在打开。
你将收到一个org.eclipse.jetty.websocket.api.Session对象，对应这个Open事件的session。
为通常的WebSocket，应该紧紧抓住这个Session，并使用它与Remote Endpoint进行交流。
如果为无状态（Stateless）WebSockets，这个Session将被传递到它出现的每一个事件，允许你使用一个WebSocket的1个实例为多个Remote Endpoint提供服务。

On Close Event

表示WebSocket已经关闭。
每个Close事件将有一个状态码（Status Code）（和一个可选的Closure Reason Message）。
一个通常的WebSocket终止将经历一个关闭握手，Local Endpoint和Remote Endpoint都会发送一个Close帧表示连接被关闭。
本地WebSocket可以通过发送一个Close帧到Remote Endpoint表示希望关闭，但是Remote Endpoint能继续发送信息直到它送一个Close帧为止。这被称之为半开（Half-Open）连接，注意一旦Local Endpoint发送了Close帧后，它将不能再发送任何WebSocket信息。
在一个异常的终止中，例如一个连接断开或者超时，底层连接将不经历Close Handshake就被终止，这也将导致一个On Close Event（和可能伴随一个On Error Event）。

On Error Event

如果一个错误出现，在实现期间，WebSocket将通过这个事件被通知。

On Message Event

表示一个完整的信息被收到，准备被你的WebSocket处理。
这能是一个（UTF8）TEXT信息或者一个原始的BINARY信息。

WebSocket Session
Session对象能被用于：

获取WebSocket的状态
连接状态（打开或者关闭）

```

if(session.isOpen()) {
  // send message
}

```
连接是安全的吗。

```
if(session.isSecure()) {
  // connection is using 'wss://'
}

```
在升级请求和响应中的是什么。

```
UpgradeRequest req = session.getUpgradeRequest();
String channelName = req.getParameterMap().get("channelName");
 
UpgradeRespons resp = session.getUpgradeResponse();
String subprotocol = resp.getAcceptedSubProtocol();

```
本地和远端地址是什么。

`InetSocketAddress remoteAddr = session.getRemoteAddress();`

配置策略
获取和设置空闲超时时间。

`session.setIdleTimeout(2000); // 2 second timeout`

获取和设置最大信息长度。

`session.setMaximumMessageSize(64*1024); // accept messages up to 64k, fail if larger`

发送信息到Remote Endpoint

Session的最重要的特征是获取org.eclipse.jetty.websocket.api.RemoteEndpoint。

使用RemoteEndpoint，你能选择发送TEXT或者BINARY Websocket信息，或者WebSocket PING和PONG控制帧。

```
实例1 发送二进制信息（阻塞）
RemoteEndpoint remote = session.getRemote();
 
// Blocking Send of a BINARY message to remote endpoint
ByteBuffer buf = ByteBuffer.wrap(new byte[] { 0x11, 0x22, 0x33, 0x44 });
try
{
    remote.sendBytes(buf);
}
catch (IOException e)
{
    e.printStackTrace(System.err);
}

```
怎么使用RemoteEndpoint送一个简单的二进制信息。这将阻塞直到信息被发送完成，如果不能发送信息可能将抛出一个IOException。

```
实例2 发送文本信息（阻塞）
RemoteEndpoint remote = session.getRemote();
 
// Blocking Send of a TEXT message to remote endpoint

try
{
    remote.sendString("Hello World");
}
catch (IOException e)
{
    e.printStackTrace(System.err);
}

```
怎么使用RemoteEndpoint发送文本信息。这将阻塞直到信息发送，如果不能发送信息可能将抛出一个IOException。

发送部分信息
如果你有一个大的信息需要被发送，并且想分多次发送，每次一部分，你能使用RemoteEndpoint发送部分信息的方法。仅需要确保你最后发送一个完成发送的信息（isLast == true）

```
实例3 发送部分二进制信息（阻塞）
RemoteEndpoint remote = session.getRemote();
 
// Blocking Send of a BINARY message to remote endpoint
// Part 1
ByteBuffer buf1 = ByteBuffer.wrap(new byte[] { 0x11, 0x22 });
// Part 2 (last part)
ByteBuffer buf2 = ByteBuffer.wrap(new byte[] { 0x33, 0x44 });
try
{
    remote.sendPartialBytes(buf1,false);
    remote.sendPartialBytes(buf2,true); // isLast is true
}
catch (IOException e)
{
    e.printStackTrace(System.err);
}

```
怎么分两次发送一个二进制信息，使用在RemoteEndpoint中的部分信息支持方法。这将阻塞直到每次信息发送完成，如果不能发送信息可能抛出一个IOException。

```
实例4 发送部分文本信息（阻塞）
RemoteEndpoint remote = session.getRemote();
 
// Blocking Send of a TEXT message to remote endpoint
String part1 = "Hello";
String part2 = " World";
try
{
    remote.sendPartialString(part1,false);
    remote.sendPartialString(part2,true); // last part
}
catch (IOException e)
{
    e.printStackTrace(System.err);

}

```

怎么通过两次发送一个文本信息，使用在RemoteEndpoint中的部分信息支持方法。这将阻塞直到每次信息发送完成，如果不能发送信息可能抛出一个IOException。

发送Ping/Pong控制帧
你也能使用RemoteEndpoint发送Ping和Pong控制帧。
```
实例5 发送Ping控制帧（阻塞）
RemoteEndpoint remote = session.getRemote();
 
// Blocking Send of a PING to remote endpoint
String data = "You There?";
ByteBuffer payload = ByteBuffer.wrap(data.getBytes());
try
{
    remote.sendPing(payload);
}
catch (IOException e)
{
    e.printStackTrace(System.err);
}

```
怎么发送一个Ping控制帧，附带一个负载“You There?”（作为一个字节数组负载到达Remote Endpoint）。这将阻塞直到信息发送完成，如果不能发送Ping帧，可能抛出一个IOException。

```
实例6 送Pong控制帧（阻塞）
RemoteEndpoint remote = session.getRemote();
 
// Blocking Send of a PONG to remote endpoint
String data = "Yup, I'm here";
ByteBuffer payload = ByteBuffer.wrap(data.getBytes());
try
{
    remote.sendPong(payload);
}
catch (IOException e)
{
    e.printStackTrace(System.err);

}

```
怎么发送一个Pong控制帧，附带一个"Yup I'm here"负载（作为一个字节数组负载到达Remote Endpoint）。这将阻塞直到信息被发送，如果不能发送Pong帧，可能抛出一个IOException。
为了正确的使用Pong帧，你应该返回你在Ping帧中收到的同样的字节数组数据。

异步发送信息
也存在来年改革异步发送信息的方法可用：
1）RemoteEndpoint.sendBytesByFuture（字节信息）
2）RemoteEndpoint.sendStringByFuture（字符串信息）
两个方法都返回一个Future&lt;Void&gt;，使用标准java.util.concurrent.Future行为，能被用于测试信息发送的成功和失败。

```
实例7 送二进制信息（异步）
RemoteEndpoint remote = session.getRemote();
 
// Async Send of a BINARY message to remote endpoint
ByteBuffer buf = ByteBuffer.wrap(new byte[] { 0x11, 0x22, 0x33, 0x44 });
remote.sendBytesByFuture(buf);
```
怎么使用RemoteEndpoint发送一个简单的二进制信息。这个信息将被放入发送队列，你将不知道发送成功或者失败。

```
实例8 发送二进制信息（异步，等待直到成功）
RemoteEndpoint remote = session.getRemote();
 
// Async Send of a BINARY message to remote endpoint
ByteBuffer buf = ByteBuffer.wrap(new byte[] { 0x11, 0x22, 0x33, 0x44 });
try
{
    Future&lt;Void&gt; fut = remote.sendBytesByFuture(buf);
    // wait for completion (forever)
    fut.get();
}
catch (ExecutionException | InterruptedException e)
{
    // Send failed
    e.printStackTrace();

}

```
怎么使用RemoteEndpoint发送一个简单的二进制信息，追踪Future&lt;Void&gt;以确定发送成功还是失败。

```
实例9 送二进制信息（异步，发送超时）
RemoteEndpoint remote = session.getRemote();
 
// Async Send of a BINARY message to remote endpoint
ByteBuffer buf = ByteBuffer.wrap(new byte[] { 0x11, 0x22, 0x33, 0x44 });
Future&lt;Void&gt; fut = null;
try
{
    fut = remote.sendBytesByFuture(buf);
    // wait for completion (timeout)
    fut.get(2,TimeUnit.SECONDS);
}
catch (ExecutionException | InterruptedException e)
{
    // Send failed
    e.printStackTrace();
}
catch (TimeoutException e)
{
    // timeout
    e.printStackTrace();
    if (fut != null)
    {
        // cancel the message
        fut.cancel(true);
    }

}

```
怎么使用RemoteEndpoint发送一个简单的二进制信息，追踪Future&lt;Void&gt;并等待一个有限的时间，如果时间超限则取消该信息。

```
实例10 发送文本信息（异步）
RemoteEndpoint remote = session.getRemote();
 
// Async Send of a TEXT message to remote endpoint
remote.sendStringByFuture("Hello World");
 
怎么使用RemoteEndpoint发送一个简单的文本信息。这个信息将被放到输出队列中，但是你将不知道发送成功还是失败。
 
实例11 发送文本信息（异步，等待直到成功）
RemoteEndpoint remote = session.getRemote();
 
// Async Send of a TEXT message to remote endpoint
try
{
    Future&lt;Void&gt; fut = remote.sendStringByFuture("Hello World");
    // wait for completion (forever)
    fut.get();
}
catch (ExecutionException | InterruptedException e)
{
    // Send failed
    e.printStackTrace();

}

```

怎么使用RemoteEndpoint发送一个简单的二进制信息，追踪Future&lt;Void&gt;以直到发送成功还是失败。
```
实例12 发送文本信息（异步，发送超时）
RemoteEndpoint remote = session.getRemote();
 
// Async Send of a TEXT message to remote endpoint
Future&lt;Void&gt; fut = null;
try
{
    fut = remote.sendStringByFuture("Hello World");
    // wait for completion (timeout)
    fut.get(2,TimeUnit.SECONDS);
}
catch (ExecutionException | InterruptedException e)
{
    // Send failed
    e.printStackTrace();
}
catch (TimeoutException e)
{
    // timeout
    e.printStackTrace();
    if (fut != null)
    {
        // cancel the message
        fut.cancel(true);
    }

}

```
怎么使用RemoteEndpoint发送一个简单的二进制信息，追踪Future&lt;Void&gt;并等待有限的时间，如果超时则取消。
使用WebSocket注释
WebSocket的最基本的形式是一个被Jetty WebSocket API提供的用注释标记的POJO。
```
实例13 AnnotatedEchoSocket.java
package examples.echo;
 
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage;
import org.eclipse.jetty.websocket.api.annotations.WebSocket;
 
/**
 * Example EchoSocket using Annotations.
 */
@WebSocket(maxTextMessageSize = 64 * 1024)
public class AnnotatedEchoSocket {
 
    @OnWebSocketMessage
    public void onText(Session session, String message) {
        if (session.isOpen()) {
            System.out.printf("Echoing back message [%s]%n", message);
            session.getRemote().sendString(message, null);
        }
    }
}

```
上面的例子是一个简单的WebSocket回送端点，将回送所有它收到的文本信息。
这个实现使用了一个无状态的方法，因此对每个出现的事件Session都会被传递到Message处理方法中。这将允许你在同多个端口交互时可以重用AnnotatedEchoSocket的单实例。
你可用的注释如下：

@WebSocket  

一个必须的类级别的注释。  
标记这个POJO作为一个WebSocket。  
类必须不是abstract，且是public。  

@OnWebSocketConnect  

一个可选的方法级别的注释。  
标记一个在类中的方法作为On Connect事件的接收者。  
方法必须是public，且不是abstract，返回void，并且有且仅有一个Session参数。  

@OnWebSocketClose  
一个可选的方法级的注释。  
标记一个在类中的方法作为On Close事件的接收者。  
方法标签必须是public，不是abstract，并且返回void。  
方法的参数包括：  
1）Session（可选）  
2）int closeCode（必须）  
3）String closeReason（必须）  

@OnWebSocketMessage  
一个可选的方法级注释。  
标记在类中的2个方法作为接收On Message事件的接收者。  
方法标签必须是public，不是abstract，并且返回void。  
为文本信息的方法参数包括：  
1）Session（可选）  
2）String text（必须）  
为二进制信息的方法参数包括：  
1）Session（可选）  
2）byte buf[]（必须）  
3）int offset（必须）   
4）int length（必须）  

@OnWebSocketError  
一个可选的方法级注释。  
标记一个类中的方法作为Error事件的接收者。  
方法标签必须是public，不是abstract，并且返回void。  
方法参数包括：  
1）Session（可选）  
2）Throwable cause（必须）  

@OnWebSocketFrame  
一个可选的方法级注释。  
标记一个类中的方法作为Frame事件的接收者。  
方法标签必须是public，不是abstract，并且返回void。  
方法参数包括：  
1）Session（可选）  
2）Frame（必须）   
收到的Frame将在这个方法上被通知，然后被Jetty处理，可能导致另一个事件，例如On Close，或者On Message。对Frame的改变将不被Jetty看到。

用WebSocketListener  
一个WebSocket的基本形式是使用org.eclipse.jetty.websocket.api.WebSocketListener处理收到的事件。  
```

实例14 ListenerEchoSocket.java
package examples.echo;
 
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.WebSocketListener;
 
/**
 * Example EchoSocket using Listener.
 */
public class ListenerEchoSocket implements WebSocketListener {
 
    private Session outbound;
 
    @Override
    public void onWebSocketBinary(byte[] payload, int offset, int len) {
    }
 
    @Override
    public void onWebSocketClose(int statusCode, String reason) {
        this.outbound = null;
    }
 
    @Override
    public void onWebSocketConnect(Session session) {
        this.outbound = session;
    }
 
    @Override
    public void onWebSocketError(Throwable cause) {
        cause.printStackTrace(System.err);
    }
 
    @Override
    public void onWebSocketText(String message) {
        if ((outbound != null) &amp;&amp; (outbound.isOpen())) {
            System.out.printf("Echoing back message [%s]%n", message);
            outbound.getRemote().sendString(message, null);
        }
    }
}

```
如果listener做了太多的工作，你能使用WebSocketAdapter代替。
使用WebSocketAdapter
WebSocketListener的适配器。

```
实例15 AdapterEchoSocket.java
package examples.echo;
 
import java.io.IOException;
import org.eclipse.jetty.websocket.api.WebSocketAdapter;
 
/**
 * Example EchoSocket using Adapter.
 */
public class AdapterEchoSocket extends WebSocketAdapter {
 
    @Override
    public void onWebSocketText(String message) {
        if (isConnected()) {
            try {
                System.out.printf("Echoing back message [%s]%n", message);
                getRemote().sendString(message);
            } catch (IOException e) {
                e.printStackTrace(System.err);
            }
        }
    }
}
```
这个类比WebSocketListener跟为便利，并提供了有用的方法检查Session的状态。

Jetty WebSocket Server API
Jetty通过WebSocketServlet和servlet桥接的使用，提供了将WebSocket端点到Servlet路径的对应。
内在地，Jetty管理HTTP升级到WebSocket，并且从一个HTTP连接移植到一个WebSocket连接。
这只有当运行在Jetty容器内部时才工作。

Jetty WebSocketServlet
为了通过WebSocketServlet对应你的WebSocket到一个指定的路径，你将需要扩展org.eclipse.jetty.websocket.servlet.WebSocketServlet并指定什么WebSocket对象应该被创建。
```

实例16 MyEchoServlet.java
package examples;
 
import javax.servlet.annotation.WebServlet;
import org.eclipse.jetty.websocket.servlet.WebSocketServlet;
import org.eclipse.jetty.websocket.servlet.WebSocketServletFactory;
 
@SuppressWarnings("serial")
@WebServlet(name = "MyEcho WebSocket Servlet", urlPatterns = { "/echo" })
public class MyEchoServlet extends WebSocketServlet {
 
    @Override
    public void configure(WebSocketServletFactory factory) {
        factory.getPolicy().setIdleTimeout(10000);
        factory.register(MyEchoSocket.class);
    }
}

```

这个例子将创建一个Sevlet，通过@WebServlet注解匹配到Servlet路径"/echo"（或者你能在你的web应用的WEB-INF/web.xml中手动的配置），当收到HTTP升级请求时将创建MyEchoSocket实例。
WebSocketServlet.configure(WebSocketServletFactory factory)是为你的WebSocket指定配置的地方。在这个例子中，我们指定一个10s的空闲超时，并注册MyEchoSocket，即当收到请求时我们想创建的WebSocket类，使用默认的WebSocketCreator创建。

使用WebSocketCreator
所有WebSocket都是通过你注册到WebSocketServletFactory的WebSocketCreator创建的。
默认，WebSocketServletFactory是一个简单的WebSocketCreator，能创建一个单例的WebSocket对象。 使用WebSocketCreator.register(Class&lt;?&gt; websocket)告诉WebSocketServletFactory应该实例化哪个类（确保它有一个默认的构造器）。
如果你有更复杂的创建场景，你可以提供你自己的WebSocketCreator，基于在UpgradeRequest对象中出现的信息创建的WebSocket。


```
实例17 MyAdvancedEchoCreator.java
package examples;
 
import org.eclipse.jetty.websocket.servlet.ServletUpgradeRequest;
import org.eclipse.jetty.websocket.servlet.ServletUpgradeResponse;
import org.eclipse.jetty.websocket.servlet.WebSocketCreator;
 
public class MyAdvancedEchoCreator implements WebSocketCreator {
 
    private MyBinaryEchoSocket binaryEcho;
 
    private MyEchoSocket textEcho;
 
    public MyAdvancedEchoCreator() {
        this.binaryEcho = new MyBinaryEchoSocket();
        this.textEcho = new MyEchoSocket();
    }
 
    @Override
    public Object createWebSocket(ServletUpgradeRequest req, ServletUpgradeResponse resp) {
        for (String subprotocol : req.getSubProtocols()) {
            if ("binary".equals(subprotocol)) {
                resp.setAcceptedSubProtocol(subprotocol);
                return binaryEcho;
            }
            if ("text".equals(subprotocol)) {
                resp.setAcceptedSubProtocol(subprotocol);
                return textEcho;
            }
        }
        return null;
    }
}
```
这儿我们展示了一个WebSocketCreator，将利用来自请求的WebSocket子协议信息决定什么类型的WebSocket应该被创建。
```
实例18 MyAdvancedEchoServlet.java
package examples;
 
import javax.servlet.annotation.WebServlet;
import org.eclipse.jetty.websocket.servlet.WebSocketServlet;
import org.eclipse.jetty.websocket.servlet.WebSocketServletFactory;
 
@SuppressWarnings("serial")
@WebServlet(name = "MyAdvanced Echo WebSocket Servlet", urlPatterns = { "/advecho" })
public class MyAdvancedEchoServlet extends WebSocketServlet {
 
    @Override
    public void configure(WebSocketServletFactory factory) {
        factory.getPolicy().setIdleTimeout(10000);
        factory.setCreator(new MyAdvancedEchoCreator());
    }
}
```
当你想要一个定制的WebSocketCreator时，使用WebSocketServletFactory.setCreator(WebSocketCreator creator)，然后WebSocketServletFactory将为所有在这个servlet上收到的Upgrade请求用你的创造器。
一个WebSocketCreator还可以用于：
1）控制WebSocket子协议的选择；
2）履行任何你认为重要的WebSocket源；
3）从输入的请求获取HTTP头；
4）获取Servlet HttpSession对象（如果它存在）；
5）指定一个响应状态码和原因；
如果你不想接收这个请求，简单的从WebSocketCreator.createWebSocket(UpgradeRequest req, UpgradeResponse resp)返回null。

Jetty WebSocket Client API
Jetty也提供了一个Jetty WebSocket Client库，为了更容易的与WebSocket服务端交互。
为了在你自己的Java项目上使用Jetty WebSocket Client，你将需要下面的maven配置：

```
&lt;dependency&gt;
  &lt;groupId&gt;org.eclipse.jetty.websocket&lt;/groupId&gt;
  &lt;artifactId&gt;websocket-client&lt;/artifactId&gt;
  &lt;version&gt;${project.version}&lt;/version&gt;
&lt;/dependency&gt;

```
WebSocketClient
为了使用WebSocketClient，你将需要连接一个WebSocket对象实例到一个指定的目标WebSocket URI。
```
实例19 SimpleEchoClient.java
package examples;
 
import java.net.URI;
import java.util.concurrent.TimeUnit;
import org.eclipse.jetty.websocket.client.ClientUpgradeRequest;
import org.eclipse.jetty.websocket.client.WebSocketClient;
 
/**
 * Example of a simple Echo Client.
 */
public class SimpleEchoClient {
 
    public static void main(String[] args) {
        String destUri = "ws://echo.websocket.org";
        if (args.length &gt; 0) {
            destUri = args[0];
        }
        WebSocketClient client = new WebSocketClient();
        SimpleEchoSocket socket = new SimpleEchoSocket();
        try {
            client.start();
            URI echoUri = new URI(destUri);
            ClientUpgradeRequest request = new ClientUpgradeRequest();
            client.connect(socket, echoUri, request);
            System.out.printf("Connecting to : %s%n", echoUri);
            socket.awaitClose(5, TimeUnit.SECONDS);
        } catch (Throwable t) {
            t.printStackTrace();
        } finally {
            try {
                client.stop();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

}
```
上面的例子连接到一个远端WebSocket服务端，并且连接后使用一个SimpleEchoSocket履行在websocket上的处理逻辑，等待socket关闭。
```
实例20 SimpleEchoSocket.java
package examples;
 
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.StatusCode;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage;
import org.eclipse.jetty.websocket.api.annotations.WebSocket;
 
/**
 * Basic Echo Client Socket
 */
@WebSocket(maxTextMessageSize = 64 * 1024)
public class SimpleEchoSocket {
 
    private final CountDownLatch closeLatch;
 
    @SuppressWarnings("unused")
    private Session session;
 
    public SimpleEchoSocket() {
        this.closeLatch = new CountDownLatch(1);
    }
 
    public boolean awaitClose(int duration, TimeUnit unit) throws InterruptedException {
        return this.closeLatch.await(duration, unit);
    }
 
    @OnWebSocketClose
    public void onClose(int statusCode, String reason) {
        System.out.printf("Connection closed: %d - %s%n", statusCode, reason);
        this.session = null;
        this.closeLatch.countDown();
    }
 
    @OnWebSocketConnect
    public void onConnect(Session session) {
        System.out.printf("Got connect: %s%n", session);
        this.session = session;
        try {
            Future&lt;Void&gt; fut;
            fut = session.getRemote().sendStringByFuture("Hello");
            fut.get(2, TimeUnit.SECONDS);
            fut = session.getRemote().sendStringByFuture("Thanks for the conversation.");
            fut.get(2, TimeUnit.SECONDS);
            session.close(StatusCode.NORMAL, "I'm done");
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
 
    @OnWebSocketMessage
    public void onMessage(String msg) {
        System.out.printf("Got msg: %s%n", msg);
    }

}

```
当SimpleEchoSocket连接成功后，它发送2个文本信息，然后关闭socket。
onMessage(String msg)收到来自远端WebSocket的响应，并输出他们到控制台。
