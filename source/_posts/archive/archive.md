---
title: 手册阅读归档
categories: 
- archive

---

|文章标题|文档地址|学到什么|
|---|---|---|
|为什么使用rust而非C++构建流数据库|https://www.singularity-data.com/blog/building-a-cloud-database-from-scratch-why-we-moved-from-cpp-to-rust/|[优点]易于使用,内存安全的,学习简单,可管理的不安全性，[缺点]碎片化的异步子系统,笨重的error处理机制,缺少泛型. [学习到的经验] 用新的语言或者新的架构成为必然.有相关方面的专家.快速壮大自己的队伍。[总结]底层编程,性能,内存安全,友好的包管理工具是你项目主要考虑的问题。有没有专家帮到你,时间时间时间上的安排,有没有内部自用的培训程序在rust上|
|避免内存泄漏在java|https://medium.com/javarevisited/memory-leak-in-java-how-to-detect-and-avoid-dea648fba770|NULL|
|内存高效，CPU优化的golang代码|https://dev.to/deadlock/golang-writing-memory-efficient-and-cpu-optimized-go-structs-2ick|结构体的数据类型的排布会影响到内存的分配，这部分主要是编译器的字段对齐概念|
|markdown文章中使用html达到折叠代码块| ```     <details> <summary><font size="4" color="orange">Show Code</font></summary> <pre><code class="language-cpp">这里填充代码</code></pre> </details>```|
|安装pyspark和spark|pyspark=3.2.2,spark=3.2.2,jdk=11,python3=3.8,scala=2.11.12.最重要的是版本保持一致|
|英语中in which 用法|in which 是relative pronoun(关系代词)，用来引导定语从句,在which前加介词显得正式，省去which就不正式.[1] This is the car in which I travelled to Beijing. [2] This is the house in which I grew up. [3] This is the pitch on which I played football all those years ago. [4] ack at school, the name by which I was known was Charlie. [5] And these are the friends with whom I played every day. 这里的frinends是指代后面从句的宾语，故用whome|
|iso8583简介|https://garlicspace.com/2022/03/19/iso8583%E5%8D%8F%E8%AE%AE/|![iso8583报文](https://i0.wp.com/garlicspace.com/wp-content/uploads/2022/03/MTI.png?w=1082&ssl=1)0xxx → version of ISO 8583 (0 = 1987 version) x1xx → class of the message (1 = authorization message) xx1x → function of the message (1 = response) xxx0 → who began the communication (0 = acquirer)|