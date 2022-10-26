---
title: install_mysql_on_ubuntu(Debian sys)
categories: 
- archive
---

我自己电脑都是使用`apt`命令  
<!-- more -->

安装mysql
1. sudo apt update
2. sudo apt upgrade
3. sudo apt install mysql-server
4. 启动mysql
   1. WSL2 `sudo /etc/init.d/mysql start`,`sudo /etc/init.d/mysql stop`
   2. ubuntu系统
5. 配置mysql
   1. `sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf` 在最后一行添加`skip-grant-tables`
   2. `sudo service mysql restart`

All configuration files (like my.cnf) are under /etc/mysql

All binaries, libraries, headers, etc., are under /usr/bin and /usr/sbin

The data directory is under /var/lib/mysql

卸载mysql
安装的过程难免会出错，这时候就可能需要卸载掉软件。下面记录下如何完全卸载掉mysql，便于之后重新安装。

1. 自动卸载mysql*相关的软件  
`sudo apt-get autoremove --purge mysql*`
2. 删除掉卸载不完全留下的文件目录  
`sudo rm -rf /etc/mysql /var/lib/mysql`
3. 自动卸载无用的程序
`sudo apt-get autoremove`
4. 自动清理卸载后的残留信息
`sudo apt-get autoclean`
5. 这样就mysql就完全卸载好了，之后遵循上面的安装步骤进行安装即可。