---
title: go语言圣经
categories:
- golang
---

摘要: Go语言有时候被描述为"C类似语言",或者是“21世纪的C语言”。Go从C语言继承了相似的表达式语法、控制流结构、基础数据类型、调用参数传值、指针等很多思想，还有C语言一直所看中的编译后机器码的运行效率以及和现有操作系统的无缝适配。

<!-- more -->
<!-- toc -->

# go语言项目

所有的编程语言都反映了语言设计者对编程哲学的反思，通常包括之前的语言所暴露的一些不足地方的改进。Go项目是在Google公司维护超级复杂的几个软件系统遇到的一些问题的反思（但是这类问题绝不是Google公司所特有的）。

正如Rob Pike所说，“软件的复杂性是乘法级相关的”，通过增加一个部分的复杂性来修复问题通常将慢慢地增加其他部分的复杂性。通过增加功能、选项和配置是修复问题的最快的途径，但是这很容易让人忘记简洁的内涵，即从长远来看，简洁依然是好软件的关键因素。

简洁的设计需要在工作开始的时候舍弃不必要的想法，并且在软件的生命周期内严格区别好的改变和坏的改变。通过足够的努力，一个好的改变可以在不破坏原有完整概念的前提下保持自适应，正如Fred Brooks所说的“概念完整性”；而一个坏的改变则不能达到这个效果，它们仅仅是通过肤浅的和简单的妥协来破坏原有设计的一致性。只有通过简洁的设计，才能让一个系统保持稳定、安全和持续的进化。

Go项目包括编程语言本身，附带了相关的工具和标准库，最后但并非代表不重要的是，关于简洁编程哲学的宣言。就事后诸葛的角度来看，Go语言的这些地方都做的还不错：拥有自动垃圾回收、一个包系统、函数作为一等公民、词法作用域、系统调用接口、只读的UTF8字符串等。但是Go语言本身只有很少的特性，也不太可能添加太多的特性。例如，它没有隐式的数值转换，没有构造函数和析构函数，没有运算符重载，没有默认参数，也没有继承，没有泛型，没有异常，没有宏，没有函数修饰，更没有线程局部存储。但是，语言本身是成熟和稳定的，而且承诺保证向后兼容：用之前的Go语言编写程序可以用新版本的Go语言编译器和标准库直接构建而不需要修改代码。

Go语言有足够的类型系统以避免动态语言中那些粗心的类型错误，但是，Go语言的类型系统相比传统的强类型语言又要简洁很多。虽然，有时候这会导致一个“无类型”的抽象类型概念，但是Go语言程序员并不需要像C++或Haskell程序员那样纠结于具体类型的安全属性。在实践中，Go语言简洁的类型系统给程序员带来了更多的安全性和更好的运行时性能。

Go语言鼓励当代计算机系统设计的原则，特别是局部的重要性。它的内置数据类型和大多数的准库数据结构都经过精心设计而避免显式的初始化或隐式的构造函数，因为很少的内存分配和内存初始化代码被隐藏在库代码中了。Go语言的聚合类型（结构体和数组）可以直接操作它们的元素，只需要更少的存储空间、更少的内存写操作，而且指针操作比其他间接操作的语言也更有效率。由于现代计算机是一个并行的机器，Go语言提供了基于CSP的并发特性支持。Go语言的动态栈使得轻量级线程goroutine的初始栈可以很小，因此，创建一个goroutine的代价很小，创建百万级的goroutine完全是可行的。

Go语言的标准库（通常被称为语言自带的电池），提供了清晰的构建模块和公共接口，包含I/O操作、文本处理、图像、密码学、网络和分布式应用程序等，并支持许多标准化的文件格式和编解码协议。库和工具使用了大量的约定来减少额外的配置和解释，从而最终简化程序的逻辑，而且，每个Go程序结构都是如此的相似，因此，Go程序也很容易学习。使用Go语言自带工具构建Go语言项目只需要使用文件名和标识符名称，一个偶尔的特殊注释来确定所有的库、可执行文件、测试、基准测试、例子、以及特定于平台的变量、项目的文档等；Go语言源代码本身就包含了构建规范。

# 1. 入门

## 1.1. hello_world

我们以现已成为传统的“hello world”案例来开始吧，这个例子首次出现于 1978 年出版的 C 语言圣经 《The C Programming Language》（译注：本书作者之一 Brian W. Kernighan 也是《The C Programming Language》一书的作者）。C 语言是直接影响 Go 语言设计的语言之一。这个例子体现了 Go 语言一些核心理念。

```golang

package main

import "fmt"

func main() {
    fmt.Println("Hello, 世界")
}
```

Go 是一门编译型语言，Go 语言的工具链将源代码及其依赖转换成计算机的机器指令（译注：静态编译）。Go 语言提供的工具都通过一个单独的命令 go 调用，go 命令有一系列子命令。最简单的一个子命令就是 run。这个命令编译一个或多个以。`.go` 结尾的源文件，链接库文件，并运行最终生成的可执行文件。（本书使用$表示命令行提示符。）

```bash
go run helloworld.go
```

毫无意外，这个命令会输出
Hello, 世界
Go 语言原生支持 Unicode，它可以处理全世界任何语言的文本。
如果不只是一次实验，你肯定希望能够编译这个程序，保存编译结果以备将来之用。可以用 build 子命令：

```bash
go build helloworld.go
```

这个命令生成一个名为 helloworld 的可执行的二进制文件(译注:Windows系统下生成的可执行文件是 helloworld.exe,增加了.exe后缀名)，之后你可以随时运行它(译注：在 Windows 系统下在命令行直接输入 helloworld.exe 命令运行),不需任何处理(译注：因为静态编译，所以不用担心在系统库更新的时候冲突，幸福感满满)

```bash
helloworld
```

Hello, 世界

本书中所有示例代码上都有一行标记，利用这些标记可以从 gopl.io 网站上本书源码仓库里获取代码;`gopl.io/ch1/helloworld`执行 `go get gopl.io/ch1/helloworld`命令，就会从网上获取代码，并放到对应目录中（需要先安装 Git 或 Hg 之类的版本管理工具，并将对应的命令添加到 PATH 环境变量中。序言已经提及，需要先设置好 GOPATH 环境变量，下载的代码会放在 `$GOPATH/src/gopl.io/ch1/helloworld` 目录）。2.6 和 10.7 节有这方面更详细的介绍。

来讨论下程序本身。Go 语言的代码通过包(package)组织，包类似于其它语言里的库(libraries)或者模块(modules)。一个包由位于单个目录下的一个或多个 .go 源代码文件组成，目录定义包的作用。每个源文件都以一条 package 声明语句开始，这个例子里就是 package main，表示该文件属于哪个包，紧跟着一系列导入（import）的包，之后是存储在这个文件里的程序语句。

Go 的标准库提供了 100 多个包，以支持常见功能，如输入、输出、排序以及文本处理。比如 fmt 包，就含有格式化输出、接收输入的函数。Println 是其中一个基础函数，可以打印以空格间隔的一个或多个值，并在最后添加一个换行符，从而输出一整行。

main包比较特殊。它定义了一个独立可执行的程序，而不是一个库。在main里的main函数也很特殊，它是整个程序执行时的入口（译注：C 系语言差不多都这样）。main 函数所做的事情就是程序做的。当然了，main 函数一般调用其它包里的函数完成很多工作（如：fmt.Println）。

必须告诉编译器源文件需要哪些包，这就是跟随在 package 声明后面的import声明扮演的角色。hello world 例子只用到了一个包，大多数程序需要导入多个包。

必须恰当导入需要的包，缺少了必要的包或者导入了不需要的包，程序都无法编译通过。这项严格要求避免了程序开发过程中引入未使用的包（译注：Go 语言编译过程没有警告信息，争议特性之一）。

import 声明必须跟在文件的 package 声明之后。随后，则是组成程序的函数、变量、常量、类型的声明语句（分别由关键字 func、var、const、type 定义）。这些内容的声明顺序并不重要（译注：最好还是定一下规范）。这个例子的程序已经尽可能短了，只声明了一个函数，其中只调用了一个其他函数。为了节省篇幅，有些时候示例程序会省略 package 和 import 声明，但是，这些声明在源代码里有，并且必须得有才能编译。

一个函数的声明由 func 关键字、函数名、参数列表、返回值列表（这个例子里的 main 函数参数列表和返回值都是空的）以及包含在大括号里的函数体组成。第五章进一步考察函数。

