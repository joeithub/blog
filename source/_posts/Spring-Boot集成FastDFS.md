title: Spring Boot集成FastDFS
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - 文件服务器
categories:
  - IT
date: 2019-09-27 00:53:00
---
https://blog.csdn.net/qq_756589808/article/details/82882589


1、建立一个springboot的工程，下面的是我的目录结构：


![upload successful](/images/pasted-160.png)

2、pom文件引入依赖：

```
&lt;properties&gt;
        &lt;project.build.sourceEncoding&gt;UTF-8&lt;/project.build.sourceEncoding&gt;
        &lt;project.reporting.outputEncoding&gt;UTF-8&lt;/project.reporting.outputEncoding&gt;
        &lt;java.version&gt;1.8&lt;/java.version&gt;
        &lt;commons-lang3.version&gt;3.3.2&lt;/commons-lang3.version&gt;
    &lt;/properties&gt;
 
    &lt;dependencies&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter&lt;/artifactId&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.projectlombok&lt;/groupId&gt;
            &lt;artifactId&gt;lombok&lt;/artifactId&gt;
            &lt;optional&gt;true&lt;/optional&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-test&lt;/artifactId&gt;
            &lt;scope&gt;test&lt;/scope&gt;
        &lt;/dependency&gt;
 
        &lt;!-- 支持 @ConfigurationProperties 注解 --&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-configuration-processor&lt;/artifactId&gt;
            &lt;optional&gt;true&lt;/optional&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-freemarker&lt;/artifactId&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-amqp&lt;/artifactId&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-data-redis&lt;/artifactId&gt;
            &lt;!-- 1.5的版本默认采用的连接池技术是jedis  2.0以上版本默认连接池是lettuce,
            在这里采用jedis，所以需要排除lettuce的jar --&gt;
            &lt;exclusions&gt;
                &lt;exclusion&gt;
                    &lt;groupId&gt;redis.clients&lt;/groupId&gt;
                    &lt;artifactId&gt;jedis&lt;/artifactId&gt;
                &lt;/exclusion&gt;
                &lt;exclusion&gt;
                    &lt;groupId&gt;io.lettuce&lt;/groupId&gt;
                    &lt;artifactId&gt;lettuce-core&lt;/artifactId&gt;
                &lt;/exclusion&gt;
            &lt;/exclusions&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-redis&lt;/artifactId&gt;
            &lt;version&gt;1.4.1.RELEASE&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;!-- 添加jedis客户端 --&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;redis.clients&lt;/groupId&gt;
            &lt;artifactId&gt;jedis&lt;/artifactId&gt;
        &lt;/dependency&gt;
 
        &lt;!-- https://mvnrepository.com/artifact/ojdbc/ojdbc --&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;com.oracle&lt;/groupId&gt;
            &lt;artifactId&gt;ojdbc6&lt;/artifactId&gt;
            &lt;version&gt;11.2.0.3&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;!-- http://repo1.maven.org/maven2/com/github/pagehelper/pagehelper/--&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;com.github.pagehelper&lt;/groupId&gt;
            &lt;artifactId&gt;pagehelper&lt;/artifactId&gt;
            &lt;version&gt;5.1.4&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;!-- Apache工具组件 --&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.apache.commons&lt;/groupId&gt;
            &lt;artifactId&gt;commons-lang3&lt;/artifactId&gt;
            &lt;version&gt;${commons-lang3.version}&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;!--spring2.0集成redis所需common-pool2--&gt;
        &lt;!-- 必须加上，jedis依赖此  --&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;org.apache.commons&lt;/groupId&gt;
            &lt;artifactId&gt;commons-pool2&lt;/artifactId&gt;
            &lt;version&gt;2.5.0&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-web&lt;/artifactId&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.mybatis.spring.boot&lt;/groupId&gt;
            &lt;artifactId&gt;mybatis-spring-boot-starter&lt;/artifactId&gt;
            &lt;version&gt;1.3.2&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-devtools&lt;/artifactId&gt;
            &lt;scope&gt;runtime&lt;/scope&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;mysql&lt;/groupId&gt;
            &lt;artifactId&gt;mysql-connector-java&lt;/artifactId&gt;
            &lt;scope&gt;runtime&lt;/scope&gt;
        &lt;/dependency&gt;
 
        &lt;!-- alibaba的druid数据库连接池 --&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;com.alibaba&lt;/groupId&gt;
            &lt;artifactId&gt;druid-spring-boot-starter&lt;/artifactId&gt;
            &lt;version&gt;1.1.9&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;!-- 集成fastjson--&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;com.alibaba&lt;/groupId&gt;
            &lt;artifactId&gt;fastjson&lt;/artifactId&gt;
            &lt;version&gt;1.2.47&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;!-- 集成Swagger2形成API文档请求接口--&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;io.springfox&lt;/groupId&gt;
            &lt;artifactId&gt;springfox-swagger2&lt;/artifactId&gt;
            &lt;version&gt;2.7.0&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;io.springfox&lt;/groupId&gt;
            &lt;artifactId&gt;springfox-swagger-ui&lt;/artifactId&gt;
            &lt;version&gt;2.7.0&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;!-- 文件服务器--&gt;
        &lt;dependency&gt;
            &lt;groupId&gt;com.github.tobato&lt;/groupId&gt;
            &lt;artifactId&gt;fastdfs-client&lt;/artifactId&gt;
            &lt;version&gt;1.26.1-RELEASE&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;commons-io&lt;/groupId&gt;
            &lt;artifactId&gt;commons-io&lt;/artifactId&gt;
            &lt;version&gt;2.4&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;commons-codec&lt;/groupId&gt;
            &lt;artifactId&gt;commons-codec&lt;/artifactId&gt;
            &lt;version&gt;1.9&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework&lt;/groupId&gt;
            &lt;artifactId&gt;spring-jdbc&lt;/artifactId&gt;
            &lt;version&gt;4.3.13.RELEASE&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;com.zaxxer&lt;/groupId&gt;
            &lt;artifactId&gt;HikariCP&lt;/artifactId&gt;
            &lt;version&gt;3.2.0&lt;/version&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-quartz&lt;/artifactId&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
            &lt;artifactId&gt;spring-boot-starter-aop&lt;/artifactId&gt;
        &lt;/dependency&gt;
 
        &lt;dependency&gt;
            &lt;groupId&gt;commons-beanutils&lt;/groupId&gt;
            &lt;artifactId&gt;commons-beanutils-core&lt;/artifactId&gt;
            &lt;version&gt;1.8.3&lt;/version&gt;
        &lt;/dependency&gt;
 
    &lt;/dependencies&gt;
```

