---
title: docker从入门到实践
categories: 
- 容器
---

摘要:
<!-- more -->

<!-- toc -->

# 1. docker简介

## 1.1 什么是docker

Docker 最初是 dotCloud 公司创始人  在法国期间发起的一个公司内部项目，它是基于 dotCloud 公司多年云服务技术的一次革新，并于 ，主要项目代码在  上进行维护。Docker 项目后来还加入了 Linux 基金会，并成立推动 。  
Docker 自开源后受到广泛的关注和讨论，至今其  已经超过 5 万 7 千个星标和一万多个 fork。甚至由于 Docker 项目的火爆，在 2013 年底，。Docker 最初是在 Ubuntu 12.04 上开发实现的；Red Hat 则从 RHEL 6.5 开始对 Docker 进行支持；Google 也在其 PaaS 产品中广泛应用 Docker。  
Docker 使用 Google 公司推出的  进行开发实现，基于 Linux 内核的 ，，以及  类的  等技术，对进程进行封装隔离，属于 。由于隔离的进程独立于宿主和其它的隔离的进程，因此也称其为容器。最初实现是基于 ，从 0.7 版本以后开始去除 LXC，转而使用自行开发的 ，从 1.11 版本开始，则进一步演进为使用和  
![docker](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/media/docker-on-linux.png)
`runc` 是一个 Linux 命令行工具，用于根据 OCI容器运行时规范 创建和运行容器。  
`containerd` 是一个守护程序，它管理容器生命周期，提供了在一个节点上执行容器和管理镜像的最小功能集。  
Docker 在容器的基础上，进行了进一步的封装，从文件系统、网络互联到进程隔离等等，极大的简化了容器的创建和维护。使得 Docker 技术比虚拟机技术更为轻便、快捷。  
下面的图片比较了 Docker 和传统虚拟化方式的不同之处。传统虚拟机技术是虚拟出一套硬件后，在其上运行一个完整操作系统，在该系统上再运行所需应用进程；而容器内的应用进程直接运行于宿主的内核，容器内没有自己的内核，而且也没有进行硬件虚拟。因此容器要比传统虚拟机更为轻便。  
![docker](https://3503645665-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2F-M5xTVjmK7ax94c8ZQcm%2Fuploads%2Fgit-blob-6e94771ad01da3cb20e2190b01dfa54e3a69d0b2%2Fvirtualization.png?alt=media)

## 1.2 为什么是docker

作为一种新兴的虚拟化方式，Docker 跟传统的虚拟化方式相比具有众多的优势。  
**更高效的利用系统资源**
由于容器不需要进行硬件虚拟以及运行完整操作系统等额外开销，Docker 对系统资源的利用率更高。无论是应用执行速度、内存损耗或者文件存储速度，都要比传统虚拟机技术更高效。因此，相比虚拟机技术，一个相同配置的主机，往往可以运行更多数量的应用。  
**更快速的启动时间**
传统的虚拟机技术启动应用服务往往需要数分钟，而 Docker 容器应用，由于直接运行于宿主内核，无需启动完整的操作系统，因此可以做到秒级、甚至毫秒级的启动时间。大大的节约了开发、测试、部署的时间。  
**一致的运行环境**
开发过程中一个常见的问题是环境一致性问题。由于开发环境、测试环境、生产环境不一致，导致有些 bug 并未在开发过程中被发现。而 Docker 的镜像提供了除内核外完整的运行时环境，确保了应用运行环境一致性，从而不会再出现 「这段代码在我机器上没问题啊」 这类问题。  
**持续交付和部署**
对开发和运维（DevOps）人员来说，最希望的就是一次创建或配置，可以在任意地方正常运行。使用 Docker 可以通过定制应用镜像来实现持续集成、持续交付、部署。开发人员可以通过 Dockerfile 来进行镜像构建，并结合 持续集成(Continuous Integration) 系统进行集成测试，而运维人员则可以直接在生产环境中快速部署该镜像，甚至结合 持续部署(Continuous Delivery/Deployment) 系统进行自动部署。  
而且使用 Dockerfile 使镜像构建透明化，不仅仅开发团队可以理解应用运行环境，也方便运维团队理解应用运行所需条件，帮助更好的生产环境中部署该镜像。  
**更轻松的迁移**
由于 Docker 确保了执行环境的一致性，使得应用的迁移更加容易。Docker 可以在很多平台上运行，无论是物理机、虚拟机、公有云、私有云，甚至是笔记本，其运行结果是一致的。因此用户可以很轻易的将在一个平台上运行的应用，迁移到另一个平台上，而不用担心运行环境的变化导致应用无法正常运行的情况。  
**更轻松的维护和扩展**
Docker 使用的分层存储以及镜像的技术，使得应用重复部分的复用更为容易，也使得应用的维护更新更加简单，基于基础镜像进一步扩展镜像也变得非常简单。此外，Docker 团队同各个开源项目团队一起维护了一大批高质量的 官方镜像，既可以直接在生产环境使用，又可以作为基础进一步定制，大大的降低了应用服务的镜像制作成本。  
**对比传统虚拟机总结**
|特性|容器|虚拟机|
|---|---|---|
|启动|秒级|分钟级|
|硬盘使用|一般为 MB|一般为 GB|
|性能|接近原生|弱于docker|
|系统支持量|单机支持上千个容器|一般几十个|


## 1.3 章节总结

1. 我为什么要使用docker呢？说实话不知道，但是可以肯定的一点是，构建分布式环境很方便
2. 大致了解到docker与os的关系
3. 1.2节总结了相对于传统的虚拟机的差别和优势,分别从存储,性能，系统部数量等维度分析


# 2.docker镜像基本概念

**镜像**
我们都知道，操作系统分为 内核 和 用户空间。对于 Linux 而言，内核启动后，会挂载 root 文件系统为其提供用户空间支持。而 Docker 镜像（Image），就相当于是一个 root 文件系统。比如官方镜像 ubuntu:18.04 就包含了完整的一套 Ubuntu 18.04 最小系统的 root 文件系统。
Docker 镜像 是一个特殊的文件系统，除了提供容器运行时所需的程序、库、资源、配置等文件外，还包含了一些为运行时准备的一些配置参数（如匿名卷、环境变量、用户等）。镜像 不包含 任何动态数据，其内容在构建之后也不会被改变。

**分层存储**
因为镜像包含操作系统完整的 root 文件系统，其体积往往是庞大的，因此在 Docker 设计时，就充分利用 Union FS 的技术，将其设计为分层存储的架构。所以严格来说，镜像并非是像一个 ISO 那样的打包文件，镜像只是一个虚拟的概念，其实际体现并非由一个文件组成，而是由一组文件系统组成，或者说，由多层文件系统联合组成。  
镜像构建时，会一层层构建，前一层是后一层的基础。每一层构建完就不会再发生改变，后一层上的任何改变只发生在自己这一层。比如，删除前一层文件的操作，实际不是真的删除前一层的文件，而是仅在当前层标记为该文件已删除。在最终容器运行的时候，虽然不会看到这个文件，但是实际上该文件会一直跟随镜像。因此，在构建镜像的时候，需要额外小心，每一层尽量只包含该层需要添加的东西，任何额外的东西应该在该层构建结束前清理掉。
分层存储的特征还使得镜像的复用、定制变的更为容易。甚至可以用之前构建好的镜像作为基础层，然后进一步添加新的层，以定制自己所需的内容，构建新的镜像。
关于镜像构建，将会在后续相关章节中做进一步的讲解。

**容器**
镜像（Image）和容器（Container）的关系，就像是面向对象程序设计中的 类 和 实例 一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。容器的实质是进程，但与直接在宿主执行的进程不同，容器进程运行于属于自己的独立的 命名空间。因此容器可以拥有自己的 root 文件系统、自己的网络配置、自己的进程空间，甚至自己的用户 ID 空间。容器内的进程是运行在一个隔离的环境里，使用起来，就好像是在一个独立于宿主的系统下操作一样。这种特性使得容器封装的应用比直接在宿主运行更加安全。也因为这种隔离的特性，很多人初学 Docker 时常常会混淆容器和虚拟机。前面讲过镜像使用的是分层存储，容器也是如此。每一个容器运行时，是以镜像为基础层，在其上创建一个当前容器的存储层，我们可以称这个为容器运行时读写而准备的存储层为 容器存储层。容器存储层的生存周期和容器一样，容器消亡时，容器存储层也随之消亡。因此，任何保存于容器存储层的信息都会随容器删除而丢失。按照 Docker 最佳实践的要求，容器不应该向其存储层内写入任何数据，容器存储层要保持无状态化。所有的文件写入操作，都应该使用 数据卷（Volume）、或者 绑定宿主目录，在这些位置的读写会跳过容器存储层，直接对宿主（或网络存储）发生读写，其性能和稳定性更高。数据卷的生存周期独立于容器，容器消亡，数据卷不会消亡。因此，使用数据卷后，容器删除或者重新运行之后，数据却不会丢失。

**仓库**
镜像构建完成后，可以很容易的在当前宿主机上运行，但是，如果需要在其它服务器上使用这个镜像，我们就需要一个集中的存储、分发镜像的服务，Docker Registry 就是这样的服务。一个 Docker Registry 中可以包含多个 仓库（Repository）；每个仓库可以包含多个 标签（Tag）；每个标签对应一个镜像。通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应该软件的各个版本。我们可以通过 <仓库名>:<标签> 的格式来指定具体是这个软件哪个版本的镜像。如果不给出标签，将以 latest 作为默认标签。以 Ubuntu 镜像 为例，ubuntu 是仓库的名字，其内包含有不同的版本标签，如，16.04, 18.04。我们可以通过 ubuntu:16.04，或者 ubuntu:18.04 来具体指定所需哪个版本的镜像。如果忽略了标签，比如 ubuntu，那将视为 ubuntu:latest。仓库名经常以 两段式路径 形式出现，比如 `jwilder/nginx-proxy`，前者往往意味着 Docker Registry 多用户环境下的用户名，后者则往往是对应的软件名。但这并非绝对，取决于所使用的具体 Docker Registry 的软件或服务。

**Docker Registry公开服务**
Docker Registry 公开服务是开放给用户使用、允许用户管理镜像的 Registry 服务。一般这类公开服务允许用户免费上传、下载公开的镜像，并可能提供收费服务供用户管理私有镜像。
最常使用的 Registry 公开服务是官方的 Docker Hub，这也是默认的 Registry，并拥有大量的高质量的 官方镜像。除此以外，还有 Red Hat 的 Quay.io；Google 的 Google Container Registry，Kubernetes 的镜像使用的就是这个服务；代码托管平台 GitHub 推出的 ghcr.io。
由于某些原因，在国内访问这些服务可能会比较慢。国内的一些云服务商提供了针对 Docker Hub 的镜像服务（Registry Mirror），这些镜像服务被称为 加速器。常见的有 阿里云加速器、DaoCloud 加速器 等。使用加速器会直接从国内的地址下载 Docker Hub 的镜像，比直接从 Docker Hub 下载速度会提高很多。在 安装 Docker 一节中有详细的配置方法。
国内也有一些云服务商提供类似于 Docker Hub 的公开服务。比如 网易云镜像服务、DaoCloud 镜像市场、阿里云镜像库 等。

**私有 Docker Registry**
除了使用公开服务外，用户还可以在本地搭建私有 Docker Registry。Docker 官方提供了 Docker Registry 镜像，可以直接使用做为私有 Registry 服务。在 私有仓库 一节中，会有进一步的搭建私有 Registry 服务的讲解。
开源的 Docker Registry 镜像只提供了 Docker Registry API 的服务端实现，足以支持 docker 命令，不影响使用。但不包含图形界面，以及镜像维护、用户管理、访问控制等高级功能。
除了官方的 Docker Registry 外，还有第三方软件实现了 Docker Registry API，甚至提供了用户界面以及一些高级功能。比如，Harbor 和 Sonatype Nexus。

## 2.2 章节总结

1. (镜像)分层存储简而言之就是作者们想复用文件层，然后减少文件体积，方便定制化
2. 容器存储层的生存周期和容器一样，容器消亡时，容器存储层也随之消亡
3. 仓库说白了就是个存储用户的镜像的中心仓库，有共有仓库，还有私有仓库


# 3. 安装docker
网站上有各个环境的[安装教程](https://docs.docker.com/get-docker/)


# 4. 使用镜像

## 4.1 获取镜像

之前提到过，Docker Hub 上有大量的高质量的镜像可以用，这里我们就说一下怎么获取这些镜像。
从 Docker 镜像仓库获取镜像的命令是 docker pull。其命令格式为：

```docker
$ docker pull [选项] [Docker Registry 地址[:端口号]/]  仓库名[:标签]
```

-具体的选项可以通过 docker pull --help 命令看到，这里我们说一下镜像名称的格式。

- Docker 镜像仓库地址：地址的格式一般是 <域名/IP>[:端口号]。默认地址是 Docker Hub(docker.io)。

- 仓库名：如之前所说，这里的仓库名是两段式名称，即 <用户名>/<软件名>。对于 Docker Hub，如果不给出用户名，则默认为 library，也就是官方镜像。
比如：

```docker
$ docker pull ubuntu:18.04
18.04: Pulling from library/ubuntu
92dc2a97ff99: Pull complete
be13a9d27eb8: Pull complete
c8299583700a: Pull complete
Digest: sha256:4bc3ae6596938cb0d9e5ac51a1152ec9dcac2a1c50829c74abd9c4361e321b26
Status: Downloaded newer image for ubuntu:18.04
docker.io/library/ubuntu:18.04
```

上面的命令中没有给出 Docker 镜像仓库地址，因此将会从 Docker Hub （docker.io）获取镜像。而镜像名称是 ubuntu:18.04，因此将会获取官方镜像 library/ubuntu 仓库中标签为 18.04 的镜像。docker pull 命令的输出结果最后一行给出了镜像的完整名称，即： docker.io/library/ubuntu:18.04。
从下载过程中可以看到我们之前提及的分层存储的概念，镜像是由多层存储所构成。下载也是一层层的去下载，并非单一文件。下载过程中给出了每一层的 ID 的前 12 位。并且下载结束后，给出该镜像完整的 sha256 的摘要，以确保下载一致性。
在使用上面命令的时候，你可能会发现，你所看到的层 ID 以及 sha256 的摘要和这里的不一样。这是因为官方镜像是一直在维护的，有任何新的 bug，或者版本更新，都会进行修复再以原来的标签发布，这样可以确保任何使用这个标签的用户可以获得更安全、更稳定的镜像。
如果从 Docker Hub 下载镜像非常缓慢，可以参照 镜像加速器 一节配置加速器。

**运行**

有了镜像后，我们就能够以这个镜像为基础启动并运行一个容器。以上面的 ubuntu:18.04 为例，如果我们打算启动里面的 bash 并且进行交互式操作的话，可以执行下面的命令。
```docker
$ docker run -it --rm ubuntu:18.04 bash

root@e7009c6ce357:/# cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04.1 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.1 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
```
`docker run`就是运行容器的命令，具体格式我们会在`容器`一节进行详细讲解，我们这里简要的说明一下上面用到的参数。
`-it`：这是两个参数，一个是 -i：交互式操作，一个是 -t 终端。我们这里打算进入 bash 执行一些命令并查看返回结果，因此我们需要交互式终端。
`--rm`：这个参数是说容器退出后随之将其删除。默认情况下，为了排障需求，退出的容器并不会立即删除，除非手动 docker rm。我们这里只是随便执行个命令，看看结果，不需要排障和保留结果，因此使用 --rm 可以避免浪费空间。
`ubuntu:18.04`：这是指用 ubuntu:18.04 镜像为基础来启动容器。
`bash`：放在镜像名后的是 命令，这里我们希望有个交互式 Shell，因此用的是 bash。
进入容器后，我们可以在 Shell 下操作，执行任何所需的命令。这里，我们执行了 `cat /etc/os-release`，这是 Linux 常用的查看当前系统版本的命令，从返回的结果可以看到容器内是 Ubuntu 18.04.1 LTS 系统。
最后我们通过 exit 退出了这个容器。
summary:
1. 大陆要换镜像源
2. `docker pull`命令的使用,`docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]`可以使用`docekr pull --help`查看具体命令
   1. 会打印出分层的镜像日志
   2. 下载结束后，给出该镜像完整的 sha256 的摘要，以确保下载一致性
3. `docker run` 命令
   1. -it参数
   2. --rm 参数
   3. ubuntu:20.04 参数
   4. bash 参数,一般是/usr/bash
4. `cat /etc/os-release`查看版本信息


## 4.2 列出镜像

要想列出已经下载下来的镜像，可以使用 `docker image ls` 命令。
```docker
$ docker image ls
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
redis                latest              5f515359c7f8        5 days ago          183 MB
nginx                latest              05a60462f8ba        5 days ago          181 MB
mongo                3.2                 fe9198c04d62        5 days ago          342 MB
<none>               <none>              00285df0df87        5 days ago          342 MB
ubuntu               18.04               329ed837d508        3 days ago          63.3MB
ubuntu               bionic              329ed837d508        3 days ago          63.3MB
```

列表包含了 仓库名、标签、镜像 ID、创建时间 以及 所占用的空间。
其中仓库名、标签在之前的基础概念章节已经介绍过了。镜像 ID 则是镜像的唯一标识，一个镜像可以对应多个 标签。因此，在上面的例子中，我们可以看到 ubuntu:18.04 和 ubuntu:bionic 拥有相同的 ID，因为它们对应的是同一个镜像。

**镜像体积**

如果仔细观察，会注意到，这里标识的所占用空间和在 Docker Hub 上看到的镜像大小不同。比如，ubuntu:18.04 镜像大小，在这里是 63.3MB，但是在 Docker Hub 显示的却是 25.47 MB。这是因为 Docker Hub 中显示的体积是压缩后的体积。在镜像下载和上传过程中镜像是保持着压缩状态的，因此 Docker Hub 所显示的大小是网络传输中更关心的流量大小。而 docker image ls 显示的是镜像下载到本地后，展开的大小，准确说，是展开后的各层所占空间的总和，因为镜像到本地后，查看空间的时候，更关心的是本地磁盘空间占用的大小。
另外一个需要注意的问题是，docker image ls 列表中的镜像体积总和并非是所有镜像实际硬盘消耗。由于 Docker 镜像是多层存储结构，并且可以继承、复用，因此不同镜像可能会因为使用相同的基础镜像，从而拥有共同的层。由于 Docker 使用 Union FS，相同的层只需要保存一份即可，因此实际镜像硬盘占用空间很可能要比这个列表镜像大小的总和要小的多。
你可以通过 `docker system df` 命令来便捷的查看镜像、容器、数据卷所占用的空间。

```docker
docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              24                  0                   1.992GB             1.992GB (100%)
Containers          1                   0                   62.82MB             62.82MB (100%)
Local Volumes       9                   0                   652.2MB             652.2MB (100%)
Build Cache 
```

**虚悬镜像**

上面的镜像列表中，还可以看到一个特殊的镜像，这个镜像既没有仓库名，也没有标签，均为 < none >:

这个镜像原本是有镜像名和标签的，原来为 mongo:3.2，随着官方镜像维护，发布了新版本后，重新 docker pull mongo:3.2 时，mongo:3.2 这个镜像名被转移到了新下载的镜像身上，而旧的镜像上的这个名称则被取消，从而成为了 < none >。除了 `docker pull` 可能导致这种情况，`docker build` 也同样可以导致这种现象。由于新旧镜像同名，旧镜像名称被取消，从而出现仓库名、标签均为 <none> 的镜像。这类无标签镜像也被称为 虚悬镜像(dangling image) ，可以用下面的命令专门显示这类镜像:

```docker
docker image ls -f dangling=true
```

一般来说，虚悬镜像已经失去了存在的价值，是可以随意删除的，可以用下面的命令删除

```docker
docker image prune
```

**中间层镜像**

为了加速镜像构建、重复利用资源，Docker 会利用 中间层镜像。所以在使用一段时间后，可能会看到一些依赖的中间层镜像。默认的 docker image ls 列表中只会显示顶层镜像，如果希望显示包括中间层镜像在内的所有镜像的话，需要加 -a 参数。
```docker
docker image ls -a
```
这样会看到很多无标签的镜像，与之前的虚悬镜像不同，这些无标签的镜像很多都是中间层镜像，是其它镜像所依赖的镜像。这些无标签镜像不应该删除，否则会导致上层镜像因为依赖丢失而出错。实际上，这些镜像也没必要删除，因为之前说过，相同的层只会存一遍，而这些镜像是别的镜像的依赖，因此并不会因为它们被列出来而多存了一份，无论如何你也会需要它们。只要删除那些依赖它们的镜像后，这些依赖的中间层镜像也会被连带删除。

**列出部分镜像**

不加任何参数的情况下，docker image ls 会列出所有顶层镜像，但是有时候我们只希望列出部分镜像。docker image ls 有好几个参数可以帮助做到这个事情。
根据仓库名列出镜像
```docekr
docker image ls ubuntu
```
列出特定的某个镜像，也就是说指定仓库名和标签
```docker
docker image ls ubuntu:18.04
```
除此以外，`docker image ls` 还支持强大的过滤器参数 `--filter`，或者简写 `-f`。之前我们已经看到了使用过滤器来列出虚悬镜像的用法，它还有更多的用法。比如，我们希望看到在 mongo:3.2 之后建立的镜像，可以用下面的命令：
```docker
docker image ls -f since=mongo:3.2
```
想查看某个位置之前的镜像也可以，只需要把 since 换成 before 即可。
此外，如果镜像构建时，定义了 LABEL，还可以通过 LABEL 来过滤。
```docker
docker image ls -f label=com.example.version=0.1
```
**以特定格式显示**
默认情况下，docker image ls 会输出一个完整的表格，但是我们并非所有时候都会需要这些内容。比如，刚才删除虚悬镜像的时候，我们需要利用 docker image ls 把所有的虚悬镜像的 ID 列出来，然后才可以交给 docker image rm 命令作为参数来删除指定的这些镜像，这个时候就用到了 -q 参数
```docker
docker image ls -q
```
--filter 配合 -q 产生出指定范围的 ID 列表，然后送给另一个 docker 命令作为参数，从而针对这组实体成批的进行某种操作的做法在 Docker 命令行使用过程中非常常见，不仅仅是镜像，将来我们会在各个命令中看到这类搭配以完成很强大的功能。因此每次在文档看到过滤器后，可以多注意一下它们的用法。
另外一些时候，我们可能只是对表格的结构不满意，希望自己组织列；或者不希望有标题，这样方便其它程序解析结果等，这就用到了 [Go的模板语法](https://gohugo.io/templates/introduction/)。
比如，下面的命令会直接列出镜像结果，并且只包含镜像ID和仓库名：
```docker
docker image ls --format "{ { .ID } }: { { .Repository } }"
```
或者打算以表格等距显示，并且有标题行，和默认一样，不过自己定义列：
```docker
$ docker image ls --format "table { { .ID } } \t { { .Repository } } \t { { .Tag } }"
IMAGE ID            REPOSITORY          TAG
5f515359c7f8        redis               latest
05a60462f8ba        nginx               latest
fe9198c04d62        mongo               3.2
00285df0df87        <none>              <none>
329ed837d508        ubuntu              18.04
329ed837d508        ubuntu              bionic
```

summary: 

- `docker image ls` 列举镜像
- `docker images`
- `docker image ls -f since=mongo:3.2` //查看某个镜像之前创建的镜像，同理也有查看某个镜像之后的镜像
- `docker ps = docker container ls` //现实运行中的容器

- `docker system df` //查看镜像体积


虚悬镜像:仓库名和版本号都是none，这是因为新版本的镜像跟旧镜像冲突，，删除虚悬镜像 

- `docker image prune`
- `docker image ls -f dangling=true` //列举虚悬镜像
- `docker image ls -a` //有些none镜像不是虚悬镜像是中间镜像


以特定格式显示

- `docker image ls -q`
- `docker image ls --format "{ { .ID } }:{ { .Repository } }" ` //支持go模板用法,方便其他程序调用
- `docker image ls --format "table { { .ID } } \t { { .Repository } } \t { { .Tag } }"` // 会显示title

## 2.1 镜像基本命令


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
