---
title: 奔跑吧ansible
categories:
- 运维
---


摘要:fuck them all

<!-- more -->

<!-- toc -->

# 3. 第三章 inventory:描述你的服务器

ansible管理的多台主机文件叫inventory

## 3.1 inventory基本参数含义

inventory文件通常是.ini格式的，常用inventory参数如下

```txt
ansible_ssh_host     #用于指定被管理的主机的真实IP和将要连接的远程主机名.与你想要设定的主机的别名不同的话,可通过此变量设置.
ansible_ssh_port     #用于指定连接到被管理主机的ssh端口号，默认是22，如果不是默认的端口号,通过此变量设置.
ansible_ssh_user     #ssh连接时默认使用的用户名
ansible_ssh_pass     #ssh连接时的密码，(这种方式并不安全,我们强烈建议使用 --ask-pass（交互密码）或 SSH 密钥)
ansible_sudo_pass     #使用sudo连接用户时的密码，(这种方式并不安全,我们强烈建议使用 --ask-sudo-pass)
ansible_sudo_exec     #如果sudo命令不在默认路径，需要指定sudo命令路径(适用于1.8及以上版本)
ansible_ssh_private_key_file     #秘钥文件路径，秘钥文件如果不想使用ssh-agent管理时可以使用此选项
ansible_shell_type     #目标系统的shell的类型，默认sh，可设置为 'csh' 或 'fish'.
ansible_connection     #SSH 连接的类型： local , ssh , paramiko，在 ansible 1.2 之前默认是 paramiko ，后来智能选择，优先使用基于 ControlPersist 的 ssh （支持的前提）
ansible_python_interpreter     #用来指定python解释器的路径，默认为/usr/bin/python 同样可以指定ruby 、perl 的路径
ansible_*_interpreter     #其他解释器路径，用法与ansible_python_interpreter类似，这里"*"可以是ruby或才perl等其他语言
以上是2.0版本之前的参数，2.0之后有更换，但是向下兼容
```

### 3.1.1 主机别名和群组

inventory支持群组,类似于下面

```yml
[webservers]
testserver ansible_port=2202

//群组变量
[webservers:vars] 
ansible_user = vagrant
ansible_host = 127.0.0.1
ansible_private_key_file = .vagrant/machines/default/virtualbox/private_key

[web]
web[1:20].example.com

```

### 3.1.2 主机和群组变量，在inventory各自文件中

在inventory目录下我们根据环境，将不同阶段的变量放进文件，`group_vars`文件夹下文件名要与`hosts`文件中的群组保持一致

```text
group_vars
|----production
|      |- db_primary_host: rhodeisland.example.com
|      |- db_replica_host: virginia.example.com
|      |- db_name: widget_production
|      |- db_user: widgetuser
|      |- db_password: pFmMxcyD;Fc6)6
|      |- rabbitmq_host: pennsylvania.example.com
|----preprod
|      |- db_primary_host: chicago.example.com
|      |- db_replica_host: amsterdam.example.com
|      |- db_name: widget_staging
|      |- db_user: widgetuser
|      |- db_password: L@4Ryz8cRUXedj
|      |- rabbitmq_host: chicago.example.com
```

### 3.1.3 动态inventory脚本接口

对于用何种语言实现脚本，没有要求，但必须支持传`--list`和`--host=<hostname>`参数,同时`--list`输出的json字符串也有要求。有群组和主机键值对，`_meta`要保存主机变量

```bash
./dynamic.py  --list
```

output

```json

{
    "group1": {
        "hosts": [
            "192.168.28.71",
            "192.168.28.72"
        ],
        "vars": {
            "ansible_ssh_user": "johndoe",
            "ansible_ssh_private_key_file": "~/.ssh/mykey",
            "example_variable": "value"
        },
        "children":['group2']
    },
    "_meta": {
        "hostvars": {
            "192.168.28.71": {
                "host_specific_var": "bar"
            },
            "192.168.28.72": {
                "host_specific_var": "foo"
            }
        }
    }
}
```

```bash
./dynamic.py  --host=192.168.28.71
```

output

```json
{
    "host_specific_var": "foo"
}
```

ansible支持将动态inventory和动态的inventory放在同一文件夹下(名为inventory的文件夹)通过ansible.cfg的hostfile进行控制，也可以使用`-i`参数进行控制

### 3.1.4 add_host模块和group_by模块

`add_host`  
playbook运行时，主机被创建是无法追加新主机的。使用`add_host`模块就可以添加新主机并在此次playbook中生效  
`group_by`
书上使用group_by 实现了按照OS系统类型进行分组执行(像if语句)，yml中具体参数不知道什么意思.
