---
title: Kafka On Ubuntu
categories: 
- article
---

摘要: 装完还没用过:)

<!-- more -->

1. 下载,并解压
[kafka官网](https://link.zhihu.com/?target=http%3A//kafka.apache.org/)

2. 将`config/server.properties`复制三份

    server1.properties,server2.properties,server3.properties

3. 修改server.properties

    ```properties
    # server1.properties
    broker.id=1
    listeners=PLAINTEXT://:9092
    advertised.listeners=PLAINTEXT://10.1.14.159:9092(其中10.1.14.159是我本机的ip)
    log.dirs=/ashura/kafka_2.11-2.2.1/logs/kafka1-logs
    zookeeper.connect=localhost:2181,localhost:2182,localhost:2183

    # server2.properties
    broker.id=2
    listeners=PLAINTEXT://:9093
    advertised.listeners=PLAINTEXT://10.1.14.159:9093(其中10.1.14.159是我本机的ip)
    log.dirs=/ashura/kafka_2.11-2.2.1/logs/kafka2-logs
    zookeeper.connect=localhost:2181,localhost:2182,localhost:2183

    # server3.properties
    broker.id=3
    listeners=PLAINTEXT://:9094
    advertised.listeners=PLAINTEXT://10.1.14.159:9094(其中10.1.14.159是我本机的ip)
    log.dirs=/ashura/kafka_2.11-2.2.1/logs/kafka3-logs
    zookeeper.connect=localhost:2181,localhost:2182,localhost:2183

    ```

4. 启动实例

    ```bash

    nohup /ashura/kafka_2.11-2.2.1/bin/kafka-server-start.sh /ashura/kafka_2.11-2.2.1/config/server3.properties > /ashura/kafka_2.11-2.2.1/logs/kafka3-logs/startup.log 2>&1 &
    nohup /ashura/kafka_2.11-2.2.1/bin/kafka-server-start.sh /ashura/kafka_2.11-2.2.1/config/server2.properties > /ashura/kafka_2.11-2.2.1/logs/kafka2-logs/startup.log 2>&1 &
    nohup /ashura/kafka_2.11-2.2.1/bin/kafka-server-start.sh /ashura/kafka_2.11-2.2.1/config/server1.properties > /ashura/kafka_2.11-2.2.1/logs/kafka1-logs/startup.log 2>&1 &
    ```

5. health check
 
    通过startup.log,或者同级目录下的server.log查看是否有报错即可。
    检测
    - 创建主题:./kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --create --topic fxb_test1 --replication-factor 3 --partitions 3
    - 启动消费者: ./kafka-console-producer.sh --broker-list 10.1.14.159:9092 --topic fxb_test1
    - 新开窗口个,启动生产者: kafka-console-producer.sh --bootstrap-server 127.0.0.1 --create --topic fxb_test1 在生产者窗口中输入消息，查看消费者的窗口，是否有消息产生。