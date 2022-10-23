---
title: go语言圣经
categories:
- golang
tag: golang
---

- [1. 入门](#1-入门)
- [2. 程序结构](#2-程序结构)
  - [2.1 命名](#21-命名)
  - [2.2 声明](#22-声明)
  - [2.3 变量](#23-变量)
    - [2.3.1 简短变量声明](#231-简短变量声明)
    - [2.3.2 指针](#232-指针)
    - [2.3.3 new函数](#233-new函数)
    - [2.3.4. 变量的生命周期](#234-变量的生命周期)
  - [2.4 赋值](#24-赋值)
    - [2.4.1 元组赋值](#241-元组赋值)
  - [2.5 类型](#25-类型)
  - [2.6 包和文件](#26-包和文件)
  - [2.7. 作用域](#27-作用域)
- [3.基础数据类型](#3基础数据类型)
  - [3.1 整型](#31-整型)
  - [3.2 浮点数](#32-浮点数)
  - [3.3 复数](#33-复数)
  - [3.4 布尔类型](#34-布尔类型)
  - [3.5 字符串](#35-字符串)
- [4. 复合数据类型](#4-复合数据类型)
  - [4.1 数组](#41-数组)
  - [4.2 slice](#42-slice)
    - [4.2.1 append函数](#421-append函数)
  - [4.3 Map](#43-map)
  - [4.4 结构体](#44-结构体)
    - [4.4.1 结构体字面值](#441-结构体字面值)
    - [4.4.2 结构体的比较](#442-结构体的比较)
    - [4.4.3 结构体嵌入和匿名成员](#443-结构体嵌入和匿名成员)
  - [4.5 json字符串](#45-json字符串)
  - [4.6 文本和HTML模板](#46-文本和html模板)
- [5. 函数](#5-函数)
  - [5.1 错误](#51-错误)
  - [5.2 函数值](#52-函数值)
  - [5.3 匿名函数](#53-匿名函数)
  - [5.4 可变参数](#54-可变参数)
  - [5.5 defer函数](#55-defer函数)
  - [5.6 panic异常](#56-panic异常)
  - [5.7 Recovery捕获异常](#57-recovery捕获异常)
- [6. 方法](#6-方法)
  - [6.1 方法声明](#61-方法声明)
  - [6.2 基于指针对象的方法](#62-基于指针对象的方法)
  - [6.3. 通过嵌入结构体来扩展类型](#63-通过嵌入结构体来扩展类型)
  - [6.4 封装](#64-封装)
- [7. 接口](#7-接口)
  - [7.1. 接口约定](#71-接口约定)
  - [7.2 接口类型](#72-接口类型)
  - [7.3 实现接口的条件](#73-实现接口的条件)
  - [7.4 flag.Value接口](#74-flagvalue接口)
  - [7.5 接口值](#75-接口值)
    - [7.5.1. 警告:一个包含nil指针的接口不是nil接口](#751-警告一个包含nil指针的接口不是nil接口)
  - [7.6. sort.Interface接口](#76-sortinterface接口)
  - [7.7. http.Handler接口](#77-httphandler接口)
  - [7.8. error接口](#78-error接口)
  - [7.9. 类型断言](#79-类型断言)
  - [7.10. 基于类型断言区别错误类型](#710-基于类型断言区别错误类型)
  - [7.11. any关键字与泛型](#711-any关键字与泛型)
- [8. Goroutines和Channels](#8-goroutines和channels)
  - [8.1 goroutine](#81-goroutine)
  - [8.2 channel](#82-channel)
  - [8.3 基于select的多路复用](#83-基于select的多路复用)
  - [8.4. 并发的退出](#84-并发的退出)
- [9. 基于共享变量的并发](#9-基于共享变量的并发)
  - [9.1 sync.Mutex与sync.RMutex互斥锁](#91-syncmutex与syncrmutex互斥锁)
  - [9.2 sync.Once惰性初始化](#92-synconce惰性初始化)
  - [9.3 sync.Cond的使用](#93-synccond的使用)
  - [9.4. Goroutines和线程](#94-goroutines和线程)
- [10. 包和工具](#10-包和工具)
- [11. 测试](#11-测试)
  - [11.1 go test](#111-go-test)
  - [11.2 测试覆盖率](#112-测试覆盖率)
  - [11.3 基准测试](#113-基准测试)
  - [11.4 刨析](#114-刨析)
  - [11.5 示例函数](#115-示例函数)
- [12. appendIndex](#12-appendindex)

# 1. 入门


# 2. 程序结构
## 2.1 命名

|功能性关键字|描述|
|---|---|
|break|退出循环|
|case|switch case, select case|
|chan||
|const||
|continue||
|default||
|defer||
|else||
|fallthrough||
|for||
|func||
|go||
|if||
|import||
|interface||
|map||
|package||
|range||
|return||
|select||
|struct||
|switch||
|type||
|var||


|内建常量|关键字|
|---|---|
|true ||
|false ||
|iota||
| nil||

|内建类型| 关键字|
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

|内建函数| 关键字|
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

  -  例子1中声明的err是重复,第二个简短声明符的err就是赋值操作，注意该操作是在变量相同作用例子2中这种情况编译不通过,至少有一个是新声明的.[ 实际工程中尽量不要出现例子2 ]

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
    |格 式	| 描 述|
    |---|---|
    |%b	| 整型以二进制方式显示|
    |%o	| 整型以八进制方式显示|
    |%d	| 整型以十进制方式显示,以锁为例子mutex=&((1 0) 0 0 -1073741824 0)|
    |%x	| 整型以十六进制方式显示|
    |%X	| 整型以十六进制、字母大写方式显示|
    |%c	| 相应Unicode码点所表示的字符|
    |%U	| Unicode 字符, Unicode格式：123，等同于 "U+007B"|

- 浮点数格式控制
    |格 式	| 描 述|
    |---|---|
    |%e	|科学计数法,例如 -1234.456e+78|
    |%E	|科学计数法,例如 -1234.456E+78|
    |%f	|有小数点而无指数,例如 123.456|
    |%g	|根据情况选择 %e 或 %f 以产生更紧凑的（无末尾的0）输出|
    |%G	|根据情况选择 %E 或 %f 以产生更紧凑的（无末尾的0）输出|

- 字符串格式化
    |格 式	|描 述|
    |---|---|
    |%s| 字符串或切片的无解译字节|
    |%q| 双引号围绕的字符串，由Go语法安全地转义|
    |%x| 十六进制，小写字母，每字节两个字符|
    |%X| 十六进制，大写字母，每字节两个字符|

- 指针格式化
    |格 式	|描 述|
    |---|---|
    |%p|十六进制表示，前缀 0x|
- 通用的占位符
    |格 式|	描 述|
    |---|---|
    |%v	|值的默认格式。只输出字段的值，没有字段名字,eg: requestVote RPC={1,1,0,0}|
    |%+v|类似%v，但输出结构体时会添加字段名,以RWMutex为例子, &{w:{state:1 sema:0} writerSem:0 readerSem:0 readerCount:-1073741824 readerWait:0}|
    |%#v|相应值的Go语法表示,比如地址用十六进制表示,以RWMutex为例子, &sync.RWMutex{w:sync.Mutex{state:1, sema:0x0}, writerSem:0x0, readerSem:0x0, readerCount:-1073741824, readerWait:0}|
    |%T	|相应值的类型的Go语法表示,比如以RWMutex为例子,rf.mu=*sync.RWMutex|
    |%%	|百分号,字面上的%,非占位符含义|

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
            *v.URL = *u
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

> 如果是接口类型定义的变量那么它的动态类型和动态值都是nil，赋nil之后动态类型和动态值也全都是nil值，但是指针和基本类型和符合类型不会
> 类似于java一样，不能没有对象就调用方法，会包空指针异常,上面代码在第三行动态值写为nil
> 这里面有个细节要明白，定义语句var w io.Writer
> 其实是动态类型和动态值都是nil，进行布尔判断的时候才是为nil

第二个语句将一个`*os.File`类型的值赋给变量`w`:

```golang
w = os.Stdout
```
这个赋值过程调用了一个具体类型到接口类型的隐式转换，这和显式的使用`io.Writer(os.Stdout)`是等价的。这类转换不管是显式的还是隐式的，都会刻画出操作到的类型和值。这个接口值的动态类型被设为`*os.File`指针的类型描述符，它的动态值持有`os.Stdout`的拷贝;这是一个代表处理标准输出的`os.File`类型变量的指针7.2
![7.2](./../../../picture/golang语言圣经/ch7-02.png)

> 在第二行的赋值操作中,type已经变成`*os.file`类型,其实上面说的很罗嗦,直接就是os.Stdout是具
> 体的*file类型实现了io.Writer接口

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

> w = nil 是将动态类型和动态值都设置成nil

这个重置将它所有的部分都设为`nil`值,把变量`w`恢复到和它之前定义时相同的状态，在图7.1中可以看到。

一个接口值可以持有任意大的动态值。例如,表示时间实例的time.Time类型，这个类型有几个对外不公开的字段。我们从它上面创建一个接口值:

```golang
var x interface{} = time.Now()
```

> 这里就是创建了一个接口类型的x值,然后可以引用任何类型值

结果可能和图7.4相似。从概念上讲，不论接口值多大，动态值总是可以容下它。（这只是一个概念上的模型;具体的实现可能会非常不同）

![7.4](./../../../picture/golang语言圣经/ch7-04.png)

接口值可以使用`==`和`!＝`来进行比较。两个接口值相等仅当它们都是`nil`值，或者它们的动态类型相同并且动态值也根据这个动态类型的`==`操作相等。因为接口值是可比较的，所以它们可以用在map的键或者作为switch语句的操作数。

然而，如果两个接口值的`动态类型`相同，但是这个动态类型是不可比较的（比如切片），将它们进行比较就会失败并且panic:

> 两个接口值都是nil的时候才相等,接口值是可比较的(基本的数据类型和指针),
> 注意到原话'它们的动态类型相同并且动态值也根据这个动态类型的`==`操作相等',
> 那么基本类型相同,复杂类型值相等,那么也是可以比较？(待解决)
> 要回一下map类型，什么值可以作为key，什么样的不可以
> 动态类型是不可比较的


考虑到这点，接口类型是非常与众不同的。其它类型要么是安全的可比较类型（如基本类型和指针）要么是完全不可比较的类型（如切片，映射类型，和函数），但是在比较接口值或者包含了接口值的聚合类型时，我们必须要意识到潜在的panic。同样的风险也存在于使用接口作为map的键或者switch的操作数。只能比较你非常确定它们的动态值是可比较类型的接口值。  

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


## 7.6. sort.Interface接口

golang提供了`sort`包帮助进行排序数据,实现排序需要自己实现对应的排序接口.

```golang
type byArtist []*Track
func (x byArtist) Len() int           { return len(x) }
func (x byArtist) Less(i, j int) bool { return x[i].Artist < x[j].Artist }
func (x byArtist) Swap(i, j int)      { x[i], x[j] = x[j], x[i] }
```

对于自定义的排序，我们也需要实现排序函数.

```golang
//!+customcode
type customSort struct {
	t    []*Track
	less func(x, y *Track) bool
}

func (x customSort) Len() int           { return len(x.t) }
func (x customSort) Less(i, j int) bool { return x.less(x.t[i], x.t[j]) }
func (x customSort) Swap(i, j int)      { x.t[i], x.t[j] = x.t[j], x.t[i] }

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

`IntsAreSorted(...interface{})` reports whether the slice x is sorted in increasing order.

## 7.7. http.Handler接口

http.Handler的实例

## 7.8. error接口

```golang

package errors_demo

func New(text string) error { return &errorString{text} }

type errorString struct { text string }

func (e *errorString) Error() string { return e.text }
```
调用`errors.New`函数是非常稀少的，因为有一个方便的封装函数`fmt.Errorf`它还会处理字符串格式化
另一个error demo实例
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

var err error = syscall.Errno(2)
fmt.Println(err.Error()) // "no such file or directory"
fmt.Println(err)         // "no such file or directory"
```
用有限几个进行描述，并且它满足标准错误接口

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

    Cond 实例都会关联一个锁`L`(互斥锁 *Mutex，或读写锁 *RWMutex);当修改条件或者调用`Wait()`方法时,必须加锁

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
    调用 Wait 会自动释放锁 c.L，并挂起调用者所在的 goroutine，因此当前协程会阻塞在 Wait 方法调用的地方。
    如果其他协程调用了 Signal 或 Broadcast 唤醒了该协程，那么 Wait 方法在结束阻塞时，会重新给 c.L 加锁，
    并且继续执行 Wait 后面的代码

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
