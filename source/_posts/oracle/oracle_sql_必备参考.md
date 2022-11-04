---
title: Oracle Sql必备手册
categories: 
- oracle
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/198887021-f1b71975-a6e8-44ca-af02-decfaf7ca9e1.jpg
metaAlignment: center
coverMeta: out
---

摘要: 主要是讲oracle的sql基础
关系数据库系统的根源要追溯到1970年，那时E.F,.Codd博土发表了标题为"A Relational Model of Data for Large Shared Data Banks"的论文（注1),当年6月刊登在由美国让算机学会(the Association of Computer Machinery，ACM）主办的《Communciations of the ACM》期刊上。该论文永久地改变了计算世界。Codd建议的关系数据库管理系统模型(relational database management system,RDBMS)最后变成了关系数据库的定义标准．而关系数据库则成了当今使用的主流数据库。


<!-- more -->

<!-- toc -->

# 第一章

## SQL元素

进行SQL开发是为了更容易地访问关系数据库,所以,sql能够执行下面几种操作：
- 从数据库中查询数据
- 向数据库中插入数据
- 从数据库中删除数据
- 创建和操纵数据库对象
- 控制对数据库的访问

严格地说，SQL根本不是‘种语言，而是对Oracle数据库传输指令的种方式。它与传统的编程语言在以下几个主要方面有所不同:
- SQL提供自动定位数据的能力
- SQL在数据集合上操作，而不是对独立的数据元素操作
- SQL是声明的，而不是过程化的，并且不提供过程控制SQL设计在逻辑层完成;这不需要处理实现的细节
简单地说，当在SQL中设计时，你告诉Oracle自己想要干什么，而不是怎样做。但是这种方法利弊并存。考虑下面的SQL语句:

```sql

SELECTename,deptno,sal,cornn.FROM scott.ermp
WHEREhiredate > '01-JAN-Q0' ;

```
这个简单的SQL语句告诉数据库显示2000年1月1日以后雇佣的职工名字( ename )、部门号( deptno)、薪水（ sal）和佣金( comm)。在“老式的”过程化编程语言巾,这可能需要儿百行代码，但是，在.SQL中只需要3行代码。Oracle在检索数据时并不总是如此灵巧。尽管Oracle内部的“查询优化器”有了稳步提高，但仍然有许多方法可以改进SQL的性能，第八章在讨论SQL语句的调试时将展示这一主题。

注意:有人将缺乏过程化控制视为SQL的缺点、因此，Oracle公司开发了PL/SQL ( Procedural
Language/SQL，即过程化编程语言/SQL),这一内容将在第七章讨论.


sQL语句也称为SQL命令，由以下儿部分组成:
关键字  带有特定Oralce操作意义的保留字。
变量    它是可以被动态文本或数宇变量替换的数据元素。SQL有许多对象名，如变量、表或视图。
文字
常t数据．包括文本字符串和数字。操作符
操作一个或多个变量或文字的符号或单词。
