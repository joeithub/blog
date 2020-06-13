title: ide配置自定义模板
author: Joe Tong
tags:
  - JAVAEE
  - IDEA
categories:
  - IT
date: 2019-10-11 17:58:00
---
设置类注释模板  
1.选择File–>Settings–>Editor–>File and Code Templates–>Includes–>File Header. 

![upload successful](/images/pasted-176.png)
2.在右边空白处，编写自己的模板即可，注意Scheme是模板的生效范围，可选变量在description有介绍，附图中本人使用的模板（${USER}为计算机用户名，可以自行修改）。

```
/**
 * @Auther: ${USER}
 * @Date: ${DATE} ${HOUR}:${MINUTE}
 * @Description: 
 */
 ```
 3.设置完成后，创建类时自动生成注释，效果如下。 
 
![upload successful](/images/pasted-177.png)
设置方法注释模板  
Idea没有可以直接设置方法注释模板的地方，可以借用Live Templates基本实现，步骤如下。   
1.选择File–>Settings–>Editor–>Live Templates，先选择右侧绿色加号新建一个自己的模板组，如图命名为myGroup。   

![upload successful](/images/pasted-178.png)
2.选中已建好的组，选择右侧绿色加号新建模板，如下图。

![upload successful](/images/pasted-179.png)
3.填好Abbreviation（快捷输入），Description（描述）和模板内容（图中模板如下）  

```  
/**
 *
 * 功能描述: 
 *
 * @param: $param$
 * @return: $return$
 * @auther: $user$
 * @date: $date$ $time$
 */
```

4.点击Define，勾选Java 
![upload successful](/images/pasted-180.png)
5.点击Edit variables编辑变量，设置如下，点击Ok–>Apply完成设置。 

![upload successful](/images/pasted-181.png)
6.输入“`/**`”，然后按Tab键即可生成注释，如下图。注意此方式有个缺点，需要在方法内部生成，否则@param为null。 

![upload successful](/images/pasted-182.png)

