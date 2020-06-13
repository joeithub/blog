title: swagger2
author: Joe Tong
tags:
  - JAVAEE
  - SWAGGER
categories:
  - IT
date: 2019-10-26 14:41:41
---
## 配置


```
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Value("${spring.application.version}")
    private String version;

    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2).apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder().title("安枢")
                .description("安枢控制器Restful API")
                .termsOfServiceUrl("")
                .contact(new Contact("江苏易安联网络技术有限公司", "http://www.enlink.com.cn/", "develop@enlink.cn"))
                .version(version)
                .build();
    }
}
```


### 运用

```
@ApiOperation(value = "日志查询")
@ApiImplicitParam(name = "dto", value = "搜索参数", required = true, dataType = "SearchSQLDto")
@PostMapping("/search")
public AjaxResult log(@RequestBody SearchSQLDto dto){
```

### 访问
http://ip:port/swagger-ui.html
