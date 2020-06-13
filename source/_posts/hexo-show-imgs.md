title: hexo show imgs
tags:
  - HEXO
categories:
  - IT
author: Joe Tong
date: 2019-07-16 00:39:00
---
Hexo快速发布博文及插入图片  

md文件放在hexo网站所在位置下的source_posts目录，这个目录下存储了很多个md文件，每个文件对应着一篇博客。  
在博客站点文件夹输入：hexo g，生成静态页面，   
再输入：hexo server，到localhost:4000预览博客效果，   
最后输入：hexo d，部署；  
第四步可简单输入命令：hexo d -g  
解决利用csdn发布博客图片不显示的问题  
1、 将主页配置文件_config.yml 里的post_asset_folder:这个选项设置为true；  
2、在hexo目录下执行npm install hexo-asset-image --save，这是下载安装一个可以上传本地图片的插件； 
3、稍等片刻，再运行hexo n "xxxx"来生成md博文时，/source/_posts文件夹内除了xxxx.md文件还有一个同名的文件夹  
4、 在xxxx.md中想引入图片时，先把图片复制到xxxx这个文件夹中，然后只需要在xxxx.md中按照markdown的格式引入图片：  
`![这里输入图片描述](/xxxx/图片名.jpg)  `

**注意： 此处xxxx代表的是新建博文md文件的名字，也是同名文件夹的名字**  
 
![](/images/sf.png)
如下图： &nbsp;
具体引入路径如下： 
/Hexo快速发布博文及插入图片/图片显示问题.png
