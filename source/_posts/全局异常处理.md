title: Spring的@ExceptionHandler和@ControllerAdvice统一处理异常
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - GLOBALEXCEPTION
categories:
  - IT
date: 2019-10-14 16:55:00
---
前言

之前敲代码的时候,避免不了各种try…catch, 如果业务复杂一点, 就会发现全都是try…catch

```
try{
    ..........
}catch(Exception1 e){
    ..........
}catch(Exception2 e){
    ...........
}catch(Exception3 e){
    ...........
}
```

这样其实代码既不简洁好看 ,我们敲着也烦, 一般我们可能想到用拦截器去处理, 但是既然现在Spring这么火,AOP大家也不陌生, 那么Spring一定为我们想好了这个解决办法.果然:

@ExceptionHandler
源码

```
//该注解作用对象为方法
@Target({ElementType.METHOD})
//在运行时有效
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ExceptionHandler {
	//value()可以指定异常类
    Class&lt;? extends Throwable&gt;[] value() default {};
}
```

@ControllerAdvice
源码

```
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
//bean对象交给spring管理生成
@Component
public @interface ControllerAdvice {
    @AliasFor("basePackages")
    String[] value() default {};

    @AliasFor("value")
    String[] basePackages() default {};

    Class&lt;?&gt;[] basePackageClasses() default {};

    Class&lt;?&gt;[] assignableTypes() default {};

    Class&lt;? extends Annotation&gt;[] annotations() default {};
}

```

从名字上可以看出大体意思是控制器增强

所以结合上面我们可以知道,使用@ExceptionHandler，可以处理异常, 但是仅限于当前Controller中处理异常, @ControllerAdvice可以配置basePackage下的所有controller. 所以结合两者使用,就可以处理全局的异常了.  

一、代码

这里需要声明的是，这个统一异常处理类，也是基于ControllerAdvice，也就是控制层切面的，如果是过滤器抛出的异常，不会被捕获!!!  
在@ControllerAdvice注解下的类，里面的方法用@ExceptionHandler注解修饰的方法，会将对应的异常交给对应的方法处理。

```
@ExceptionHandler({IOException.class})
public Result handleException(IOExceptione) {
    log.error("[handleException] ", e);
    return ResultUtil.failureDefaultError();
  }
```

比如这个，就是捕获IO异常并处理。

废话不多说，代码：

