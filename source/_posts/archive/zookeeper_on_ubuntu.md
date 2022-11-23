---
title: Zookeeper On Ubuntu20.04
categories:
- archive
---

# 搭建zookeeper集群

摘要:当时主要是想在wsl2上面搭建kafka集群

<!-- more -->

首先下载(zookeeper)[https://zookeeper.apache.org/]

- 将`zookeeper`复制三份,分别命名为`zookeeper-1,zookeeper-2,zookeeper-3`
- 将`zookeeper-1`中的`zoo.example.cfg`文件复制一份改名为: `zoo.cfg`
- 修改`config/zoo.cfg`文件
  - 修改端口: `clientPort=2181`
  - 修改数据目录: `dataDir=/home/kirk/usr/traces/zookeeper_data_log/`
  - 增加以下配置: `server.1=localhost.:2887:3887 server.2=localhost.:2888:3888 server.3=localhost.:2889:3889 admin.serverPort=8000`

完成的配置文件如下:

```properties

# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/ashura/zookeeper-1/datalog
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
server.1=localhost.:2887:3887
server.2=localhost.:2888:3888
server.3=localhost.:2889:3889
```
将这份zoo.cfg分别复制到zookeeper-2,zookeeper-3的config目录下.
修改zookeeper2的zoo.cfg中clientPort=2183,dataDir=/home/kirk/usr/traces/zookeeper_data_log/
修改zookeeper3的zoo.cfg中clientPort=2184,dataDir=/home/kirk/usr/traces/zookeeper_data_log/

创建刚才在配置文件中写的目录

```bash
mkdir /home/kirk/usr/traces/zookeeper_data_log
mkdir /home/kirk/usr/traces/zookeeper_data_log
mkdir /home/kirk/usr/traces/zookeeper_data_log
```

分别{-- 在datalog目录下 --}执行以下命令,写入myid。

```bash
echo "1" > /home/kirk/usr/traces/zookeeper_data_log/zookeeper-1/datalog/myid
echo "2" > /home/kirk/usr/traces/zookeeper_data_log/zookeeper-2/datalog/myid
echo "3" > /home/kirk/usr/traces/zookeeper_data_log/zookeeper-3/datalog/myid
```

最后分别启动zookeeper集群

```bash
/opt/zookeeper/apache-zookeeper-3.8.0-1/bin/zkServer.sh start
/opt/zookeeper/apache-zookeeper-3.8.0-2/bin/zkServer.sh start
/opt/zookeeper/apache-zookeeper-3.8.0-3/bin/zkServer.sh start
```

使用如下命令判断是否启动成功

```bash
/opt/zookeeper/apache-zookeeper-3.8.0-3/bin/zkServer.sh status
/opt/zookeeper/apache-zookeeper-3.8.0-3/bin/zkServer.sh status
/opt/zookeeper/apache-zookeeper-3.8.0-3/bin/zkServer.sh status
```