title: OSGI Command
author: Joe Tong
tags:
  - JAVAEE
  - OSGI
categories:
  - IT
date: 2019-07-27 10:48:00
---
OSGI中Command -控制台命令

在OSGI的中开发bundle，在Karaf容器中加载bundle后，往往需要获取bundle处理的中间信息，用于调试、故障定位等。而org.apache.karaf.shell.console提供一种可以以控制台命令的方式介入bundle。提供一种在运行时，以命令触发原代码中的逻辑功能。

![upload successful](/images/pasted-53.png)  
具体开发，与开发bundle过程一样，有几点需要注意：

1、@Command @Option @Argument 的使用，父类OsgiCommandSupport和重载方法doExecute

2、pom中的build的plugin需要增加maven-scr-plugin

3、pom的build的maven-bundle-plugin显示Import org.apache.karaf.shell.*

```
package com.zte.sdn.oscp.yang.adapter;
 
import org.apache.karaf.shell.commands.Argument;
import org.apache.karaf.shell.commands.Command;
import org.apache.karaf.shell.commands.Option;
import org.apache.karaf.shell.console.OsgiCommandSupport;
 
/**
 * Created by sunquan on 2017/10/20.
 */
@Command(scope = "livio", name = "example", description = "livio exmaple command")
public class ExampleCommand extends OsgiCommandSupport {
    @Option(name = "-n",
            aliases = {"--Name"},
            description = "Show the information of specific shard module",
            required = false,
            multiValued = false)
    private String shardModuleName = "";
 
    @Argument(index = 0, name = "command",
            description = "[help]",
            required = true, multiValued = false)
    private String command = "help";
 
    @Override
    protected Object doExecute() throws Exception {
        if (!shardModuleName.isEmpty()) {
            System.out.println("Name:" + shardModuleName);
        }
        switch (command) {
            case "help":
                session.getConsole().println("help command output");
                break;
            case "print":
                session.getConsole().println("print command output");
                break;
            default:
                break;
        }
        return null;
    }
}

```
其中multiValued为false，command字段则为字符串help或print，即输入命令中字面量
但如果为true,表示该参数可以配置多个值command字段，会自动加上[],并以逗号分隔。如livio:example print help  则command字段为[print,help]
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
 
    <groupId>com.zte.sunquan.demo</groupId>
    <artifactId>yang-adapter</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>bundle</packaging>
 
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
 
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
        </dependency>
        <!--<dependency>-->
            <!--<groupId>com.zte.sunquan.demo</groupId>-->
            <!--<artifactId>yang-middle</artifactId>-->
            <!--<version>1.0-SNAPSHOT</version>-->
        <!--</dependency>-->
        <dependency>
            <groupId>org.osgi</groupId>
            <artifactId>org.osgi.compendium</artifactId>
            <version>5.0.0</version>
        </dependency>
        <dependency>
            <groupId>org.osgi</groupId>
            <artifactId>org.osgi.core</artifactId>
            <version>5.0.0</version>
        </dependency>
        <dependency>
            <groupId>org.apache.felix</groupId>
            <artifactId>org.apache.felix.scr</artifactId>
            <version>1.8.2</version>
        </dependency>
        <dependency>
            <groupId>org.apache.felix</groupId>
            <artifactId>org.apache.felix.scr.annotations</artifactId>
            <version>1.9.12</version>
        </dependency>
        <dependency>
            <groupId>org.apache.karaf.shell</groupId>
            <artifactId>org.apache.karaf.shell.console</artifactId>
            <version>3.0.5</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>com.zte.sunquan.demo</groupId>
            <artifactId>yang-admodel</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>2.5.1</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.felix</groupId>
                <artifactId>maven-bundle-plugin</artifactId>
                <version>3.0.1</version>
                <extensions>true</extensions>
                <configuration>
                    <instructions>
                        <Bundle-ManifestVersion>2</Bundle-ManifestVersion>
                        <Bundle-Name>${project.description}</Bundle-Name>
                        <Bundle-SymbolicName>${project.groupId}.${project.artifactId}</Bundle-SymbolicName>
                        <Bundle-Version>${project.version}</Bundle-Version>
                        <Bundle-Vendor>${project.groupId}</Bundle-Vendor>
                        <Import-Package>
                            !com.zte.sdn.oscp.commons.serialize.binary.protostuff*,
                            org.apache.karaf.shell.*,
                            com.zte.sdn.oscp.yang.gen.v1.ip.device.rev20170324.*,
                            com.zte.sdn.oscp.yang.gen.v1.ip.device.rev20170324.NetconfState.*,
                        *</Import-Package>
                        <!--<Private-Package></Private-Package>-->
                        <!--<Embed-Dependecy></Embed-Dependecy>-->
                    </instructions>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.felix</groupId>
                <artifactId>maven-scr-plugin</artifactId>
                <version>1.21.0</version>
                <executions>
                    <execution>
                        <id>generate-scr-scrdescriptor</id>
                        <goals>
                            <goal>scr</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>

```
在reources/OSGI-INF/blueprint目录中增加文件shell-config.xml并输入
```
<blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0">
 
    <command-bundle xmlns="http://karaf.apache.org/xmlns/shell/v1.1.0">
        <command>
            <action class="com.zte.sdn.oscp.yang.adapter.ExampleCommand"/>
        </command>
    </command-bundle>
 
</blueprint>
```

