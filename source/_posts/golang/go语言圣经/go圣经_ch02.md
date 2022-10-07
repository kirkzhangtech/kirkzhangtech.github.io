---
title: go语言圣经-chapter02-程序结构
categories:
- golang
tag: golang
---

# 2. 程序结构
## 2.1 命名

|功能性关键字|描述|
|---|---|
|break||
|case||
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