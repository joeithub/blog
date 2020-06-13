title: bazel
author: Joe Tong
tags:
  - JAVAEE
  - BAZEL
categories:
  - IT
date: 2019-07-18 19:48:00
---
bazel   
演变一: Carthage   
将整个工程拆分成多个仓库.每个仓库都是一个Framework.  
每个小组维护一个仓库.  
每个小组也只需关心这一个仓库.对其他仓库的依赖都用二进制依赖.  
大大加快编译速度.  
代表工具: Carthage.  
演变二: bazel  
不把每个库拆分成小仓库了.  
所有库都在一个Git仓库中.  
通过bazel拆分成多个package.  
每个package的编译缓存都是独立的.  
解决了编译过慢的问题.  
虽然在同一个大仓库里.  
但是每组各自维护自己的package.  
所以不会导致不同组之间的git冲突  

bazel :  
解决了编译过慢问题  
解决了库之间依赖问题  
解决了多人协作导致的git冲突  

安装  
安装过程请参考: http://bazel.io/docs/install.html  
使用工作区（workspace）  
所有的Bazel构建都是基于一个 工作区（workspace） 概念，它是文件系统中一个保存了全部源代码的目录，同时还将包含一些构建后的输出目录的符号链接（例如：bazel-bin和 bazel-out 等输出目录）。工作区目录可以随意放在哪里，但是工作区的根目录必须包含一个名为 WORKSPACE 的工作区配置文件。工作区配置文件可以是一个空文件，也可以包含引用外部构建输出所需的 依赖关系。  
在一个工作区内，可以根据需要共享多个项目。为了简单，我们先从只有一个项目的工作区开始介绍。  
先假设你已经有了一个项目，对应 ~/gitroot/my-project/ 目录。我们先创建一个空的 ~/gitroot/my-project/WORKSPACE 工作区配置文件，用于表示这是Bazel项目对应的根目录。  
创建自己的Build构建文件  
使用下面的命令创建一个简单的Java项目：  
$ # If you're not already there, move to your workspace directory.  
$ cd ~/gitroot/my-project  
$ mkdir -p src/main/java/com/example  
$ cat &gt; src/main/java/com/example/ProjectRunner.java &lt;&lt;EOF
package com.example;  

public class ProjectRunner {  
public static void main(String args[]) {  
Greeting.sayHi();  
}  
}  
EOF  
$ cat &gt; src/main/java/com/example/Greeting.java &lt;&lt;EOF  
package com.example;  

public class Greeting {   
public static void sayHi() {  
System.out.println("Hi!");  
}  
}  
EOF  

Bazel通过工作区中所有名为 BUILD 的文件来解析需要构建的项目信息，因此，我们需要先在 ~/gitroot/my-project 目录创建一个 BUILD 构建文件。下面是BUILD构建文件的内容：  
#### ~/gitroot/my-project/BUILD
```
java_binary(
name = "my-runner",
srcs = glob(["**/*.java"]),
main_class = "com.example.ProjectRunner",
)
```
BUILD文件采用类似Python的语法。虽然不能包含任意的Python语法，但是BUILD文件中的每个构建规则看起来都象是一个Python函数调用，而且你也可以用 "#" 开头来添加单行注释。
java_binary 是一个构建规则。其中 name 对应一个构建目标的标识符，可用用它来向Bazel指定构建哪个项目。srcs 对应一个源文件列表，Bazel需要将这些源文件编译为二进制文件。其中 glob(["**/*.java"]) 表示递归包含每个子目录中以每个 .java 为后缀名的文件。com.example.ProjectRunner 指定包含main方法的类。