这个是方便在yml中自定义参数同过@Value的形式注入


![upload successful](/images/pasted-161.png)

这个依赖确保是1.26.1以上的不然SpringBoot2.0集成会报错

![upload successful](/images/pasted-162.png)

按照截图创建包以及建立类：

![upload successful](/images/pasted-163.png)

3、编写FdfsConfig 类

```
package com.saliai.logsystem.common.conf;
 
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
 
/**
 * @author: Martin
 * @Date: 2018/10/12
 * @Description:
 * @Modify By:
 */
@Component
public class FdfsConfig {
    @Value("${fdfs.res-host}")
    private String resHost;
 
    @Value("${fdfs.storage-port}")
    private String storagePort;
 
    public String getResHost() {
        return resHost;
    }
 
    public void setResHost(String resHost) {
        this.resHost = resHost;
    }
 
    public String getStoragePort() {
        return storagePort;
    }
 
    public void setStoragePort(String storagePort) {
        this.storagePort = storagePort;
    }
 
}

```

4、编写 FdfsConfiguration 类


```
package com.saliai.logsystem.common.conf;
 
/**
 * @author: Martin
 * @Date: 2018/10/12
 * @Description:
 * @Modify By:
 */
 
import com.github.tobato.fastdfs.FdfsClientConfig;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableMBeanExport;
import org.springframework.context.annotation.Import;
import org.springframework.jmx.support.RegistrationPolicy;
 
@Configuration
@Import(FdfsClientConfig.class)
@EnableMBeanExport(registration = RegistrationPolicy.IGNORE_EXISTING)
public class FdfsConfiguration {
}
```

5、建立constants包并建立GlobalConstants类

![upload successful](/images/pasted-164.png)

```
package com.saliai.logsystem.common.constants;
 
/**
 * @author: Martin
 * @Date: 2018/10/25
 * @Description:
 * @Modify By:
 */
public class GlobalConstants {
    public final static String HTTP_FILEURL = "http://baihoomall.100healths.cn";
}

```

6、创建截图中的FastDFSClientWrapper类：

