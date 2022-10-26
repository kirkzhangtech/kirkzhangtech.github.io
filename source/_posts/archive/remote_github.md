---
title: 更新origin 和upstream url链接
categories: 
- archive
---

## 背景
本地想更改项目代码的绑定的github链接，但是repo的url变了。
`remote: This repository moved. Please use the new location [new location]` 的警示。因為你的git連結位置有變動因此要修改本機端的git remote位置。另外一种场景下载别人的代码库，并做修改最后推到自己的github，这个github repo
<!-- more -->

## 解决办法
- 绑定本地origin仓库
    ```bash
    git remote set-url origin https://XXX.git
    ```
- 绑定upstream仓库
    ```bash
    $ git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
    ```