现在可以用下面的命令构建这个Java程序了：
```
$ cd ~/gitroot/my-project
$ bazel build //:my-runner
INFO: Found 1 target...
Target //:my-runner up-to-date:
bazel-bin/my-runner.jar
bazel-bin/my-runner
INFO: Elapsed time: 1.021s, Critical Path: 0.83s
$ bazel-bin/my-runner
Hi!
```
恭喜，你已经成功构建了第一个Bazel项目了！
添加依赖关系
对于小项目创建一个规则是可以的，但是随着项目的变大，则需要分别构建项目的不同的部件，最终再组装成产品。这种构建方式可以避免因为局部细小的修改儿导致重现构建整个应用，同时不同的构建步骤可以很好地并发执行以提高构建效率。
我们现在将一个项目拆分为两个部分独立构建，同时设置它们之间的依赖关系。基于上面的例子，我们重写了BUILD构建文件：
```
java_binary(
name = "my-other-runner",
srcs = ["src/main/java/com/example/ProjectRunner.java"],
main_class = "com.example.ProjectRunner",
deps = [":greeter"],
)

java_library(
name = "greeter",
srcs = ["src/main/java/com/example/Greeting.java"],
)
```
虽然源文件是一样的，但是现在Bazel将采用不同的方式来构建：首先是构建 greeter库，然后是构建 my-other-runner。可以在构建成功后立刻运行 //:my-other-runner：
```
$ bazel run //:my-other-runner
INFO: Found 1 target...
Target //:my-other-runner up-to-date:
bazel-bin/my-other-runner.jar
bazel-bin/my-other-runner
INFO: Elapsed time: 2.454s, Critical Path: 1.58s

INFO: Running command line: bazel-bin/my-other-runner
Hi!
```
现在如果你改动ProjectRunner.java代码并重新构建my-other-runner目标，Greeting.java文件因为没有变化而不会重现编译。
使用多个包（Packages）
对于更大的项目，我们通常需要将它们拆分到多个目录中。你可以用类似//path/to/directory:target-name的名字引用在其他BUILD文件定义的目标。假设src/main/java/com/example/有一个cmdline/子目录，包含下面的文件：
```
$ mkdir -p src/main/java/com/example/cmdline
$ cat &gt; src/main/java/com/example/cmdline/Runner.java &lt;&lt;EOF
package com.example.cmdline;

import com.example.Greeting;

public class Runner {
public static void main(String args[]) {
Greeting.sayHi();
}
}
EOF
```
Runner.java依赖com.example.Greeting，因此我们需要在src/main/java/com/example/cmdline/BUILD构建文件中添加相应的依赖规则：  

##### ~/gitroot/my-project/src/main/java/com/example/cmdline/BUILD
```
java_binary(
name = "runner",
srcs = ["Runner.java"],
main_class = "com.example.cmdline.Runner",
deps = ["//:greeter"]
)
```
然而，默认情况下构建目标都是 私有 的。也就是说，我们只能在同一个BUILD文件中被引用。这可以避免将很多实现的细节暴漏给公共的接口，但是也意味着我们需要手工允许runner所依赖的//:greeter目标。就是类似下面这个在构建runner目标时遇到的错误：  
```
$ bazel build //src/main/java/com/example/cmdline:runner
ERROR: /home/user/gitroot/my-project/src/main/java/com/example/cmdline/BUILD:2:1:
Target '//:greeter' is not visible from target '//src/main/java/com/example/cmdline:runner'.
Check the visibility declaration of the former target if you think the dependency is legitimate.
ERROR: Analysis of target '//src/main/java/com/example/cmdline:runner' failed; build aborted.
INFO: Elapsed time: 0.091s
```
可用通过在BUILD文件增加visibility = level属性来改变目标的可间范围。下面是通过在~/gitroot/my-project/BUILD文件增加可见规则，来改变greeter目标的可见范围：
```
java_library(
name = "greeter",
srcs = ["src/main/java/com/example/Greeting.java"],
visibility = ["//src/main/java/com/example/cmdline:__pkg__"],
)
```
这个规则表示//:greeter目标对于//src/main/java/com/example/cmdline包是可见的。现在我们可以重新构建runner目标程序：
```
$ bazel run //src/main/java/com/example/cmdline:runner
INFO: Found 1 target...
Target //src/main/java/com/example/cmdline:runner up-to-date:
bazel-bin/src/main/java/com/example/cmdline/runner.jar
bazel-bin/src/main/java/com/example/cmdline/runner
INFO: Elapsed time: 1.576s, Critical Path: 0.81s
INFO: Running command line: bazel-bin/src/main/java/com/example/cmdline/runner
Hi!
```

