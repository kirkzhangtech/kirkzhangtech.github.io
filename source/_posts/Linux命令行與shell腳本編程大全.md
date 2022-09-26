---
title: Linux命令行与shell腳本編程大全
categories:
- linux
---

- [1. linux入门](#1-linux入门)
- [2. 走进shell](#2-走进shell)
- [3. 基本shell命令](#3-基本shell命令)
  - [3.1 启动shell](#31-启动shell)
  - [3.2 bash 手册](#32-bash-手册)
  - [3.4 文件系统](#34-文件系统)
- [4. 其他shell命令](#4-其他shell命令)
  - [4.1 监控程序](#41-监控程序)
  - [4.2 磁盘空间监控](#42-磁盘空间监控)
  - [4.3 处理文件](#43-处理文件)
- [5. 理解shell](#5-理解shell)
  - [5.1 shell的类型](#51-shell的类型)
  - [5.2 shell的父子关系](#52-shell的父子关系)
    - [5.2.1 进程列表](#521-进程列表)
    - [5.2.2 子shell的其他用法](#522-子shell的其他用法)
  - [5.3 理解shell的内建命令](#53-理解shell的内建命令)
    - [5.3.1 外部命令](#531-外部命令)
    - [5.3.2 内部命令](#532-内部命令)
- [6. 环境变量](#6-环境变量)
- [7. linux文件权限](#7-linux文件权限)
  - [7.1 linux的安全性](#71-linux的安全性)
    - [7.1.1 添加linux用户](#711-添加linux用户)
    - [7.1.2 删除用户](#712-删除用户)
    - [7.1.2 修改用户](#712-修改用户)
  - [7.2 使用linux组](#72-使用linux组)
  - [7.3 理解文件权限](#73-理解文件权限)
  - [7.4 改变安全性设置](#74-改变安全性设置)
  - [7.5 共享文件](#75-共享文件)
- [9. 安装软件程序](#9-安装软件程序)
  - [9.1 包管理工具](#91-包管理工具)
  - [9.2 基于Debian的系统](#92-基于debian的系统)
    - [9.2.1 用aptitude 管理软件包](#921-用aptitude-管理软件包)
  - [9.3 基于源码安装](#93-基于源码安装)
- [10. 使用编辑器](#10-使用编辑器)
  - [10.1 vim 编辑器](#101-vim-编辑器)
- [11.基本脚本](#11基本脚本)
- [12. 使用结构化命令](#12-使用结构化命令)
- [13. for 循环](#13-for-循环)
  - [13.1 for命令](#131-for命令)
  - [13.2 C语言风格](#132-c语言风格)
  - [13.3 while语句](#133-while语句)
  - [13.4 until命令](#134-until命令)
  - [13.5 循环处理数据并以特定分隔符分割数据](#135-循环处理数据并以特定分隔符分割数据)
- [14. 处理用户输入](#14-处理用户输入)
  - [14.1 读取参数，脚本名和测试参数](#141-读取参数脚本名和测试参数)
  - [14.2 处理选项](#142-处理选项)
  - [14.3 获取用户输入](#143-获取用户输入)
- [15. 呈现数据](#15-呈现数据)
  - [15.1 理解输入和输出](#151-理解输入和输出)
    - [15.1.1 标准文件描述符](#1511-标准文件描述符)
  - [15.1.2 重定向错误](#1512-重定向错误)
  - [15.2 在脚本中重定向输出](#152-在脚本中重定向输出)
    - [15.2.1 临时重定向](#1521-临时重定向)
    - [15.2.2 永久重定向](#1522-永久重定向)
  - [15.3 在脚本中重定向输入](#153-在脚本中重定向输入)
  - [15.4 创建自己的重定向](#154-创建自己的重定向)
    - [15.4.1 创建输出文件描述符](#1541-创建输出文件描述符)
- [19.初识sed和gawk](#19初识sed和gawk)
  - [19.1 sed and gawk基础](#191-sed-and-gawk基础)
  - [19.2 sed and gawk进阶](#192-sed-and-gawk进阶)
- [20.正则表达式](#20正则表达式)
  - [20.1 什么是正则表达式](#201-什么是正则表达式)
  - [20.2 定义BRE模式](#202-定义bre模式)
    - [20.2.1. 纯文本](#2021-纯文本)
    - [20.2.2 特殊字符](#2022-特殊字符)
    - [20.2.3 锚定字符](#2023-锚定字符)
    - [20.2.4 点字符](#2024-点字符)
    - [20.2.5 字符数组](#2025-字符数组)
    - [20.2.6 排除型字符](#2026-排除型字符)
    - [20.2.7 区间](#2027-区间)
    - [20.2.8 特殊的字符数组](#2028-特殊的字符数组)
    - [20.2.9 星号](#2029-星号)


# 1. linux入门

linux是一款开源操作系统统称，其有很多发行版本，像ubuntu..，它的核心是其`内核`，早期由linus torvalds开发

![linus本人](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1da5122af2d44d499197cd6eafe8fc02~tplv-k3u1fbpfcp-watermark.image?)

内核主要负责以下四种功能:

- 系统内存管理
- 软件程序管理
    linux管理所有运行程序的进程.内核启动时会将`init`进程加载到`虚拟内存`，一些发行版本在`/etc/inittab`位置进行管理自启动进程,ubuntu则是在`/etc/init.d`或者`/etc/rcX.d`,`/etc/rcX.d`，`X`是某一特定是某一特定类型的进程，如下`rc0.d/`,`rc1.d/`,`rc2.d/`,`rc3.d/`,`rc4.d/`,`rc5.d/`,`rc6.d/`,`rcS.d/`运行级为**1**时，只启动基本的系统进程以及一个控制台终端进程。称之为**单用户模式**。单用户模式通常用来在系统有问题时进行紧急的文件系统维护。在这种模式下，仅有一个人（通常是系统管理员）能登录到系统上操作数据（这块部分以后涉及再补充也来的急，别深究）
- 硬件设备管理
  两种方式将驱动程序插入到系统内核
  1. 编译进内核的设备驱动代码
     - 以前加入新的驱动要重新编译内核，效率低下
  2. 可插入内核的设备驱动模块
      可插拔式内核驱动，Linux系统将硬件设备当成特殊的文件，称为`设备文件`。设备文件有3种分类：
      - 字符型设备文件
      - 块设备文件
      - 网络设备文件

- 文件系统管理
    linux自有的诸多文件系统外，Linux还支持从其他操作系统（比如Microsoft Windows）采用的文件系统中读写数据。内核必须在编译时就加入对所有可能用到的文件系统的支持

# 2. 走进shell

在图形化桌面出现之前，与Unix(linux是兼容unix操作系统)系统进行交互的唯一方式就是借助由shell所提供的`文本命令`行界面(command line interface，CLI),是一种同Linux系统交互的直接接口

# 3. 基本shell命令

## 3.1 启动shell

- `/etc/passwd`包含用户的基本信息,如下输出
```bash
christine: x :501:501:Christine Bresnahan:/home/christine:/bin/bash
```
位置以此类推是用户名,密码,UID,GID,用户文本描述,家目录,默认启动启动bash作为自己的shell命令(第七章将有详细描述),目前绝大多数linux发行版将密码放在`/etc/shadow`目录下,普通方式是无法直接看到的

## 3.2 bash 手册
linux自带命令手册，方便用户查看相关命令的具体选项和参数。在手册左上角括号内的数字表明对应的内容区域。每个内容区域都分配了一个数字，

|序号|解释|
|---|---|
|1|可执行程序或shell命令|
|2|系统调用|
|3|库调用|
|4|特殊文件|
|5|文件格式与约定|
|6|游戏|
|7|概览,约定及杂项|
|8|超级用户和系统管理员命令|
|9|内核例程|

如果你忘了命令的关键字那么可以使用`man -k `的方式查找命令，比如`mkdir`,就可以使用`man -k mkdir`,就可以检索出与`mkdir`相关的命令.
包括对系统主机名的概述。要想查看所需要的页面，输入`man section linux-CMD-sytax`。对手册页中的第1部分而言，就是输入`man 1 hostname`。对于手册页中的第7部分，就是输入`man 7 hostname`  
手册页不是唯一的参考资料。还有另一种叫作info页面的信息。可以输入`info info`来了解info页面的相关内容。

## 3.4 文件系统
简单理解，linux文件系统跟windows的文件布局是不一样的。
- linux 文件系统
  |目录|描述|
  |---|---|
  |/bin |二进制目录，存放许多用户级的GNU工具|
  |/boot |启动目录，存放启动文件|
  |/dev |设备目录，Linux在这里创建设备节点|
  |/etc |系统配置文件目录|
  |/home |主目录，Linux在这里创建用户目录|
  |/lib |库目录，存放系统和应用程序的库文件|
  |/media| 媒体目录，可移动媒体设备的常用挂载点|
  |/mnt |挂载目录，另一个可移动媒体设备的常用挂载点|
  |/opt |可选目录，常用于存放第三方软件包和数据文件|
  |/proc |进程目录，存放现有硬件及当前进程的相关信息|
  |/root |root用户的主目录|
  |/sbin |系统二进制目录，存放许多GNU管理员级工具|
  |/run |运行目录，存放系统运作时的运行时数据|
  |/srv |服务目录，存放本地服务的相关文件|
  |/sys |系统目录，存放系统硬件信息的相关文件|
  |/tmp |临时目录，可以在该目录中创建和删除临时工作文件|
  |/usr |用户二进制目录，大量用户级的GNU工具和数据文件都存储在这里|
  |/var |可变目录，用以存放经常变化的文件，比如日志文件|

- 遍历目录(cd命令)
  需要你知道文件树状结构,这样才能知道你将访问文件的具体位置，无论是`相对路径`还是`绝对路径`
  `cd`命令，这时要注意文件系统的相对路径和绝对路径问题，linux通过这两种方式确定目录位置，符号`/`是表示根目录
  - 绝对路径  通过从root目录开始一层一层的进行访问，最终访问到目标文件或者目录,`/bin/bash`从根目录定位到bash
  - 相对路径
    - `./` 当前目录
    - `../` 上层目录
    - `~/` 表示当前用户home目录
  ```bash
  cd ~/   # 进到对应账号的home目录下
  cd /home/kirkzhang  #使用绝对路径进入家目录
  ```
- 目录列表(ls命令)
  `ls`按照字母序列,参数`-l` 显示长列表,更多参数查看ls手册
  - 问号（?）代表一个字符
  - 星号（*）代表零个或多个字符
- 文件链接
  - 软连接
    当我们需要相同文件时,不必要在每个文件夹下都放一份文件夹，只需要使用软链接
    ls -s /usr/local/mysql/bin/mysql /usr/bin
  - 硬链接


# 4. 其他shell命令
- date
  ```bash
  echo  `date --date="-5 day" +%Y%m%d`
  echo  `date --date="-5 month" +%Y%m%d`
  echo  `date --date="-5 year" +%Y%m%d`
  ```

## 4.1 监控程序

- ps查看进程
  ```bash
  ps 选项
  -A 显示所有进程 
  -N 显示与指定参数不符的所有进程 
  -a 显示除控制进程（session leader①）和无终端进程外的所有进程 
  -d 显示除控制进程外的所有进程 
  -e 显示所有进程 
  -C cmdlist 显示包含在cmdlist列表中的进程 
  -G grplist 显示组ID在grplist列表中的进程 
  -U userlist 显示属主的用户ID在userlist列表中的进程 
  -g grplist 显示会话或组ID在grplist列表中的进程② 
  -p pidlist 显示PID在pidlist列表中的进程
  -f 完整格式输出
  ```
  命令输出关键词意义
  |名词|解释|
  |---|---|
  |UID|启动这些进程的用户  |
  |PID|进程的ID  |
  |PPID|父进程的进程号（如果该进程是由另一个进程启动的）  |
  |C|进程生命周期中的CPU利用率 | 
  |STIME|进程启动时的系统时间 | 
  |TTY|进程启动时的终端设  |
  |TIME|运行进程需要的累计CPU时间  |
  |CMD|启动的程序名称|

- top实时监控
  - 第一行：当前时间，系统运行时间，登录用户数，系统的平均负载(15分钟的参数越大且超过，说明有问题)  
  - 第二行：进程状态  
  - 第三行：CPU相关数值，使用率  

  |名词|解释|
  |---|---|
  |PID：|进程的ID|  
  |USER：|进程属主的名字  |
  |PR：|进程的优先级  |
  |NI：|进程的谦让度度|
  |VIRT：|进程占用的虚拟内存总量|
  |RES：|进程占用的物理内存总量  |
  |SHR：|进程和其他进程共享的内存总量|
  |S：|进程的状态（D代表可中断的休眠状态，R代表在运行状态，S代表休眠状态，T代表 跟踪状态或停止状态，Z代表僵化状态) | 
  |%CPU：|进程使用的CPU时间比例  |
  |%MEM：||进程使用的内存占可用内存的比例  |
  |TIME+：|自进程启动到目前为止的CPU时间总量|
  |COMMAND|：进程所对应的命令行名称，也就是启动的程序名  |
- kill结束进程
  | 信号 | 名称 |描述|
  | --- | --- |---|
  | 1 | HUP | 挂起 |
  | 2 | INT | 中断 |
  | 3 | QUIT | 退出 |
  | 9 | KILL | 无条件终止 |
  | 11 | SEGV | 段错误 |
  | 15 | TERM | 尽可能终止 |
  | 17 | STOP | 无条件终止 |
  | 18 | TSTP | 停止或暂停，但在后台运行 |
  | 19 | CONT | 在STOP或TSTP之后恢复执行 |
- 系统performance监控
  这个要下载`sysstat`程序。
  - iostat - reports CPU statistics and input/output statistics for block devices and partitions.
  - mpstat - Processors Statistics
    - `mpstat -P ALl` 所有processor
    - `mpstat -P ALL 2 5` 迭代五次间隔两秒
  - pidstat - Process and Kernel Threads Statistics
  - tapestat - reports statistics for tape drives connected to the system
  - cifsiostat - reports CIFS statistics.

## 4.2 磁盘空间监控

- mount挂在存储媒体
  `mount`提供如下信息`媒体设备名`,`挂载点`,`文件类型`,`访问方式`  
  ```bash
  #将A设备挂在到B目录上,type 参数指定了磁盘被格式化的文件系统类型,如`vfat`,`iso9660`,`ntfs`,例如`mount -t vfat /dev/sdb1 /media/  disk`
  mount -t type  A  B  
  ```
- mount参数列表，详情见man手册，或者如下
  |参 数|  描 述 |
  |---|---|
  |-a|挂载/etc/fstab文件中指定的所有文件系统|
  |-f|使 mount 命令模拟挂载设备，但并不真的挂载|
  |-F|和 -a 参数一起使用时，会同时挂载所有文件系统|
  |-v|详细模式，将会说明挂载设备的每一步|
  |-I|不启用任何/sbin/mount.filesystem下的文件系统帮助文件|
  |-l|给ext2、ext3或XFS文件系统自动添加文件系统标签|
  |-n| 挂载设备，但不注册到/etc/mtab已挂载设备文件中|
  |-p| num进行加密挂载时，从文件描述符 num 中获得密码短语|
  |-s| 忽略该文件系统不支持的挂载选项|
  |-r| 将设备挂载为只读的|
  |-w| 将设备挂载为可读写的（默认参数）|
  |-L label|  将设备按指定的 label 挂载|
  |-U uuid|  将设备按指定的 uuid 挂载|
  |-O| 和 -a 参数一起使用，限制命令只作用到特定的一组文件系统上|
  |-o| 给文件系统添加特定的选项|
- `-o`参数允许在挂载文件系统时添加一些以逗号分隔的额外选项。以下为常用的选项
  ```bash
  ro #只读挂载  
  rw #读写挂载
  user #允许普通用户挂在
  loop #挂载一个文件
  check=none #挂载时进行完整性校验
  ```
- unmount 卸载设备
  ```bash
  unmount [directory | device] # //卸载文件应在外侧目录完成,命令行提示符仍然在挂载设备的文件系统目录中，`umount` 命令无法卸载该镜像
  ```
- df 查看文件大小  
  ```bash
  df -h #以M,G描述问价大小
  ```
- du 查看文件大小
  ```bash
  -c #显示所有已列出文件总的大小(还是不宜读)
  -h #按用户易读的格式输出大小，即用K替代千字节
  -s #显示每个输出参数的总计
  ```
- find 
  ```bash
  find 目录 -
  ```
  
## 4.3 处理文件  

- sort - 文件排序  
  ```bash
   -n  #sort命令会把数字当做字符来执行标准的字符排序,解决
   -M  #按照月份排序
   -k  #和`-t`参数在对按字段分隔的数据进行排序时非常有用`sort -t ':' -k 3 -n /etc/passwd`
   -n  #按照数值排序du -hs * | sort -nr
   -r  #反向排序 
   ``` 
- grep - 搜索文件  
  ```bash
  -v #输出不匹配的行
  -n #输出行号
  -c #计算匹配到的行数
  -e #指定多个匹配模式
  grep [tf] file1 #支持正则匹配
  ```
- egrep, fgrep 功能更强大  
- 压缩数据 - zip , gzip:gz, compress:Z, bzip2:bz2
  ```bash
    gzip #压缩文件
    gzcat #查看文件内容
    gunzip #用来解压文件  
  ```
- 归档数据 - tar
  ```bash
  -c #~ create`创建一个新的tar文件
  -r #追加文件到tar文件末尾
  -x #~ extract`抽取tar文件
  -v #显示文件列表
  -z #将输出重定向给gzip命令
  -f # file`输出文件结果到文化，`tar -cvf test.tar test/ test2/` 创建一个新文件
  -t # list`列举tar内容
  -C #指定具体目录
  tar -xvf test.tar`令从tar文件test.tar中提取内容。如果tar文件是从一个目录结构创建的，那整个目录结构都会在当前目录下重新创建
  ```

# 5. 理解shell

## 5.1 shell的类型

不同Linux系统有很多种shell,`cat /etc/passwd`可以看到用户默认登录默认的shell

- Debian的是dash
- csh
- sh(你经常会看到某些发行版使用软链接将默认的系统shell设置成bash shell，如本书所使用的CentOS发行版)

## 5.2 shell的父子关系

在生成子shell进程时，只有部分父进程的环境被复制到子shell环境中的一些东西造成影响
|参数|描述|
|---|---|
|-c string|从 string 中读取命令并进行处理|
|-i|启动一个能够接收用户输入的交互shell|
|-l |以登录shell的形式启动|
|-r|启动一个受限shell，用户会被限制在默认目录中|
|-s|从标准输入中读取命令|

### 5.2.1 进程列表

1. `(pwd ; ls ; cd /etc ; pwd ; cd ; pwd ; ls)`,括号的加入使命令列表变成了进程列表，生成了一个子shell来执行对应的命令
2. 语法为 `{ command; }` 。使用花括号进行命令分组,并不会像进程列表那样创建出子shell
3. ( pwd ; (echo $BASH_SUBSHELL)) 创建子shell的子shell
4. 在shell脚本中，经常使用子shell进行多进程处理。但是采用子shell的成本不菲，会明显拖慢
处理速度。在交互式的CLI shell会话中，子shell同样存在问题。它并非真正的多进程处理，因为
终端控制着子shell的I/O

### 5.2.2 子shell的其他用法

1. 后台运行模式( & )
2. 进程列表置于后台 (sleep 2 ; echo $BASH_SUBSHELL ; sleep 2) &
3. 携程
    - coproc My_Job { sleep 10; }, My_Job 是自定义名字，必须确保在第一个花括号（ { ）和命令名之间有一个空格
    - 将`协程`与进程列表结合起来产生嵌套的子shell。只需要输入进程列表,
      然后把命令 `coproc` 放在前面就行了`coproc ( sleep 10; sleep 2 )`

## 5.3 理解shell的内建命令

### 5.3.1 外部命令

当外部命令执行时，会创建出一个子进程。这种操作被称为`衍生`(forking),有时候也被称为文件系统命令，是存在于bash shell之外的程序。它们并不是shell程序的一部分。外部命令程序通常位于/bin、/usr/bin、/sbin或/usr/sbin中

- `which ps`
- `type -a ps`
- 当进程必须执行衍生操作时，它需要花费时间和精力来设置新子进程的环境。所以说，外部命令多少还是有代价的,就算衍生出子进程或是创建了子shell，你仍然可以通过发送信号与其沟通，这一点无论是
在命令行还是在脚本编写中都是极其有用的

### 5.3.2 内部命令

1. 命令`type -a`显示出了每个命令的两种实现。注意， which 命令只显示出了外部命令文件
2. `!数字`可以使用.bash_history文件的命令
3. `alias -p`,有一个别名取代了标准命令 `ls`.它自动加入了` --color`选项，表明终端支持彩色模式的列表
4. `alias li='ls -li'`,一个别名仅在它所被定义的shell进程中才有效

# 6. 环境变量

- login shell : 用户成功登陆后使用的是 Login shell。例如，当你通过终端、SSH 或使用 "su -" 命令来切换账号时都会使用的Login Shell
- non-login shell : Non Login Shell 是指通过 login shell 开启的shell,Non-login shell执行`~/.bashrc`脚本来初始shell环境
- 交互式shell ： 就是终端等待你输入命令的就是交互式shell
- 非交互式shell : 非交互式模式，以shell script(非交互)方式执行。在这种模式 下，shell不与你进行交互，而是读取存放在文件中的命令,并且执行它们。当它读到文件的结尾EOF，shell也就终止了

如何快速辨别是login shell 还是non-login shell ,可通过`echo $0`如果是输出`-bash`说明是login shell,`bash`说明是non-login shell  

- 全局环境变量对于所有shell都是可见的,对于子shell来说这是非常重要的,`printenv`or`env`命令查看全局命令
- 局部变量，`set`返回全局变量，用户自定义变量,所以返回局部变量有点复杂，以字母序进行排序

- 用户自定义变量

  `echo $my_variable -> my_variable=Hello `可赋值,并且当你想要使用自定义变量时候要使用`${my_variable}`语法，大小写敏感

- 设置全局环境变量
  - `export my_variable`导出为全局变量，在子shell中修改该值，只会在子shell中生效
  - `unset my_variable`删除环境变量,这条规则的一个例外就是使用 printenv 显示某个变量的值)
  - 默认的环境变量，直接使用就好了

    ![linux_default_variables](./../picture/linux_命令行与shell脚本/linux_default_variables.png)
    ![linux_default_variables_1](./../picture/linux_命令行与shell脚本/linux_default_variables_1.png)
  - 设置`path`环境变量,当你在shell命令行界面中输入一个外部命令时，shell必须搜索系统来找到对应的程序.`PATH`环境变量定义了用于进行命令和程序查找的目录
  - 定位环境变量
    - 登录式shell  
      在你登入Linux系统启动一个bash shell时，默认情况下bash会在几个文件中查找命令。这些文件叫作`启动文件`或`环境文件`。bash检查启动文件的方式取决于你启动bash的方式，启动bash shell有3种方式
      - 登录时作为默认登录shell(login shell)
        当你登录系统的时候，bash shell会作为登陆式shell进行启动，会在如下文件五个不同启动文件读取命令`/etc/profile`,`$HOME/.bash_profile`,`$HOME/.bash_login`,`$HOME/.profile`,`$HOME/.bashrc`
        - `/etc/profile`  是系统默认的bash shell主启动文件，系统上每个用户登陆时候都会读取这个主启动文件，
          两个发行版的`/etc/profile`文件都用到了同一个特性：for语句。它用来迭代`/etc/profile.d`目录，这为Linux系统提供了一个放置特定应用程序启动文件的地方，
          当用户登录时，shell会执行这些文件。在本书所用的Ubuntu Linux系统中，
          `/etc/profile.d`目录下包含以下文件  
        - shell会按照按照下列顺序，运行第一个被找到的文件，余下的则被忽略,这里没提到`$HOME/.bashrc`文件，这个文件通常是通过其他文件运行  
          - `$HOME/.bash_profile`
          - `$HOME/.bash_login`
          - `$HOME/.profile`

        **NOTE** : 要留意的是有些Linux发行版使用了可拆卸式认证模块(Pluggable AuthenticationModules ，PAM)。在这种情况下，PAM文件会在bash shell启动之前处理，这些文件中可能会包含环境变量。PAM文件包括`/etc/environment`文 件 和`$HOME/.pam_environment`文件
    - 交互式shell(non-login shell)  
      如果你的shell不是登录系统时候启动的，那么你启动的shell就是交互式shell，它不会访问`/etc/profile`只会检查`.bashrc`文件，`.bashrc`文件有两个作用：一是查看/etc目录下通用的`bashrc`文件，二是为用户提供一个定制自己的命令别名(参见第5章)和私有脚本函数的地方(将在第17章中讲到)
    - 非交互shell  
      TBC
    - 环境变量的持久化
        对全局环境变量来说（Linux系统中所有用户都需要使用的变量），可能更倾向于将新的或修改过的变量设置放在`/etc/profile`文件中，但这可不是什么好主意。如果你升级了所用的发行版，这个文件也会跟着更新，那你所有定制过的变量设置可就都没有了。最好是在`/etc/profile.d`目录中创建一个以.sh结尾的文件。把所有新的或修改过的全局环境变量设置放在这个文件中。在大多数发行版中，存储个人用户永久性bash shell变量的地方是`$HOME/.bashrc`文件。这一点适用于所有类型的shell进程。但如果设置了`BASH_ENV`变量，那么记住，除非它指向的是$HOME/.bashrc，否则你应该将非交互式shell的用户变量放在别的地方
- 环境变量数组
    `mytest=(one two three four five)`定义了环境变量数组,`echo ${mytest[2]}`使用下标索引可以访问具体值,`echo ${mytest[*]}`可以访问所有的值,`unset mytest[2]`删除某个值,`unset mytest`删除全部
- 总结
    bash shell会在启动时执行几个启动文件。这些启动文件包含了环境变量的定义，可用于为每个bash会话设置标准环境变量。每次登录Linux系统，bash shell都会访问`/etc/profile`启动文件以及3个针对每个用户的本地启动文件：`$HOME/.bash_profile`、`$HOME/.bash_login`和`$HOME/.profile`。用户可以在这些文件中定制自己想要的环境变量和启动脚本。

# 7. linux文件权限
用户权限是通过创建用户时分配的用户ID（User ID，通常缩写为UID）来跟踪的。UID是数值，每个用户都有唯一的UID，但在登录系统时用的不是UID，而是`登录名`。登录名是用户用来登录系统的最长八字符的字符串（字符可以是数字或字母），同时会关联一个对应的密码
## 7.1 linux的安全性

- `/etc/passwd`包含用户的基本信息,所有在服务器后台运行都需要个`系统账户`运行
  ```bash
  1. 登录用户名
  2. 用户密码
  3. 用户账户的UID（数字形式）
  4. 用户账户的组ID（GID）（数字形式）
  5. 用户账户的文本描述（称为备注字段）
  6. 用户HOME目录的位置
  7. 用户的默认shell
  ```
  root固定分配UID是0，Linux系统会为各种各样的功能创建不同的用户账户，而这些账户并不是真的用户。这些账户叫作`系统账户`，是系统上运行的各种服务进程访问资源用的特殊账户。所有运行在后台的服务都需要用一个(application account)，如果全都是root权限登录系统就很危险，被攻陷就直接是root权限。
- `/etc/shadow`真正存密码的文件,只允许root用户访问
  ```bash
  1. 与/etc/passwd文件中的登录名字段对应的登录名
  2. 加密后的密码
  3. 自上次修改密码后过去的天数密码（自1970年1月1日开始计算）
  4. 多少天后才能更改密码
  5. 多少天后必须更改密码
  6. 密码过期前提前多少天提醒用户更改密码
  7. 密码过期后多少天禁用用户账户
  8. 用户账户被禁用的日期（用自1970年1月1日到当天的天数表示）
  9. 预留字段给将来使用
  ```
### 7.1.1 添加linux用户

- `useradd`命令添加默认配置的用户,`/etc/default/useradd`可以加入`-D`选项查看默认参数如下(一些Linux发行版会把Linux用户和组工具放在/usr/sbin目录下，这个目录可能不在`PATH`环境变量里)
  - 新用户会被添加到GID为100 的公共组；
  - 新用户的HOME目录将会位于/home/loginname；
  - 新用户账户密码在过期后不会被禁用；
  - 新用户账户未被设置过期日期；
  - 新用户账户将bash shell作为默认shell；
  - 系统会将/etc/skel目录下的内容复制到用户的HOME目录下；
  - 系统为该用户账户在mail目录下创建一个用于接收邮件的文件

  `/etc/skel`下面它们是bash shell环境的标准启动文件,允许管理员把它作为创建新用户HOME目录的模板。这样就能自动在每个新用户的HOME目录里放置默认的系统文件,`useradd`参数可以控制这些默认值,ubuntu系统在`/etc/skel`下，默认命令行参数
  ```bash
  -c comment 给新用户添加备注
  -d home_dir 为主目录指定一个名字（如果不想用登录名作为主目录名的话）
  -e expire_date 用YYYY-MM-DD格式指定一个账户过期的日期
  -f inactive_days 指定这个账户密码过期后多少天这个账户被禁用；0表示密码一过期就立即禁用，1表示禁用这个功能
  -g initial_group 指定用户登录组的GID或组名
  -G group ... 指定用户除登录组之外所属的一个或多个附加组
  -k 必须和-m一起使用，将/etc/skel目录的内容复制到用户的HOME目录
  -m 创建用户的HOME目录
  -M 不创建用户的HOME目录（当默认设置里要求创建时才使用这个选项）
  -n 创建一个与用户登录名同名的新组
  -r 创建系统账户
  -p passwd 为用户账户指定默认密码
  -s shell 指定默认的登录shell 
  -u uid 为账户指定唯一的UID 
  ```
  同时也可以更改默认值的参数
  ```bash
  -b default_home  更改默认的创建用户HOME目录的位置
  -e expiration_date  更改默认的新账户的过期日期
  -f inactive  更改默认的新用户从密码过期到账户被禁用的天数
  -g group  更改默认的组名称或GID 
  -s shell  更改默认的登录shell 
  # 更改用户默认shell
  useradd -D -s /bin/tsch
  ```

### 7.1.2 删除用户
to_be_continue
### 7.1.2 修改用户
to_be_continue


## 7.2 使用linux组

- /etc/group 存储一个组的信息，低于500是系统的，高于500是用户组的
  - 组名
  - 组密码
  - GID
  - 属于该组的用户列表
- 创建组
- 修改组

## 7.3 理解文件权限
- 理解文件权限符号
  ```bash
  `-`代表文件
  `d` 代表目录
  `l` 代表链接
  `c` 代表字符型设备
  `b` 代表块设备
  `n` 代表网络设备
  `r` 可写
  `w` 可写
  `x` 可执行
  文件owner,和对象组
  ```
- 设置默认文件权限
  设置`umask`的值,默认文件权限等于文件最大权限，减去`umask`值，第一位代表了一项特别的安全特性，叫作粘着位（sticky bit）
  rwx = 4 + 2 + 1 = 7, rw = 4 + 2 = 6, rx = 4 +1 = 5.

## 7.4 改变安全性设置
- chmod 改文件权限，如果使用的符号模式设置就是`u`代表用户，`g`代表组，`o`代表其他，`a`代表所有，`+`代表增加权限，`-`代表移除权限，`=`将权限设置成后面的值，额外的第三作用符号如下
  ```bash
  `X` ：如果对象是目录或者它已有执行权限，赋予执行权限。
  `s` ：运行时重新设置UID或GID。
  `t` ：保留文件或目录。
  `u` ：将权限设置为跟属主一样。
  `g` ：将权限设置为跟属组一样。
  `o` ：将权限设置为跟其他用户一样
  ```
- chown 改文件所属
  `chown option owner file[.group] file`
  `chown owner.group file`直接改属主和组
  `chown owner .` 属主和组都同名
  `chgrp` 更改文件目录的默认属组

## 7.5 共享文件
Linux还为每个文件和目录存储了3个额外的信息位。
-  设置用户ID（SUID）：当文件被用户使用时，程序会以文件属主的权限运行。
-  设置组ID（SGID）：对文件来说，程序会以文件属组的权限运行；对目录来说，目录中创建的新文件会以目录的默认属组作为默认属组。
-  粘着位：进程结束后文件还驻留（粘着）在内存中。
如果你用的是八进制模式，你需要知道这些位的位置

|二进制值|八进制值|描述|
|---|---|---|
|000|  0|所有位都清零|
|001 | 1|粘着位置位|
|010 | 2|SGID位置位|
|011 | 3|SGID位和粘着位都置位|
|100 | 4|SUID位置位|
|101 | 5|SUID位和粘着位都置位|
|110 | 6|SUID位和SGID位都置位|
|111 | 7|所有位都置位|


首先，用 `mkdir` 命令来创建希望共享的目录。然后通过 `chgrp` 命令将目录的默认属组改为包
含所有需要共享文件的用户的组（你必须是该组的成员）。最后，将目录的SGID位置位，以保证
目录中新建文件都用shared作为默认属组  
```bash
$ mkdir testdir
$ ls -l
drwxrwxr-x 2 rich rich 4096 Sep 20 23:12 testdir/
$ chgrp shared testdir
$ chmod g+s testdir  // chmod 6770 testdir
$ ls -l
drwxrwsr-x 2 rich shared 4096 Sep 20 23:12 testdir/
$ umask 002
$ cd testdir
$ touch testfile
$ ls -l
total 0
-rw-rw-r-- 1 rich shared 0 Sep 20 23:13 testfile

```

# 9. 安装软件程序

## 9.1 包管理工具
管理版本

## 9.2 基于Debian的系统
基于 Debian 的系统
- dpkg 包管理工具
- apt
- apt-get
- aptitude

### 9.2.1 用aptitude 管理软件包

`apt`,`dpkg`是包管理工具，`aptitude`是完整的软件包管理系统

1. aptitude show wine  显示包wine的详细信息
2. aptitude install package_name
3. aptitude search package_name
    如果看到一个 `i` ，说明这个包现在已经安装到了你的系统上了。如果看到一个 `p` 或 `v` ，说明这个包可用，但还没安装
4. aptitude safe-upgrade
5. aptitude remove/purge package_name
6. `/etc/apt/sources.list`前面有deb说明是编译过的，deb-src是源代码，package_type_list 条目可能并不止一个词，它还表明仓库里面有什么类型的包。你可以看到诸如main、restricted、universe和partner这样的值

dpkg -L vim  显示vim的所有安装信息
dpkg --search vim

## 9.3 基于源码安装

C++编译要使用CMake

# 10. 使用编辑器

## 10.1 vim 编辑器

1. 移动光标
   ```bash
   文件很大,用方向键移动
   gg 移动到最后一行
   num G 移动到指定行数
   G 移动到第一行
   w file_name 将文件保存到另一个文件中
   Pagedown + Pageup 翻页
   w file_name 保存为另一个文件
  ```

2. 编辑数据
   ```
   x 删除光标当前所在字符(剪切)
   dd 是切除当前行, p 是粘贴(剪切)
   dw 删除光标当前所在当前字符(剪切)
   yw 复制一个单词  y$复制整个行 
   u 撤销
   a 在文件尾追加数据
   A 在当前行尾追加数据
   r char 用char 替换当前光标位置字符
   R char 用text文本替换当前文本字符
  ```
3. 替换数据
  ```bash
  :s/old/new/  替换数据
  :s/olr/new/g  替换文件中一行所有old
  :m,ns/old/new/g 替换行号之间的所有old
  :$s/old/new/g 替换整个文件中的old
  :$s/old/new/gc 替换整个文件中的old，但是每次都提醒
  ```
# 11.基本脚本

- 创建shell脚本
  `#!/bin/bash`,bash找你的文件都是从path目录下，如果没有设置path目录那么就需要通过绝对路径和相对路径引用你的命令。然后是注意你的文件权限`umask`决定了你文件创建时候的默认权限
- 文本信息  
  echo可使用单引号和双引号来划定文本字符串
  1. `echo  "This is a test to see if you're paying attention"`  文本中有单引号
  2. `echo  'Rich says "scripting is easy".'` 文本中有双引号
  3. 如果是单/双引号混合会怎样？
  4. 文本字符串和命令输出到同一行

- 使用变量
  1. 用户变量区分大小写长度不超过20个字符
  2. 变量,等号,值之间不能出现空格
  3. 引用一个变量值时需要使用美元符，而引用变量来对其进行赋值时则不要使用美元符.没有美元符号引用变量进行赋值shell就会将其理解为字符串
  4. 命令替换分为`$()`和\` \`,testing=$(date)他们中间没有空格.命令替换会创建一个子shell来运行对应的命令。子shell（subshell）是由运行该脚本的shell所创建出来的一个独立的子shell（child shell）。正因如此，由该子shell所执行命令是无法使用脚本中所创建的变量的.在命令行提示符下使用路径./运行命令的话，也会创建出子shell；要是运行命令的时候不加入路径，就不会创建子shell。如果你使用的是内建的shell命令，并不会涉及子shell。在命令行提示符下运行脚本时一定要留心！
  5. 
- 输入输出重定向
  - `>`会覆盖,`>>`追加 
  - `wc < test6` 输入重定向,内联重定向`<<`,在命令行上使用内联输入重定向时,shell会用PS2环境变量中定义的次提示符（参见第6章）
  - 管道，Linux管道命令（断条符号）允许你将命令的输出直接重定向到另一个命令的输入。【这里的问题还很多】

- 执行数学计算
  1. `expr`命令,特别注意`expr 1+5`这种是不起作用的(建议以后少用)
  2. `$[ ]`对`expr`的改进,bash shell数学运算符只支持整数运算,`zsh`支持浮点运算
  3. `bc`计算器
     - `scale=4` 保留四位精度，`3.44 / 5 = .6880`, 支持定义变量
     - 在脚本中使用`bc`,`variable=$(echo "scale=4 ;3.44 / 5" | bc)`,`var3=$(echo "scale=4; $var1 / $var2" | bc)`这里的var1和var2都是预定义的
     - 将表达式定义到一个文件中，或者内联表达式
        ```bash
        #!/bin/bash 
        var1=10.46 
        var2=43.67 
        var3=33.2 
        var4=71 
        var5=$(bc << EOF 
        scale = 4 
        a1 = ( $var1 * $var2) 
        b1 = ($var3 * $var4) 
        a1 + b1 
        EOF 
        )

        echo The final answer for this mess is $var5
        ```

- 退出脚本
  1. `0`成功结束，`1`一般未知错误，`2`不适合的shell命令，`126`命令不可执行,`127`没找到命令，`128`无效退出参数，`128+x`与linux信号x相关的严重错误，`130`通过ctrl+退出，`255`正常范围之外的退出状态码
  2. `exit`退出命令，可以自定义状态码，退出状态码最大只能是255，所以超过255会进行模运算

# 12. 使用结构化命令

- if statement

  ```bash
  ## style 1
  if pwd
  then
    echo "it works"
  fi
  ## style 2
  if pwd ; then 
    echo "it works"
  fi

  # style 3 
  ## 如果grep返回0 就去执行echo statement
  if grep $testuser /etc/passwd
  then 
    echo "this is my first command"
    echo "this is my second command"
  fi
  ## if elif else  ,在elif语句中，紧跟其后的else语句属于elif代码块。它们并不属于之前的if-then代码块 
  if pwd 
  then 
    echo 1
  else | elif command  ;then  echo 3 ; else  fi
    echo 2
  fi

  ```

- test命令

  如果test命令中列出的条件成立，test命令就会退出并返回退出状态码0。这样if-then语句就与其他编程语言中的if-then语句以类似的方式工作了。如果条件不成立，test命令就会退出并返回非零的退出状态码，这使得if-then语句不会再被执行。支持符合条件检查
  ```bash
    ## 单一逻辑校验
    if [ condition ] 
    then 
      commands
    fi
    ## 符合逻辑校验
    if [ condition1 ] && [ condition2 ] || [ condition ] 
    then 
      commands
    fi
  ```
  - 数值比较
    - n1 -eq n2   等于
    - n1 -ge n2   大于等于
    - n1 -gt n2   大于
    - n1 -le n2   小于等于
    - n1 -lt n2   小于
  - 字符串比较
    - str1 = str2 字面量相等，在比较字符串的相等性时，比较测试会将所有的标点和大小写情况都考虑在内
    - str1 != str2 不相等
    - str1 < str2   小于. `if [ $val1 > $val2 ]`直接这样比较字符串会创建一个文件。所以必须要转义`if [ $val1 \> $val2 ]`。在比较测试中，大写字母被认为是小于小写字母的。比较测试中使用的是标准的ASCII顺序，根据每个字符的ASCII数值来决定排序结果但sort命令恰好相反，本地语言设置（英语），A在a前面
    - str1 > str2   大于
    - -n str1  判断长度是否为非零
    - -z str1  判断长度是否为零
    
  - 文件比较
    |比较|描述|
    |---|---|
    |-d file         |d=directory. 检查file是否存在并是一个目录|
    |-e file         |e=exist. 检查file是否存在|
    |-f file         |f=file. 检查file是否存在并是一个文件|
    |-r file         |r=read. 检查file是否存在并可读|
    |-s file         |s=检查file 是否存在并非空|
    |-w file         |w=write. 检查file是否存在并可写|
    |-x file         |检查file 是否存在并可执行|
    |-O file         |O=all user 检查file是否存在并属当前用户所有|
    |-G file         |G=group 检查file是否存在并且默认组与当前用户相同|
    |file1 -nt file2 |检查file1是否比file2新|
    |file1 -ot file2 |检查file1是否比file2旧|
    
- (( ))和[[ ]]提供高级特性
  - (( )) 提供更加方便的数学表达式计算，像其他oop语言一样
  - [[ ]] 提供更加方便的字符串处理功能

- `case`命令
  ```bash
  case variable in 
  pattern1 | pattern2 ) command1;;
  pattern3) command2;;
  *) command3;;
  esac

  ```

# 13. for 循环

## 13.1 for命令

- for 基本语句
```bash
list="Alabama Alaska Arizona Arkansas Colorado" 
list=$list" Connecticut"
for v in v_list
do
  echo 1

done

```

v_list如果有单引号，1.用转义字符转义。2.用双引号定义用到的单引号的值。3.如果在单独的数据值中有空格，就必须用双引号将这些值圈起来，可直接拼接值。

```bash
file="path of your file"
for state in $(cat $file) 
do 
 echo "Visit beautiful $state" 
done

```

读取文件内容进行迭代
(ubuntu没有IFS环境变量和IFS.OLD)
- 更改字段分隔符
默认分隔符是`空格`，`制表符`，`换行符`环境变量IFS,控制着字段分隔符，有时候想灵活一点,有些地方用的换行符，但是其他地方继续保留原先的分隔符，可使用IFS=$'\n', IFS.OLD=$IFS,IFS=$'\n',但是如果想加入冒号作为换行符可以更改`/etc/passwd`文件加上IFS=:,如果想加多个可以依次在后面加IFS='\n':;"

- 通配符
  ```bash
  #!bin/bash
  for file in /home/rich/test/* 
  do 
    if [ -d "$file" ] 
    then 
      echo "$file is a directory" 
    elif [ -f "$file" ] 
    then 
      echo "$file is a file" 
    fi 
  done
  ## 目录文件都会匹配
  ##请注意这次条件判断有些特别使用了if [ -d "$file" ] 因为在linux中文件名有空格是合法的

  ```

## 13.2 C语言风格

```bash

for (( a=1,b=10;a<=10;a++,b--))
do
  echo 1
done

```

## 13.3 while语句

```bash
while true
do
  echo

done

```

`break` 还可以指定跳出循环层数,两层`for`就跳出最内层,`break n`就会跳出.  
`continue`结束本次循环，n为1，表明跳出的是当前的循环。如果你将n设为2，break命令就会停止下一级的外部循环  

- 处理循环中的输出
  ```bash
  for file in /home/rich/* 
  do 
  if [ -d "$file" ] 
  then 
    echo "$file is a directory" 
  elif 
    echo "$file is a file"  
  fi 
  done > output.txt
  ```

- 处理多个测试命令

  这种情况下要注意，判断了所有条件，因为有一个条件返回为false，所以相当于逻辑`与`判断
  ```bash
  #!/bin/bash
  # testing a multicommand while loop 
  var1=10 
  while echo $var1 
          [ $var1 -ge 0 ] 
  do 
  echo "This is inside the loop" 
  var1=$[ $var1 - 1 ] 
  done 

  ```

while 或者for的嵌套循环中，内部循环可以读到外部变量

## 13.4 until命令

有点像其他语言的
do .... while 语法

## 13.5 循环处理数据并以特定分隔符分割数据

主要是修改IFS变量

```bash
#!/bin/bash 
# changing the IFS value 
IFS.OLD=$IFS 
IFS='\n'
for entry in $(cat /etc/passwd) 
do 
 echo "Values in $entry –" 
 IFS=':'
  for value in $entry 
  do 
    echo " $value" 
  done 
done 
```

# 14. 处理用户输入

## 14.1 读取参数，脚本名和测试参数
- ./sumAB.sh  a  b  ## 这里$0是程序名, `$1`是a, `$2`是b. 超过九个就一定要花括号引用变量比如`${10}`，`$#`返回参数个数， `${!#}`获取最后一个参数，如果没有参数就会输出脚本名，`$*`变量会将所有参数当成单个参数,`$@`变量会组成数组，轻松访问所有的参数.
  ```bash
  for param in "$@"
  do 
  echo "\$@ Parameter #$count = $param" 
  count=$[ $count + 1 ] 
  done 
  ```
- 如果程序名是`./test.sh`,那么echo $0 就是`./test.sh`
- 如果程序名是`bash  /usr/lib/test.sh`,那么echo $0 就是`/usr/lib/test.sh`
- 定义了参数位置，如果不传参会报错
- `name=$(basename $0)` 可以只返回脚本名
- `if [ -n "$1" ]`是指`$1`不为空
- `shift`命令会移动命令参数,`shift n`可以指定跳过`n`参数.

## 14.2 处理选项
bash命令提供了`选项`和`参数`来控制,可以通过`shift`命令来控制
- 处理简单的选项
  ```bash
  #!/bin/bash
  # extracting command line options as parameters 
  # 
  echo 
  while [ -n "$1" ] 
  do 
  case "$1" in 
    -a) echo "Found the -a option" ;; 
    -b) echo "Found the -b option" ;; 
    -c) echo "Found the -c option" ;; 
    *) echo "$1 is not an option" ;; 
  esac
  shift 
  done 
  $ ./test15.sh -a -b -c -d
  ```

- 分离选项和参数
  ```bash
  #!/bin/bash
  # extracting options and parameters 
  echo 
  while [ -n "$1" ] 
  do 
    case "$1" in 
      -a) echo "Found the -a option" ;; 
      -b) echo "Found the -b option";; 
      -c) echo "Found the -c option" ;; 
      --) shift 
                break ;; 
      *) echo "$1 is not an option";; 
    esac 
  shift 
  done 
  # 
  count=1 
  for param in $@ 
  do 
    echo "Parameter #$count: $param" 
    count=$[ $count + 1 ] 
  done 
  $ ./test16.sh -c -a -b -- test1 test2 test3
  ```

- 处理带值的选项
  ```bash
  #!/bin/bash
  # extracting command line options and values 
  echo 
  while [ -n "$1" ] 
  do 
    case "$1" in 
      -a) echo "Found the -a option";; 
      -b) param="$2" 
      echo "Found the -b option, with parameter value $param" 
      shift ;; 
      -c) echo "Found the -c option";; 
      --) shift 
      break ;; 
      *) echo "$1 is not an option";; 
    esac 
    shift 
  done 
  # 
  count=1 
  for param in "$@" 
  do 
    echo "Parameter #$count: $param" 
    count=$[ $count + 1 ] 
  done 
  $ ./test17.sh -a -b test1 -d
  ```
  case语句定义了三个它要处理的选项。-b选项还需要一个额外的参数值。由于要处理的参数是$1，额外的参数值就应该位于$2（因为所有的参数在处理完之后都会被移出）。只要将参数值从$2变量中提取出来就可以了

- 使用getopt与getopts命令
  getopts命令会用到两个环境变量。如果选项需要跟一个参数值，OPTARG环境变量就会保存这个值。
  OPTIND环境变量保存了参数列表中getopts正在处理的参数位置。
  这样你就能在处理完选项之后继续处理其他命令行参数了。
  ```bash
  #!/bin/bash
  # simple demonstration of the getopts command 
  # 
  echo 
    while getopts :ab:c opt 
  do 
    case "$opt" in 
    a) echo "Found the -a option" ;; 
    b) echo "Found the -b option, with value $OPTARG";; 
    c) echo "Found the -c option" ;; 
    *) echo "Unknown option: $opt";; 
    esac 
  done
  $ bash ./test19.sh -a -b "1 2" -c  # 在参数中加空格
  $ bash ./test19.sh -abtest1        # 可以挨在一起
  $ bash ./test19.sh -d              # 返回问号
  $ bash ./test19.sh -a -b 456 -cdefg# 如果有参数的就要分开写
  ```
  - 使用OPTIND参数和OPTARG参数
  ```bash
  #!/bin/bash
  # Processing options & parameters with getopts 
  # 
  echo 
  while getopts :ab:cd opt 
  do 
  case "$opt" in 
    a) echo "Found the -a option" ;; 
    b) echo "Found the -b option, with value $OPTARG" ;; 
    c) echo "Found the -c option" ;; 
    d) echo "Found the -d option" ;; 
    *) echo "Unknown option: $opt" ;; 
  esac 
  done 
  # 
  shift $[ $OPTIND - 1 ] 
  # 
  echo 
    count=1 
  for param in "$@" 
  do 
    echo "Parameter $count: $param" 
    count=$[ $count + 1 ] 
  done
  ```

- 选项标准化
  |参数|解释|
  |---|---|
  |-a |显示所有对象|
  |-c |生成一个计数|
  |-d |指定一个目录|
  |-e |扩展一个对象|
  |-f |指定读入数据的文件|
  |-h |显示命令的帮助信息|
  |-i |忽略文本大小写|
  |-l |产生输出的长格式版本|
  |-n |使用非交互模式（批处理）|
  |-o |将所有输出重定向到的指定的输出文件|
  |-q |以安静模式运行|
  |-r |递归地处理目录和文件|
  |-s |以安静模式运行|
  |-v |生成详细输出|
  |-x |排除某个对象|
  |-y |对所有问题回答yes |


## 14.3 获取用户输入

- `read`命令，
  - read命令包含了-p选项，允许你直接在read命令行指定提示符,
  - read命令会将提示符后输入的所有数据分配给单个变量，要么你就指定多个变量。输入的每个数据值都会分配给变量列表中的下一个变量。如果变量数量不够，剩下的数据就全部分配给最后一个变量
  - `-t`代表超时
  - `-n 1`read命令来统计输入的字符数。当输入的字符达到预设的字符数时，就自动退出，将输入的数据赋给变量
  - `-s` 选项可以避免在read命令中输入的数据出现在显示器上
  - 从文件中读取数据
  ```bash
  //单个变量
  read -p "please enter your age" age
  //多个变量
  read -p "please enter your name" first last
  // 超时参数
  read -t 5 -p 
  // 获取指定字符个数
  read -n1  -p "Do you want to continue [Y/N]?" answer
  //隐藏输入
  read -s -p "Enter your password: " pass 
  // 从文件中读取数据
  #!/bin/bash
  # reading data from a file 
  # 
  count=1 
  cat test | while read line 
  do 
    echo "Line $count: $line" 
    count=$[ $count + 1] 
  done 
  echo "Finished processing the file" 
  ```
  
# 15. 呈现数据
这一章主要是讲如何将脚本输出重定型向到系统其他位置

## 15.1 理解输入和输出
### 15.1.1 标准文件描述符
Linux系统将每个对象(操作的文件，linux万物皆文件)当作文件处理。这包括输入和输出进程。Linux用文件描述符（filedescriptor）来标识每个文件对象
```bash
文件描述符  缩 写   描 述
0           STDIN   标准输入
1           STDOUT  标准输出
2           STDERR  标准错误
```
1. STDIN实例  
   `cat` 就会从STDIN输入数据，这时候你输入什么屏幕就会显示什么  
   `cat < file.txt`通过STDIN通过重定向符号使`cat`查看一个非STDIN文件的输入
2. STDOUT  
3. STDERR
   shell通过特殊的`STDERR`文件描述符来处理错误消息。`STDERR`文件描述符代表shell的标准错误输出。shell或shell中运行的程序和脚本出错时生成的错误消息都会发送到这个位置

## 15.1.2 重定向错误
1. 只重定向错误
通过`2> file.txt`的方式将错误信息重定向到文件中
2. 重定向错误和数据   
` ls -al test test2 test3 badtest 2> test6 1> test7` 这种就是将`STDERR`重定向到test6,然后将`STDOUT`重定向到test7.  
也可以将STDERR和STDOUT的输出重定向到同一个输出文件使用`&>`,比如`ls -al test test2 test3 badtest &> test7`，bash消息赋予error更高的优先级

## 15.2 在脚本中重定向输出
可以在脚本中用STDOUT和STDERR文件描述符以在多个位置生成输出，只要简单地重定向相应的文件描述符就行了。有两种方法来在脚本中重定向输出：
- 临时重定向行输出
- 永久重定向脚本中的所有命令

### 15.2.1 临时重定向
如果使用上文提到的`STDERR`重定向方法就会将全局的`STDERR`信息都重定向到文件中，但是如果只重定向自己特定某些error信息就可以使用临时重定向，必须在文件描述符数字之前加一个`&`
```bash
# 举个例子 ./test8
#!/bin/bash
# testing STDERR messages 
echo "This is an error" >&2 
echo "This is normal output" 
```
如果像平常一样运行这个脚本，你可能看不出什么区别,因为所有输出都到了STDOUT,但是默认情况下，linux会将STDERR导向STDOUT,但是，如果你在运行脚本时重定向了STDERR，脚本中所有导向STDERR的文本都会被重定向。
```bash
$ ./test8 2> test9
This is normal output 
$ cat test9 
This is an error 
```


### 15.2.2 永久重定向
如果脚本中有大量数据需要重定向，那重定向每个echo语句就会很烦琐。取而代之，你可以用`exec`命令告诉shell在脚本执行期间重定向某个特定文件描述符。
```bash
#!/bin/bash
# redirecting all output to a file 
exec 1>testout 
echo "This is a test of redirecting all output" 
echo "from a script to another file." 
echo "without having to redirect every individual line" 
```
## 15.3 在脚本中重定向输入
`exec`命令允许你将STDIN重定向到Linux系统上的文件中`exec 0< testfile`
```bash
# redirecting file input 
exec 0< testfile 
count=1 
while read line 
do 
 echo "Line #$count: $line" 
 count=$[ $count + 1 ] 
done 
```
## 15.4 创建自己的重定向
### 15.4.1 创建输出文件描述符
可以用exec命令来给输出分配文件描述符。和标准的文件描述符一样，一旦将另一个文件
描述符分配给一个文件，这个重定向就会一直有效，直到你重新分配。这里有个在脚本中使用其
他文件描述符的简单例子。(不是太理解这句话)
```bash
#./test13
#!/bin/bash
# using an alternative file descriptor 
exec 3>test13out 
echo "This should display on the monitor" 
echo "and this should be stored in the file" >&3 
echo "Then this should be back on the monitor" 

```
这个脚本用exec命令将文件描述符3重定向到另一个文件。当脚本执行echo语句时，输出内
容会像预想中那样显示在STDOUT上。但你重定向到文件描述符3的那行echo语句的输出却进入
了另一个文件。这样你就可以在显示器上保持正常的输出，而将特定信息重定向到文件中（比如
日志文件）。







# 19.初识sed和gawk

## 19.1 sed and gawk基础

**sed**

- 一次输入一行
- 按照命令修改流中数据
- 将最后结果输出到STDOUT

> sed  options  script  file

echo 'this is a test' | sed  's/test/big test/'  使用s命令将test替换为big test

sed 's/dog/cat/'  data.txt    这是修改文件中dog为cat
sed  -e  's/brown/red;  s/blue/yellow/'   data/txt

从文件中读取编辑器命令

sed -f script.sed  data.txt

**gawk**

option

-F fs  指定行中划分数据字段的字段分隔符
-f file  从指定的文件中读取程序
-v var=value  定义gawk程序中的一个变量及其默认值
-mf N  指定要处理的数据文件中的最大字段数
-mr N  指定数据文件中的最大数据行数
-W keyword  指定gawk的兼容模式或警告等级

- 从命令行读取程序脚本
  gawk '{print "Hello World!"}'

- 从文件中读取数据
  自动为文件每一行数据分配一个变量gawk '{print $1}' data2.txt 数据文件中每一行的第一个字符
  eg: gawk -F: '{print $1}' /etc/passwd

- 在程序脚本中使用多个命令

  echo "my name is rich" | gawk '{$4="Christine"; print $0}' , 给第四个字段名赋值，并输出文本名 ，如果不指定文件名就会从标准输入等待输入

- 从文件中读取程序

  command_gawk.gawk        gawk -F: -f  command_gawk.gawk  /etc/passwd

  ```bash
  BEGIN {
  print "The latest list of users and shells"
  print " UserID \t Shell"
  print "-------- \t -------"
  FS=":"
  }
  {
  print $NF " \t " $7
  }
  END {
  print "This concludes the listing"
  }
  ```

- 在处理数据前运行脚本

  gawk 'BEGIN {print "Hello World!"}'

  \>{print $0}' data3.txt

- 处理数据后运行脚本

## 19.2 sed and gawk进阶

替换标记
s/pattern/replacement/flags

- 数字， 说明新文本将替换第几处的地方
- g，说明文本将替换所有
- p, 原先行要打印
- w file ， 将结果输出到新文件中
- option 位置是 n 说明禁止输出

替换字符
在替换文件路径时候涉及到转义字符这样很影响阅读性

替换指定行
sed '2s/dog/cat/' data1.txt        这个命令的意思就是将data1.txt替换第二行中的dog，替换成cat
sed '2,3s/dog/cat/' data1.txt    以此类推是第二行，第三行
sed '2,$s/dog/cat/' data1.txt    从第二行开始到最后一行
sed '/Samantha/s/bash/csh/' /etc/passwd   推过模式匹配
sed '3,${
  s/brown/green/
  s/lazy/active/
  }' data1.txt

# 20.正则表达式

## 20.1 什么是正则表达式
正则表达式就是某种模板(筛子)，正则表达式是通过正则表达式引擎（regular expression engine）实现的。正则表达式引擎是
一套底层软件，负责解释正则表达式模式并使用这些模式进行文本匹配。
- POSIX基础正则表达式（basic regular expression，BRE）引擎
- POSIX扩展正则表达式（extended regular expression，ERE）引擎

## 20.2 定义BRE模式

### 20.2.1. 纯文本
`echo "This is a test" | sed -n '/this/p'` 这里面p是print,少了-n是打印两条，this没匹配到所以没有显示  
空格也是普通的字符，比如`sed -n /  /p data.set`

### 20.2.2 特殊字符
` echo "3 / 2" | sed -n '///p' ` 正斜线也需要转义字符，故正确的是` echo "3 / 2" | sed -n '/\//p'`

### 20.2.3 锚定字符
1. `^`锚定字符  
主要是锚定字符串行首。如果模式出现在行首之外的位置则不匹配，如果你将脱字符放到模式开头之外的其他位置，那么它就跟普通字符一样，不再是特殊字符了`echo "This is ^ a test" | sed -n '/s ^/p'`
``
2. `$`锚定结尾
特殊字符美元符`$`定义了行尾锚点。将这个特殊字符放在文本模式之后来指明数据行必须以该文本模式结尾。`echo "This is a good book" | sed -n '/book$/p'`
3. 组合锚定
    ```bash
    $ cat data4
    this is a test of using both anchors  # 这一行会被忽略
    I said this is a test 
    this is a test 
    I'm sure this is a test. 
    $ sed -n '/^this is a test$/p' data4 
    this is a test
    ```
    第二种情况
    ```bash
    $ cat data5
    This is one test line. 
    This is another test line. 
    $ sed '/^$/d' data5 
    This is one test line. 
    This is another test line. 
    ```
    定义的正则表达式模式会查找行首和行尾之间什么都没有的那些行。由于空白行在两个换行符之间没有文本，刚好匹配了正则表达式模式。sed编辑器用删除命令d来删除匹配该正则表达式模式的行，因此删除了文本中的所有空白行。这是从文档中删除空白行的有效方法
### 20.2.4 点字符
特殊字符点号用来匹配除换行符之外的任意单个字符。它必须匹配一个字符，如果在点号字符的位置没有字符，那么模式就不成立。
```bash
$ cat data6
This is a test of a line. 
The cat is sleeping. 
That is a very nice hat. 
This test is at line four. 
at ten o'clock we'll go home. 
$ sed -n '/.at/p' data6 
The cat is sleeping. 
That is a very nice hat. 
This test is at line four. 

```
### 20.2.5 字符数组
点字符在模糊匹配上很有用，但是你想在某一位置上指定字符范围，那么字符数组就会很有用
```bash
$ sed -n '/[ch]at/p' data6
The cat is sleeping. 
That is a very nice hat. 

```
### 20.2.6 排除型字符
```bash
$ sed -n '/[
ch]at/p' data6
This test is at line four. 
```
通过排除型字符组，正则表达式模式会匹配c或h之外的任何字符以及文本模式。由于空格字
符属于这个范围，它通过了模式匹配。但即使是排除，字符组仍然必须匹配一个字符，所以以at
开头的行仍然未能匹配模式

### 20.2.7 区间
想想匹配邮编那个case，实在是太麻烦，我们可以简化为`区间`表示  
```bash
sed -n '/^[0-9][0-9][0-9][0-9][0-9]$/p' data8 
```
也可以指定多个区间`sed -n '/[a-ch-m]at/p' data6 `,该字符组允许区间a~c、h~m中的字母出现在at文本前

### 20.2.8 特殊的字符数组

```bash
#BRE特殊字符组
组                      描 述
[[:alpha:]]             匹配任意字母字符，不管是大写还是小写
[[:alnum:]]             匹配任意字母数字字符0~9、A~Z或a~z 
[[:blank:]]             匹配空格或制表符
[[:digit:]]             匹配0~9之间的数字
[[:lower:]]             匹配小写字母字符a~z 
[[:print:]]             匹配任意可打印字符
[[:punct:]]             匹配标点符号    
[[:space:]]             匹配任意空白字符：空格、制表符、NL、FF、VT和CR 
[[:upper:]]             匹配任意大写字母字符A~Z 
```

### 20.2.9 星号
在字符后面放置**星号**表明该字符必须在匹配模式的文本中出现0次或多次
```bash
$ echo "ik" | sed -n '/ie*k/p'
ik 
$ echo "iek" | sed -n '/ie*k/p' 
iek 
$ echo "ieek" | sed -n '/ie*k/p' 
ieek 
$ echo "ieeek" | sed -n '/ie*k/p'
```
另一个方便的特性是将点号特殊字符和星号特殊字符组合起来。这个组合能够匹配任意数量
的任意字符。它通常用在数据流中两个可能相邻或不相邻的文本字符串之间。
```bash
$ echo "this is a regular pattern expression" | sed -n '
> /regular.*expression/p' 
this is a regular pattern expression 
```
星号还能用在字符组上。它允许指定可能在文本中出现多次的字符组或字符区间。  
```bash
$ echo "bt" | sed -n '/b[ae]*t/p'
bt 
$ echo "bat" | sed -n '/b[ae]*t/p' 
bat 
$ echo "bet" | sed -n '/b[ae]*t/p' 
bet 
$ echo "btt" | sed -n '/b[ae]*t/p' 
btt 
$ 
$ echo "baat" | sed -n '/b[ae]*t/p' 
baat 
$ echo "baaeeet" | sed -n '/b[ae]*t/p' 
baaeeet 
$ echo "baeeaeeat" | sed -n '/b[ae]*t/p' 
baeeaeeat 
$ echo "baakeeet" | sed -n '/b[ae]*t/p' 
$ 
```
只要a和e字符以任何组合形式出现在b和t字符之间（就算完全不出现也行），模式就能够匹配。如果出现了字符组之外的字符，该模式匹配就会不成立。