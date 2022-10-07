---
title: go语言圣经-chapter10-包和工具
categories:
- golang
tag: golang
---

# 10. 包和工具
互联网上已经发布了非常多的Go语言开源包，它们可以通过 http://godoc.org 检索

- 包的声明 ： 通过`package.struct`的形式访问我们的下载的`package`,但是也有同名的例如`math/rand`和`crypto/rand`，这种要重新指定包名，只影响当前文件，同时也解决了那些又臭又长的包名
- 文件开头以`_`和`.`的会被忽略
- 以`_test`结尾的通常是测试包
- 一些依赖版本号的管理工具会在导入路径后追加版本号信息，例如“gopkg.in/yaml.v2”。这种情况下包的名字并不包含版本号后缀，而是yaml
- `包的匿名导入`:
  - 解决包的依赖顺序
  - 初始化包级声明的变量
  - 按顺序初始化包中每个文件里的 init 函数
  - 每个文件中可以包含多个 init 函数，按顺序执行(所以你导和不导包差距很大，匿名导入只是表明你无法使用相应包内函数)
  - 包名和成员名要尽量的短，并且能见名知意
- go的工具
  - 工作区结构 : 当需要切换工作区的时候，只需要更新下GOPATH环境变量即可`src`保存源代码,`pkg`子目录用于保存编译后的包的目标文件,`bin`子目录用于保存编译后的可执行程序
  - 下载包 : `go get`命令，`go get -u`命令只是简单地保证每个下载最新版本，实际工作中要对包版本做精细的管理，需要vendor目录管理不同版本的包,`go help gopath`查看vendor帮助文档,而go get 相当于获取的是远程仓库源代码的整个库，还可以看到仓库的版本信息，go支持导入远程github仓库的代码，`go get`下载的包保存在哪里呢？一般他会保存在这个目录：`GOPATH/src`
  [goget详细介绍](https://www.cnblogs.com/mrbug/p/11990418.html#:~:text=go%20get%20%E4%B8%8B%E8%BD%BD%E7%9A%84%E5%8C%85,%E7%9A%84go%20%E6%96%87%E4%BB%B6%E5%A4%B9%E4%B8%8B%E3%80%82)，`go get`是对模块代码的更新
  - 构建包 : 可以使用相对路径和绝对路径进行构建项目，`go run`其实也可以偷懒，直接`go run *.go`,`go build -i`命令将安装每个目标所依赖的包,`// +build linux darwin`,在包声明和包注释的前面，该构建注释参数告诉`go build`只在编译程序对应的目标操作系统是Linux或Mac OS X时才编译这个文件,`// +build ignore`这个构建注释则表示不编译这个文件。`go doc go/build`
  - 包文档 : 专门用于保存包文档的源文件通常叫`doc.go`,例如 `go doc time` 某个具体成员结构`go doc time.Since`,或者具体函数`go doc time.Duration.Second` , 更简单的是`godoc -http :8000`包含了所有go包的索引，`-analysis=type`和`-analysis=pointer`命令行标志参数用于打开文档和代码中关于静态分析的结果
  - 内部包 : 一个internal包只能被和internal目录有同一个父目录的包所导入。例如，net/http/internal/chunked内部包只能被net/http/httputil或net/http包导入，但是不能被net/url包导入。不过net/url包却可以导入net/http/httputil包
  - 搜索包 : `go list`列出工作区相关包,还可以查看完整包的原信息,例如`hash`包`go list -json hash`
    - 命令行参数-f则允许用户使用text/template包（§4.6）的模板语言定义输出文本的格式
      ```golang
      //windows环境下注意
      go list -f '{{.ImportPath}} -> {{join .Imports " "}}' compress/...
        compress/bzip2 -> bufio io sort
        compress/flate -> bufio fmt io math sort strconv
        compress/gzip -> bufio compress/flate errors fmt hash hash/crc32 io time
        compress/lzw -> bufio errors fmt io
        compress/zlib -> bufio compress/flate errors fmt hash hash/adler32 io
      ```

# 11. 测试

go test选项含义
```bash

-args 传递参数到test binary(到时候补一个demo)
-c 编译test binary,但是不执行
-exec xprog  运行test binary ,原理如同 go run
-i 安装test binary的相关依赖
-json 将测试输出转化为json为了自动化处理
-c file   定义编译后的binary的文件名

```
