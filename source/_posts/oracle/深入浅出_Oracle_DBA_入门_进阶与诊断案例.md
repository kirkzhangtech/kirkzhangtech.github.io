---
title: 深入浅出_Oracle_DBA_入门_进阶与诊断案例
categories:
- oracle
---


# 1. 数据库额启动与关闭

oracle server分为两部分(database: 这部分是指文件系统上的数据，instance则是指后台运行的线程和部分共享内存)。  
并且数据启动分为三部分：1. `nomount`  2. `mount`  3. `open` 状态

1. 启动到nomount状态