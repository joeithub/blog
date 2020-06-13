title: push existing folder to git
author: Joe Tong
tags:
  - JAVAEE
  - GIT
categories:
  - IT
date: 2019-07-16 18:22:00
---
Command line instructions    

You can also upload existing files from your computer using the instructions below.
``` 
Git global setup  
git config --global user.name "Tong"  
git config --global user.email "joetonghao@126.com"  
```
Create a new repository  
```
git clone http://tong.lab.com/Joe/springboot-login.git  
cd springboot-login  
touch README.md  
git add README.md  
git commit -m "add README"  
git push -u origin master  
```
Push an existing folder 
```
cd existing_folder  
git init  
git remote add origin http://tong.lab.com/Joe/springboot-login.git  
git add .
git commit -m "Initial commit"  
git push -u origin master
```
Push an existing Git repository  
```
cd existing_repo  
git remote rename origin old-origin  
git remote add origin http://tong.lab.com/Joe/springboot-login.git  
git push -u origin --all  
git push -u origin --tags  
```

git - 查看远程仓库信息

`git remote show origin`
