title: '@SessionAttribute与@SessionAttributes'
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - SESSION
categories:
  - IT
date: 2019-07-17 00:40:00
---
@SessionAttribute与@SessionAttributes

@SessionAttributes  
@SessionAttributes作用于处理器类上，用于在多个请求之间传递参数，类似于Session的Attribute，但不完全一样，一般来说@SessionAttributes设置的参数只用于暂时的传递，而不是长期的保存，长期保存的数据还是要放到Session中。
通过@SessionAttributes注解设置的参数有3类用法：  
（1）在视图中通过request.getAttribute或session.getAttribute获取  
（2）在后面请求返回的视图中通过session.getAttribute或者从model中获取  
（3）自动将参数设置到后面请求所对应处理器的Model类型参数或者有  @ModelAttribute注释的参数里面。  
将一个参数设置到SessionAttributes中需要满足两个条件：  
（1）在@SessionAttributes注解中设置了参数的名字或者类型  
（2）在处理器中将参数设置到了model中。  
@SessionAttributes用户后可以调用SessionStatus.setComplete来清除，这个方法只是清除SessionAttribute里的参数，而不会应用Session中的参数。  
示例如下：注解@SessionAttribute中设置book、description和  types={Double}，这样值会被放到@SessionAttributes中，但Redirect跳转时就可以重新获得这些数据了，接下来操作sessionStatus.setComplete()，则会清除掉所有的数据，这样再次跳转时就无法获取数据了。  
```
@Controller  

@RequestMapping("/book")  

@SessionAttributes(value ={"book","description"},types={Double.class})  

public class RedirectController {  

	@RequestMapping("/index")  

	public String index(Model model){  

		model.addAttribute("book", "金刚经");  

		model.addAttribute("description","不擦擦擦擦擦擦擦车");  

		model.addAttribute("price", new Double("1000.00"));  

		//跳转之前将数据保存到book、description和price中，因为注解@SessionAttribute中有这几个参数

		return "redirect:get.action";

	}

 

 

	@RequestMapping("/get")

    public String get(@ModelAttribute ("book") String book,ModelMap model,

			SessionStatus sessionStatus){

 

		//可以获得book、description和price的参数

		        System.out.println(model.get("book")+";"+model.get("description")+";"+model.get("price"));

		sessionStatus.setComplete();

 

		return "redirect:complete.action";

 

	}

	@RequestMapping("/complete")

	public String complete(ModelMap modelMap){

 

		//已经被清除，无法获取book的值

 

		System.out.println(modelMap.get("book"));

		modelMap.addAttribute("book", "妹纸");

		return "sessionAttribute";

 

	}

 

}
```
@SessionAttribute  
① 使用@SessionAttribute来访问预先存在的全局会话属性  
  如果你需要访问预先存在的、以全局方式管理的会话属性的话，比如在控制器之外（比如通过过滤器）可能或不可能存在在一个方法参数上使用注解  
  ```
  @SessionAttribute：  

  /**



     * 在处理请求 /helloWorld/jump 的时候，会在会话中添加一个 sessionStr 属性。



     * &lt;p/&gt;



     * 这里可以通过@SessionAttribute 获取到



     */

    @RequestMapping("/sesAttr")

    public String handleSessionAttr(@SessionAttribute(value = "sessionStr") String sessionStr, Model model)

 

    {

 

        System.out.println("--&gt; sessionStr : " + sessionStr);

 

        model.addAttribute("sth", sessionStr);

 

        return "/examples/targets/test1";

 

}
```
为了使用这些需要添加或移除会话属性的情况，考虑注入org.springframework.web.context.request.WebRequest或javax.servlet.http.HttpSession到一个控制器方法中。
  对于暂存在会话中的用作控制器工作流一部分的模型属性，要像“使用 @SessionAttributes 存储模型属性到请求共享的HTTP会话”一节中描述的那样使用SessionAttributes。
@RequestAttribute
② 使用@RequestAttribute访问请求属性
就像@SessionAttribute一样，注解@RequestAttribute可以被用于访问由过滤器或拦截器创建的、预先存在的请求属性：
```
 @RequestMapping("/reqAttr")

    public String handle(@RequestAttribute("reqStr") String str, Model model)

    {

        System.out.println("--&gt; reqStr : " + str);

        model.addAttribute("sth", str);

        return "/examples/targets/test1";

    }
    ```
可以使用下面的过滤器进行测试：
```
@WebFilter(filterName = "myFilter", description = "测试过滤器", urlPatterns = { "/*" })

public class MyFilter implements Filter{

    @Override

    public void init(FilterConfig filterConfig) throws ServletException

    {}

    @Override

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException

    {

        System.out.println("--&gt; MyFilter Do.");

        request.setAttribute("reqStr", "万万没想到，啦啦啦啦啦！");        

        chain.doFilter(request, response);        

    }    

    @Override

    public void destroy() {}    

}
```
