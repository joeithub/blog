title: subList用法
author: Joe Tong
tags:
  - JAVAEE
categories:  
  - IT
date: 2019-11-28 17:25:35 
---

java 中subList的区间为左闭右开

比如集合中的内容为1,2,3,4,5
list.sublist(2,4)
就返回一个子集合：它的内容包括从下标为2到下标为4，而且这是左闭右开的
就是说是从大于等于2到小于4
那子集内容就是3,4(集合的下标都是从0开始)

```
public static void main(String[] args) {
        List list = new ArrayList();
        for (int i = 1; i <= 5; i++) {
            list.add(i);
        }
        System.out.println(list);
        System.out.println(list.subList(2,4));
    }
```
输出：[1, 2, 3, 4, 5]
　　　[3, 4]
