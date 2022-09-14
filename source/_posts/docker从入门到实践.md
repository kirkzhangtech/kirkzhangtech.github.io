---
title: docker从入门到实践
categories: 
- CICD
tag: Docker
---


- [1. 什么是docker](#1-什么是docker)
- [2.docker镜像基本概念与基本命令](#2docker镜像基本概念与基本命令)
  - [2.1 镜像基本命令](#21-镜像基本命令)
  - [2.2 定制镜像](#22-定制镜像)
    - [2.2.1 使用Dockerfile定制镜像](#221-使用dockerfile定制镜像)
    - [2.2.2 直接用 Git repo构建镜像](#222-直接用-git-repo构建镜像)
    - [2.2.3 用网络位置上tar构建镜像](#223-用网络位置上tar构建镜像)
    - [2.2.4 从标准输入输出定制](#224-从标准输入输出定制)
    - [2.2.5 从标准输入中读取上下文压缩包进行构建](#225-从标准输入中读取上下文压缩包进行构建)
  - [2.3 Dockerfile构建命令详解](#23-dockerfile构建命令详解)
    - [2.3.1 COPY复制](#231-copy复制)
    - [2.3.2 ADD更高级的复制命令](#232-add更高级的复制命令)
    - [2.3.3 CMD容器启动命令](#233-cmd容器启动命令)
    - [2.3.4 ENTRYPOINT 入口点](#234-entrypoint-入口点)
    - [2.3.5 ENV 设置环境变量](#235-env-设置环境变量)
    - [2.3.6 ARG 构建指令](#236-arg-构建指令)
    - [2.3.7 VOLUME 定义匿名卷](#237-volume-定义匿名卷)
    - [2.3.8 EXPOSE 暴露端口](#238-expose-暴露端口)
    - [2.3.9 WORKDIR 指定工作目录](#239-workdir-指定工作目录)
    - [2.3.10 USER指定当前用户](#2310-user指定当前用户)
    - [2.3.11 HEALTHCHECK 健康检查`HEALTHCHECK` 支持下列选项](#2311-healthcheck-健康检查healthcheck-支持下列选项)
    - [2.3.12 ONBUILD 为他人作嫁衣裳](#2312-onbuild-为他人作嫁衣裳)
    - [2.3.13 LABEL 为镜像添加元数据](#2313-label-为镜像添加元数据)
    - [2.3.14 shell指令](#2314-shell指令)
    - [2.3.15 参考文档](#2315-参考文档)
  - [2.4 Dockerfile 多阶段构建](#24-dockerfile-多阶段构建)
  - [实战多阶段构建镜像](#实战多阶段构建镜像)
  - [2.5 构建多种系统架构支持的docker镜像](#25-构建多种系统架构支持的docker镜像)
  - [2.6 其它制作镜像的方式](#26-其它制作镜像的方式)
- [3. 操作容器](#3-操作容器)
  - [3.1 容器基本操作](#31-容器基本操作)
- [4. 访问仓库](#4-访问仓库)
- [5. 数据管理](#5-数据管理)
  - [5.1 数据卷](#51-数据卷)
  - [5.2 挂载主机目录](#52-挂载主机目录)
- [6. 网络](#6-网络)
  - [6.1 端口映射](#61-端口映射)
  - [6.2 容器互联](#62-容器互联)
  - [6.3. 配置DNS](#63-配置dns)
- [7. 高级网络配置](#7-高级网络配置)
- [8. Docker Buildx](#8-docker-buildx)
- [9. Docker Compose](#9-docker-compose)
  - [9.1 搭建一个web应用](#91-搭建一个web应用)
- [10. 安全](#10-安全)
- [11. 底层实现](#11-底层实现)
- [12. Kubernetes](#12-kubernetes)
- [13. 实战案例 - CI/CD](#13-实战案例---cicd)
# 1. 什么是docker

Docker是云技术的一次革新，2013年以Apache协议开源，基于linux内核的**cgroup**,**namespace**以及OverlayFS的**UnionFS**实现，对进程进行封装，属于操作系统层面的虚拟化技术，由于隔离的进程独立于宿主机因此称为容器

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9b5d51fa80b2435386d16496375409c2~tplv-k3u1fbpfcp-watermark.image?)

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/89f40405bc364cd295076c36c9d354e5~tplv-k3u1fbpfcp-watermark.image?)

- 镜像
操作系统分为`内核`和`用户空间`，而docker的镜像就是一种特殊的文件系统，除了提供容器运行所需的程序，库，资源，配置等文件外，还包括为运行时准备的的一些配置参数

- 分层存储
Docker 设计时，就充分利用 [Union FS](https://en.wikipedia.org/wiki/Union_mount) 的技术，将其设计为分层存储的架构。所以严格来说，镜像并非是像一个 `ISO` 那样的打包文件，镜像只是一个虚拟的概念，其实际体现并非由一个文件组成，而是由一组文件系统组成，或者说，由多层文件系统联合组成。

- 容器
容器跟镜像的关系就像是面向对象中类和实例的概念，容器的实质是进程，与宿主机的进程不同，容器拥有自己独立的命空间，因此拥有自己的root文件系统，自己的网络配置，自己的进程空间，自己的用户id空间。进程是运行在一个隔离的环境里，使用起来，就好像是在一个独立于宿主的系统下操作一样。
一个容器运行时，是以镜像为基础层，在其上创建一个当前容器的存储层，我们可以称这个为容器运行时读写而准备的存储层为 **容器存储层**
容器存储层的生存周期和容器一样，容器消亡时，容器存储层也随之消亡。因此，任何保存于容器存储层的信息都会随容器删除而丢失（后面建议挂载volume）

- 仓库
[仓库](https://yeasy.gitbook.io/docker_practice/basic_concept/repository)

# 2.docker镜像基本概念与基本命令

## 2.1 镜像基本命令

拉取镜像:

- docker pull [OPTION] NAME

```text
<域名/IP>[:端口号]
```

运行镜像：

- docker run -it --rm 镜像 [命令 /bin/bash]  参数  
列举镜像：
- docker image ls
- docker images
- docker image ls -f since=mongo:3.2 //查看某个镜像之前创建的镜像，同理也有查看某个镜像之后的镜像
- docker ps = docker container ls //现实运行中的容器
查看镜像体积
- docker system df
虚悬镜像
仓库名和版本号都是none，这是因为新版本的镜像跟旧镜像冲突，，删除虚悬镜像
- docker image prune
- docker image ls -f dangling=true //列举虚悬镜像
- docker image ls -a //有些none镜像不是虚悬镜像是中间镜像
以特定格式显示
- docker image ls -q
- `docker image ls --format "{{ .ID }}:{{ .Repository }}" ` //支持go模板用法,方便其他程序调用
- `docker image ls --format "table {{ .ID }} \t {{ .Repository }} \t {{ .Tag }}"` // 会显示title
删除镜像
- docker image rm [选项] <镜像1> [<镜像2> ...]
- docker image rm $(docker image ls -q redis)  //使用docker image ls命令配合使用

untageged和删除  

- 当该镜像所有的标签都被取消了，该镜像很可能会失去了存在的意义，因此会触发删除行为。镜像是多层存储结构，因此在删除的时候也是从上层向基础层方向依次进行判断删除。镜像的多层结构让镜像复用变得非常容易，因此很有可能某个其它镜像正依赖于当前镜像的某一层。这种情况，依旧不会触发删除该层的行为。直到没有任何层依赖当前层时，才会真实的删除当前层。这就是为什么，有时候会奇怪，为什么明明没有别的标签指向这个镜像，但是它还是存在的原因，也是为什么有时候会发现所删除的层数和自己 `docker pull` 看到的层数不一样的原因  

利用commit来持久化容器变化到镜像(黑箱镜)

```Dockerfile
docker commit \
--author "Tao Wang <twang2218@gmail.com>" \
--message "修改了默认网页" \
webserver \
nginx:v2
```

- `docker history` 具体查看镜像内的历史记录

## 2.2 定制镜像

### 2.2.1 使用Dockerfile定制镜像

**From** 关键字指定基础镜像  
***RUN*** 执行命令,在撰写 Dockerfile 的时候,要经常提醒自己，这并不是在写 Shell 脚本，而是在定义每一层该如何构建，使用docker build 构建编写的Dockerfile  
> `docker` 命令这样的客户端工具，则是通过这组 API 与 Docker 引擎交互，从而完成各种功能,当服务端需要本地文件时候该怎么获得

***COPY***  复制 **上下文（context）** 目录下的源文件
> COPY ./package.json /app/

复制 **上下文（context）** 目录下的 `package.json`,`COPY` 这类指令中的源文件的路径都是*相对路径*。现在就可以理解刚才的命令 `docker build -t nginx:v3 .` 中的这个 `.`，实际上是在指定上下文的目录，`docker build` 命令会将该目录下的内容打包交给 Docker 引擎以帮助构建镜像

- 那么为什么会有人误以为 `.` 是指定 `Dockerfile` 所在目录呢？这是因为在默认情况下，如果不额外指定 `Dockerfile` 的话，会将上下文目录下的名为 `Dockerfile` 的文件作为 Dockerfile
- 如果目录下有些东西确实不希望构建时传给 Docker 引擎，那么可以用 `.gitignore` 一样的语法写一个 `.dockerignore`，该文件是用于剔除不需要作为上下文传递给 Docker 引擎的
- 实际上 `Dockerfile` 的文件名并不要求必须为 `Dockerfile`，而且并不要求必须位于上下文目录中，比如可以用 `-f ../Dockerfile.php` 参数指定某个文件作为 `Dockerfile`

### 2.2.2 直接用 Git repo构建镜像

```Dockerfile
# $env:DOCKER_BUILDKIT=0
# export DOCKER_BUILDKIT=0
$ docker build -t hello-world https://github.com/docker-library/hello-world.git#master:amd64/hello-world
Step 1/3 : FROM scratch
--->
Step 2/3 : COPY hello /
---> ac779757d46e
Step 3/3 : CMD ["/hello"]
---> Running in d2a513a760ed
Removing intermediate container d2a513a760ed
---> 038ad4142d2b
Successfully built 038ad4142d2b
```

### 2.2.3 用网络位置上tar构建镜像

如果所给出的 URL 不是个 Git repo，而是个 `tar` 压缩包，那么 Docker 引擎会下载这个包，并自动解压缩，以其作为上下文，开始构建.  

### 2.2.4 从标准输入输出定制  

docker build - < Dockerfile  
cat Dockerfile | docker build -
因为没有上下文，所以Dockerfile里面不可以使用`copy`  

### 2.2.5 从标准输入中读取上下文压缩包进行构建

docker build - < context.tar.gz
说白了就是解压后进行构建

## 2.3 Dockerfile构建命令详解

### 2.3.1 COPY复制

- 将上下文目录的文件复制到容器中的对应的目录下
- 支持通配符
- 源路径是相对路径，目标路径支持绝对路径
- `COPY` 指令，源文件的各种元数据都会保留。比如读、写、执行权限、文件变更时间等。这个特性对于镜像定制很有用。特别是构建相关文件都在使用 Git 进行管理的时候
- example

```Dockerfile
COPY requirements.txt /code  //copy 文件到容器中的/code目录下
```

### 2.3.2 ADD更高级的复制命令

- 源路径是tar包会在目标路径下解压(非常实用)
- `ADD` 指令会令镜像构建缓存失效，从而可能会令镜像构建变得比较缓慢
- `--chown=<user>:<group>` 选项来改变文件的所属用户及所属组

```
ADD --chown=55:mygroup files* /mydir/
ADD --chown=bin files* /mydir/
ADD --chown=1 files* /mydir/
ADD --chown=10:11 files* /mydir/
```

### 2.3.3 CMD容器启动命令

容器既然是进程，那么启动时就需要指定运行参数  

- example  
`CMD [ "sh", "-c", "echo $HOME" ]`

```Dockerfile
FROM ubuntu:18.04
RUN apt-get update \
&& apt-get install -y curl \
&& rm -rf /var/lib/apt/lists/*
CMD [ "curl", "-s", "http://myip.ipip.net" ]
```

这个时候运行容器，docker run myip 就会打印ip相关信息，但是如果你想加参数`-i`，以如下方式  
`docker run myip -i` 就会报错，因为myip后面传入的参数会被认为是命令，而正确是的方式是  
`docker run myip curl -s http://myip.ipip.net -i`，显然这不是一个好的方案。可以使用2.3.4的参数来设计

### 2.3.4 ENTRYPOINT 入口点

`ENTRYPOINT` 的目的和 `CMD` 一样，都是在指定容器启动程序及参数,例子如下

- 场景一:让镜像像命令一样使用`ENTRYPOINT`

```Dockerfile
FROM ubuntu:18.04
RUN apt-get update \
&& apt-get install -y curl \
&& rm -rf /var/lib/apt/lists/*
ENTRYPOINT [ "curl", "-s", "http://myip.ipip.net" ]
//再次尝试跑 docker run myip -i，就会将-i作为参数传给curl命令
```

- 场景二: 应用运行前的准备工作
比如 `mysql` 类的数据库，可能需要一些数据库配置、初始化的工作，这些工作要在最终的 mysql 服务器运行之前解决。

```Dockerfile
FROM alpine:3.4
RUN addgroup -S redis && adduser -S -G redis redis
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 6379
CMD [ "redis-server" ]
//redis服务创建了redis用户，并在最后ENTRYPOINT指定了entrypoint.sh的脚本,该脚本的内容就是根据CMD的内容
//来判断，如果是redis-server的话，则切换到redis用户身份启动服务器，否则依旧使用root身份执行。比如：
```

### 2.3.5 ENV 设置环境变量

可以为后面的RUN命令提供环境变量，是以键值对的形式存在，如果value部分有空格，需要使用双引号括起来

### 2.3.6 ARG 构建指令

ARG指令有生效范围，如果在FROM之前指定的，那么只能用于`FROM`指令中

```Dockerfile
ARG DOCKER_USERNAME=library
FROM ${DOCKER_USERNAME}/alpine
RUN set -x ; echo ${DOCKER_USERNAME}
```

`RUN`拿不到变量值，要想使用只能是在`FROM`命令后面重新指定`ARG`,多阶段构建需要指定各个阶段的`ARG`

### 2.3.7 VOLUME 定义匿名卷

`VOLUME /data` 挂在匿名卷,向容器/data写入的数据最终会落入host磁盘  
`$ docker run -d -v mydata:/data xxxx`
就使用了 `mydata` 这个命名卷挂载到了 `/data` 这个位置，替代了 `Dockerfile` 中定义的匿名卷的挂载配置

### 2.3.8 EXPOSE 暴露端口

与-p <宿主端口>:<容器端口>, 映射端口不通，EXPOSE是暴漏容器端口给其他容器

### 2.3.9 WORKDIR 指定工作目录

使用 `WORKDIR` 指令可以来指定工作目录（或者称为当前目录），以后各层的当前目录就被改为指定的目录，如该目录不存在，`WORKDIR` 会帮你建立目录

### 2.3.10 USER指定当前用户

`USER` 只是帮助你切换到指定用户而已，这个用户必须是事先建立好的，否则无法切换。

### 2.3.11 HEALTHCHECK 健康检查`HEALTHCHECK` 支持下列选项

- `--interval=<间隔>`：两次健康检查的间隔，默认为 30 秒；
- `--timeout=<时长>`：健康检查命令运行超时时间，如果超过这个时间，本次健康检查就被视为失败，默认 30 秒；
- `--retries=<次数>`：当连续失败指定次数后，则将容器状态视为 `unhealthy`，默认 3 次。

```Dockerfile
FROM nginx
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
HEALTHCHECK --interval=5s --timeout=3s \
CMD curl -fs http://localhost/ || exit 1

//这里我们设置了每 5 秒检查一次（这里为了试验所以间隔非常短，实际应该相对较长），
//如果健康检查命令超过 3 //秒没响应就视为失败，并且使用 `curl -fs http://localhost/ || exit 1`
//作为健康检查命令。
```

### 2.3.12 ONBUILD 为他人作嫁衣裳

### 2.3.13 LABEL 为镜像添加元数据

我们还可以用一些标签来申明镜像的作者、文档地址等：

```shell
LABEL org.opencontainers.image.authors="yeasy"
LABEL org.opencontainers.image.documentation="https://yeasy.gitbooks.io"
```

### 2.3.14 shell指令

`SHELL` 指令可以指定 `RUN` `ENTRYPOINT` `CMD` 指令的 shell程序，Linux 中默认为 `["/bin/sh", "-c"]`

### 2.3.15 参考文档

- `Dockerfie` 官方文档：<https://docs.docker.com/engine/reference/builder/>

- `Dockerfile` 最佳实践文档：<https://docs.docker.com/develop/develop-images/dockerfile_best-practices/>

- `Docker` 官方镜像 `Dockerfile`：<https://github.com/docker-library/docs>

## 2.4 Dockerfile 多阶段构建

- 以前是全部放到一个Dockerfile里面，将编译，测试，打包放在一起，可能导致镜像层次过多，源代码泄露风险
- 分多个Dockerfile编写，然后指定文件逐个构建
- 使用多阶段构建

```Dockerfile
FROM golang:alpine as builder
RUN apk --no-cache add git
WORKDIR /go/src/github.com/go/helloworld/
RUN go get -d -v github.com/go-sql-driver/mysql
COPY app.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .
FROM alpine:latest as prod
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/github.com/go/helloworld/app .
CMD ["./app"]
// 构建镜像  docker build -t go/helloworld:3 .
```

    - 我们可以使用 `as` 来为某一阶段命名，例如`FROM golang:alpine as builder`
    - 例如当我们只想构建 `builder` 阶段的镜像时，增加 `--target=builder` 参数即可 `$ docker build --target builder -t username/imagename:tag .`

- 构建时从其他镜像复制文件
上面例子中我们使用 `COPY --from=0 /go/src/github.com/go/helloworld/app .` 从上一阶段的镜像中复制文件，我们也可以复制任意镜像中的文件  
`$ COPY --from=nginx:latest /etc/nginx/nginx.conf /nginx.conf`

## 实战多阶段构建镜像

[实战地址](https://github.com/nigelpoulton/dotnet-docker-samples.git)  

- 生产环境多阶段构建需要保持镜像精简，可以通过&&精简镜像层
- run指令执行完会残留构建镜像完后的文件，直接上生产及其不妥，docker提供了多种方式解决这个问题，重瞳方式叫`建造者模式`

    1. 构建`Dockerfile.dev`文件
    2. 在此基础之上构建新一层镜像
    3. 编写Dockerfile.prod，把上一步容器的相关代码和文件复制过来

- 多阶段构建方式
分析Dockerfile文件

```Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnetapp/*.csproj ./aspnetapp/
RUN dotnet restore

# copy everything else and build app
COPY aspnetapp/. ./aspnetapp/
WORKDIR /source/aspnetapp
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "aspnetapp.dll"]
```

首先注意到，`Dockerfile`有三个`FROM`指令。每一个`FROM`指令构成一个单独的**构建阶段**  

 1. 阶段`0`：`build-env`
 `build-env`阶段拉取了`aspnetcore-build:2.0`作为基础镜像，然后设置了工作目录，复制一些应用代码，接着执行两个`RUN`指令，生成`1`个镜像层并显著得到一个比原镜像大得多的镜像，包含许多构建工具和应用代码

 2. 阶段`1`：`microsoft/aspnetcore:2.0`
 `aspnetcore:2.0`阶段拉取了`aspnetcore:2.0`作为基础镜像，设置工作目录，然后执行`COPY --from`指令从`build-env`阶段生成的镜像中复制一些应用代码过来，最后执行`ENTRYPOINT`指令指定容器的默认应用程序

上述构建过程的重点在于`COPY --from`指令**表示从之前的构建阶段复制生产环境相关的应用代码，而不会复制生产环境不需要的构件**

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7053651f6091402c9c8ff10c99d1ae34~tplv-k3u1fbpfcp-watermark.image?)

## 2.5 构建多种系统架构支持的docker镜像

`$ docker manifest inspect golang:alpine`  
查看manifest列表

- 创建manifest 列表
- 设置manifest列表
- 查看manifest列表
- 推送manifest列表
- 测试
- [官方博客](https://www.docker.com/blog/multi-arch-all-the-things/)

## 2.6 其它制作镜像的方式

- 从 rootfs 压缩包导入

```docker
$ docker import \
    http://download.openvz.org/template/precreated/ubuntu-16.04-x86_64.tar.gz \
    openvz/ubuntu:16.04

Downloading from http://download.openvz.org/template/precreated/ubuntu-16.04-x86_64.tar.gz
sha256:412b8fc3e3f786dca0197834a698932b9c51b69bd8cf49e100c35d38c9879213
// 从web远程下载ubuntu然后制作镜像
```

- Docker 镜像的导入和导出 `docker save` 和 `docker load` ，目前已经不推荐

# 3. 操作容器

## 3.1 容器基本操作

两种启动容器方式，从镜像到容器，启动停止的容器

- 新建容器

```Dockerfile
$ docker run -dit --name new_name ubuntu:18.04 /bin/echo 'Hello world'
Hello world
```

-itd 意思是指容器绑定标准输入输出，然后绑定个伪终端，然后以守护态运行
要获取容器的输出信息，可以通过 `docker container logs` 命令

- stop/restart 容器
docker container ls //查看容器
docker container restart
docker container stop/start
- 进入容器
`docker attach` 进入容器
`docker exec -it` 进入容器
- 导出/导入容器
`docker export 7691a814370e > ubuntu.tar`  
`docker import - test/ubuntu:v1.0`  
`docker import url`
- 删除容器
`docker container rm trusting_newton`
`docker container prune` 清理所有种植状态的容器

# 4. 访问仓库

1. docker hub
2. 私有仓库
3. 私有仓库高级配置
4. nexus3

# 5. 数据管理

## 5.1 数据卷

对数据卷的使用有点像linux的mount，镜像中被挂载的目录文件会复制到宿主机的目录上，独立于容器

1. 创建一个数据卷

```docker
docker volume create my-vol  创建一个数据卷  
docker volume ls  列举数据卷  
docker volume inspect my_vol 查看某一个数据卷  
```

2. 启动一个挂在了数据卷的容器

```docker
docker run -d -P \
    --name web \
    # -v my-vol:/usr/share/nginx/html \
    --mount source=my-vol,target=/usr/share/nginx/html \
    nginx:alpine
//使用my_vol数据卷，映射到/usr/share/nginx/html
```

3. 查看数据卷具体信息

```docker
docker inspect web //数据卷信息在Mounts key下
....
"Mountpoint": "/var/lib/docker/volumes/my-vol/_data" //默认位置
```

4.删除一个数据卷

```docker
docker volume rm my-vol
docker volume prune //删除无主的数据卷
```

- 数据卷可以在容器间共用
- 对数据卷的修改会立马生效
- 对数据卷的更新，不会影响镜像
- 数据卷默认会一直存在，即使容器被输出

## 5.2 挂载主机目录

1. 挂载目录到容器目录

```docker
$ docker run -d -P \
    --name web \
    # -v /src/webapp:/usr/share/nginx/html \
    --mount type=bind,source=/src/webapp,target=/usr/share/nginx/html, readonly \
    nginx:alpine
```

`挂载主机目录` 的配置信息在 "Mounts" Key 下面

- 目录与容器目录绑定，容器写进文件，就会落盘到宿主机上  
- 目前如果source不存在就会报错  
- 宿主机目录也可以指定readonly  

2. 挂载宿主机文件到容器文件中  
   source=  ,target= 关键字处直接替换成文件

# 6. 网络

## 6.1 端口映射

-P 会随即映射  
-p 特定端口映,可使用多次指定多个端口

- `$ docker run -d -p 80:80 nginx:alpine` hostport:containerport  
- `$ docker run -d -p 127.0.0.1:80:80 nginx:alpine` 指定地址绑定，容器有自己的网络和地址
- `$ docker run -d -p 127.0.0.1::80/udp nginx:alpine` 容器80端口随机映射到主机,并指定传输协议

## 6.2 容器互联

1. 新建网络

```docker
docker network create -d bridge my-net
```

`-d` 参数指定 Docker 网络类型，有 `bridge` `overlay`。其中 `overlay` 网络类型用于 [Swarm mode](/docker_practice/swarm_mode)，在本小节中你可以忽略它
2. 容器互联

```docker
docker run -it --rm --name busybox1 --network my-net busybox sh
docker run -it --rm --name busybox2 --network my-net busybox sh

```

可以直接ping另外的容器

- Docker Compose 可以考虑使用

## 6.3. 配置DNS

TBC

# 7. 高级网络配置

# 8. Docker Buildx

# 9. Docker Compose

结合实战操纵理解

## 9.1 搭建一个web应用

- 服务：运行多个相同镜像的实例
- 项目：一组应用容器组成的一个完整单元
[docker compose](https://docs.docker.com/compose/compose-file/)

# 10. 安全

# 11. 底层实现

# 12. Kubernetes

# 13. 实战案例 - CI/CD
