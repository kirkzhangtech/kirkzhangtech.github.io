---
title: mysql manual
categories:
- mysql
tag: mysql
---
>  install mysql on ubuntu https://hevodata.com/learn/installing-mysql-on-ubuntu-20-04/

1. 创建数据库

   ```sql
    CREATE DATABASE 'newdatabase';
   ```

2. 设置创建用户并设置密码

   ```sql
   -- # Host: %表示支持任意连接，localhost表示只允许本地连接
    CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'newpassword';
    CREATE USER 'newuser'@ '%' IDENTIFIED BY 'newpassword';

   ```

3. 授权

   ```sql
    -- 如果需要给用户创建数据库的权限，则可以这样设置
    GRANT ALL PRIVILEGES ON *.* to my_user@'%'; -- 这里的my_user 跟第五步是相同的

    GRANT ALL PRIVILEGES ON newdatabase.* TO 'newuser'@'localhost';
    FLUSH PRIVILEGES;
   ```

4. 重新登陆

   ```sql
    mysql -u kirkzhang -p
   ```