```
package com.saliai.logsystem.common.utils;
 
/**
 * @author: Martin
 * @Date: 2018/9/28
 * @Description:
 * @Modify By:
 */
 
import com.github.tobato.fastdfs.domain.StorePath;
import com.github.tobato.fastdfs.exception.FdfsUnsupportStorePathException;
import com.github.tobato.fastdfs.proto.storage.DownloadByteArray;
import com.github.tobato.fastdfs.service.FastFileStorageClient;
import com.saliai.logsystem.common.conf.FdfsConfig;
import com.saliai.logsystem.common.constants.GlobalConstants;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
 
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
 
/**
 * 功能描述: 文件处理类
 *
 * @author Martin
 * @version V1.0
 * @date 2018/10/12
 */
@Component
@Slf4j
public class FastDFSClientWrapper {
 
    @Autowired
    private FastFileStorageClient storageClient;
 
    @Autowired
    private FdfsConfig fdfsConfig;
 
    public String uploadFile(MultipartFile file) throws IOException {
        StorePath storePath = storageClient.uploadFile((InputStream) file.getInputStream(), file.getSize(), FilenameUtils.getExtension(file.getOriginalFilename()), null);
        log.info("storePath:" + storePath);
        return getResAccessUrl(storePath);
    }
 
    /**
     * 封装文件完整URL地址
     *
     * @param storePath
     * @return
     */
    private String getResAccessUrl(StorePath storePath) {
        //GlobalConstants.HTTP_PRODOCOL +
        String fileUrl = GlobalConstants.HTTP_FILEURL + ":" + fdfsConfig.getStoragePort() + "/" + storePath.getFullPath();
        log.info("fileUrl:" + fileUrl);
        return fileUrl;
    }
 
    /**
     * 功能描述: 删除文件
     *
     * @param fileUrl
     * @return void
     * @author Martin
     * @date 2018/10/12
     * @version V1.0
     */
    public void deleteFile(String fileUrl) {
 
        log.info("删除的文件的url:" + fileUrl);
        if (StringUtils.isEmpty(fileUrl)) {
            return;
        }
        try {
            StorePath storePath = StorePath.praseFromUrl(fileUrl);
            log.info("groupName:"+storePath.getGroup()+"------"+"文件路径path："+storePath.getPath());
            storageClient.deleteFile(storePath.getGroup(), storePath.getPath());
        } catch (FdfsUnsupportStorePathException e) {
            log.warn(e.getMessage());
        }
    }
 
    /**
     * 功能描述: 下载文件
     *
     * @param fileUrl
     * @return java.io.InputStream
     * @author Martin
     * @date 2018/10/12
     * @version V1.0
     */
    public InputStream downFile(String fileUrl) {
        try {
            StorePath storePath = StorePath.praseFromUrl(fileUrl);
            byte[] fileByte = storageClient.downloadFile(storePath.getGroup(), storePath.getPath(), new DownloadByteArray());
            InputStream ins = new ByteArrayInputStream(fileByte);
            return ins;
        } catch (Exception e) {
            log.error("Non IO Exception: Get File from Fast DFS failed", e);
        }
        return null;
    }
}

```

7、接下来编写controller进行测试

```
package com.saliai.logsystem.controller;
 
import com.saliai.logsystem.common.utils.FastDFSClientWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
 
import java.io.IOException;
 
/**
 * @author: Martin
 * @Date: 2018/9/28
 * @Description:
 * @Modify By:
 */
@Controller
@RequestMapping("/upload")
public class UploadController {
    @Autowired
    private FastDFSClientWrapper dfsClient;
 
    @GetMapping("/")
    public String index() {
        return "upload/upload";
    }
 
    @PostMapping("/fdfs_upload")
    public String fdfsUpload(@RequestParam("file") MultipartFile file,
                             RedirectAttributes redirectAttributes) {
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "Please select a file to upload");
            return "redirect:/upload/uploadStatus";
        }
 
        try {
            String fileUrl = dfsClient.uploadFile(file);
            redirectAttributes.addFlashAttribute("message",
                    "You successfully uploaded '" + fileUrl + "'");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "redirect:/upload/uploadStatus";
    }
 
    @GetMapping("/uploadStatus")
    public String uploadStatus() {
        return "upload/uploadStatus";
    }
 
    @RequestMapping("/deleteFile")
    @ResponseBody
    public String deleteFile(@RequestParam(value = "fileUrl") String fileUrl) {
        dfsClient.deleteFile(fileUrl);
        return "Success";
    }
}

```

8、建立页面测试上传功能。这里使用freemarker


![upload successful](/images/pasted-165.png)

upload.ftl:

```
&lt;!DOCTYPE html&gt;
 
&lt;html&gt;
 
&lt;body&gt;
 
 
 
&lt;h1&gt;Spring Boot file upload example&lt;/h1&gt;
 
 
 
&lt;form method="POST" action="/upload/fdfs_upload" enctype="multipart/form-data"&gt;
 
 
 
&lt;input type="file" name="file" /&gt;&lt;br/&gt;&lt;br/&gt;
 
&lt;input type="submit" value="Submit" /&gt;
 
&lt;/form&gt;
 
 
 
&lt;/body&gt;
 
&lt;/html&gt;
```

uploadStatus.ftl:


```
&lt;!DOCTYPE html&gt;
 
&lt;html lang="en" xmlns:th="http://www.thymeleaf.org"&gt;
 
&lt;body&gt;
 
 
 
&lt;h1&gt;Spring Boot - Upload Status&lt;/h1&gt;
 
 
 
&lt;div&gt;
 
&lt;h1&gt;${message}&lt;/h1&gt;
 
&lt;/div&gt;
 
&lt;/body&gt;
 
&lt;/html&gt;

```

在启动类中加上@EnableAutoConfiguration注解

![upload successful](/images/pasted-167.png)


在配置文件中加入这两个截图的东西：

![upload successful](/images/pasted-168.png)


![upload successful](/images/pasted-169.png)

9、启动项目，进行测试
![upload successful](/images/pasted-170.png)

![upload successful](/images/pasted-171.png)
提交，进行文件上传：

![upload successful](/images/pasted-172.png)

返回文件的地址，直接拷贝到浏览器访问，看看是否能访问。

![upload successful](/images/pasted-173.png)
