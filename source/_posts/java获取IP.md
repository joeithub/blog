title: java获取IP
author: Joe Tong
tags:
  - JAVAEE 
categories:  
  - IT
date: 2020-02-28 15:34:43
---

2.NetworkInterface.getNetworkInterfaces();可以获取本地所有的ip地址，如docker服务相关的ip等。
//all ip
```
Enumeration<NetworkInterface> n = NetworkInterface.getNetworkInterfaces();
for (; n.hasMoreElements(); ) {
    NetworkInterface e = n.nextElement();
    System.out.println("Interface: " + e.getName());
    Enumeration<InetAddress> a = e.getInetAddresses();
    for (; a.hasMoreElements(); ) {
        InetAddress addr = a.nextElement();
        System.out.println("  " + addr.getHostAddress());
    }
}
```


过滤回环网卡、点对点网卡、非活动网卡、虚拟网卡并要求网卡名字是eth或ens开头；再过滤回环地址，并要求是内网地址（非外网）
```
public static List<Inet4Address> getLocalIp4AddressFromNetworkInterface() throws SocketException {
    List<Inet4Address> addresses = new ArrayList<>(1);
    Enumeration e = NetworkInterface.getNetworkInterfaces();
    if (e == null) {
        return addresses;
    }
    while (e.hasMoreElements()) {
        NetworkInterface n = (NetworkInterface) e.nextElement();
        if (!isValidInterface(n)) {
            continue;
        }
        Enumeration ee = n.getInetAddresses();
        while (ee.hasMoreElements()) {
            InetAddress i = (InetAddress) ee.nextElement();
            if (isValidAddress(i)) {
                addresses.add((Inet4Address) i);
            }
        }
    }
    return addresses;
}

/**
 * 过滤回环网卡、点对点网卡、非活动网卡、虚拟网卡并要求网卡名字是eth或ens开头
 *
 * @param ni 网卡
 * @return 如果满足要求则true，否则false
 */
private static boolean isValidInterface(NetworkInterface ni) throws SocketException {
    return !ni.isLoopback() && !ni.isPointToPoint() && ni.isUp() && !ni.isVirtual()
            && (ni.getName().startsWith("eth") || ni.getName().startsWith("ens"));
}

/**
 * 判断是否是IPv4，并且内网地址并过滤回环地址.
 */
private static boolean isValidAddress(InetAddress address) {
    return address instanceof Inet4Address && address.isSiteLocalAddress() && !address.isLoopbackAddress();
}
```

3.通过建立UDP连接，让系统通过路由表自己选择一个主要的ip地址的方式。来获取ip地址
```
try(final DatagramSocket socket = new DatagramSocket()){
  socket.connect(InetAddress.getByName("8.8.8.8"), 10002);
  ip = socket.getLocalAddress().getHostAddress();
}
```

另一种写法
```
private static Optional<Inet4Address> getIpBySocket() throws SocketException {
    try (final DatagramSocket socket = new DatagramSocket()) {
        socket.connect(InetAddress.getByName("8.8.8.8"), 10002);
        if (socket.getLocalAddress() instanceof Inet4Address) {
            return Optional.of((Inet4Address) socket.getLocalAddress());
        }
    } catch (UnknownHostException e) {
        throw new RuntimeException(e);
    }
    return Optional.empty();
}
```

