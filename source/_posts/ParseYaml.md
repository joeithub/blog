title: ParseYaml
author: Joe Tong
tags:
  - JAVAEE
  - YAML
  - SPRING
categories:
  - IT
date: 2019-07-11 23:08:00
---
yaml解析


1、使用spring自带的yaml解析工具：
```
public class YamlUtils {
    private static final Logger logger = LogManager.getLogger(YamlUtils.class);

    public static Map&lt;String, Object&gt; yaml2Map(String yamlSource) {
        try {
            YamlMapFactoryBean yaml = new YamlMapFactoryBean();
            yaml.setResources(new ClassPathResource(yamlSource));
            return yaml.getObject();
        } catch (Exception e) {
            logger.error("Cannot read yaml", e);
            return null;
        }
    }

    public static Properties yaml2Properties(String yamlSource) {
        try {
            YamlPropertiesFactoryBean yaml = new YamlPropertiesFactoryBean();
            yaml.setResources(new ClassPathResource(yamlSource));
            return yaml.getObject();
        } catch (Exception e) {
            logger.error("Cannot read yaml", e);
            return null;
        }
    }
}
```
**spring提供的yaml工具只能够解析出map和properties，如果想解析生成java bean就有点力不从心，不方便。** 
2、使用snakeyaml 

在maven中引入
```
&lt;dependency&gt;
            &lt;groupId&gt;org.yaml&lt;/groupId&gt;
            &lt;artifactId&gt;snakeyaml&lt;/artifactId&gt;
            &lt;version&gt;1.17&lt;/version&gt;
        &lt;/dependency&gt;
```
Yaml yaml = new Yaml();
LibraryPolicyDto libraryPolicyDto = yaml.loadAs(inputStream, LibraryPolicyDto.class);

附yaml文件：
```
systemLibraryId: 1 
relativeLibraryId: xxx 
readerPolicyIndex: 1 
bookPolicyIndex: 1 
```
otherPublicApi: 
- 
```
name: showApi 
desc: 查看api 
url: 127.0.0.1:8080/api/showApi 
port: 8080 
inputParams: 
- id:int 
- libraryId:String 
outputParams: 
- name:String 
- desc:String 
- url:String 
- inputParams:String 
- ouputParams:String
```
附LibraryPolicyDto
```
public class LibraryPolicyDto {
    private int systemLibraryId;
    private String relativeLibraryId;
    private int readerPolicyIndex;
    private int bookPolicyIndex;
    private List&lt;ApiDto&gt; otherPublicApi;
    //getter
    //setter
}
```