参考文档 中有可见性配置说明。
部署
如果你查看 bazel-bin/src/main/java/com/example/cmdline/runner.jar 的内容，可以看到里面只包含了Runner.class，并没有保护所依赖的Greeting.class：
```
$ jar tf bazel-bin/src/main/java/com/example/cmdline/runner.jar
META-INF/
META-INF/MANIFEST.MF
com/
com/example/
com/example/cmdline/
com/example/cmdline/Runner.class
```

这只能在本机正常工作（因为Bazel的runner脚本已经将greeter jar添加到了classpath），但是如果将runner.jar单独复制到另一台机器上讲不能正常运行。如果想要构建可用于部署发布的自包含所有依赖的目标，可以构建runner_deploy.jar目标（类似&lt;target-name&gt;_deploy.jar以_deploy为后缀的名字对应可部署目标）。
```
$ bazel build //src/main/java/com/example/cmdline:runner_deploy.jar
INFO: Found 1 target...
Target //src/main/java/com/example/cmdline:runner_deploy.jar up-to-date:
bazel-bin/src/main/java/com/example/cmdline/runner_deploy.jar
INFO: Elapsed time: 1.700s, Critical Path: 0.23s
```
win环境下 Bazel 离线安装教程  
对于bazel谷歌的开发脚手架，发现用windows系统下powershell下载速度特别慢，在刨坑过程中发现了一种捷径，就是离线安装，接下来将简单介绍离线安装过程  
1、安装choco
cmd安装指令：  
```@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" &amp;&amp; SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"``` 
powershell安装指令：  
```Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))```  
特别说明：一定注意都是在管理员用户权限下打开cmd或者是powershell 这里推荐win10系统下使用powershell，如图所示，右键开始菜单打开管理员用户下的powershell：  
2、通过powershell安装bazel  
2.1、输入指令：  
`choco install bazel`  

&lt;hr/&gt;  
离线安装  
从官网上下载目前最新的bazel压缩包  
先运行choco install bazel指令  
如图所示等待选择阶段，这个时候不要打y 或者 n，让命令行停留于此:  
![upload successful](/images/pasted-9.png)    
在命令行停留之际，修改C:\ProgramData\chocolatey\lib\bazel\tools目录下的params.txt文件内容，将网络版本指定地址修改为本地地址  
修改之前的：  
``` 
https://github.com/bazelbuild/bazel/releases/download/0.12.0/bazel-0.12.0-windows-x86_64.zip

// 此处是文件哈希，禁止修改，原来系统给予是怎样的就是怎样的。
86f84e2c870ed14e4d2e599c309614298b9e08a049657e860d218d56873111bc    
```
修改之后的： 【由于我这里直接下载到桌面上，所以指向桌面地址，如果下载到其他位置，请将绝对地址替换，请勿复制粘贴此段】    
```
C:/Users/ke_li/Desktop/bazel-0.12.0-windows-x86_64.zip

// 此处是文件哈希，禁止修改，仅修改了上面文件目录，下面未修改，注意保留哈希的意思
86f84e2c870ed14e4d2e599c309614298b9e08a049657e860d218d56873111bc
```
接下来输入y，回车进行下一阶段，等待一段时间后，结果：

![upload successful](/images/pasted-10.png)


可调试bazel，在命令行输入bazel 检查安装是否成功，如图所示即为成功安装

![upload successful](/images/pasted-11.png)

