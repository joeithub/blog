title: 自定义js弹框
author: Joe Tong
tags:
  - JAVASCRIPT
categories:  
  - IT
date: 2019-11-05 18:33:31 
---

```
//显示框信息
function showMsg(val,time){
	if(!document.getElementById('parent_pop_up')){
	var parent_pop_up = document.createElement('div');
	parent_pop_up.id = "parent_pop_up";
	parent_pop_up.style.cssText = "position: fixed; z-index: 9999; bottom: 5rem; width: 100%;";
	var poo_up = document.createElement('div');
	poo_up.id = 'poo_up';
	poo_up.style.cssText = 'height: 1rem; margin:0 auto; text-align: center;';
	var span = document.createElement('span');
	span.style.cssText = 'background-color: rgba(0,0,0,0.6); padding: 0.2rem 0.35rem; letter-spacing: 1px; border-radius: 5px; color: #FFFFFF; font-size: 0.34rem; text-align: center;';
	span.innerHTML = val;
	poo_up.appendChild(span);
	parent_pop_up.appendChild(poo_up);
	document.body.appendChild(parent_pop_up);
	if(time == null || time == ''){
	time = 2000;
	}
	setTimeout(function(){hideMsg();},time);
	}
};
//隐藏显示框
function hideMsg(){
	var pop = document.getElementById('parent_pop_up');
	pop.style.display = 'none';
	document.body.removeChild(pop);
};
```
