---
title: Edition-Based Redefinition Technical Deep Dive
categories:
- oracle
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/201715474-35abea08-9840-4b33-a645-210948d5dafc.jpg
metaAlignment: center
coverMeta: out
---

摘要: 当应用程序的数据库组件在应用程序升级过程中被更新时，大型的关键的应用程序可能会经历几十个小时，甚至更长的停机时间。app的数据库组件在应用程序升级期间进行更新。Oracle数据库推出了基于版本的重新定义（EBR），这是一项革命性的功能，可以在不间断的情况下在线升级应用程序。革命性的功能，它允许在线应用升级，并保证应用的不间断可用性。

<!-- more -->

<!-- toc -->

# INTRODUCTION


EBR的功能是同时维护两个版本的应用程序。当升级的安装完成后。
升级前(pre-upgrade application)的应用程序和升级后(post-upgrade application)
的应用程序可以同时使用。因此，一个现有的会话可以 继续使用升级前的应用程序，直到
其用户决定结束它；而所有新的会话可以使用升级后的应用程序。在所有会话与它断开连接后，
升级前的应用程序就可以退役了。换句话说，该 应用程序作为一个整体享有从升级前版本到
升级后版本的热迁移。

为了利用这种能力，应用程序的数据库后端必须通过一些一次性的schema改变来启用EBR。
另外，**执行应用程序升级的脚本必须以使用EBR功能的方式来编写**。因此，EBR的采用和后续使用是开发车的事情。

为了实现在线应用升级2，必须满足以下条件。

- 改变后的数据库对象的安装不能影响到升级前应用程序的实时用户。

- 升级前应用程序的用户所做的交易必须反映在升级后的应用程序中。

- 升级后应用程序的用户进行的交易必须反映在升级前的应用程序中。

Oracle数据库通过一种称为基于版本的重新定义（EBR）的革命性功能实现了这一点。

Using EBR:

- 代码修改是在新版本的隐私中安装的。

- 数据的改变是通过只写入新的列或新的表来实现的，而旧版本是看不到的。这是 
这是通过一个编辑视图来实现的，该视图将一个表的不同投影暴露在每个版本中，因此每个版本只看到自己的列。
看到自己的列。

- 跨版本触发器将旧版本的数据变化传播到新版本的公共列中，或者（在hot-rollover）反之亦然。