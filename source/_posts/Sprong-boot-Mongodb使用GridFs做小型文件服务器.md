title: Sprong-boot Mongodb使用GridFs做小型文件服务器
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - 文件服务器
categories:
  - IT
date: 2019-09-26 15:00:00
---
话不多说，直接正题：
```
compile("org.springframework.boot:spring-boot-starter-data-mongodb")
compile group: 'commons-codec', name: 'commons-codec', version: '1.10'
```
配置文件：
```
spring:
  data:
    mongodb:
      database: ***
      host: ***
      username: ***
      password: ***
      port: ***
```
上传文件代码：

```
@ResponseBody
@PostMapping(value = "/upload/file")
public String uploadSample(@RequestBody MultipartFile file) {
    try {
        String md5 = DigestUtils.md5Hex(file.getInputStream());
        QueryBuilder builder = new QueryBuilder();
        builder.and("md5").is(md5);
        GridFSDBFile gridFSDBFile = gridFsTemplate.findOne(new BasicQuery(builder.get()));
        if (gridFSDBFile != null) {
            return gridFSDBFile.getId().toString();
        }
        GridFSFile gridFSFile = gridFsTemplate.store(file.getInputStream(), file.getOriginalFilename(), file.getContentType());
        returngridFSFile.getId().toString();
    } catch (Exception e) {
        throw new RuntimeException("");
    }
}
```

访问图片代码:

```
@GetMapping(value = "/get/file/{id}")
public void get(@PathVariable Object id, HttpServletResponse response) throws IOException {
    QueryBuilder builder = new QueryBuilder();
    builder.and("_id").is(id);
    GridFSDBFile file = gridFsTemplate.findOne(new BasicQuery(builder.get()));
    response.setContentType(file.getContentType());
    file.writeTo(response.getOutputStream());
}
```
spring boot中默认配置可以满足基本需求，文件存储可以使用文件md5去重，非常方便，需要注意的是mongodb存储对文件大小的限制，这个具体数值请自行测试。

另一篇参考文档：
https://blog.csdn.net/szs860806/article/details/72528618

https://www.songliguo.com/gridfs-mongodb-distributed-file-storage-system.html
