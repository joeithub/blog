title: java获取本机ip
author: Joe Tong
tags:
  - JAVAEE
categories:  
  - IT
date: 2019-10-24 10:08:59
---

获取localhost不一定对

```
 private String  localHost() {
        String ip = "";
        try {
            Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();
            while (networkInterfaces.hasMoreElements()) {
                NetworkInterface ni = networkInterfaces.nextElement();
                Enumeration<InetAddress> nias = ni.getInetAddresses();
                while (nias.hasMoreElements()) {
                    InetAddress ia = nias.nextElement();
                    if (!ia.isLinkLocalAddress() && !ia.isLoopbackAddress() && ia instanceof Inet4Address) {
                        ip =ia.toString().split("/")[1];
                    }
                }
            }
        } catch (SocketException e) {
            LOGGER.error("控制器ip地址获取UnknownHostException异常：", e);
        }
        return ip;
    }
```
