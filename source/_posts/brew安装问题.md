title: brew安装问题
author: Joe Tong
tags:
  - MAC
categories:  
  - SYSTEM
date: 2019-12-03 16:10:29 
---
[TOCM]


## github下载
[Homebrew for macOS ](https://github.com/Homebrew/brew.git "Homebrew for macOS ")

## 替换源
把下载的install文件里的 BREW_REPO 替换掉
BREW_REPO = “https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git”.freeze

## 然后install
`./install`

## 问题解决

brew 安装出现Checksum mismatch解决方法
用brew 安装APP出现Error: Checksum mismatch.说明下载的文件和期望的hashCode对不上，删掉对应的文件就行了
删除对应文件，然后重新执行brew安装脚本
`rm -rf  /Users/tongqiao/Library/Caches/Homebrew/portable-ruby-2.6.3.mavericks.bottle.tar.gz`

---


## 替换国内源为下载源
```
// 执行下面这句命令，更换为中科院的镜像：
git clone git://mirrors.ustc.edu.cn/homebrew-core.git/ /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core --depth=1

// 把homebrew-core的镜像地址也设为中科院的国内镜像

cd "$(brew --repo)" 

git remote set-url origin https://mirrors.ustc.edu.cn/brew.git

cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core" 

git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

// 更新
brew update
```