Go 语言不需要在语句或者声明的末尾添加分号，除非一行上有多条语句。实际上，编译器会主动把特定符号后的换行符转换为分号，因此换行符添加的位置会影响 Go 代码的正确解析（译注：比如行末是标识符、整数、浮点数、虚数、字符或字符串文字、关键字 break、continue、fallthrough或 return 中的一个、运算符和分隔符 ++、--、)、] 或 } 中的一个）。举个例子，函数的左括号 { 必须和 func 函数声明在同一行上，且位于末尾，不能独占一行，而在表达式 x+y 中，可在 + 后换行，不能在 + 前换行（译注：以+结尾的话不会被插入分号分隔符，但是以 x 结尾的话则会被分号分隔符，从而导致编译错误）。

Go 语言在代码格式上采取了很强硬的态度。gofmt工具把代码格式化为标准格式（译注：这个格式化工具没有任何可以调整代码格式的参数，Go 语言就是这么任性），并且 go 工具中的 fmt 子命令会对指定包，否则默认为当前目录中所有。go 源文件应用 gofmt 命令。本书中的所有代码都被 gofmt 过。你也应该养成格式化自己的代码的习惯。以法令方式规定标准的代码格式可以避免无尽的无意义的琐碎争执（译注：也导致了 Go 语言的 TIOBE 排名较低，因为缺少撕逼的话题）。更重要的是，这样可以做多种自动源码转换，如果放任 Go 语言代码格式，这些转换就不大可能了。

很多文本编辑器都可以配置为保存文件时自动执行 gofmt，这样你的源代码总会被恰当地格式化。还有个相关的工具：goimports，可以根据代码需要，自动地添加或删除 import 声明。这个工具并没有包含在标准的分发包中，可以用下面的命令安装：

`$ go get golang.org/x/tools/cmd/goimports`
对于大多数用户来说，下载、编译包、运行测试用例、察看 Go 语言的文档等等常用功能都可以用 go 的工具完成节详细介绍这些知识。

summary:  
1. go拥有完整的工具链，通常是go的子命令，在命令输入go关键字就可以查看子命令
2. Go 语言原生支持 Unicode，它可以处理全世界任何语言的文本。
3. 编写完程序就可以编译成二进制可执行程序使用`go build`
   1. `go help build` 查看build文档
   2. go build 选项列表及说明,语法为`usage: go build [-o output] [build flags] [packages]`
        ```text
        -o      指定编译输出的软件名称
        -i      安装作为目标的依赖关系的包(用于增量编译提速)
        -a      强制重建已经是最新版本的软件包 
        -n      print the commands but do not run them(只是输出一些运行过程)
        -p n    the number of programs, such as build commands or (指定内核数量编译程序，包括test binary)
                test binaries, that can be run in parallel.
                The default is GOMAXPROCS, normally the number of CPUs available.
        -race   (同时检测数据竞争状态，只支持 linux/amd64, freebsd/amd64, darwin/amd64 和 windows/amd64)
                enable data race detection.
                Supported only on linux/amd64, freebsd/amd64, darwin/amd64, darwin/arm64, windows/amd64,
                linux/ppc64le and linux/arm64 (only for 48-bit VMA).
        -msan   (启用与内存消毒器的互操作。仅支持linux / amd64，并且只用Clang / LLVM作为主机C编译器（少用))
                enable interoperation with memory sanitizer.
                Supported only on linux/amd64, linux/arm64
                and only with Clang/LLVM as the host C compiler.
                On linux/arm64, pie build mode will be used.
        -asan
                enable interoperation with address sanitizer.
                Supported only on linux/arm64, linux/amd64.
        -v      (打印名称)
                print the names of packages as they are compiled.
        -work   (打印临时工作目录名称)
                print the name of the temporary work directory and
                do not delete it when exiting.
        -x      打印输出 执行命令名
                print the commands.

        -asmflags '[pattern=]arg list'   (传递每个go工具asm调用的参数)
                arguments to pass on each go tool asm invocation.
        -buildmode mode             (编译模式 go help buildmode)
                build mode to use. See 'go help buildmode' for more.
        -buildvcs                   ()
                Whether to stamp binaries with version control information
                ("true", "false", or "auto"). By default ("auto"), version control
                information is stamped into a binary if the main package, the main module
                containing it, and the current directory are all in the same repository.
                Use -buildvcs=false to always omit version control information, or
                -buildvcs=true to error out if version control information is available but
                cannot be included due to a missing tool or ambiguous directory structure.
        -compiler name  (指定编译器)
                name of compiler to use, as in runtime.Compiler (gccgo or gc).
        -gccgoflags '[pattern=]arg list'  gccgo编译/连接器参数
                arguments to pass on each gccgo compiler/linker invocation.
        -gcflags '[pattern=]arg list'   垃圾回收参数
                arguments to pass on each go tool compile invocation.
        -installsuffix suffix           (压缩编译后体积)
                a suffix to use in the name of the package installation directory,
                in order to keep output separate from default builds.
                If using the -race flag, the install suffix is automatically set to race
                or, if set explicitly, has _race appended to it. Likewise for the -msan
                and -asan flags. Using a -buildmode option that requires non-default compile
                flags has a similar effect.
        -ldflags '[pattern=]arg list'
                arguments to pass on each go tool link invocation.
        -linkshared             (链接到以前共享库)
                build code that will be linked against shared libraries previously
                created with -buildmode=shared.
        -mod mode
                module download mode to use: readonly, vendor, or mod.
                By default, if a vendor directory is present and the go version in go.mod
                is 1.14 or higher, the go command acts as if -mod=vendor were set.
                Otherwise, the go command acts as if -mod=readonly were set.
                See https://golang.org/ref/mod#build-commands for details.
        -modcacherw
                leave newly-created directories in the module cache read-write
                instead of making them read-only.
        -modfile file
                in module aware mode, read (and possibly write) an alternate go.mod
                file instead of the one in the module root directory. A file named
                "go.mod" must still be present in order to determine the module root
                directory, but it is not accessed. When -modfile is specified, an
                alternate go.sum file is also used: its path is derived from the
                -modfile flag by trimming the ".mod" extension and appending ".sum".
        -overlay file
                read a JSON config file that provides an overlay for build operations.
                The file is a JSON struct with a single field, named 'Replace', that
                maps each disk file path (a string) to its backing file path, so that
                a build will run as if the disk file path exists with the contents
                given by the backing file paths, or as if the disk file path does not
                exist if its backing file path is empty. Support for the -overlay flag
                has some limitations: importantly, cgo files included from outside the
                include path must be in the same directory as the Go package they are
                included from, and overlays will not appear when binaries and tests are
                run through go run and go test respectively.
        -pkgdir dir     (从指定位置，而不是通常的位置安装和加载所有软件包。例如，当使用非标准配置构建时，使用-pkgdir将生成的包保留在单独的位置。)
                install and load all packages from dir instead of the usual locations.
                For example, when building with a non-standard configuration,
                use -pkgdir to keep generated packages in a separate location.
        -tags tag,list  (构建出带tag的版本.)
                a comma-separated list of build tags to consider satisfied during the
                build. For more information about build tags, see the description of
                build constraints in the documentation for the go/build package.
                (Earlier versions of Go used a space-separated list, and that form
                is deprecated but still recognized.)
        -trimpath
                remove all file system paths from the resulting executable.
                Instead of absolute file system paths, the recorded file names
                will begin either a module path@version (when using modules),
                or a plain import path (when using the standard library, or GOPATH).
        -toolexec 'cmd args'
                a program to use to invoke toolchain programs like vet and asm.
                For example, instead of running asm, the go command will run
                'cmd args /path/to/asm <arguments for asm>'.
                The TOOLEXEC_IMPORTPATH environment variable will be set,
                matching 'go list -f {{.ImportPath}}' for the package being built.
        ```
4. go拥有丰富的库函数
5. `go help 子命令(build等等)`

## 1.2 命令行参数(os package)

大多数的程序都是处理输入，产生输出；这也正是“计算”的定义。但是，程序如何获取要处理的输入数据呢？一些程序生成自己的数据，但通常情况下，输入来自于程序外部：文件、网络连接、其它程序的输出、敲键盘的用户、命令行参数或其它类似输入源。下面几个例子会讨论其中几个输入源，首先是命令行参数。

os 包以跨平台的方式，提供了一些与操作系统交互的函数和变量。程序的命令行参数可从os包的 Args变量获取；os 包外部使用 os.Args 访问该变量。

os.Args 变量是一个字符串（string）的 切片（slice）（译注：slice 和 Python 语言中的切片类似，是一个简版的动态数组），切片是 Go 语言的基础概念，稍后详细介绍。现在先把切片 s 当作数组元素序列，序列的长度动态变化，用 s[i] 访问单个元素，用 s[m:n] 获取子序列（译注：和 Python 里的语法差不多）。序列的元素数目为 len(s)。和大多数编程语言类似，区间索引时，Go 语言里也采用左闭右开形式，即，区间包括第一个索引元素，不包括最后一个，因为这样可以简化逻辑。（译注：比如 a=[1,2,3,4,5], a[0:3]=[1,2,3]，不包含最后一个元素）。比如 s[m:n] 这个切片，0≤m≤n≤len(s)，包含 n-m 个元素。

os.Args 的第一个元素：os.Args[0]，是命令本身的名字；其它的元素则是程序启动时传给它的参数。s[m:n] 形式的切片表达式，产生从第 m 个元素到第 n-1 个元素的切片，下个例子用到的元素包含在 os.Args[1:len(os.Args)] 切片中。如果省略切片表达式的 m 或 n，会默认传入 0 或 len(s)，因此前面的切片可以简写成 os.Args[1:]。

下面是 Unix 里 echo 命令的一份实现，echo 把它的命令行参数打印成一行。程序导入了两个包，用括号把它们括起来写成列表形式，而没有分开写成独立的 import 声明。两种形式都合法，列表形式习惯上用得多。包导入顺序并不重要；gofmt 工具格式化时按照字母顺序对包名排序。（示例有多个版本时，我们会对示例编号，这样可以明确当前正在讨论的是哪个。）

```golang
gopl.io/ch1/echo1


// Echo1 prints its command-line arguments.
package main

import (
    "fmt"
    "os"
)

func main() {
    var s, sep string
    for i := 1; i < len(os.Args); i++ {
        s += sep + os.Args[i]
        sep = " "
    }
    fmt.Println(s)
}
```
注释语句以 // 开头。对于程序员来说，// 之后到行末之间所有的内容都是注释，被编译器忽略。按照惯例，我们在每个包的包声明前添加注释；对于 main package，注释包含一句或几句话，从整体角度对程序做个描述。

var 声明定义了两个 string 类型的变量 s 和 sep。变量会在声明时直接初始化。如果变量没有显式初始化，则被隐式地赋予其类型的 零值（zero value），数值类型是 0，字符串类型是空字符串 ""。这个例子里，声明把 s 和 sep 隐式地初始化成空字符串。第 2 章再来详细地讲解变量和声明。

对数值类型，Go 语言提供了常规的数值和逻辑运算符。而对 string 类型，+ 运算符连接字符串（译注：和 C++ 或者 JavaScript 是一样的）。所以表达式：sep + os.Args[i] 表示连接字符串 sep 和 os.Args。程序中使用的语句：s+=sep+os.Args[i] 是一条 赋值语句，将 s 的旧值跟 sep 与 os.Args[i] 连接后赋值回 s，等价于：s=s+sep+os.Args[i]。

运算符 += 是赋值运算符（assignment operator），每种数值运算符或逻辑运算符，如 + 或 *，都有对应的赋值运算符。

echo 程序可以每循环一次输出一个参数，这个版本却是不断地把新文本追加到末尾来构造字符串。字符串 s 开始为空，即值为 ""，每次循环会添加一些文本；第一次迭代之后，还会再插入一个空格，因此循环结束时每个参数中间都有一个空格。这是一种二次加工（quadratic process），当参数数量庞大时，开销很大，但是对于 echo，这种情形不大可能出现。本章会介绍 echo 的若干改进版，下一章解决低效问题。

循环索引变量 i 在 for 循环的第一部分中定义。符号 := 是 短变量声明（short variable declaration）的一部分，这是定义一个或多个变量并根据它们的初始值为这些变量赋予适当类型的语句。下一章有这方面更多说明。

自增语句 i++ 给 i 加 1；这和 i+=1 以及 i=i+1 都是等价的。对应的还有 i-- 给 i 减 1。它们是语句，而不像 C 系的其它语言那样是表达式。所以 j=i++ 非法，而且 ++ 和 -- 都只能放在变量名后面，因此 --i 也非法。

Go 语言只有 for 循环这一种循环语句。for 循环有多种形式，其中一种如下所示：

```golang
for initialization; condition; post {
    // zero or more statements
}
```
for 循环三个部分不需括号包围。大括号强制要求，左大括号必须和 post 语句在同一行。

initialization 语句是可选的，在循环开始前执行。initalization 如果存在，必须是一条 简单语句（simple statement），即，短变量声明、自增语句、赋值语句或函数调用。condition 是一个布尔表达式（boolean expression），其值在每次循环迭代开始时计算。如果为 true 则执行循环体语句。post 语句在循环体执行结束后执行，之后再次对 condition 求值。condition 值为 false 时，循环结束。

for 循环的这三个部分每个都可以省略，如果省略 initialization 和 post，分号也可以省略：

```golang
// a traditional "while" loop
for condition {
    // ...
}
```
如果连 condition 也省略了，像下面这样：
```golang

// a traditional infinite loop
for {
    // ...
}
```
这就变成一个无限循环，尽管如此，还可以用其他方式终止循环，如一条 break 或 return 语句。

for 循环的另一种形式，在某种数据类型的区间（range）上遍历，如字符串或切片。echo 的第二版本展示了这种形式：
```golang
gopl.io/ch1/echo2


// Echo2 prints its command-line arguments.
package main

import (
    "fmt"
    "os"
)

func main() {
    s, sep := "", ""
    for _, arg := range os.Args[1:] {
        s += sep + arg
        sep = " "
    }
    fmt.Println(s)
}
```
每次循环迭代，range 产生一对值；索引以及在该索引处的元素值。这个例子不需要索引，但 range 的语法要求，要处理元素，必须处理索引。一种思路是把索引赋值给一个临时变量（如 temp）然后忽略它的值，但 Go 语言不允许使用无用的局部变量（local variables），因为这会导致编译错误。

Go 语言中这种情况的解决方法是用 空标识符（blank identifier），即 _（也就是下划线）。空标识符可用于在任何语法需要变量名但程序逻辑不需要的时候（如：在循环里）丢弃不需要的循环索引，并保留元素值。大多数的 Go 程序员都会像上面这样使用 range 和 _ 写 echo 程序，因为隐式地而非显式地索引 os.Args，容易写对。

echo 的这个版本使用一条短变量声明来声明并初始化 s 和 seps，也可以将这两个变量分开声明，声明一个变量有好几种方式，下面这些都等价：

```golang
s := ""
var s string
var s = ""
var s string = ""
```
用哪种不用哪种，为什么呢？第一种形式，是一条短变量声明，最简洁，但只能用在函数内部，而不能用于包变量。第二种形式依赖于字符串的默认初始化零值机制，被初始化为 ""。第三种形式用得很少，除非同时声明多个变量。第四种形式显式地标明变量的类型，当变量类型与初值类型相同时，类型冗余，但如果两者类型不同，变量类型就必须了。实践中一般使用前两种形式中的某个，初始值重要的话就显式地指定变量的类型，否则使用隐式初始化。

如前文所述，每次循环迭代字符串 s 的内容都会更新。+= 连接原字符串、空格和下个参数，产生新字符串，并把它赋值给 s。s 原来的内容已经不再使用，将在适当时机对它进行垃圾回收。

如果连接涉及的数据量很大，这种方式代价高昂。一种简单且高效的解决方案是使用 strings 包的 Join 函数：

```golang
gopl.io/ch1/echo3


func main() {
    fmt.Println(strings.Join(os.Args[1:], " "))
}
```
最后，如果不关心输出格式，只想看看输出值，或许只是为了调试，可以用 Println 为我们格式化输出。

`fmt.Println(os.Args[1:])`
这条语句的输出结果跟 strings.Join 得到的结果很像，只是被放到了一对方括号里。切片都会被打印成这种格式。

练习 1.1： 修改 echo 程序，使其能够打印 os.Args[0]，即被执行命令本身的名字。

练习 1.2： 修改 echo 程序，使其打印每个参数的索引和值，每个一行。

练习 1.3： 做实验测量潜在低效的版本和使用了 strings.Join 的版本的运行时间差异。（1.6 节讲解了部分 time 包，11.4 节展示了如何写标准测试程序，以得到系统性的性能评测。）

summary:  
1. os提供跨平台的方式。具体怎么用要参考文档
2. golang定义参数的方式`var a,b,c int=0,0,0`,还有海马运算符
      `s := ""`
      `var s , v string`
      `var s = ""`
      `var s string = ""`
3. `for k,v := range os.Args[1:]{}`

## 1.3 查找重复的行

```golang
%d          十进制整数
%x, %o, %b  十六进制，八进制，二进制整数。
%f, %g, %e  浮点数： 3.141593 3.141592653589793 3.141593e+00
%t          布尔：true或false
%c          字符（rune） (Unicode码点)
%s          字符串
%q          带双引号的字符串"abc"或带单引号的字符'c'
%v          变量的自然形式（natural format）
%T          变量的类型
%%          字面上的百分号标志（无操作数）
```
1. `a := make(map[string]int)`
2. golang的传递都是值传递，如果不指定的话

## 1.4 GIF动画
没啥意思，都是介绍功能

## 1.5 获取URL
这一节主要还是`io`的例子

## 1.6. 并发获取多个URL

开始介绍`go`关键字进行并发还有channel

## 1.7. Web服务

主要还是介绍`net`包


# 2. 程序结构

## 2.1 命名

|功能性关键字|描述|
|---|---|
|break|退出循环|
|case|switch case, select case|
|chan| var ch chan int, ch := make(chan int),ch := make(chan int,1) |
|const| const( a int,b int ,c string)|
|continue| 退出循环 |
|default| 常见于select {}一起使用 |
|defer| 函数退出前执行|
|else| if else|
|fallthrough| N/A|
|for| for {}, for i:=0;i < length ;i++{}, for k,v := range Slice{} |
|func| func (){}|
|go| 携程|
|if||
|import| |
|interface| interface{} 是噩梦|
|map|  a := make(map[int]string) ,var a map[int]string |
|package||
|range|for _,_ := range _ {}|
|return| you know |
|select| select {case a: }|
|struct| 相当于java的类,跟c的struct很像|
|switch| switch conditional {}|
|type| type A struct {}|
|var| var a , b, int|

|内建常量|关键字|
|---|---|
|true | shit|
|false | shit|
|iota| 1,2,3,4....|
| nil| shit|

|golang的基本数据类型| 关键字|
|---|---|
|int ||
|int8 ||
|int16 ||
|int32 ||
|int64 ||
|uint ||
|uint8 ||
|uint16 ||
|uint32 ||
|uint64 ||
|uintptr ||
|float32 ||
|float64 ||
|complex128 ||
|complex64 ||
|bool ||
|byte ||
|rune ||
|string ||
|error||

|常用内建函数| 关键字|
|---|---|
|make||
|len||
|cap||
|new||
|append ||
|copy ||
|close ||
|delete ||
|complex ||
|real ||
|imag ||
|panic ||
|recover||

Go推荐使用`驼峰式`命名:

- 一个名字必须以一个字母（Unicode字母）或下划线开头,下划线开头可能表示`私有的`
- 后面可以跟任意数量的字母、数字或下划线。
- 名字的开头字母的大小写决定了名字在包外的可见性.如果一个名字是大写字母开头的(译注必须是 在函数外部定义的包级名字;包级函数名本身也是包级名字),那么它将是导出的,也就是说可以被外部的包访问,例如`fmt.Printf`,就可以在包外访问

## 2.2 声明

Go语言主要有四种类型的声明语句:
  
- var
- const
- type
- func

```golang
  package main

  import "fmt"

  const boilingF = 212.0
  const var a = 0

  func main() {
      var f = boilingF
      var c = (f - 32) * 5 / 9
      fmt.Printf("boiling point = %g°F or %g°C\n", f, c)
      // Output:
      // boiling point = 212°F or 100°C
  }
```

`boilingF`是包一级的变量在包内可以访问。如果函数没有返回值，那么返回值列表是省略的。函数顺序执行直到遇到return返回语句，如果没有返回语句则是执行到函数末尾，然后返回到函数调用者

## 2.3 变量

常规声明变量

```golang
  var 变量名字 类型 = 表达式
```

```golang
  var i ,j , k int // 都是int类型
  var b,f,s =true , 2.3 ,"four" //bool , float 64,string
  var f, err = os.Open(name) // os.Open returns a file and an error
```

- 在包级别声明的变量会在main入口函数执行前完成初始化,局部变量将在声明语句被执行到的时候完成初始化。
- `类型`和`表达式`都可以缺省,如果是`类型`缺省那么就可以通过`表达式`进行推断,如果是表达式缺省那么就会赋类型的`零`值,如果是自定义类型或者是引用类型就是内部各个字段都是`零`值.Go语言程序员应该让一些聚合类型的零值也具有意义，这样可以保证不管任何类型的变量总是有一个合理有效的零值状态

### 2.3.1 简短变量声明

  ```golang
  anim := gif.GIF{LoopCount: nframes} //聚合类型,引用类型
  freq := rand.Float64() * 3.0 // float
  t := 0.0  //float
  f, err := os.Open(name) //通过函数进行声明，并初始化
  if err != nil {
      return err
  }
  ```

- 例子1中声明的err是重复,第二个简短声明符的err就是赋值操作，注意该操作是在变量相同作用例子2中这种情况编译不通过,至少有一个是新声明的.[ 实际工程中尽量不要出现例子2 ]

  ```golang
  //例子1
  in, err := os.Open(infile)
  // ...
  out, err := os.Create(outfile)
  //例子2
  f, err := os.Open(infile)
  // ...
  f, err := os.Create(outfile) // compile error: no new variables
  ```

### 2.3.2 指针

- `任何类型`的指针的`零值`都是`nil`。如果p指向某个有效变量，那么`p != nil`测试为`真`。指针之间也是可以进行相等测试的，只有当它们指向同一个变量或全部是nil时才相等。
- 返回局部变量地址也是安全的。

    ```golang
    func incr(p *int) int {
        *p++ // 非常重要：只是增加p指向的变量的值，并不改变p指针！！！
        return *p
    }
    v := 1
    incr(&v)              // side effect: v is now 2
    fmt.Println(incr(&v)) // "3" (and v is 3)
    ```

- 在flag包中,应用到了`指针`技术

    ```golang
    package main
    import (
        "flag"
        "fmt"
        "strings"
    )
    var n = flag.Bool("n", false, "omit trailing newline")
    var sep = flag.String("s", " ", "separator")

    func main() {
        flag.Parse() //解析标志性参数位
        fmt.Print(strings.Join(flag.Args(), *sep)) //flag.Args() 解析非标志参数位
        if !*n {
            fmt.Println()
        }
    }
    ```
  - 在此代码例子中使用`flag.Args()`解析非标志参数位,`flag.Parse()`解析标志性参数位,to be continue

### 2.3.3 new函数

  表达式new(T)将创建一个T类型的匿名变量，初始化为T类型的零值，然后返回变量地址，返回的指针类型为*T(返回的是指针)

- 每次new()返回新的变量地址,比如new(int)

### 2.3.4. 变量的生命周期

- 包一级的声明会伴随程序整个声明周期,但是函数内部则是动态,会被GC回收
- 函数的`参数变量`(参数列表)和`返回值变量`都是`局部变量`。它们在函数每次被调用的时候创建,下面循环的`变量t`就是动态创建,用完就扔

  ```golang
  for t := 0.0; t < cycles*2*math.Pi; t += res {
    x := math.Sin(t)
    y := math.Sin(t*freq + phase)
    img.SetColorIndex(size+int(x*size+0.5), size+int(y*size+0.5),
        blackIndex)
  }
  ```

  下面也是合法的

  ```golang
  for t := 0.0; t < cycles*2*math.Pi; t += res {
    x := math.Sin(t)
    y := math.Sin(t*freq + phase)
    img.SetColorIndex(
        size+int(x*size+0.5), size+int(y*size+0.5),
        blackIndex, // 最后插入的逗号不会导致编译错误，这是Go编译器的一个特性
    )               // 小括弧另起一行缩进，和大括弧的风格保存一致
  }
  ```

- `局部变量逃逸`.因为一个变量的有效周期只取决于是否可达，因此一个循环迭代内部的局部变量的生命周期可能超出其局部作用域。同时，局部变量可能在函数返回之后依然存在。`编译器`会自动选择在`栈`上还是在`堆`上分配局部变量的存储空间,代码如下,`f`函数里的`x变量`必须在`堆`上分配,因为它在函数退出后依然可以通过包一级的`global变量`找到,`g`函数在栈上分配`*y`内存空间

  ```golang
  var global *int

  func f() {
      var x int
      x = 1
      global = &x
  }

  func g() {
      y := new(int)
      *y = 1
  }

  ```

- Go语言的自动垃圾收集器对编写正确的代码是一个巨大的帮助，但也并不是说你完全不用考虑内存了。你虽然不需要显式地分配和释放内存，但是要编写高效的程序你依然需要了解变量的生命周期,比如,如果将指向短生命周期对象的指针保存到具有长生命周期的对象中，特别是保存到全局变量时，会阻止对短生命周期对象的垃圾回收(从而可能影响程序的性能)。

## 2.4 赋值

  ```golang
  x = 1                       // 命名变量的赋值
  *p = true                   // 通过指针间接赋值
  person.name = "bob"         // 结构体字段赋值
  count[x] = count[x] * scale // 数组、slice或map的元素赋值

  ```

### 2.4.1 元组赋值

  ```golang
  x,y = y,x; //不限制数量
  a[i], a[j] = a[j], a[i];
  //额外的布尔类型表达某种错误类型
  v, ok = m[key]             // map lookup
  v, ok = x.(T)              // type assertion
  v, ok = <-ch               // channel receive
  //只做检查
  v = m[key]                // map查找，失败时返回零值
  v = x.(T)                 // type断言，失败时panic异常
  v = <-ch                  // 管道接收，失败时返回零值（阻塞不算是失败）

  _, ok = m[key]            // map返回2个值
  _, ok = mm[""], false     // map返回1个值
  _ = mm[""]                // map返回1个值
  //复合类型隐式赋值
  medals := []string{"gold", "silver", "bronze"}
  //等价写法
  medals[0] = "gold"
  medals[1] = "silver"
  medals[2] = "bronze"
  ```

- 对于两个值是否可以用==或!=进行相等比较的能力也和可赋值能力有关系

## 2.5 类型

  ```golang
  package tempconv

  import "fmt"

  type Celsius float64    // 摄氏温度
  type Fahrenheit float64 // 华氏温度

  const (
      AbsoluteZeroC Celsius = -273.15 // 绝对零度
      FreezingC     Celsius = 0       // 结冰点温度
      BoilingC      Celsius = 100     // 沸水温度
  )

  func CToF(c Celsius) Fahrenheit { return Fahrenheit(c*9/5 + 32) }

  func FToC(f Fahrenheit) Celsius { return Celsius((f - 32) * 5 / 9) }

  ```

- 类型声明语句一般出现在包一级，因此如果新创建的类型名字的首字符大写，则在包外部也可以使用
- `Celsius`和`Fahrenheit`是两种不同类型,`Celsius(t)`或`Fahrenheit(t)`形式的显式转型,`整数`->`小数`回省略小数部分(CPP在这部分有很详细的讨论)
- 如果两个值有着不同的类型，则不能直接进行比较
- 命名类型还可以为该类型的值定义新的行为。这些行为表示为一组关联到该类型的函数集合，我们称为类型的方法集后面详细讨论

## 2.6 包和文件

- `名字空间`每个包都对应一个独立的名字空间,例如，在image包中的Decode函数和在unicode/utf16包中的 Decode函数是不同的。要在外部引用该函数，必须显式使用image.Decode或utf16.Decode形式访问
- `包的导入`Go语言的规范并没有定义这些源代码的具体含义或包来自哪里，它们是由构建工具来解释的。当使用Go语言自带的go工具箱时（第十章），一个导入路径代表一个目录中的一个或多个Go源文件。
- `包的初始化`。包级别声明的变量，如果有初始化表达式则用表达式初始化，还有一些没有初始化表达式的。例如`func init() { /* ... */ }`,`init`不能被调用，也不能被声明。包会按照声明的顺序初始化。
- `包的初始化顺序`。如果一个p包导入了q包，那么在p包初始化的时候可以认为q包必然已经初始化过了。初始化工作是自下而上进行的，main包最后被初始化。以这种方式，可以确保在main函数执行之前，所有依赖的包都已经完成初始化工作了

    复杂初始化可以用以下方式

    ```golang
    //可以使用匿名函数处理
    var pc [256]byte = func() (pc [256]byte) {
      for i := range pc {
          pc[i] = pc[i/2] + byte(i&1)
      }
      return
    }()

    ```
  
## 2.7. 作用域

- 不要将作用域和生命周期混为一谈，作用域是指文本域，而生命周期是指运行有效时段
- 任何在`函数`外部（也就是包级语法域）声明的名字可以在同一个`包`的任何源文件中访问的
- 对于导入的包，例如tempconv导入的fmt包，则是对应源文件级的作用域，因此只能在当前的文件中访问导入的fmt包，当前包的其它源文件无法访问在当前源文件导入的包
- 控制流标号，就是break、continue或goto语句后面跟着的那种标号，则是
    函数级的作用域

几种常见作用域例子

- 正常情况下作用域例子

    ```golang
    func f() {}

    var g = "g"

    func main() {
        f := "f"
        fmt.Println(f) // "f"; local var f shadows package-level func f
        fmt.Println(g) // "g"; package-level var
        fmt.Println(h) // compile error: undefined: h
    }
    ```

- 作用域嵌套,函数中可以进行词法域嵌套

    ```golang
    func main() {
      x := "hello!"
      for i := 0; i < len(x); i++ {
          x := x[i]
          if x != '!' {
              x := x + 'A' - 'a'
              fmt.Printf("%c", x) // "HELLO" (one letter per iteration)
            }
        }
    }
    //上述代码`x[]`和`x + 'A' - 'a'`都是引用了外部作用域声明的x变量。
    //再比如下面的例子,有三个不同的x变量，
    ```

    ```golang
    //每个声明在不同的词法域，一个在函数体词法域，一个在for隐式的初始化
    //词法域，一个在for循环体词法域；只有两个块是显式创建的：
    func main() {
      x := "hello"
      for _, x := range x {
          x := x + 'A' - 'a'
          fmt.Printf("%c", x) // "HELLO" (one letter per iteration)
      }
    }
    ```

- 建隐式词法域,隐式作用域
  if和switch语句也会在条件部分创建隐式词法域，代码例子如下.第二个if语句嵌套在第一个内部，因此第一个if语句条件初始化词法域声明的变量在第二个if中也可以访问

    ```golang
    if x := f(); x == 0 {
      fmt.Println(x)
    } else if y := g(x); x == y {
        fmt.Println(x, y)
    } else {
        fmt.Println(x, y)
    }
    fmt.Println(x, y) // compile error: x and y are not visible here
    ```

    如果不想提前声明变量还可以选择如下方式，但这不是Go语言推荐的做法，Go语言的习惯是在if中处理错误然后直接返回

    ```golang
    if f, err := os.Open(fname); err != nil {
      return err
    } else {
        // f and err are visible here too
        f.ReadByte()
        f.Close()
    }
    ```

- 屏蔽其他作用域变暗亮
    cwd在外部已经声明的包级变量，但是:=语句还是将cwd和err重新声明为新的局部变量

    ```golang
    var cwd string

    func init() {
        cwd, err := os.Getwd() // compile error: unused: cwd
        if err != nil {
            log.Fatalf("os.Getwd failed: %v", err)
        }
    }
    ```

    可以用赋值运算符，就不会屏蔽`cwd`变量

    ```golang
    var cwd string

    func init() {
        var err error //因为是赋值运算符所以需要定义error变量
        cwd, err = os.Getwd()
        if err != nil {
            log.Fatalf("os.Getwd failed: %v", err)
        }
    }
    ```

# 3.基础数据类型

- 整型格式控制符
    |格 式 | 描 述|
    |---|---|
    |%b | 整型以二进制方式显示|
    |%o | 整型以八进制方式显示|
    |%d | 整型以十进制方式显示,以锁为例子mutex=&((1 0) 0 0 -1073741824 0)|
    |%x | 整型以十六进制方式显示|
    |%X | 整型以十六进制、字母大写方式显示|
    |%c | 相应Unicode码点所表示的字符|
    |%U | Unicode 字符, Unicode格式：123，等同于 "U+007B"|

- 浮点数格式控制
    |格 式 | 描 述|
    |---|---|
    |%e |科学计数法,例如 -1234.456e+78|
    |%E |科学计数法,例如 -1234.456E+78|
    |%f |有小数点而无指数,例如 123.456|
    |%g |根据情况选择 %e 或 %f 以产生更紧凑的（无末尾的0）输出|
    |%G |根据情况选择 %E 或 %f 以产生更紧凑的（无末尾的0）输出|

- 字符串格式化
    |格 式 |描 述|
    |---|---|
    |%s| 字符串或切片的无解译字节|
    |%q| 双引号围绕的字符串，由Go语法安全地转义|
    |%x| 十六进制，小写字母，每字节两个字符|
    |%X| 十六进制，大写字母，每字节两个字符|

- 指针格式化
    |格 式 |描 述|
    |---|---|
    |%p|十六进制表示，前缀 0x|
- 通用的占位符
    |格 式| 描 述|
    |---|---|
    |%v |值的默认格式。只输出字段的值，没有字段名字,eg: requestVote RPC={1,1,0,0}|
    |%+v|类似%v，但输出结构体时会添加字段名,以RWMutex为例子, &{w:{state:1 sema:0} writerSem:0 readerSem:0 readerCount:-1073741824 readerWait:0}|
    |%#v|相应值的Go语法表示,比如地址用十六进制表示,以RWMutex为例子, &sync.RWMutex{w:sync.Mutex{state:1, sema:0x0}, writerSem:0x0, readerSem:0x0, readerCount:-1073741824, readerWait:0}|
    |%T |相应值的类型的Go语法表示,比如以RWMutex为例子,rf.mu=*sync.RWMutex|
    |%% |百分号,字面上的%,非占位符含义|

- 控制宽度
    宽度设置格式: 占位符中间加一个数字, 数字分正负, +: 右对齐, -: 左对齐
  - 字符串控制

        ```golang
        fmt.Printf("|%s|", "aa") // 不设置宽度
        fmt.Printf("|%5s|", "aa") // 5个宽度,  默认+， 右对齐
        fmt.Printf("|%-5s|", "aa") // 5个宽度, 左对齐
        fmt.Printf("|%05s|", "aa") // |000aa|
        ```
  - 浮点控制

        ```golang
        a := 54.123456
        fmt.Printf("|%f|", a)  // |54.123456|
        fmt.Printf("|%5.1f|", a)  // | 54.1|
        fmt.Printf("|%-5.1f|", a) // |54.1 |
        fmt.Printf("|%05.1f|", a) // |054.1|
        ```

## 3.1 整型

1. 因为不同的编译器即使在相同的硬件平台上可能产生不同的大小字节
2. Unicode和rune类型是个`int32`等价的类型,通常用于表示一个Unicode码点
3. 同样byte也是`uint8`类型的等价类型
4. 还有一种无符号的整数类型`uintptr`，没有指定具体的bit大小但是足以容纳指针。`uintptr`类型只有在底层编程时才需要，特别是Go语言和C语言函数库或操作系统接口相交互的地方
5. `int`、`uint`和`uintptr`是不同类型的兄弟类型。其中`int`和`int32`也是不同的类型，即使`int`的大小也是32bit，在需要将int当作int32类型的地方需要一个显式的类型转换操作，反之亦然
6. 位元素符号
7. `int32`和`int64`无法直接四则运算
8. `fmt.Printf("%d %[1]o %#[1]o\n", o) // "438 666 0666"`中的`fmt`两个使用技巧.(1)%之后的[1]副词告诉Printf函数再次使用第一个操作数.(2)后的#副词告诉Printf在用%o、%x或%X输出时生成0、0x或0X前缀

## 3.2 浮点数

1. 一个`float32`类型的浮点数可以提供大约`6`个十进制数的精度，而`float64`则可以提供约`15`个十进制数的精度；通常应该优先使用`float64`类型，因为`float32`类型的累计计算误差很容易扩散，并且`float32`能精确表示的正整数并不是很大
2. 浮点数字面量可以直接书写
3. 很大或者很小的数都可以用科学计数法来书写
4. `fmt.Printf("x = %d e^x = %8.3f\n", x, math.Exp(float64(x)))`8.3是指三个小数精度，8个字符宽度,`%g %e %f`.

## 3.3 复数

复数类型：complex64和complex128，分别对应float32和float64两种浮点数精度。内置的complex函数用于构建复数，内建的real和imag函数分别返回复数的实部和虚部:

```golang
var x complex128 = complex(1, 2) // 1+2i
var y complex128 = complex(3, 4) // 3+4i
fmt.Println(x*y)                 // "(-5+10i)"
fmt.Println(real(x*y))           // "-5"
fmt.Println(imag(x*y))           // "10"

```

## 3.4 布尔类型

布尔值并不会隐式转换为数字值0或1，反之亦然。必须使用一个显式的if语句辅助转换:

```golang
i := 0
if b {
    i = 1
}
```

## 3.5 字符串

- 字符串可以用==和<进行比较；比较通过逐个字节比较完成的
- 字符串的值是不可变的：一个字符串包含的字节序列永远不会被改变.故`s[0] = 'L' // compile error: cannot assign to s[0]`

  - 因为Go语言源文件总是用UTF8编码，并且Go语言的文本字符串也以UTF8编码的方式处理，因此我们可以将Unicode码点也写到字符串面值中
  - 可在字符串面值中写`十六进制`和`八进制`数字进行码点转义
  - 原生字面值用反引号(`)说明字面值不转义,而且字符串无法使用( 反引号 )，但是可以使用八进制和十六进制(泛化转义字符)进行转化.
  - 通用的表示一个Unicode码点的数据类型是int32，也就是Go语言中rune对应的类型；它的同义词rune符文正是这个意思
  - UTF-8 [to be continue]
  - `bytes`、`strings`、`strconv`和`unicode`包,四个包对字符串处理尤为重要,`strings`包提供了许多如字符串的查询、替换、比较、截断、拆分和合并等功能
  - 字符串和数字的转换,`strconv`包提供这类转换功能

# 4. 复合数据类型

## 4.1 数组

数组代码示例

```golang
var a [3]int             // array of 3 integers
fmt.Println(a[0])        // print the first element
fmt.Println(a[len(a)-1]) // print the last element, a[2]

// Print the indices and elements.
for i, v := range a {
    fmt.Printf("%d %d\n", i, v)
}

// Print the elements only.
for _, v := range a {
    fmt.Printf("%d\n", v)
}
```

如果在数组的长度位置出现的是“...”省略号，则表示数组的长度是根据初始化值的个数来计算

```golang
q := [...]int{1, 2, 3}
fmt.Printf("%T\n", q) // "[3]int"
```

上面的形式是直接提供顺序初始化值序列，但是也可以指定一个索引和对应值列表的方式初始化

```golang
type Currency int

const (
    USD Currency = iota // 美元
    EUR                 // 欧元
    GBP                 // 英镑
    RMB                 // 人民币
)

symbol := [...]string{USD: "$", EUR: "€", GBP: "￡", RMB: "￥"}

fmt.Println(RMB, symbol[RMB]) // "3 ￥"
```

定义了一个含有100个元素的数组r，最后一个元素被初始化为-1，其它元素都是用0初始化。

```golang
r := [...]int{99: -1}
```

数组进行比较是比较所有元素是否相等

## 4.2 slice

创建slice变量

```golang
v_len := make([]T, len)
v_len_cap := make([]T, len, cap) // same as make([]T, cap)[:len]
s := []int{0, 1, 2, 3, 4, 5}
```

`slice`和`数组`典型的不同就是`slice`不指定长度
`bytes.Equal`函数来判断两个字节型slice是否相等（[]byte)

```golang
func equal(x, y []string) bool {
    if len(x) != len(y) {
        return false
    }
    for i := range x {
        if x[i] != y[i] {
            return false
        }
    }
    return true
}
```

slice的nil值

```golang
var s []int    // len(s) == 0, s == nil
s = nil        // len(s) == 0, s == nil
s = []int(nil) // len(s) == 0, s == nil
s = []int{}    // len(s) == 0, s != nil
```

### 4.2.1 append函数

(留着放些API东西)

## 4.3 Map

其中K对应的key必须是支持==比较运算符的数据类型,所以map可以通过测试key是否相等来判断是否已经存在  
创建map

```golang
ages := make(map[string]int) // mapping from strings to ints
ages := map[string]int{
    "alice":   31,
    "charlie": 34,
}
//访问map数据，也是put操作
ages["alice"] = 32
//删除元素
delete(ages, "alice") // remove element ages["alice"]
//map中的元素并不是一个变量，因此我们不能对map的元素进行取址操作：
_ = &ages["bob"] // compile error: cannot take address of map element

```

Map的迭代顺序是不确定的，并且不同的哈希函数实现可能导致不同的遍历顺序。在实践中，遍历的顺序是随机的，每一次遍历的顺序都不相同。这是故意的，每次都使用随机的遍历顺序可以强制要求程序不会依赖具体的哈希函数实现。如果要按顺序遍历key/value对，我们必须显式地对key进行排序，可以使用sort包的Strings函数对字符串slice进行排序

```golang
import "sort"

var names []string
for name := range ages {
    names = append(names, name)
}
sort.Strings(names)
for _, name := range names {
    fmt.Printf("%s\t%d\n", name, ages[name])
}
```

map返回两个值，第一个值是bool类型,false则说明不存在这个key。
map的key要求必须是可比较类型，那么如果想用slice作为key就需要写小改动

```golang
var m = make(map[string]int)

func k(list []string) string { return fmt.Sprintf("%q", list) }

func Add(list []string)       { m[k(list)]++ }
func Count(list []string) int { return m[k(list)] }
```

## 4.4 结构体

```golang
seen := make(map[string]struct{}) // set of strings
// ...
if _, ok := seen[s]; !ok {
    seen[s] = struct{}{}
    // ...first time seeing s...
}
```

### 4.4.1 结构体字面值

```golang
type Point struct{ X, Y int }
//第一种类型初始化方式
p := Point{1, 2}
//第二种初始化方式,如果成员被忽略的话将默认用零值。因为提供了成员的名字，所以成员出现的顺序并不重要
p :=Point{x:1,y:2}
```

非导出结构体或者字段，不能在其他包中进行赋值

```golang
package p
type T struct{ a, b int } // a and b are not exported

package q
import "p"
var _ = p.T{a: 1, b: 2} // compile error: can't reference a, b
var _ = p.T{1, 2}       // compile error: can't reference a, b
```

如果考虑效率的话，较大的结构体通常会用指针的方式传入和返回，

```golang

func Bonus(e *Employee, percent int) int {
    return e.Salary * percent / 100
}
```

可以用下面的写法来创建并初始化一个结构体变量，并返回结构体的地址：

```golang
pp := &Point{1, 2}
```

它和下面的语句是等价的

```golang
pp := new(Point)
*pp = Point{1, 2}
```

### 4.4.2 结构体的比较

首先结构体是可比较类型

```golang

type Point struct{ X, Y int }

p := Point{1, 2}
q := Point{2, 1}
fmt.Println(p.X == q.X && p.Y == q.Y) // "false"
fmt.Println(p == q)                   // "false"

```

### 4.4.3 结构体嵌入和匿名成员

```golang

type Point struct {
    X, Y int
}

type Circle struct {
    Center Point
    Radius int
}

type Wheel struct {
    Circle Circle
    Spokes int
}

var w Wheel
w.Circle.Center.X = 8
w.Circle.Center.Y = 8
w.Circle.Radius = 5
w.Spokes = 20
```

匿名成员，说白了就是只写类型不写名字.

```golang
type Circle struct {
    Point
    Radius int
}

type Wheel struct {
    Circle
    Spokes int
}

var w Wheel
w.X = 8            // equivalent to w.Circle.Point.X = 8
w.Y = 8            // equivalent to w.Circle.Point.Y = 8
w.Radius = 5       // equivalent to w.Circle.Radius = 5
w.Spokes = 20
//以下初始化是错误的
w = Wheel{8, 8, 5, 20}                       // compile error: unknown fields
w = Wheel{X: 8, Y: 8, Radius: 5, Spokes: 20} // compile error: unknown fields
```

所以我们只能用下面两种方式进行初始化

```golang

w = Wheel{Circle{Point{8, 8}, 5}, 20}

w = Wheel{
    Circle: Circle{
        Point:  Point{X: 8, Y: 8},
        Radius: 5,
    },
    Spokes: 20, // NOTE: trailing comma necessary here (and at Radius)
}

fmt.Printf("%#v\n", w)
// Output:
// Wheel{Circle:Circle{Point:Point{X:8, Y:8}, Radius:5}, Spokes:20}

w.X = 42

fmt.Printf("%#v\n", w)
// Output:
// Wheel{Circle:Circle{Point:Point{X:42, Y:8}, Radius:5}, Spokes:20}

```

需要注意，但是在包外部，因为circle和point没有导出，不能访问它们的成员，因此简短的匿名成员访问语法也是禁止的。

## 4.5 json字符串

`json.Marshal`包
代码例子

```golang
type Movie struct {
    Title  string
    Year   int  `json:"released"` // 这个tag指定生成json名字
    Color  bool `json:"color,omitempty"`
    Actors []string
}

var movies = []Movie{
    {Title: "Casablanca", Year: 1942, Color: false,
        Actors: []string{"Humphrey Bogart", "Ingrid Bergman"}},
    {Title: "Cool Hand Luke", Year: 1967, Color: true,
        Actors: []string{"Paul Newman"}},
    {Title: "Bullitt", Year: 1968, Color: true,
        Actors: []string{"Steve McQueen", "Jacqueline Bisset"}},
    // ...
}
```

## 4.6 文本和HTML模板

(后面需要时候着重的看)
`text/template和html/template`,们提供了一个将变量值填充到一个文本或HTML格式的模板的机制。模板语言支持流程控制语句
模板语言demo

```golang
const templ = `{{.TotalCount}} issues:
{{range .Items}}----------------------------------------
Number: {{.Number}}
User:   {{.User.Login}}
Title:  {{.Title | printf "%.64s"}}
Age:    {{.CreatedAt | daysAgo}} days
{{end}}`
```

`|` 操作符表示将前一个表达式的结果作为后一个函数的输入.  
生成模板的输出需要两个处理步骤

```golang
var report = template.Must(template.New("issuelist").
    Funcs(template.FuncMap{"daysAgo": daysAgo}).
    Parse(templ))

func main() {
    result, err := github.SearchIssues(os.Args[1:])
    if err != nil {
        log.Fatal(err)
    }
    if err := report.Execute(os.Stdout, result); err != nil {
        log.Fatal(err)
    }
}
```

如果想转化为html则需要编写如下代码

```golang

import "html/template"

var issueList = template.Must(template.New("issuelist").Parse(`
<h1>{{.TotalCount}} issues</h1>
<table>
<tr style='text-align: left'>
  <th>#</th>
  <th>State</th>
  <th>User</th>
  <th>Title</th>
</tr>
{{range .Items}}
<tr>
  <td><a href='{{.HTMLURL}}'>{{.Number}}</a></td>
  <td>{{.State}}</td>
  <td><a href='{{.User.HTMLURL}}'>{{.User.Login}}</a></td>
  <td><a href='{{.HTMLURL}}'>{{.Title}}</a></td>
</tr>
{{end}}
</table>
`))
```

注意，html/template包已经自动将特殊字符转义，因此我们依然可以看到正确的字面值。如果我们使用text/template包的话，这2个issue将会产生错误，其中“&lt;”四个字符将会被当作小于字符“<”处理，同时“<link>”字符串将会被当作一个链接元素处理，它们都会导致HTML文档结构的改变，从而导致有未知的风险。

# 5. 函数

声明和定义

- switch 控制语句

  ```golang
  switch cond{
    case a :
        fmt.Printf()
    case b :
        fmt.Printf()
    case c :
        fmt.Printf()
  }
  ```

## 5.1 错误

通常，导致失败的原因不止一种，尤其是对I/O操作而言，用户需要了解更多的错误信息。因此，额外的返回值不再是简单的布尔类型，而是error类型。

我们有几种处理错误的策略

1. 发生错误时的解析器

  发生解析错误后,findLinks 函数构造了一个新的异常信息,既包含了自定义的，也包含了底层解析出错的信息

  ```golang
  doc, err := html.Parse(resp.Body)
  resp.Body.Close()
  if err != nil {
      return nil, fmt.Errorf("parsing %s as HTML: %v", url,err)
  }
  ```

  参考宇航局事故调查
2. 重试
  我们需要限制重试的时间间隔或重试的次数，防止无限制的重试.
3. 输出错误信息并结束程序
  输出错误信息并结束程序。需要注意的是，这种策略只应在main中执行,对库函数而言，应仅向上传播错误，除非该错误意味着程序内部包含不一致性，即遇到了bug，才能在库函数中结束程序

  ```golang
  if err := WaitForServer(url); err != nil {
    log.Fatalf("Site is down: %v\n", err)
  }
  ```

  `log.Fatalf`代码更简洁，并输出自定义格式信息

4. 只是输出错误信息就可以

  ```golang
  if err := Ping(); err != nil {
    log.Printf("ping failed: %v; networking disabled",err)
  }
  //或者标准错误流输出错误信息。

  if err := Ping(); err != nil {
      fmt.Fprintf(os.Stderr, "ping failed: %v; networking disabled\n", err)
  }
  ```

5. 直接忽略掉错误

  ```golang
  dir, err := ioutil.TempDir("", "scratch")
  if err != nil {
      return fmt.Errorf("failed to create temp dir: %v",err)
  }
  // ...use temp dir…
  os.RemoveAll(dir) // ignore errors; $TMPDIR is cleaned periodically
  ```

  尽管os.RemoveAll会失败，但上面的例子并没有做错误处理。这是因为操作系统会定期的清理临时目录。正因如此，虽然程序没有处理错误，但程序的逻辑不会因此受到影响

6. 文件结尾错误

io包保证任何由文件结束引起的读取失败都返

```golang
package io

import "errors"

// EOF is the error returned by Read when no more input is available.
var EOF = errors.New("EOF")

in := bufio.NewReader(os.Stdin)
for {
    r, _, err := in.ReadRune()
    if err == io.EOF {
        break // finished reading
    }
    if err != nil {
        return fmt.Errorf("read failed:%v", err)
    }
    // ...use r…
}
```

## 5.2 函数值

- 函数在golang中也是一种类型，可以被复制给其他变量。  
- 很熟类型的`零`值是`nil`,调用值为nil会引起`panic`错误  
- 函数值之间是不可以比较的,也不能用函数值作为map的key
- strings.Map对字符串中的每个字符调用add1函数，并将每个add1函数的返回值组成一个新的字符串返回给调用者
  
  ```golang
  func add1(r rune) rune { return r + 1 }

  fmt.Println(strings.Map(add1, "HAL-9000")) // "IBM.:111"
  fmt.Println(strings.Map(add1, "VMS"))      // "WNT"
  fmt.Println(strings.Map(add1, "Admix"))    // "Benjy"
  ```

demo示例

```golang
//值得学习
// forEachNode针对每个结点x，都会调用pre(x)和post(x)。
// pre和post都是可选的。
// 遍历孩子结点之前，pre被调用
// 遍历孩子结点之后，post被调用
func forEachNode(n *html.Node, pre, post func(n *html.Node)) {
    if pre != nil {
        pre(n)
    }
    for c := n.FirstChild; c != nil; c = c.NextSibling {
        forEachNode(c, pre, post)
    }
    if post != nil {
        post(n)
    }
}
```

## 5.3 匿名函数

函数内部定义的函数可以访问整个词法环境，言外之意就是嵌套的函数可以访问外层函数的变量

```golang
// squares返回一个匿名函数。
// 该匿名函数每次被调用时都会返回下一个数的平方。
//squares 函数每次都返回一个函数类型-func()int{}
func squares() func() int {
    var x int
    return func() int { // 匿名函数
        x++
        return x * x
    }
}
func main() {
    f := squares()
    fmt.Println(f()) // "1"
    fmt.Println(f()) // "4"
    fmt.Println(f()) // "9"
    fmt.Println(f()) // "16"
}
//通过这个例子，我们看到变量的生命周期不由它的作用域决定：squares返回后，变量x仍然隐式的存在于f中。
```

> 网页抓取的核心问题就是如何遍历图

警告:捕获迭代变量

```golang
var rmdirs []func()
for _, d := range tempDirs() {
    dir := d // NOTE: necessary!
    os.MkdirAll(dir, 0755) // creates parent directories too
    rmdirs = append(rmdirs, func() {
        os.RemoveAll(dir)
    })
}
// ...do some work…
for _, rmdir := range rmdirs {
    rmdir() // clean up
}
// 
var rmdirs []func()
for _, dir := range tempDirs() {
    os.MkdirAll(dir, 0755)
    rmdirs = append(rmdirs, func() {
        os.RemoveAll(dir) // NOTE: incorrect!
    })
}

```

问题出在了循环变量的作用域,循环变量dir在这个词法块中被声明，每一次迭代都是会不断地更新这个值，被`range`语句，解决这个问题的办法就是引入同名变量来覆盖其作用域。

## 5.4 可变参数

简单的可变参数例子,其实`可变参数`就是个切片的值传递,`interface{}`表示函数的最后一个参数可以接收任意类型

```golang
func sum(vals ...int) int {
    total := 0
    for _, val := range vals {
        total += val
    }
    return total
}
```

如果原参数就是切片该怎么传递？可以直接在`实参`后面加省略号

## 5.5 defer函数

在函数执行完成之后，不管是正常退出还是异常退出函数，最后都会被执行

## 5.6 panic异常

当panic发生时会在该goroutine上执行defer函数，打印对应的栈信息
`regexp`包的使用
为了方便诊断问题，runtime包允许程序员输出堆栈信息。在下面的例子中，我们通过在main函数中延迟调用printStack输出堆栈信息。

```golang
func main() {
    defer printStack()
    f(3)
}
func printStack() {
    var buf [4096]byte
    n := runtime.Stack(buf[:], false)
    os.Stdout.Write(buf[:n])
}

```

将panic机制类比其他语言异常机制的读者可能会惊讶，runtime.Stack为何能输出已经被释放函数的信息？在Go的panic机制中，延迟函数的调用在释放堆栈信息之前。

## 5.7 Recovery捕获异常

通常来说，不应该对panic异常做任何处理，但有时，也许我们可以从异常中恢复，至少我们可以在程序崩溃前，做一些操作。举个例子，当web服务器遇到不可预料的严重问题时，在崩溃前应该将所

- 语言解析器为例
说明recover的使用场景。考虑到语言解析器的复杂性，即使某个语言解析器目前工作正常，也无法肯定它没有漏洞。因此，当某个异常出现时，我们不会选择让解析器崩溃，而是会将panic异常当作普通的解析错误，并附加额外信息提醒用户报告此错误

```golang
func Parse(input string) (s *Syntax, err error) {
    defer func() {
        if p := recover(); p != nil {
            err = fmt.Errorf("internal error: %v", p)
        }
    }()
    // ...parser...
}
```

- 虽然把对panic的处理都集中在一个包下，有助于简化对复杂和不可以预料问题的处理，但作为被广泛遵守的规范，你不应该试图去恢复其他包引起的panic。公有的API应该将函数的运行失败作为error返回，而不是panic。同样的，你也不应该恢复一个由他人开发的函数引起的panic，比如说调用者传入的回调函数，因为你无法确保这样做是安全的。  
- 有时我们很难完全遵循规范，举个例子，net/http包中提供了一个web服务器，将收到的请求分发给用户提供的处理函数。很显然，我们不能因为某个处理函数引发的panic异常，杀掉整个进程；web服务器遇到处理函数导致的panic时会调用recover，输出堆栈信息，继续运行。这样的做法在实践中很便捷，但也会引起资源泄漏，或是因为recover操作，导致其他问题。

```golang
// soleTitle returns the text of the first non-empty title element
// in doc, and an error if there was not exactly one.
//防御性panic代码
func soleTitle(doc *html.Node) (title string, err error) {
    type bailout struct{}
    defer func() {
        switch p := recover(); p {
        case nil:       // no panic
        case bailout{}: // "expected" panic
            err = fmt.Errorf("multiple title elements")
        default:
            panic(p) // unexpected panic; carry on panicking
        }
    }()
    // Bail out of recursion if we find more than one nonempty title.
    forEachNode(doc, func(n *html.Node) {
        if n.Type == html.ElementNode && n.Data == "title" &&
            n.FirstChild != nil {
            if title != "" {
                panic(bailout{}) // multiple titleelements
            }
            title = n.FirstChild.Data
        }
    }, nil)
    if title == "" {
        return "", fmt.Errorf("no title element")
    }
    return title, nil
}
```

# 6. 方法

## 6.1 方法声明

- 普通函数与接收器方法
`接收器`因此在Go语言里，我们为一些简单的数值、字符串、slice、map来定义一些附加行为很方便。我们可以给同一个包内的任意命名类型定义方法，只要这个命名类型的底层类型（译注：这个例子里，底层类型是指[]Point这个slice，Path就是命名类型）不是指针或者interface。对于一个给定的类型，其内部的方法都必须有唯一的方法名

## 6.2 基于指针对象的方法

- 不管你的method的receiver是指针类型还是非指针类型，都是可以通过指针/非指针类型进行调用的，编译器会帮你做类型转换。
- 在声明一个method的receiver该是指针还是非指针类型时，你需要考虑两方面的因素，第一方面是这个对象本身是不是特别大，如果声明为非指针变量时，调用会产生一次拷贝；第二方面是如果你用指针类型作为receiver，那么你一定要注意，这种指针类型指向的始终是一块内存地址，就算你对其进行了拷贝。熟悉C或者C++的人这里应该很快能明白。
- 当你定义一个允许nil作为接收器值的方法的类型时，在类型前面的注释中指出nil变量代表的意义是很有必要的，就像我们下面例子里做的这样

    ```golang
    func (list *IntList) Sum() int {
    if list == nil {
        return 0
    }
    return list.Value + list.Tail.Sum()
    }
    ```

    如果此时结构体是`nil`调用对象可能会发生类似于空指针异常的错误

## 6.3. 通过嵌入结构体来扩展类型

- 方法值
    在go语言中，方法是第一公民，这一点在函数式编程中非常实用(maybe)

    ```golang
    //方法值demo
    p := Point{1, 2}
    q := Point{4, 6}

    distanceFromP := p.Distance        // method value,Distance是结构体方法
    fmt.Println(distanceFromP(q))      // "5"
    var origin Point                   // {0, 0}
    fmt.Println(distanceFromP(origin)) // "2.23606797749979", sqrt(5)

    scaleP := p.ScaleBy // method value
    scaleP(2)           // p becomes (2, 4)
    scaleP(3)           //      then (6, 12)
    scaleP(10)          //      then (60, 120)
    ```

- 方法表达式
    在面向对象中，当根据哪一个变量来决定调用哪个函数时候,方法表达式就很有用了.

    ```golang
    p := Point{1, 2}
    q := Point{4, 6}

    distance := Point.Distance   // method expression
    fmt.Println(distance(p, q))  // "5"
    fmt.Printf("%T\n", distance) // "func(Point, Point) float64"

    scale := (*Point).ScaleBy
    scale(&p, 2)
    fmt.Println(p)            // "{2 4}"
    fmt.Printf("%T\n", scale) // "func(*Point, float64)"

    ```

practice demo

```golang
type Point struct{ X, Y float64 }

func (p Point) Add(q Point) Point { return Point{p.X + q.X, p.Y + q.Y} }
func (p Point) Sub(q Point) Point { return Point{p.X - q.X, p.Y - q.Y} }

type Path []Point

func (path Path) TranslateBy(offset Point, add bool) {
    var op func(p, q Point) Point
    if add {
        op = Point.Add
    } else {
        op = Point.Sub
    }
    for i := range path {
        // Call either path[i].Add(offset) or path[i].Sub(offset).
        path[i] = op(path[i], offset)
    }
}
```

## 6.4 封装

封装提供了三方面的优点。

1. 首先，因为调用方不能直接修改对象的变量值，其只需要关注少量的语句并且只要弄懂少量变量的可能的值即可.
2. 第二，隐藏实现的细节，可以防止调用方依赖那些可能变化的具体实现，这样使设计包的程序员在不破坏对外的api情况下能得到更大的自由
3. bytes.Buffer这个类型作为例子来考虑

    ```golang

    type Buffer struct {
    buf     []byte
    initial [64]byte
    /* ... */
    }

    // Grow expands the buffer's capacity, if necessary,
    // to guarantee space for another n bytes. [...]
    func (b *Buffer) Grow(n int) {
        if b.buf == nil {
            b.buf = b.initial[:0] // use preallocated space initially
        }
        if len(b.buf)+n > cap(b.buf) {
            buf := make([]byte, b.Len(), 2*cap(b.buf) + n)
            copy(buf, b.buf)
            b.buf = buf
        }
    }
    // Grow()函数式导出类型，但是stuct的字段不是到处类型
    ```

4. 只暴漏关键信息给外部使用者

# 7. 接口

很多面向对象的语言都有相似的接口概念，但Go语言中接口类型的独特之处在于它是满足隐式实现的。也就是说，我们没有必要对于给定的具体类型定义所有满足的接口类型；简单地拥有一些必需的方法就足够了。这种设计可以让你创建一个新的接口类型满足已经存在的具体类型却不会去改变这些类型的定义；当我们使用的类型来自于不受我们控制的包时这种设计尤其有用  

只要一个物体能像鸭子一样叫那我们就可以称它为鸭子；只要一个软件能存储和查询数据我们就可以称它为数据库；只要一台机器有洗衣服和甩干的功能我们就可以称它为洗衣机。  

为了保护你的Go语言职业生涯，请牢记接口（interface）是一种类型

## 7.1. 接口约定

例如`fmt`包

```golang
    package fmt

    func Fprintf(w io.Writer, format string, args ...interface{}) (int, error)
    //Printf 最后调用Fprintf 函数
    func Printf(format string, args ...interface{}) (int, error) {
        return Fprintf(os.Stdout, format, args...)
    }
    // Sprintf函数最后也是调用Fprintf
    func Sprintf(format string, args ...interface{}) string {
        var buf bytes.Buffer
        Fprintf(&buf, format, args...)
        return buf.String()
    }
```

`Fprintf`函数的`F`说明了文件类型也说明了所有信息要被写入到文件当中，在`Printf`函数中的第一个参数`os.Stdout`是`*os.File`类型实现了`io.Writer`接口，在`Sprintf`函数中的第一个参数`&buf`是一个指向可以写入字节的内存缓冲区也该类型也是实现了`io.Writer`接口,用户可以自定义一个函数并实现`io.Writer`接口。  
**LSP里氏替换** : `fmt.Fprintf`通过使用接口类型`io.Writer`使得只要调用者只要传入实现了该接口的类型就可以实现自由替换

<details><summary>自定义bytecounter函数，实现计算int转byte长度</summary>

```golang

package main

import (
 "fmt"
)

//!+bytecounter

type ByteCounter int

func (c *ByteCounter) Write(p []byte) (int, error) {
 *c += ByteCounter(len(p)) // convert int to ByteCounter
 return len(p), nil
}

//!-bytecounter

func main() {
 //!+main
 var c ByteCounter
 c.Write([]byte("hello"))
 fmt.Println(c) // "5", = len("hello")

 c = 0 // reset the counter
 var name = "Dolly"
 fmt.Fprintf(&c, "hello, %s", name)
 fmt.Println(c) // "12", = len("hello, Dolly")
 //!-main
}
```

</details>

因为它实现了`writer`接口就可以传入到`Fprintf`函数中.总结来说，接口约定了包使用者的行为，但是使用者想创建什么样的实例需要他自己去实现。

## 7.2 接口类型

通过组合定义接口

```golang
package io
type Reader interface {
    Read(p []byte) (n int, err error)
}
type Closer interface {
    Close() error
}

type ReadWriter interface {
    Reader
    Writer
}
type ReadWriteCloser interface {
    Reader
    Writer
    Closer
}
// 另一种命名风格
type ReadWriter interface {
    Read(p []byte) (n int, err error)
    Write(p []byte) (n int, err error)
}
//或者甚至使用一种混合的风格：

type ReadWriter interface {
    Read(p []byte) (n int, err error)
    Writer
}
```

## 7.3 实现接口的条件

- 一个类型如果拥有一个接口需要的所有方法，那么这个类型就实现了这个接口.

    ```golang
    var w io.Writer
    //只实现了Write 方法
    w = os.Stdout           // OK: *os.File has Write method
    //只实现了Write方法
    w = new(bytes.Buffer)   // OK: *bytes.Buffer has Write method
    // time.Duration没有Write方法
    w = time.Second         // compile error: time.Duration lacks Write method

    var rwc io.ReadWriteCloser
    rwc = os.Stdout         // OK: *os.File has Read, Write, Close methods
    rwc = new(bytes.Buffer) // compile error: *bytes.Buffer lacks Close method
    // 这个规则甚至适用于等式右边本身也是一个接口类型
    // rwc io.ReadWriteCloser
    w = rwc                 // OK: io.ReadWriteCloser has Write method
    // w 只有Write方法
    rwc = w                 // compile error: io.Writer lacks Close method
    ```

-

## 7.4 flag.Value接口

在linux程序中，你会发现很多程序都支持选项，通过带上参数，程序会有很多丰富的功能
比如下面demo就是简单的打印选项-period后面的值。

```golang
    var period = flag.Duration("period", 1*time.Second, "sleep period")

    func main() {
        flag.Parse()
        fmt.Printf("Sleeping for %v...", *period)
        time.Sleep(*period)
        fmt.Println()
    }
```

这里golang的flag包提供了这种功能，我们可以通过实现flag的接口自定义新的标记符号

```golang
package flag

// Value is the interface to the value stored in a flag.
type Value interface {
    String() string
    Set(string) error
}

```

`string() string`方法格式化标记的值  
`Set(string) error` 解析它的字符串参数，并更新标记变量的值  
让我们定义一个允许通过摄氏度或者华氏温度变换的形式指定温度的celsiusFlag类型。
注意celsiusFlag内嵌了一个Celsius类型，因此不用实现本身就已经有String方法了。为了实现flag.Value，我们只需要定义Set方法：
代码demo如下

- 自定义新的标记符号

    <details><summary>温度的转化</summary>

    ```golang
    package tempconv

    import (
        "flag"
        "fmt"
    )

    type Celsius float64
    type Fahrenheit float64

    func CToF(c Celsius) Fahrenheit { return Fahrenheit(c*9.0/5.0 + 32.0) }
    func FToC(f Fahrenheit) Celsius { return Celsius((f - 32.0) * 5.0 / 9.0) }

    func (c Celsius) String() string { return fmt.Sprintf("%g°C", c) }

    /*
    //!+flagvalue
    package flag

    // Value is the interface to the value stored in a flag.
    type Value interface {
        String() string
        Set(string) error
    }
    //!-flagvalue
    */

    //!+celsiusFlag
    // *celsiusFlag satisfies the flag.Value interface.
    type celsiusFlag struct{ Celsius }

    func (f *celsiusFlag) Set(s string) error {
        var unit string
        var value float64
        fmt.Sscanf(s, "%f%s", &value, &unit) // no error check needed
        switch unit {
        case "C", "°C":
            f.Celsius = Celsius(value)
            return nil
        case "F", "°F":
            f.Celsius = FToC(Fahrenheit(value))
            return nil
        }
        return fmt.Errorf("invalid temperature %q", s)
    }

    //!-celsiusFlag

    //!+CelsiusFlag

    // CelsiusFlag defines a Celsius flag with the specified name,
    // default value, and usage, and returns the address of the flag variable.
    // The flag argument must have a quantity and a unit, e.g., "100C".
    func CelsiusFlag(name string, value Celsius, usage string) *Celsius {
        f := celsiusFlag{value}
        flag.CommandLine.Var(&f, name, usage)
        return &f.Celsius
    }
    // main函数
    var temp = tempconv.CelsiusFlag("temp", 20.0, "the temperature")

    func main() {
        flag.Parse()
        fmt.Println(*temp)
    }
    ```

    </details>

    <details><summary>url解析</summary>
    ```golang

    package main

    import (
        "flag"
        "fmt"
        "net/url"
    )

    type URLValue struct {
        URL *url.URL
    }

    func (v URLValue) String() string {
        if v.URL != nil {
            return v.URL.String()
        }
        return ""
    }

    func (v URLValue) Set(s string) error {
        if u, err := url.Parse(s); err != nil {
            return err
        } else {
            *v.URL =*u
        }
        return nil
    }

    var u = &url.URL{}

    func main() {
        fs := flag.NewFlagSet("ExampleValue", flag.ExitOnError)
        fs.Var(&URLValue{u}, "url", "URL to parse")

        fs.Parse([]string{"-url", "https://golang.org/pkg/flag/"})
        fmt.Printf(\`{scheme: %q, host: %q, path: %q}\`, u.Scheme, u.Host, u.Path)

    }

    ```

    </details>

## 7.5 接口值

概念上讲接口的值,由两部分组成,是其`类型(值)`和`具体类型的值`,他们的组合被称为接口的`动态类型`和`动态值`.
对于像Go语言这种静态类型的语言,类型是编译期的概念;因此一个类型不是一个值。在我们的概念模型中，
一些提供每个类型信息的值被称为类型描述符，比如类型的名称和方法。在一个接口值中，类型部分代表与之相关类型的描述符。  
下面语句中，变量w得到了3个不同的值,他们三个的值都是相同的

```golang
var w io.Writer //接口type Write
w = os.Stdout // 最后返回的是*file类型,func (f *File) Write(b []byte) (n int, err error)
w = new(bytes.Buffer) // func (b *Buffer) Write(p []byte) (n int, err error)
w = nil // 动态类型和动态值都为空

var a *bytes.Buffer //接口*bytes.Buffer
a = nil               // 动态类型不为空和动态值都为空
fmt.Printf("%T\n", a) // "*bytes.Buffer"
```

```golang
var w io.Writer
```

![7.1](./../../../picture/golang语言圣经/ch7-01.png)

在Go语言中，变量总是被一个定义明确的值初始化，即使接口类型也不例外。对于一个接口的零值就是它的类型和值的部分都是nil（图7.1）。

一个接口值基于它的动态类型被描述为`nil`或`!nil`，所以这是一个空的接口值。你可以通过使用`w==nil`或者`w!=nil`来判断接口值是否为空。调用一个空接口值上的任意方法都会产生`panic`:

```golang
w.Write([]byte("hello")) // panic: nil pointer dereference
```

<text style="font-family:Courier New;color:red">
如果是接口类型定义的变量那么它的动态类型和动态值都是nil，赋nil之后动态类型和动态值也全都是nil值，
但是指针,基本类型和复合类型不会.

类似于java一样，不能没有对象就调用方法，会报空指针异常,上面代码在第三行动态值写为nil
这里面有个细节要明白，定义语句var w io.Writer(接口类型),其实是动态类型和动态值都是nil,
进行布尔判断的时候才是为nil,w = nil 是将动态类型和动态值都设置成nil

</text>

第二个语句将一个`*os.File`类型的值赋给变量`w`:

```golang
w = os.Stdout
```

这个赋值过程调用了一个具体类型到接口类型的隐式转换，这和显式的使用`io.Writer(os.Stdout)`是等价的。这类转换不管是显式的还是隐式的，都会刻画出操作到的类型和值。这个接口值的动态类型被设为`*os.File`指针的类型描述符，它的动态值持有`os.Stdout`的拷贝;这是一个代表处理标准输出的`os.File`类型变量的指针7.2
![7.2](./../../../picture/golang语言圣经/ch7-02.png)

<text style="font-family:Courier New;color:red">
在第二行的赋值操作中,type已经变成`*os.file`类型,其实上面说的很啰嗦,直接就是os.Stdout是具
体的*file类型实现了io.Writer接口
</text>

调用一个包含`*os.File`类型指针的接口值的`Write`方法，使得`(*os.File).Write`方法被调用。这个调用输出“hello”。

```golang
w.Write([]byte("hello")) // "hello"
```

通常在编译期，我们不知道接口值的动态类型是什么，所以一个接口上的调用必须使用动态分配。因为不是直接进行调用，所以编译器必须把代码生成在类型描述符的方法`Write`上，然后间接调用那个地址。这个调用的接收者是一个接口动态值的拷贝，`os.Stdout`。效果和下面这个直接调用一样：

```golang
os.Stdout.Write([]byte("hello")) // "hello"
```

第三个语句给接口值赋了一个`*bytes.Buffer`类型的值

```golang
w = new(bytes.Buffer)
```

现在动态类型是`*bytes.Buffer`,并且动态值是一个指向新分配的缓冲区的指针
![7.3](./../../../picture/golang语言圣经/ch7-03.png)
`Write`方法的调用也使用了和之前一样的机制:

```golang
w.Write([]byte("hello")) // writes "hello" to the bytes.Buffers
```

这次类型描述符是`*bytes.Buffer`，所以调用了`(*bytes.Buffer).Write`方法，并且接收者是该缓冲区的地址。这个调用把字符串“hello”添加到缓冲区中。
最后，第四个语句将nil赋给了接口值:

```golang
w = nil
```

这个重置将它所有的部分都设为`nil`值,把变量`w`恢复到和它之前定义时相同的状态，在图7.1中可以看到。

一个接口值可以持有任意大的动态值。例如,表示时间实例的time.Time类型，这个类型有几个对外不公开的字段。我们从它上面创建一个接口值:

```golang
var x interface{} = time.Now()
```

<text style="font-family:Courier New;color:red">
这里就是创建了一个接口类型的x值,然后可以引用任何类型值
</text>

结果可能和图7.4相似。从概念上讲，不论接口值多大，动态值总是可以容下它。（这只是一个概念上的模型;具体的实现可能会非常不同）

![7.4](./../../../picture/golang语言圣经/ch7-04.png)

接口值可以使用`==`和`!＝`来进行比较。两个接口值相等仅当它们都是`nil`值，或者它们的动态类型相同并且动态值也根据这个动态类型的`==`操作相等。因为接口值是可比较的，所以它们可以用在map的键或者作为switch语句的操作数。

然而，如果两个接口值的`动态类型`相同，但是这个动态类型是不可比较的（比如切片），将它们进行比较就会失败并且panic:

<text style="font-family:Courier New;color:red">

注意到原话'它们的动态类型相同并且动态值,就可以进行`==`操作',要保证动态类型相等,动态值相等,则A==A
那么基本类型相同,复杂类型地址相等

</text>

考虑到这点，接口类型是非常与众不同的。其它类型要么是安全的可比较类型(如基本类型和指针)要么是完全不可比较的类型（如切片，映射类型，和函数），但是在比较接口值或者包含了接口值的聚合类型时，我们必须要意识到潜在的panic。同样的风险也存在于使用接口作为map的键或者switch的操作数。只能比较你非常确定它们的动态值是可比较类型的接口值。  

当我们处理错误或者调试的过程中，得知接口值的动态类型是非常有帮助的。所以我们使用fmt包的%T动作:

```golang

var w io.Writer
fmt.Printf("%T\n", w) // "<nil>"
w = os.Stdout
fmt.Printf("%T\n", w) // "*os.File"
w = new(bytes.Buffer)
fmt.Printf("%T\n", w) // "*bytes.Buffer"
var buf *bytes.Buffer
fmt.Printf("%T\n", buf) // "*bytes.Buffer"
var x interface{}
fmt.Printf("%T\n", x) // "<nil>"
// 另一个接口值相等的case
w := new(bytes.Buffer)
fmt.Printf("%T\n", w) // "*bytes.Buffer"
var buf *bytes.Buffer
fmt.Printf("%T\n", buf) // "*bytes.Buffer"
w = &bytes.Buffer{}
buf = &bytes.Buffer{}
w!=buf

```

### 7.5.1. 警告:一个包含nil指针的接口不是nil接口

一个不包含任何值的nil接口值和一个刚好包含nil指针的接口值是不同的。这个细微区别产生了一个容易绊倒每个Go程序员的陷阱。

思考下面的程序。当debug变量设置为true时，main函数会将`f函数`的输出收集到一个bytes.Buffer类型中。

```golang
const debug = true

func main() {
    var buf *bytes.Buffer
    if debug {
        buf = new(bytes.Buffer) // enable collection of output
    }
    f(buf) // NOTE: subtly incorrect!
    if debug {
        // ...use buf...
    }
}

// If out is non-nil, output will be written to it.
func f(out io.Writer) {
    // ...do something...
    if out != nil {
        out.Write([]byte("done!\n"))
    }
}

```

我们可能会预计当把变量debug设置为false时可以禁止对输出的收集，但是实际上在out.Write方法调用时程序发生了panic：

```golang
if out != nil {
    out.Write([]byte("done!\n")) // panic: nil pointer dereference
}
```

当main函数调用函数f时，它给`f函数`的out参数赋了一个`*bytes.Buffer`的空指针，所以out的动态值是nil。然而，它的动态类型是`*bytes.Buffer`，意思就是out变量是一个包含空指针值的非空接口（如图7.5），所以防御性检查out!=nil的结果依然是true。

![7.5](./../../../picture/golang语言圣经/ch7-05.png)

动态分配机制依然决定`(*bytes.Buffer).Write`的方法会被调用，但是这次的接收者的值是nil。对于一些如`*os.File`的类型，nil是一个有效的接收者（§6.2.1），但是`*bytes.Buffer`类型不在这些种类中。这个方法会被调用，但是当它尝试去获取缓冲区时会发生panic。

问题在于尽管一个nil的`*bytes.Buffer`指针有实现这个接口的方法，它也不满足这个接口具体的行为上的要求。特别是这个调用违反了`(*bytes.Buffer).Write`方法的接收者非空的隐含先觉条件，所以将nil指针赋给这个接口是错误的。解决方案就是将main函数中的变量buf的类型改为`io.Writer`，因此可以避免一开始就将一个不完整的值赋值给这个接口：

```golang
var buf io.Writer // 这时候是空指针，没有具体值(对象)
if debug {
    buf = new(bytes.Buffer) // enable collection of output
}
f(buf) // OK


// If out is non-nil, output will be written to it.
func f(out io.Writer) {
    // ...do something...
    if out != nil { // 此处判断out为nil
        out.Write([]byte("done!\n"))
    }
}
```

<text style="font-family:Courier New;color:red">
总结一句话就是动态类型不为nil,动态值为nil,这个变量也是不要nil
</text>

## 7.6. sort.Interface接口

排序操作和字符串格式化一样是很多程序经常使用的操作。尽管一个最短的快排程序只要15行就可以搞定，但是一个健壮的实现需要更多的代码，并且我们不希望每次我们需要的时候都重写或者拷贝这些代码。

幸运的是，sort包内置的提供了根据一些排序函数来对任何序列排序的功能。它的设计非常独到。在很多语言中，排序算法都是和序列数据类型关联，同时排序函数和具体类型元素关联。相比之下，Go语言的sort.Sort函数不会对具体的序列和它的元素做任何假设。相反，它使用了一个接口类型sort.Interface来指定通用的排序算法和可能被排序到的序列类型之间的约定。这个接口的实现由序列的具体表示和它希望排序的元素决定，序列的表示经常是一个切片。

一个内置的排序算法需要知道三个东西：序列的长度，表示两个元素比较的结果，一种交换两个元素的方式；这就是sort.Interface的三个方法：

```golang
package sort

type Interface interface {
    Len() int
    Less(i, j int) bool // i, j are indices of sequence elements
    Swap(i, j int)
}
```

为了对序列进行排序，我们需要定义一个实现了这三个方法的类型，然后对这个类型的一个实例应用sort.Sort函数。思考对一个字符串切片进行排序，这可能是最简单的例子了。下面是这个新的类型`StringSlice`和它的`Len`,`Less`和`Swap`方法

```golang
type StringSlice []string
func (p StringSlice) Len() int           { return len(p) }
func (p StringSlice) Less(i, j int) bool { return p[i] < p[j] }
func (p StringSlice) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }
```

现在我们可以通过像下面这样将一个切片转换为一个`StringSlice`类型来进行排序：

`sort.Sort(StringSlice(names))`
这个转换得到一个相同长度，容量，和基于`names`数组的切片值;并且这个切片值的类型有三个排序需要的方法。

对字符串切片的排序是很常用的需要，所以`sort`包提供了`StringSlice`类型，也提供了`Strings`函数能让上面这些调用简化成`sort.Strings(names)`

这里用到的技术很容易适用到其它排序序列中，例如我们可以忽略大小写或者含有的特殊字符。（本书使用Go程序对索引词和页码进行排序也用到了这个技术，对罗马数字做了额外逻辑处理。）对于更复杂的排序，我们使用相同的方法，但是会用更复杂的数据结构和更复杂地实现`sort.Interface`的方法。

我们会运行上面的例子来对一个表格中的音乐播放列表进行排序。每个track都是单独的一行，每一列都是这个track的属性像艺术家，标题，和运行时间。想象一个图形用户界面来呈现这个表格，并且点击一个属性的顶部会使这个列表按照这个属性进行排序；再一次点击相同属性的顶部会进行逆向排序。让我们看下每个点击会发生什么响应。

下面的变量tracks包含了一个播放列表。（One of the authors apologizes for the other author’s musical tastes.）每个元素都不是Track本身而是指向它的指针。尽管我们在下面的代码中直接存储Tracks也可以工作，sort函数会交换很多对元素，所以如果每个元素都是指针而不是Track类型会更快，指针是一个机器字码长度而Track类型可能是八个或更多。

```golang
gopl.io/ch7/sorting


type Track struct {
    Title  string
    Artist string
    Album  string
    Year   int
    Length time.Duration
}

var tracks = []*Track{
    {"Go", "Delilah", "From the Roots Up", 2012, length("3m38s")},
    {"Go", "Moby", "Moby", 1992, length("3m37s")},
    {"Go Ahead", "Alicia Keys", "As I Am", 2007, length("4m36s")},
    {"Ready 2 Go", "Martin Solveig", "Smash", 2011, length("4m24s")},
}

func length(s string) time.Duration {
    d, err := time.ParseDuration(s)
    if err != nil {
        panic(s)
    }
    return d
}
```

printTracks函数将播放列表打印成一个表格。一个图形化的展示可能会更好点，但是这个小程序使用text/tabwriter包来生成一个列整齐对齐和隔开的表格，像下面展示的这样。注意到*tabwriter.Writer是满足io.Writer接口的。它会收集每一片写向它的数据；它的Flush方法会格式化整个表格并且将它写向os.Stdout（标准输出）。

```golang
func printTracks(tracks []*Track) {
    const format = "%v\t%v\t%v\t%v\t%v\t\n"
    tw := new(tabwriter.Writer).Init(os.Stdout, 0, 8, 2, ' ', 0)
    fmt.Fprintf(tw, format, "Title", "Artist", "Album", "Year", "Length")
    fmt.Fprintf(tw, format, "-----", "------", "-----", "----", "------")
    for _, t := range tracks {
        fmt.Fprintf(tw, format, t.Title, t.Artist, t.Album, t.Year, t.Length)
    }
    tw.Flush() // calculate column widths and print table
}
```

为了能按照Artist字段对播放列表进行排序，我们会像对StringSlice那样定义一个新的带有必须的Len，Less和Swap方法的切片类型。

```golang
type byArtist []*Track
func (x byArtist) Len() int           { return len(x) }
func (x byArtist) Less(i, j int) bool { return x[i].Artist < x[j].Artist }
func (x byArtist) Swap(i, j int)      { x[i], x[j] = x[j], x[i] }
```

为了调用通用的排序程序，我们必须先将tracks转换为新的byArtist类型，它定义了具体的排序：

`sort.Sort(byArtist(tracks))`
在按照artist对这个切片进行排序后，printTrack的输出如下

```golang
Title       Artist          Album               Year Length
-----       ------          -----               ---- ------
Go Ahead    Alicia Keys     As I Am             2007 4m36s
Go          Delilah         From the Roots Up   2012 3m38s
Ready 2 Go  Martin Solveig  Smash               2011 4m24s
Go          Moby            Moby                1992 3m37s
```

如果用户第二次请求“按照artist排序”，我们会对tracks进行逆向排序。然而我们不需要定义一个有颠倒Less方法的新类型byReverseArtist，因为sort包中提供了Reverse函数将排序顺序转换成逆序。
`sort.Sort(sort.Reverse(byArtist(tracks)))`
在按照artist对这个切片进行逆向排序后，printTrack的输出如下

```golang
Title       Artist          Album               Year Length
-----       ------          -----               ---- ------
Go          Moby            Moby                1992 3m37s
Ready 2 Go  Martin Solveig  Smash               2011 4m24s
Go          Delilah         From the Roots Up   2012 3m38s
Go Ahead    Alicia Keys     As I Am             2007 4m36s
```

`sort.Reverse`函数值得进行更近一步的学习，因为它使用了（§6.3）章中的组合，这是一个重要的思路。`sort`包定义了一个不公开的`struct`类型`reverse`，它嵌入了一个`sort.Interface`。`reverse`的`Less`方法调用了内嵌的`sort.Interface`值的`Less`方法，但是通过交换索引的方式使排序结果变成逆序。

```golang
package sort

type reverse struct{ Interface } // that is, sort.Interface

func (r reverse) Less(i, j int) bool { return r.Interface.Less(j, i) }

func Reverse(data Interface) Interface { return reverse{data} }
```

`reverse`的另外两个方法`Len`和`Swap`隐式地由原有内嵌的`sort.Interface`提供。因为`reverse`是一个不公开的类型，所以导出函数`Reverse`返回一个包含原有`sort.Interface`值的reverse类型实例。

为了可以按照不同的列进行排序，我们必须定义一个新的类型例如byYear：

```golang
type byYear []*Track
func (x byYear) Len() int           { return len(x) }
func (x byYear) Less(i, j int) bool { return x[i].Year < x[j].Year }
func (x byYear) Swap(i, j int)      { x[i], x[j] = x[j], x[i] }
```

在使用sort.Sort(byYear(tracks))按照年对tracks进行排序后，printTrack展示了一个按时间先后顺序的列表：

```golang
Title       Artist          Album               Year Length
-----       ------          -----               ---- ------
Go          Moby            Moby                1992 3m37s
Go Ahead    Alicia Keys     As I Am             2007 4m36s
Ready 2 Go  Martin Solveig  Smash               2011 4m24s
Go          Delilah         From the Roots Up   2012 3m38s
```

对于我们需要的每个切片元素类型和每个排序函数，我们需要定义一个新的sort.Interface实现。如你所见，Len和Swap方法对于所有的切片类型都有相同的定义。下个例子，具体的类型customSort会将一个切片和函数结合，使我们只需要写比较函数就可以定义一个新的排序。顺便说下，实现了sort.Interface的具体类型不一定是切片类型；customSort是一个结构体类型。

```golang
type customSort struct {
    t    []*Track
    less func(x, y *Track) bool
}

func (x customSort) Len() int           { return len(x.t) }
func (x customSort) Less(i, j int) bool { return x.less(x.t[i], x.t[j]) }
func (x customSort) Swap(i, j int) { x.t[i], x.t[j] = x.t[j], x.t[i] }
```

让我们定义一个多层的排序函数，它主要的排序键是标题，第二个键是年，第三个键是运行时间Length。下面是该排序的调用，其中这个排序使用了匿名排序函数：

```golang
sort.Sort(customSort{tracks, func(x, y *Track) bool {
    if x.Title != y.Title {
        return x.Title < y.Title
    }
    if x.Year != y.Year {
        return x.Year < y.Year
    }
    if x.Length != y.Length {
        return x.Length < y.Length
    }
    return false
}})
```

这下面是排序的结果。注意到两个标题是“Go”的track按照标题排序是相同的顺序，但是在按照year排序上更久的那个track优先。

```golang

Title       Artist          Album               Year Length
-----       ------          -----               ---- ------
Go          Moby            Moby                1992 3m37s
Go          Delilah         From the Roots Up   2012 3m38s
Go Ahead    Alicia Keys     As I Am             2007 4m36s
Ready 2 Go  Martin Solveig  Smash               2011 4m24s
```

尽管对长度为n的序列排序需要 O(n log n)次比较操作，检查一个序列是否已经有序至少需要n-1次比较。sort包中的IsSorted函数帮我们做这样的检查。像sort.Sort一样，它也使用sort.Interface对这个序列和它的排序函数进行抽象，但是它从不会调用Swap方法：这段代码示范了IntsAreSorted和Ints函数在IntSlice类型上的使用：

```golang
values := []int{3, 1, 4, 1}
fmt.Println(sort.IntsAreSorted(values)) // "false"
sort.Ints(values)
fmt.Println(values)                     // "[1 1 3 4]"
fmt.Println(sort.IntsAreSorted(values)) // "true"
sort.Sort(sort.Reverse(sort.IntSlice(values)))
fmt.Println(values)                     // "[4 3 1 1]"
fmt.Println(sort.IntsAreSorted(values)) // "false"
```

为了使用方便，sort包为`[]int`、`[]string`和`[]float64`的正常排序提供了特定版本的函数和类型。对于其他类型，例如`[]int64`或者`[]uint`，尽管路径也很简单，还是依赖我们自己实现。

练习 7.8： 很多图形界面提供了一个有状态的多重排序表格插件：主要的排序键是最近一次点击过列头的列，第二个排序键是第二最近点击过列头的列，等等。定义一个sort.Interface的实现用在这样的表格中。比较这个实现方式和重复使用sort.Stable来排序的方式。

练习 7.9： 使用html/template包（§4.6）替代printTracks将tracks展示成一个HTML表格。将这个解决方案用在前一个练习中，让每次点击一个列的头部产生一个HTTP请求来排序这个表格。

练习 7.10： sort.Interface类型也可以适用在其它地方。编写一个IsPalindrome(s sort.Interface) bool函数表明序列s是否是回文序列，换句话说反向排序不会改变这个序列。假设如果!s.Less(i, j) && !s.Less(j, i)则索引i和j上的元素相等。

## 7.7. http.Handler接口

在第一章中,我们粗略的了解了怎么用`net/http`包去实现网络客户端（§1.5）和服务器（§1.7）。在这个小节中，我们会对那些基于`http.Handler`接口的服务器API做更进一步的学习：

```golang
net/http
package http

type Handler interface {
    ServeHTTP(w ResponseWriter, r *Request)
}

func ListenAndServe(address string, h Handler) error
```

`ListenAndServe`函数需要一个例如'localhost:8000'的服务器地址，和一个所有请求都可以分派的Handler接口实例。它会一直运行，直到这个服务因为一个错误而失败（或者启动失败），它的返回值一定是一个非空的错误。

想象一个电子商务网站，为了销售，将数据库中物品的价格映射成美元。下面这个程序可能是能想到的最简单的实现了。它将库存清单模型化为一个命名为database的map类型，我们给这个类型一个`ServeHttp`方法,这样它可以满足`http.Handler`接口。这个`handler`会遍历整个map并输出物品信息

```golang
gopl.io/ch7/http1


func main() {
    db := database{"shoes": 50, "socks": 5}
    log.Fatal(http.ListenAndServe("localhost:8000", db))
}

type dollars float32

func (d dollars) String() string { return fmt.Sprintf("$%.2f", d) }

type database map[string]dollars

func (db database) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    for item, price := range db {
        fmt.Fprintf(w, "%s: %s\n", item, price)
    }
}
```

如果我们启动这个服务，

```golang
go build gopl.io/ch7/http1
./http1 &
```

然后用1.5节中的获取程序（如果你更喜欢可以使用web浏览器）来连接服务器，我们得到下面的输出：

```golang
$ go build gopl.io/ch1/fetch
$ ./fetch http://localhost:8000
shoes: $50.00
socks: $5.00
```

目前为止，这个服务器不考虑URL，只能为每个请求列出它全部的库存清单。更真实的服务器会定义多个不同的URL，每一个都会触发一个不同的行为。让我们使用`/list`来调用已经存在的这个行为并且增加另一个`/price`调用表明单个货品的价格，像这样`/price?item=socks`来指定一个请求参数。

```golang
gopl.io/ch7/http2


func (db database) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    switch req.URL.Path {
    case "/list":
        for item, price := range db {
            fmt.Fprintf(w, "%s: %s\n", item, price)
        }
    case "/price":
        item := req.URL.Query().Get("item")
        price, ok := db[item]
        if !ok {
            w.WriteHeader(http.StatusNotFound) // 404
            fmt.Fprintf(w, "no such item: %q\n", item)
            return
        }
        fmt.Fprintf(w, "%s\n", price)
    default:
        w.WriteHeader(http.StatusNotFound) // 404
        fmt.Fprintf(w, "no such page: %s\n", req.URL)
    }
}
```

现在handler基于URL的路径部分(req.URL.Path)来决定执行什么逻辑。如果这个handler不能识别这个路径，它会通过调用w.WriteHeader(http.StatusNotFound)返回客户端一个HTTP错误；这个检查应该在向w写入任何值前完成。（顺便提一下，http.ResponseWriter是另一个接口。它在io.Writer上增加了发送HTTP相应头的方法。）等效地，我们可以使用实用的http.Error函数：

```golang
msg := fmt.Sprintf("no such page: %s\n", req.URL)
http.Error(w, msg, http.StatusNotFound) // 404
```

`/price`的case会调用URL的Query方法来将HTTP请求参数解析为一个map，或者更准确地说一个`net/url`包中`url.Values`(§6.2.1)类型的多重映射。然后找到第一个item参数并查找它的价格。如果这个货品没有找到会返回一个错误。

这里是一个和新服务器会话的例子：

```golang
$ go build gopl.io/ch7/http2
$ go build gopl.io/ch1/fetch
$ ./http2 &
$ ./fetch http://localhost:8000/list
shoes: $50.00
socks: $5.00
$ ./fetch http://localhost:8000/price?item=socks
$5.00
$ ./fetch http://localhost:8000/price?item=shoes
$50.00
$ ./fetch http://localhost:8000/price?item=hat
no such item: "hat"
$ ./fetch http://localhost:8000/help
no such page: /help
```

显然我们可以继续向ServeHTTP方法中添加case，但在一个实际的应用中，将每个case中的逻辑定义到一个分开的方法或函数中会很实用。此外，相近的URL可能需要相似的逻辑；例如几个图片文件可能有形如/images/*.png的URL。因为这些原因，net/http包提供了一个请求多路器ServeMux来简化URL和handlers的联系。一个ServeMux将一批http.Handler聚集到一个单一的http.Handler中。再一次，我们可以看到满足同一接口的不同类型是可替换的：web服务器将请求指派给任意的http.Handler 而不需要考虑它后面的具体类型。

对于更复杂的应用，一些ServeMux可以通过组合来处理更加错综复杂的路由需求。Go语言目前没有一个权威的web框架，就像Ruby语言有Rails和python有Django。这并不是说这样的框架不存在，而是Go语言标准库中的构建模块就已经非常灵活以至于这些框架都是不必要的。此外，尽管在一个项目早期使用框架是非常方便的，但是它们带来额外的复杂度会使长期的维护更加困难。

在下面的程序中，我们创建一个ServeMux并且使用它将URL和相应处理/list和/price操作的handler联系起来，这些操作逻辑都已经被分到不同的方法中。然后我们在调用ListenAndServe函数中使用ServeMux为主要的handler。

```golang
gopl.io/ch7/http3


func main() {
    db := database{"shoes": 50, "socks": 5}
    mux := http.NewServeMux()
    mux.Handle("/list", http.HandlerFunc(db.list))
    mux.Handle("/price", http.HandlerFunc(db.price))
    log.Fatal(http.ListenAndServe("localhost:8000", mux))
}

type database map[string]dollars

func (db database) list(w http.ResponseWriter, req *http.Request) {
    for item, price := range db {
        fmt.Fprintf(w, "%s: %s\n", item, price)
    }
}

func (db database) price(w http.ResponseWriter, req *http.Request) {
    item := req.URL.Query().Get("item")
    price, ok := db[item]
    if !ok {
        w.WriteHeader(http.StatusNotFound) // 404
        fmt.Fprintf(w, "no such item: %q\n", item)
        return
    }
    fmt.Fprintf(w, "%s\n", price)
}
```

让我们关注这两个注册到handlers上的调用。第一个db.list是一个方法值（§6.4），它是下面这个类型的值。

func(w http.ResponseWriter, req *http.Request)
也就是说db.list的调用会援引一个接收者是db的database.list方法。所以db.list是一个实现了handler类似行为的函数，但是因为它没有方法（理解：该方法没有它自己的方法），所以它不满足http.Handler接口并且不能直接传给mux.Handle。

语句http.HandlerFunc(db.list)是一个转换而非一个函数调用，因为http.HandlerFunc是一个类型。它有如下的定义：

```golang
net/http


package http

type HandlerFunc func(w ResponseWriter, r *Request)

func (f HandlerFunc) ServeHTTP(w ResponseWriter, r *Request) {
    f(w, r)
}
```

HandlerFunc显示了在Go语言接口机制中一些不同寻常的特点。这是一个实现了接口http.Handler的方法的函数类型。ServeHTTP方法的行为是调用了它的函数本身。因此HandlerFunc是一个让函数值满足一个接口的适配器，这里函数和这个接口仅有的方法有相同的函数签名。实际上，这个技巧让一个单一的类型例如database以多种方式满足http.Handler接口：一种通过它的list方法，一种通过它的price方法等等。

因为handler通过这种方式注册非常普遍，ServeMux有一个方便的HandleFunc方法，它帮我们简化handler注册代码成这样：

```golang

gopl.io/ch7/http3a

mux.HandleFunc("/list", db.list)
mux.HandleFunc("/price", db.price)
```

从上面的代码很容易看出应该怎么构建一个程序：由两个不同的web服务器监听不同的端口，并且定义不同的URL将它们指派到不同的handler。我们只要构建另外一个ServeMux并且再调用一次`ListenAndServe`（可能并行的）。但是在大多数程序中，一个web服务器就足够了。此外，在一个应用程序的多个文件中定义`HTTP handler`也是非常典型的，如果它们必须全部都显式地注册到这个应用的`ServeMux`实例上会比较麻烦。

所以为了方便，`net/http`包提供了一个全局的`ServeMux`实例`DefaultServerMux`和包级别的`http.Handle`和`http.HandleFunc`函数。现在，为了使用`DefaultServeMux`作为服务器的主`handler`，我们不需要将它传给`ListenAndServe`函数;nil值就可以工作。

然后服务器的主函数可以简化成：

```golang
gopl.io/ch7/http4

func main() {
    db := database{"shoes": 50, "socks": 5}
    http.HandleFunc("/list", db.list)
    http.HandleFunc("/price", db.price)
    log.Fatal(http.ListenAndServe("localhost:8000", nil))
}
```

最后，一个重要的提示：就像我们在1.7节中提到的，web服务器在一个新的协程中调用每一个handler，所以当handler获取其它协程或者这个handler本身的其它请求也可以访问到变量时，一定要使用预防措施，比如锁机制。我们后面的两章中将讲到并发相关的知识。

练习 7.11： 增加额外的handler让客户端可以创建，读取，更新和删除数据库记录。例如，一个形如 /update?item=socks&price=6 的请求会更新库存清单里一个货品的价格并且当这个货品不存在或价格无效时返回一个错误值。（注意：这个修改会引入变量同时更新的问题）

练习 7.12： 修改/list的handler让它把输出打印成一个HTML的表格而不是文本。html/template包（§4.6）可能会对你有帮助。

## 7.8. error接口

从本书的开始，我们就已经创建和使用过神秘的预定义error类型，而且没有解释它究竟是什么。实际上它就是interface类型，这个类型有一个返回错误信息的单一方法：

```golang
type error interface {
    Error() string
}
```

创建一个error最简单的方法就是调用errors.New函数，它会根据传入的错误信息返回一个新的error。整个errors包仅只有4行：

```golang
package errors

func New(text string) error { return &errorString{text} }

type errorString struct { text string }

func (e *errorString) Error() string { return e.text }
```

承载errorString的类型是一个结构体而非一个字符串，这是为了保护它表示的错误避免粗心（或有意）的更新。并且因为是指针类型*errorString满足error接口而非errorString类型，所以每个New函数的调用都分配了一个独特的和其他错误不相同的实例。我们也不想要重要的error例如io.EOF和一个刚好有相同错误消息的error比较后相等。

`fmt.Println(errors.New("EOF") == errors.New("EOF")) // "false"`
调用`errors.New`函数是非常稀少的，因为有一个方便的封装函数fmt.Errorf，它还会处理字符串格式化。我们曾多次在第5章中用到它。

```golang
package fmt

import "errors"

func Errorf(format string, args ...interface{}) error {
    return errors.New(Sprintf(format, args...))
}
```

虽然*errorString可能是最简单的错误类型，但远非只有它一个。例如，syscall包提供了Go语言底层系统调用API。在多个平台上，它定义一个实现error接口的数字类型Errno，并且在Unix平台上，Errno的Error方法会从一个字符串表中查找错误消息，如下面展示的这样：

```golang
package syscall

type Errno uintptr // operating system error code

var errors = [...]string{
    1:   "operation not permitted",   // EPERM
    2:   "no such file or directory", // ENOENT
    3:   "no such process",           // ESRCH
    // ...
}

func (e Errno) Error() string {
    if 0 <= int(e) && int(e) < len(errors) {
        return errors[e]
    }
    return fmt.Sprintf("errno %d", e)
}
```

下面的语句创建了一个持有Errno值为2的接口值，表示POSIX ENOENT状况：

var err error = syscall.Errno(2)
fmt.Println(err.Error()) // "no such file or directory"
fmt.Println(err)         // "no such file or directory"
err的值图形化的呈现在图7.6中。

Errno是一个系统调用错误的高效表示方式，它通过一个有限的集合进行描述，并且它满足标准的错误接口。我们会在第7.11节了解到其它满足这个接口的类型。

## 示例-表达式求值

在本节中，我们会构建一个简单算术表达式的求值器。我们将使用一个接口Expr来表示Go语言中任意的表达式。现在这个接口不需要有方法，但是我们后面会为它增加一些。

// An Expr is an arithmetic expression.
type Expr interface{}
我们的表达式语言包括浮点数符号（小数点）；二元操作符+，-，*， 和/；一元操作符-x和+x；调用pow(x,y)，sin(x)，和sqrt(x)的函数；例如x和pi的变量；当然也有括号和标准的优先级运算符。所有的值都是float64类型。这下面是一些表达式的例子：

```golang
sqrt(A / pi)
pow(x, 3) + pow(y, 3)
(F - 32) * 5 / 9
```

下面的五个具体类型表示了具体的表达式类型。Var类型表示对一个变量的引用。（我们很快会知道为什么它可以被输出。）literal类型表示一个浮点型常量。unary和binary类型表示有一到两个运算对象的运算符表达式，这些操作数可以是任意的Expr类型。call类型表示对一个函数的调用；我们限制它的fn字段只能是pow，sin或者sqrt。

```golang
gopl.io/ch7/eval


// A Var identifies a variable, e.g., x.
type Var string

// A literal is a numeric constant, e.g., 3.141.
type literal float64

// A unary represents a unary operator expression, e.g., -x.
type unary struct {
    op rune // one of '+', '-'
    x  Expr
}

// A binary represents a binary operator expression, e.g., x+y.
type binary struct {
    op   rune // one of '+', '-', '*', '/'
    x, y Expr
}

// A call represents a function call expression, e.g., sin(x).
type call struct {
    fn   string // one of "pow", "sin", "sqrt"
    args []Expr
}
```

为了计算一个包含变量的表达式，我们需要一个environment变量将变量的名字映射成对应的值：

```golang
type Env map[Var]float64
```

我们也需要每个表达式去定义一个Eval方法，这个方法会根据给定的environment变量返回表达式的值。因为每个表达式都必须提供这个方法，我们将它加入到Expr接口中。这个包只会对外公开Expr，Env，和Var类型。调用方不需要获取其它的表达式类型就可以使用这个求值器。

```golang
type Expr interface {
    // Eval returns the value of this Expr in the environment env.
    Eval(env Env) float64
}
```

下面给大家展示一个具体的Eval方法。Var类型的这个方法对一个environment变量进行查找，如果这个变量没有在environment中定义过这个方法会返回一个零值，literal类型的这个方法简单的返回它真实的值。

```golang
func (v Var) Eval(env Env) float64 {
    return env[v]
}

func (l literal) Eval(_ Env) float64 {
    return float64(l)
}
```

unary和binary的Eval方法会递归的计算它的运算对象，然后将运算符op作用到它们上。我们不将被零或无穷数除作为一个错误，因为它们都会产生一个固定的结果——无限。最后，call的这个方法会计算对于pow，sin，或者sqrt函数的参数值，然后调用对应在math包中的函数。

```golang
func (u unary) Eval(env Env) float64 {
    switch u.op {
    case '+':
        return +u.x.Eval(env)
    case '-':
        return -u.x.Eval(env)
    }
    panic(fmt.Sprintf("unsupported unary operator: %q", u.op))
}

func (b binary) Eval(env Env) float64 {
    switch b.op {
    case '+':
        return b.x.Eval(env) + b.y.Eval(env)
    case '-':
        return b.x.Eval(env) - b.y.Eval(env)
    case '*':
        return b.x.Eval(env) * b.y.Eval(env)
    case '/':
        return b.x.Eval(env) / b.y.Eval(env)
    }
    panic(fmt.Sprintf("unsupported binary operator: %q", b.op))
}

func (c call) Eval(env Env) float64 {
    switch c.fn {
    case "pow":
        return math.Pow(c.args[0].Eval(env), c.args[1].Eval(env))
    case "sin":
        return math.Sin(c.args[0].Eval(env))
    case "sqrt":
        return math.Sqrt(c.args[0].Eval(env))
    }
    panic(fmt.Sprintf("unsupported function call: %s", c.fn))
}
```

一些方法会失败。例如，一个call表达式可能有未知的函数或者错误的参数个数。用一个无效的运算符如!或者<去构建一个unary或者binary表达式也是可能会发生的（尽管下面提到的Parse函数不会这样做）。这些错误会让Eval方法panic。其它的错误，像计算一个没有在environment变量中出现过的Var，只会让Eval方法返回一个错误的结果。所有的这些错误都可以通过在计算前检查Expr来发现。这是我们接下来要讲的Check方法的工作，但是让我们先测试Eval方法。

下面的TestEval函数是对evaluator的一个测试。它使用了我们会在第11章讲解的testing包，但是现在知道调用t.Errof会报告一个错误就足够了。这个函数循环遍历一个表格中的输入，这个表格中定义了三个表达式和针对每个表达式不同的环境变量。第一个表达式根据给定圆的面积A计算它的半径，第二个表达式通过两个变量x和y计算两个立方体的体积之和，第三个表达式将华氏温度F转换成摄氏度。

```golang
func TestEval(t *testing.T) {
    tests := []struct {
        expr string
        env  Env
        want string
    }{
        {"sqrt(A / pi)", Env{"A": 87616, "pi": math.Pi}, "167"},
        {"pow(x, 3) + pow(y, 3)", Env{"x": 12, "y": 1}, "1729"},
        {"pow(x, 3) + pow(y, 3)", Env{"x": 9, "y": 10}, "1729"},
        {"5 / 9 * (F - 32)", Env{"F": -40}, "-40"},
        {"5 / 9 * (F - 32)", Env{"F": 32}, "0"},
        {"5 / 9 * (F - 32)", Env{"F": 212}, "100"},
    }
    var prevExpr string
    for _, test := range tests {
        // Print expr only when it changes.
        if test.expr != prevExpr {
            fmt.Printf("\n%s\n", test.expr)
            prevExpr = test.expr
        }
        expr, err := Parse(test.expr)
        if err != nil {
            t.Error(err) // parse error
            continue
        }
        got := fmt.Sprintf("%.6g", expr.Eval(test.env))
        fmt.Printf("\t%v => %s\n", test.env, got)
        if got != test.want {
            t.Errorf("%s.Eval() in %v = %q, want %q\n",
            test.expr, test.env, got, test.want)
        }
    }
}
```

对于表格中的每一条记录，这个测试会解析它的表达式然后在环境变量中计算它，输出结果。这里我们没有空间来展示Parse函数，但是如果你使用go get下载这个包你就可以看到这个函数。

```golang
go test(§11.1) 命令会运行一个包的测试用例：
$ go test -v gopl.io/ch7/eval
```

这个-v标识可以让我们看到测试用例打印的输出；正常情况下像这样一个成功的测试用例会阻止打印结果的输出。这里是测试用例里fmt.Printf语句的输出：

```golang
sqrt(A / pi)
    map[A:87616 pi:3.141592653589793] => 167

pow(x, 3) + pow(y, 3)
    map[x:12 y:1] => 1729
    map[x:9 y:10] => 1729

5 / 9 * (F - 32)
    map[F:-40] => -40
    map[F:32] => 0
    map[F:212] => 100
```

幸运的是目前为止所有的输入都是适合的格式，但是我们的运气不可能一直都有。甚至在解释型语言中，为了静态错误检查语法是非常常见的；静态错误就是不用运行程序就可以检测出来的错误。通过将静态检查和动态的部分分开，我们可以快速的检查错误并且对于多次检查只执行一次而不是每次表达式计算的时候都进行检查。

让我们往Expr接口中增加另一个方法。Check方法对一个表达式语义树检查出静态错误。我们马上会说明它的vars参数。

```golang
type Expr interface {
    Eval(env Env) float64
    // Check reports errors in this Expr and adds its Vars to the set.
    Check(vars map[Var]bool) error
}
```

具体的Check方法展示在下面。literal和Var类型的计算不可能失败，所以这些类型的Check方法会返回一个nil值。对于unary和binary的Check方法会首先检查操作符是否有效，然后递归的检查运算单元。相似地对于call的这个方法首先检查调用的函数是否已知并且有没有正确个数的参数，然后递归的检查每一个参数。

```golang
func (v Var) Check(vars map[Var]bool) error {
    vars[v] = true
    return nil
}

func (literal) Check(vars map[Var]bool) error {
    return nil
}

func (u unary) Check(vars map[Var]bool) error {
    if !strings.ContainsRune("+-", u.op) {
        return fmt.Errorf("unexpected unary op %q", u.op)
    }
    return u.x.Check(vars)
}

func (b binary) Check(vars map[Var]bool) error {
    if !strings.ContainsRune("+-*/", b.op) {
        return fmt.Errorf("unexpected binary op %q", b.op)
    }
    if err := b.x.Check(vars); err != nil {
        return err
    }
    return b.y.Check(vars)
}

func (c call) Check(vars map[Var]bool) error {
    arity, ok := numParams[c.fn]
    if !ok {
        return fmt.Errorf("unknown function %q", c.fn)
    }
    if len(c.args) != arity {
        return fmt.Errorf("call to %s has %d args, want %d",
            c.fn, len(c.args), arity)
    }
    for _, arg := range c.args {
        if err := arg.Check(vars); err != nil {
            return err
        }
    }
    return nil
}

var numParams = map[string]int{"pow": 2, "sin": 1, "sqrt": 1}
```

我们在两个组中有选择地列出有问题的输入和它们得出的错误。Parse函数（这里没有出现）会报出一个语法错误和Check函数会报出语义错误。

```golang
x % 2               unexpected '%'
math.Pi             unexpected '.'
!true               unexpected '!'
"hello"             unexpected '"'

log(10)             unknown function "log"
sqrt(1, 2)          call to sqrt has 2 args, want 1
```

Check方法的参数是一个Var类型的集合，这个集合聚集从表达式中找到的变量名。为了保证成功的计算，这些变量中的每一个都必须出现在环境变量中。从逻辑上讲，这个集合就是调用Check方法返回的结果，但是因为这个方法是递归调用的，所以对于Check方法，填充结果到一个作为参数传入的集合中会更加的方便。调用方在初始调用时必须提供一个空的集合。

在第3.2节中，我们绘制了一个在编译期才确定的函数f(x,y)。现在我们可以解析，检查和计算在字符串中的表达式，我们可以构建一个在运行时从客户端接收表达式的web应用并且它会绘制这个函数的表示的曲面。我们可以使用集合vars来检查表达式是否是一个只有两个变量x和y的函数——实际上是3个，因为我们为了方便会提供半径大小r。并且我们会在计算前使用Check方法拒绝有格式问题的表达式，这样我们就不会在下面函数的40000个计算过程（100x100个栅格，每一个有4个角）重复这些检查。

这个ParseAndCheck函数混合了解析和检查步骤的过程：

```golang
gopl.io/ch7/surface


import "gopl.io/ch7/eval"

func parseAndCheck(s string) (eval.Expr, error) {
    if s == "" {
        return nil, fmt.Errorf("empty expression")
    }
    expr, err := eval.Parse(s)
    if err != nil {
        return nil, err
    }
    vars := make(map[eval.Var]bool)
    if err := expr.Check(vars); err != nil {
        return nil, err
    }
    for v := range vars {
        if v != "x" && v != "y" && v != "r" {
            return nil, fmt.Errorf("undefined variable: %s", v)
        }
    }
    return expr, nil
}
```

为了编写这个web应用，所有我们需要做的就是下面这个plot函数，这个函数有和http.HandlerFunc相似的签名：

```golang
func plot(w http.ResponseWriter, r *http.Request) {
    r.ParseForm()
    expr, err := parseAndCheck(r.Form.Get("expr"))
    if err != nil {
        http.Error(w, "bad expr: "+err.Error(), http.StatusBadRequest)
        return
    }
    w.Header().Set("Content-Type", "image/svg+xml")
    surface(w, func(x, y float64) float64 {
        r := math.Hypot(x, y) // distance from (0,0)
        return expr.Eval(eval.Env{"x": x, "y": y, "r": r})
    })
}

```

这个plot函数解析和检查在HTTP请求中指定的表达式并且用它来创建一个两个变量的匿名函数。这个匿名函数和来自原来surface-plotting程序中的固定函数f有相同的签名，但是它计算一个用户提供的表达式。环境变量中定义了x，y和半径r。最后plot调用surface函数，它就是gopl.io/ch3/surface中的主要函数，修改后它可以接受plot中的函数和输出io.Writer作为参数，而不是使用固定的函数f和os.Stdout。图7.7中显示了通过程序产生的3个曲面。

练习7.13为Expr增加一个String方法来打印美观的语法树。当再一次解析的时候，检查它的结果是否生成相同的语法树

练习7.14定义一个新的满足Expr接口的具体类型并且提供一个新的操作例如对它运算单元中的最小值的计算。因为Parse函数不会创建这个新类型的实例，为了使用它你可能需要直接构造一个语法树(或者继承parser接口)

练习7.15编写一个从标准输入中读取一个单一表达式的程序，用户及时地提供对于任意变量的值，然后在结果环境变量中计算表达式的值。优雅的处理所有遇到的错误

练习7.16编写一个基于web的计算器程序。

## 7.9. 类型断言

语法上它看起来像`x.(T)`被称为断言类型，这里`x`表示一个接口的类型和T表示一个类型,详细解释，一个类型断言检查它操作对象的动态类型是否和断言的类型是否匹配,分两种情况

- (T传入的是具体类型，X是动态类型),然后类型断言检查`X`的动态类型是否和`T`相同.如果检查成功了类型断言的结果就是`X`的动态值

- (T传入的是接口类型，X是动态类型),然后类型断言检查是否`x`的动态类型满足T,如果这个检查成功了，动态值没有获取到；这个结果仍然是一个有相同动态类型和值部分的接口值

    ```golang

    var w io.Writer
    w = os.Stdout   //能赋值说明os.Stdout 实现了Write()方法
    rw := w.(io.ReadWriter) // success: *os.File has both Read and Write,断言w是否实现了接口(io.ReadWriter)的Read和Write接口
    w = new(ByteCounter)
    rw = w.(io.ReadWriter) // panic: *ByteCounter has no Read method
    //如果对预期结果只是个判断就可以用第二个返回参数bool.
    var w io.Writer = os.Stdout
    f, ok := w.(*os.File)      // success:  ok, f == os.Stdout
    b, ok := w.(*bytes.Buffer) // failure: !ok, b == nil
    // if 后面的w变量不会覆盖外层的w
    if w, ok := w.(*os.File); ok {
    // ...use w...
    }
    ```

## 7.10. 基于类型断言区别错误类型

对这些判断的一个缺乏经验的实现可能会去检查错误消息是否包含了特定的子字符串，但是处理I/O错误的逻辑可能一个和另一个平台非常的不同，所以这种方案并不健壮，并且对相同的失败可能会报出各种不同的错误消息。在测试的过程中，通过检查错误消息的子字符串来保证特定的函数以期望的方式失败是非常有用的，但对于线上的代码是不够的。

一个更可靠的方式是使用一个专门的类型来描述结构化的错误。os包中定义了一个PathError类型来描述在文件路径操作中涉及到的失败，像Open或者Delete操作；并且定义了一个叫LinkError的变体来描述涉及到两个文件路径的操作，像Symlink和Rename。这下面是os.PathError：

```golang


package main

import (
 "errors"
 "fmt"
 "os"
 "syscall"
)

type PathError struct {
 Op   string
 Path string
 Err  error
}

func (e *PathError) Error() string {
 return e.Op + " " + e.Path + ": " + e.Err.Error()
}

var ErrNotExist = errors.New("file does not exist")

// IsNotExist returns a boolean indicating whether the error is known to
// report that a file or directory does not exist. It is satisfied by
// ErrNotExist as well as some syscall errors.
func IsNotExist(err error) bool {
 if pe, ok := err.(*PathError); ok {
  err = pe.Err
 }
 return err == syscall.ENOENT || err == ErrNotExist
}

func main() {
 _, err := os.Open("/no/such/file")
 fmt.Println(os.IsNotExist(err)) // "true"
}
```

## 7.11. any关键字与泛型

类型定义时不限制`形参类型`，在函数调用的时候再指定`具体类型`.  `any`其实是`interface{}`的别名
泛型好处:  (1).在编译期间对类型进行检查以提高类型安全(2).通过指定类型消除强制类型转换(3).能够减少代码重复性，提供更通用的功能函数。

- 类型泛型

  ```golang
    package main

    import "fmt"

    type ListType[T int | int32 | int64 | string] []T

    type MapType[K int | int32, V int64 | string] map[K]V

    func main() {
        var intList ListType[int]
        intList = []int{1, 2, 3}
        fmt.Println(intList)
        strList := ListType[string]{"1", "2", "3"}
        fmt.Println(strList)

        intMap := MapType[int, string]{1: "1", 2: "2"}
        int32Map := MapType[int32, int64]{1: 2, 3: 4}
        fmt.Println(intMap)
        fmt.Println(int32Map)
    }
  ```

  这里面的T,K,V都是占位符号,`ListType`只能在那三种类型中选择,同理`MapType`也是
- 接口泛型

  ```golang
  type GenericStackInterface[T any] interface {
    Push(element T)
    Pop() T
  }
  ```

- 泛型函数

  ```golang
    func minInt[T int | int8 | int16 | int32](a, b T) T {
    if a < b {
        return a
    }
        return b
    }

    func maxInt[T int | int8 | int16 | int32](a, b T) T {
        if a > b {
            return a
        }
        return b
    }
    func Mix(a any) any {

    }
    //还可以简化一下
    type Numeric interface {
        int | int8 | int16 | int32 | int64 | uint | uint8 | uint16 | uint32 | uint64 | float32 | float64
    }
    func min[T Numeric](a, b T) T {
    if a < b {
        return a
    }
        return b
    }

    func max[T Numeric](a, b T) T {
        if a > b {
            return a
        }
        return b
    }
    // go.18内置了数字类型的集合，故可以
    import (
    "golang.org/x/exp/constraints"
    )

    func minType[T constraints.Ordered](a, b T) T {
        if a < b {
            return a
        }
        return b
    }

    func maxType[T constraints.Ordered](a, b T) T {
        if a > b {
            return a
        }
        return b
    }
  ```

  如果进入`constraints`源代码查看其具体代码的话，会发现在 Ordered 类型中也是有各种数字类型组合起来的。但是有一点奇怪的地方就是这里的类型集合中，各种类型前加了一个波浪线~, 表示衍生类型，即使用 type 自定义的类型也可以被识别到，只要底层类型一致即可。比如 ~int 可以包含 int 和 type MyInt int 等多种类型

# 8. Goroutines和Channels

(多看看本章代码)

## 8.1 goroutine

通过代码示例了解`goroutine`的使用

```golang
func main() {
    go spinner(100 * time.Millisecond)
    const n = 45
    fibN := fib(n) // slow
    fmt.Printf("\rFibonacci(%d) = %d\n", n, fibN)
}

func spinner(delay time.Duration) {
    for {
        for _, r := range `-\|/` {
            fmt.Printf("\r%c", r)
            time.Sleep(delay)
        }
    }
}

func fib(x int) int {
    if x < 2 {
        return x
    }
    return fib(x-1) + fib(x-2)
}
```

## 8.2 channel

这里应该还得看一下uber编码规范

- 无缓冲channel

    ```golang
    ch <- x
    x = <-chan //取出元素
    <- ch //取出，舍弃
    close(ch) // 关闭chan
    ```

  - 串联channel

  - 单方向channel

- 缓冲channel

    ```golang
    ch = make(chan string, 3) //channel容量为3
    ```

## 8.3 基于select的多路复用

<details>
<summary>多路复用demo</summary>
<pre>

```golang
// Copyright © 2016 Alan A. A. Donovan & Brian W. Kernighan.
// License: https://creativecommons.org/licenses/by-nc-sa/4.0/

// See page 246.

// Countdown implements the countdown for a rocket launch.
package main

// NOTE: the ticker goroutine never terminates if the launch is aborted.
// This is a "goroutine leak".

import (
        "fmt"
        "os"
        "time"
)

//!+

func main() {
        // ...create abort channel...

        //!-

        abort := make(chan struct{})
        go func() {
                os.Stdin.Read(make([]byte, 1)) // read a single byte
                abort <- struct{}{}
        }()

        //!+
        fmt.Println("Commencing countdown.  Press return to abort.")
        tick := time.Tick(1 * time.Second)
        for countdown := 10; countdown > 0; countdown-- {
                fmt.Println(countdown)
                select {
                case <-tick:
                        // Do nothing.
                case <-abort:
                        fmt.Println("Launch aborted!")
                        return
                }
        }
        launch()
}
//!-
func launch() {
        fmt.Println("Lift off!")
}
```

</pre>
</details>

- goroutine泄露 : 当for语句执行完后，程序已经跳转到其他部分，但是`time.Tick(1 * time.Second)`仍然会继续的网channel里面发送数据，这就会导致gotourine泄露，以上面为例，那么就需要合适的地方调用`tick.stop()`

- channel的ready : 一定要等到channel准备完毕，开始接受或者发送消息

- channel的轮询 : 下面的select语句会在abort channel中有值时，从其中接收值；无值时什么都不做。这是一个非阻塞的接收操作；反复地做这样的操作叫做“轮询channel”

  ```golang
  select {
    case <-abort:
        fmt.Printf("Launch aborted!\n")
        return
    default:
        // do nothing
  }
  ```

## 8.4. 并发的退出

这节主要讨论如何有效退出goroutines

<details>
<summary>
<font size="3" color="orange">goroutines退出代码示例</font></summary>
<pre>

```golang
//gopl.io/ch8/du4
// Copyright © 2016 Alan A. A. Donovan & Brian W. Kernighan.
// License: https://creativecommons.org/licenses/by-nc-sa/4.0/

// See page 251.

// The du4 command computes the disk usage of the files in a directory.
package main

// The du4 variant includes cancellation:
// it terminates quickly when the user hits return.

import (
 "fmt"
 "os"
 "path/filepath"
 "sync"
 "time"
)

//!+1
var done = make(chan struct{})

func cancelled() bool {
 select {
 case <-done:
  return true
 default:
  return false
 }
}

//!-1

func main() {
 // Determine the initial directories.
 roots := os.Args[1:]
 if len(roots) == 0 {
  roots = []string{"."}
 }

 //!+2
 // Cancel traversal when input is detected.
 go func() {
  os.Stdin.Read(make([]byte, 1)) // read a single byte
  close(done)
 }()
 //!-2

 // Traverse each root of the file tree in parallel.
 fileSizes := make(chan int64)
 var n sync.WaitGroup
 for _, root := range roots {
  n.Add(1)
  go walkDir(root, &n, fileSizes)
 }
 go func() {
  n.Wait()
  close(fileSizes)
 }()

 // Print the results periodically.
 tick := time.Tick(500 * time.Millisecond)
 var nfiles, nbytes int64
loop:
 //!+3
 for {
  select {
  case <-done:
   // Drain fileSizes to allow existing goroutines to finish.
   for range fileSizes {
    // Do nothing.
   }
   return
  case size, ok := <-fileSizes:
   // ...
   //!-3
   if !ok {
    break loop // fileSizes was closed
   }
   nfiles++
   nbytes += size
  case <-tick:
   printDiskUsage(nfiles, nbytes)
  }
 }
 printDiskUsage(nfiles, nbytes) // final totals
}

func printDiskUsage(nfiles, nbytes int64) {
 fmt.Printf("%d files  %.1f GB\n", nfiles, float64(nbytes)/1e9)
}

// walkDir recursively walks the file tree rooted at dir
// and sends the size of each found file on fileSizes.
//!+4
func walkDir(dir string, n *sync.WaitGroup, fileSizes chan<- int64) {
 defer n.Done()
 if cancelled() {
  return
 }
 for _, entry := range dirents(dir) {
  // ...
  //!-4
  if entry.IsDir() {
   n.Add(1)
   subdir := filepath.Join(dir, entry.Name())
   go walkDir(subdir, n, fileSizes)
  } else {
   fileSizes <- entry.Size()
  }
  //!+4
 }
}

//!-4

var sema = make(chan struct{}, 20) // concurrency-limiting counting semaphore

// dirents returns the entries of directory dir.
//!+5
func dirents(dir string) []os.FileInfo {
 select {
 case sema <- struct{}{}: // acquire token
 case <-done:
  return nil // cancelled
 }
 defer func() { <-sema }() // release token

 // ...read directory...
 //!-5

 f, err := os.Open(dir)
 if err != nil {
  fmt.Fprintf(os.Stderr, "du: %v\n", err)
  return nil
 }
 defer f.Close()

 entries, err := f.Readdir(0) // 0 => no limit; read all entries
 if err != nil {
  fmt.Fprintf(os.Stderr, "du: %v\n", err)
  // Don't return: Readdir may return partial results.
 }
 return entries
}
```

</pre>
</details>

# 9. 基于共享变量的并发

(多看这章代码)
避免数据竞争的三个方法

- 并发读数据不会有数据竞争问题
- 避免从多个goroutine中访问变量，使用独立变量
- 临界区控制

- 总结
  - 数据竞争: 程序在多个goroutine交叉执行操作时，导致数据不一致.  
  - `包级别`的导出函数一般情况下都是并发安全的。由于package级的变量没法被限制在单一的gorouine，所以修改这些变量“必须”使用互斥条件。
    (多看看本章代码)

## 9.1 sync.Mutex与sync.RMutex互斥锁

比如银行存款查询余额的场景，因为所有的余额查询请求是顺序执行的，这样会互斥地获得锁，并且会暂时阻止其它的goroutine运行。由于Balance函数只需要读取变量的状态，所以我们同时让多个Balance调用并发运行事实上是安全的，只要在运行的时候没有存款或者取款(这句话很关键要没有)操作就行。在这种场景下我们需要一种特殊类型的锁，其允许多个只读操作并行执行，但写操作会完全互斥。这种锁叫作“多读单写”锁

- 总结
  - 避免临界区中的变量在中途被其他的goroutine修改
  - 使用mutex包进行互斥goroutine
  - 一个deferred Unlock即使在临界区发生`panic`时依然会执行
  - golang不支持重入锁
  - sync.RWMutex.RLock()持锁，sync.RWMutex.Lock()会阻塞，相同的RWMutex.Lock()持锁，sync.RWMutex.RLock()阻塞，但是sync.RWMutex.RLock()阻塞之间不阻塞

## 9.2 sync.Once惰性初始化

如果初始化的成本太高，需要延迟的初始化对象。可考虑使用`sync.Once`
<detials>
<summary>sync.One的demo</summary>
<pre>

</pre>
</details>

## 9.3 sync.Cond的使用

1. 使用场景: `sync.Cond` 经常用在多个goroutine等待,一个goroutine通知,如果是一读一等待使用`sync.Mutx`和`chan`就可以
2. `sync.Cond`的[方法](https://pkg.go.dev/sync@go1.19#Cond)

    ```golang
    // Each Cond has an associated Locker L (often a *Mutex or *RWMutex),
    // which must be held when changing the condition and
    // when calling the Wait method.
    // A Cond must not be copied after first use.
    type Cond struct {
            noCopy noCopy
            // L is held while observing or changing the condition
            L Locker
            notify  notifyList
            checker copyChecker
    }

    ```

    Cond 实例都会关联一个锁`L`(互斥锁 *Mutex，或读写锁*RWMutex);当修改条件或者调用`Wait()`方法时,必须加锁

    ```golang
    // Signal wakes one goroutine waiting on c, if there is any.
    // It is allowed but not required for the caller to hold c.L
    // during the call.
    // Signal 只唤醒任意 1 个等待条件变量 c 的 goroutine，无需锁保护
    func (c *Cond) Signal()
    // Broadcast wakes all goroutines waiting on c.
    // It is allowed but not required for the caller to hold c.L
    // during the call.
    func (c *Cond) Broadcast()

    // c.L.Unlock()
    // 挂起调用者所在的 goroutine,等待Broadcast或者Signal方法
    func (c *Cond) Wait()
        //代码片段
        c.L.Lock()
        for !condition() {
            c.Wait()
        }
        ... make use of condition ...
        c.L.Unlock()
    ```

    调用`Wait`会自动释放锁 `c.L`,并挂起调用者所在的`goroutine`，因此当前协程会阻塞在`Wait`方法调用的地方。
    如果其他协程调用了`Signal`或`Broadcast`唤醒了该协程,那么`Wait`方法在结束阻塞时,会重新给`c.L`加锁，
    并且继续执行`Wait`后面的代码

3. Cond代码示例

    ```golang
    var done = false

    func read(name string, c *sync.Cond) {
        c.L.Lock()
        for !done {
            c.Wait()
        }
        log.Println(name, "starts reading")
        c.L.Unlock()
    }

    func write(name string, c *sync.Cond) {
        log.Println(name, "starts writing")
        time.Sleep(time.Second)
        c.L.Lock()
        done = true
        c.L.Unlock()
        log.Println(name, "wakes all")
        c.Broadcast()
    }

    func main() {
        cond := sync.NewCond(&sync.Mutex{})

        go read("reader1", cond)
        go read("reader2", cond)
        go read("reader3", cond)
        write("writer", cond)

        time.Sleep(time.Second * 3)
    }

    ```

## 9.4. Goroutines和线程

- 每一个OS线程都有一个固定大小的内存块（一般会是2MB）来做栈，这个栈会用来存储当前正在被调用或挂起（指在调用其它函数时）的函数的内部变量
- 一个goroutine会以一个很小的栈开始其生命周期，一般只需要2KB。一个goroutine的栈，和操作系统线程一样，会保存其活跃或挂起的函数调用的本地变量，但是和OS线程不太一样的是，一个goroutine的栈大小并不是固定的；栈的大小会根据需要动态地伸缩
- Go的`运行时`有自己的调度器，这个调度器比如m:n调度，n个操作系统线程调度m个gotoutine，例如当一个goroutine调用了time.Sleep，或者被channel调用或者mutex操作阻塞时，调度器会使其进入休眠并开始执行另一个goroutine，直到时机到了再去唤醒第一个goroutine。因为这种调度方式不需要进入内核的上下文，所以重新调度一个goroutine比调度一个线程代价要低得多。

- GOMAXPROCS : 变量来决定会有多少个操作系统的线程同时执行Go的代码,其默认的值是运行机器上的CPU的核心数,`GOMAXPROCS`是前面说的m:n调度中的n.下面代码就可以简单的看出os线程调度代码的情况

  ```golang

    for {
        go fmt.Print(0)
        fmt.Print(1)
    }

    $ GOMAXPROCS=1 go run hacker-cliché.go
    111111111111111111110000000000000000000011111...

    $ GOMAXPROCS=2 go run hacker-cliché.go
    010101010101010101011001100101011010010100110...
  ```

- 总结
  - 通过广播机制来取消goroutines
  - 确保主函数退出，routines也随即退出

# 10. 包和工具

互联网上已经发布了非常多的Go语言开源包，它们可以通过 <http://godoc.org> 检索

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

## 11.1 go test

一个测试函数是以`Test`为函数名前缀的函数
一个基准测试函数是以`Benchmark`为函数名前缀的函数
一个示例函数是以`Example`为函数名前缀的函数，提供一个由编译器保证正确性的示例文档

```golang
- `go test -v `会打印每个函数的名字和运行时间
- `go test -run= `会去匹配正则表达式，只有被匹配到的才会被执行
- `go test -v ./...` 执行所有当前目录下测试cases
- `go test -v foo/...` 执行foo目录下所有cases
- `go test -v foo...` 执行指定前缀的测试cases
- `go test ...` gopath下所有测试cases
- `go test -v hello_test.go` 执行某一文件下的测试cases,但是该文件中如果调用了其它文件中的模块会报错
- `go test -v hello_test.go -test.run TestHello` 测试单个函数
```

- 组织多个测试用例
  
  即使表格中前面的数据导致了测试的失败，表格后面的测试数据依然会运行测试，因此在一个测试中我们可能了解多个失败的信息,可以使用`t.Fatal`或`t.Fatalf`停止当前测试函数
    <details>
    <summary>组织多测试用例</summary>
    <pre>

    ```golang
    func TestIsPalindrome(t *testing.T) {
    var tests = []struct {
        input string
        want  bool
    }{
            {"", true},
            {"a", true},
            {"aa", true},
            {"ab", false},
            {"kayak", true},
            {"detartrated", true},
            {"A man, a plan, a canal: Panama", true},
            {"Evil I did dwell; lewd did I live.", true},
            {"Able was I ere I saw Elba", true},
            {"été", true},
            {"Et se resservir, ivresse reste.", true},
            {"palindrome", false}, // non-palindrome
            {"desserts", false},   // semi-palindrome
        }
        for _, test := range tests {
            if got := IsPalindrome(test.input); got != test.want {
                t.Errorf("IsPalindrome(%q) = %v", test.input, got)
            }
        }
    }
    ```

    </pre>
    </details>

- 随机测试
  1. 编写对照函数，效率低下
  2. 生成的随机输入的数据遵循特定的模式，然后就知道期望的输出

  ```golang

  import "math/rand"

    // randomPalindrome returns a palindrome whose length and contents
    // are derived from the pseudo-random number generator rng.
    func randomPalindrome(rng *rand.Rand) string {
        n := rng.Intn(25) // random length up to 24
        runes := make([]rune, n)
        for i := 0; i < (n+1)/2; i++ {
            r := rune(rng.Intn(0x1000)) // random rune up to '\u0999'
            runes[i] = r
            runes[n-1-i] = r
        }
        return string(runes)
    }

    func TestRandomPalindromes(t *testing.T) {
        // Initialize a pseudo-random number generator.
        seed := time.Now().UTC().UnixNano()
        t.Logf("Random seed: %d", seed)
        rng := rand.New(rand.NewSource(seed))

        for i := 0; i < 1000; i++ {
            p := randomPalindrome(rng)
            if !IsPalindrome(p) {
                t.Errorf("IsPalindrome(%q) = false", p)
            }
        }
    }
    // IsPalindrome reports whether s reads the same forward and backward.
    // Letter case is ignored, as are non-letters.
    func IsPalindrome(s string) bool {
        var letters []rune
        for _, r := range s {
            if unicode.IsLetter(r) {
                letters = append(letters, unicode.ToLower(r))
            }
        }
        for i := range letters {
            if letters[i] != letters[len(letters)-1-i] {
                return false
            }
        }
        return true
    }

    ```

- 测试一个命令(测试内部未导出函数)

  要注意的是测试代码和产品代码在同一个包。虽然是main包，也有对应的main入口函数，但是在测试的时候main包只是TestEcho测试函数导入的一个普通包，里面main函数并没有被导出，而是被忽略的。要注意的是在测试代码中并没有调用`log.Fatal`或`os.Exit`，因为调用这类函数会导致程序提前退出；调用这些函数的特权应该放在main函数中。如果真的有意外的事情导致函数发生panic异常，测试驱动应该尝试用recover捕获异常，然后将当前测试当作失败处理,如果是可预期的错误，例如非法的用户输入、找不到文件或配置文件不当等应该通过返回一个非空的error的方式处理.导出内部函数,

  ```golang
  // src/bytes/export_test.go
    package bytes
    // Export func for testing
    var IndexBytePortable = indexBytePortable // 赋值给包级可导出变量
  ```
  
  然后通过外部包进行测试

  ```golang

  // src/bytes/bytes_test.go
    package bytes_test

    func TestIndexByte(t *testing.T) {
        for _, tt := range indexTests {
            ... 代码片段
            posp := IndexBytePortable(a, b) // 导出的内部方法在这里被使用
            if posp != tt.i {
                t.Errorf(`indexBytePortable(%q, '%c') = %v`, tt.a, b, posp)
            }
        }
    }
  
  ```

  还有种方式就是不导出，直接在包名下写测试函数，然后进行测试源代码

- 白盒测试

  TBC,代码的内部实现对于测试人员来说是可见的，言外之意就是能看到内部实现,测试内部实现，这个实现可能是未导出的
- 外部测试包

  ```golang
  package pprint_test
    //这时候就可以在
    import (
        "gott/hi"
        // 导入 要进行测试的 pprint 包本身
        "gott/pprint"
        "testing"
    )

    func TestPPrint(t *testing.T) {
        pprint.PPrint()
        hi.Say()
        t.Log("expect call PPrint")
    }
    
  ```

  使用 Go 官方的代码风格：pprint_test.go 文件，因为pprint_test在 pprint 目录下，通过在 import 时，使用` . `选项，可以直接调用PPrint()方法
- 编写有效的测试
  1. 一个好的测试不应该引发其他无关的错误信息，它只要清晰简洁地描述问题的症状即可，有时候可能还需要一些上下文信息
  2. 一个好的测试不应该在遇到一点小错误时就立刻退出测试，它应该尝试报告更多的相关的错误信息，因为我们可能从多个失败测试的模式中发现错误产生的规律
  3. 现在的测试不仅报告了调用的具体函数、它的输入和结果的意义；并且打印的真实返回的值和期望返回的值；并且即使断言失败依然会继续尝试运行更多的测试
- 避免脆弱的测试
  TBC

## 11.2 测试覆盖率

对待测程序执行的测试的程度称为测试的覆盖率。测试覆盖率并不能量化(应该是有)

1. go test -run=Coverage -coverprofile=c.out gopl.io/ch7/eval
2. go test -run=Coverage -covermode=count gopl.io/ch7/eval

## 11.3 基准测试

1. `-bench`也是正则匹配,BenchmarkIsPalindrome-8,8表示的是GOMAXPROCS的值,`-benchmem`命令行标志参数将在报告中包含内存的分配数据统计
2. 比较型的基准测试就是普通程序代码,它们通常是单参数的函数，由几个不同数量级的基准测试函数调用,通过函数参数来指定输入的大小，但是参数变量对于每个具体的基准测试都是固定的。要避免直接修改b.N来控制输入的大小。除非你将它作为一个固定大小的迭代计算输入，否则基准测试的结果将毫无意义。所有的测试cases都要保留，随着项目的发展，都需要做回归测试

## 11.4 刨析

TBC

## 11.5 示例函数

示例函数有三个用处。

1. 最主要的一个是作为文档，根据示例函数的后缀名部分，godoc这个web文档服务器会将示例函数关联到某个具体函数或包本身，因此ExampleIsPalindrome示例函数将是IsPalindrome函数文档的一部分，Example示例函数将是包文档的一部分。
2. 在go test执行测试的时候也会运行示例函数测试。如果示例函数内含有类似上面例子中的// Output:格式的注释，那么测试工具会执行这个示例函数，然后检查示例函数的标准输出与注释是否匹配
3. 提供一个真实的演练场，它使用了Go Playground让用户可以在浏览器中在线编辑和运行每个示例函数

# 12. appendIndex

1. 线程内再重启一个线程，然后就可以通过加锁，进行隔离开，但此时任然是两个线程的间的交替