```
package com.zgd.shop.core.exception;

import com.zgd.shop.core.error.ErrorCache;
import com.zgd.shop.core.result.Result;
import com.zgd.shop.core.result.ResultUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import javax.validation.ValidationException;
import java.util.Set;

/**
 * GlobalExceptionHandle
 * 全局的异常处理
 *
 * @author zgd
 * @date 2019/7/19 11:01
 */
@ControllerAdvice
@ResponseBody
@Slf4j
public class GlobalExceptionHandle {
  /**
   * 请求参数错误
   */
  private final static String BASE_PARAM_ERR_CODE = "BASE-PARAM-01";
  private final static String BASE_PARAM_ERR_MSG = "参数校验不通过";
  /**
   * 无效的请求
   */
  private final static String BASE_BAD_REQUEST_ERR_CODE = "BASE-PARAM-02";
  private final static String BASE_BAD_REQUEST_ERR_MSG = "无效的请求";

  /**
   * 顶级的异常处理
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.OK)
  @ExceptionHandler({Exception.class})
  public Result handleException(Exception e) {
    log.error("[handleException] ", e);
    return ResultUtil.failureDefaultError();
  }

  /**
   * 自定义的异常处理
   *
   * @param ex
   * @return
   */
  @ResponseStatus(HttpStatus.OK)
  @ExceptionHandler({BizServiceException.class})
  public Result serviceExceptionHandler(BizServiceException ex) {
    String errorCode = ex.getErrCode();
    String msg = ex.getErrMsg() == null ? "" : ex.getErrMsg();
    String innerErrMsg;
    String outerErrMsg;
    if (BASE_PARAM_ERR_CODE.equalsIgnoreCase(errorCode)) {
      innerErrMsg = "参数校验不通过：" + msg;
      outerErrMsg = BASE_PARAM_ERR_MSG;
    } else if (ex.isInnerError()) {
      innerErrMsg = ErrorCache.getInternalMsg(errorCode);
      outerErrMsg = ErrorCache.getMsg(errorCode);
      if (StringUtils.isNotBlank(msg)) {
        innerErrMsg = innerErrMsg + "，" + msg;
        outerErrMsg = outerErrMsg + "，" + msg;
      }
    } else {
      innerErrMsg = msg;
      outerErrMsg = msg;
    }
    log.info("【错误码】：{}，【错误码内部描述】：{}，【错误码外部描述】：{}", errorCode, innerErrMsg, outerErrMsg);
    return ResultUtil.failure(errorCode, outerErrMsg);
  }

  /**
   * 缺少servlet请求参数抛出的异常
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  @ExceptionHandler({MissingServletRequestParameterException.class})
  public Result handleMissingServletRequestParameterException(MissingServletRequestParameterException e) {
    log.warn("[handleMissingServletRequestParameterException] 参数错误: " + e.getParameterName());
    return ResultUtil.failure(BASE_PARAM_ERR_CODE, BASE_PARAM_ERR_MSG);
  }

  /**
   * 请求参数不能正确读取解析时，抛出的异常，比如传入和接受的参数类型不一致
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.OK)
  @ExceptionHandler({HttpMessageNotReadableException.class})
  public Result handleHttpMessageNotReadableException(HttpMessageNotReadableException e) {
    log.warn("[handleHttpMessageNotReadableException] 参数解析失败：", e);
    return ResultUtil.failure(BASE_PARAM_ERR_CODE, BASE_PARAM_ERR_MSG);
  }

  /**
   * 请求参数无效抛出的异常
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  @ExceptionHandler({MethodArgumentNotValidException.class})
  public Result handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
    BindingResult result = e.getBindingResult();
    String message = getBindResultMessage(result);
    log.warn("[handleMethodArgumentNotValidException] 参数验证失败：" + message);
    return ResultUtil.failure(BASE_PARAM_ERR_CODE, BASE_PARAM_ERR_MSG);
  }

  private String getBindResultMessage(BindingResult result) {
    FieldError error = result.getFieldError();
    String field = error != null ? error.getField() : "空";
    String code = error != null ? error.getDefaultMessage() : "空";
    return String.format("%s:%s", field, code);
  }

  /**
   * 方法请求参数类型不匹配异常
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  @ExceptionHandler({MethodArgumentTypeMismatchException.class})
  public Result handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException e) {
    log.warn("[handleMethodArgumentTypeMismatchException] 方法参数类型不匹配异常: ", e);
    return ResultUtil.failure(BASE_PARAM_ERR_CODE, BASE_PARAM_ERR_MSG);
  }

  /**
   * 请求参数绑定到controller请求参数时的异常
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  @ExceptionHandler({BindException.class})
  public Result handleHttpMessageNotReadableException(BindException e) {
    BindingResult result = e.getBindingResult();
    String message = getBindResultMessage(result);
    log.warn("[handleHttpMessageNotReadableException] 参数绑定失败：" + message);
    return ResultUtil.failure(BASE_PARAM_ERR_CODE, BASE_PARAM_ERR_MSG);
  }

  /**
   * javax.validation:validation-api 校验参数抛出的异常
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  @ExceptionHandler({ConstraintViolationException.class})
  public Result handleServiceException(ConstraintViolationException e) {
    Set&lt;ConstraintViolation&lt;?&gt;&gt; violations = e.getConstraintViolations();
    ConstraintViolation&lt;?&gt; violation = violations.iterator().next();
    String message = violation.getMessage();
    log.warn("[handleServiceException] 参数验证失败：" + message);
    return ResultUtil.failure(BASE_PARAM_ERR_CODE, BASE_PARAM_ERR_MSG);
  }

  /**
   * javax.validation 下校验参数时抛出的异常
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  @ExceptionHandler({ValidationException.class})
  public Result handleValidationException(ValidationException e) {
    log.warn("[handleValidationException] 参数验证失败：", e);
    return ResultUtil.failure(BASE_PARAM_ERR_CODE, BASE_PARAM_ERR_MSG);
  }

  /**
   * 不支持该请求方法时抛出的异常
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.METHOD_NOT_ALLOWED)
  @ExceptionHandler({HttpRequestMethodNotSupportedException.class})
  public Result handleHttpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
    log.warn("[handleHttpRequestMethodNotSupportedException] 不支持当前请求方法: ", e);
    return ResultUtil.failure(BASE_BAD_REQUEST_ERR_CODE, BASE_BAD_REQUEST_ERR_MSG);
  }

  /**
   * 不支持当前媒体类型抛出的异常
   *
   * @param e
   * @return
   */
  @ResponseStatus(HttpStatus.UNSUPPORTED_MEDIA_TYPE)
  @ExceptionHandler({HttpMediaTypeNotSupportedException.class})
  public Result handleHttpMediaTypeNotSupportedException(HttpMediaTypeNotSupportedException e) {
    log.warn("[handleHttpMediaTypeNotSupportedException] 不支持当前媒体类型: ", e);
    return ResultUtil.failure(BASE_BAD_REQUEST_ERR_CODE, BASE_BAD_REQUEST_ERR_MSG);
  }
```

至于返回值，就可以理解为controller层方法的返回值，可以返回@ResponseBody，或者页面。我这里是一个@ResponseBody的Result&lt;&gt;，前后端分离。

我们也可以自己根据需求，捕获更多的异常类型。

包括我们自定义的异常类型。比如：

```
package com.zgd.shop.core.exception;

import lombok.Data;

/**
 * BizServiceException
 * 业务抛出的异常
 * @author zgd
 * @date 2019/7/19 11:04
 */
@Data
public class BizServiceException extends RuntimeException{

  private String errCode;

  private String errMsg;

  private boolean isInnerError;

  public BizServiceException(){
    this.isInnerError=false;
  }

  public BizServiceException(String errCode){
    this.errCode =errCode;
    this.isInnerError = false;
  }

  public BizServiceException(String errCode,boolean isInnerError){
    this.errCode =errCode;
    this.isInnerError = isInnerError;
  }

  public BizServiceException(String errCode,String errMsg){
    this.errCode =errCode;
    this.errMsg = errMsg;
    this.isInnerError = false;
  }

  public BizServiceException(String errCode,String errMsg,boolean isInnerError){
    this.errCode =errCode;
    this.errMsg = errMsg;
    this.isInnerError = isInnerError;
  }
}

```

