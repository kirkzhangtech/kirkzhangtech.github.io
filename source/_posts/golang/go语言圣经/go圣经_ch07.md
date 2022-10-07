---
title: go语言圣经-chapter07-接口
categories:
- golang
tag: golang
---

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
(翻译的太差劲，要去读原文)
- 简单的`flag`包支持命令行的例子

    ```golang
    var period = flag.Duration("period", 1*time.Second, "sleep period")

    func main() {
        flag.Parse()
        fmt.Printf("Sleeping for %v...", *period)
        time.Sleep(*period)
        fmt.Println()
    }
    ```

- 自定义新的标记符号

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

## 7.5 接口值

下面语句中,`io.Writer`是接口类型值

```golang
var w io.Writer
w = os.Stdout
w = new(bytes.Buffer)
w = nil
```
- 对于接口的定义也不例外，`接口`的零值是它的类型和值的部分都是`nil`
- 一个接口值基于它的动态类型被描述为空或非空，所以这是一个空的接口值。你可以通过使用w==nil或者w!=nil来判断接口值是否为空。调用一个空接口值上的任意方法都会产生`panic`: `w.Write([]byte("hello")) // panic: nil pointer dereference`
- 第二句statement，这个赋值过程调用了一个`具体类型`到`接口类型`的隐式转换，这和显式的使用io.Writer(os.Stdout)是等价的。这类转换不管是显式的还是隐式的，它的动态值持有os.Stdout的拷贝；这是一个代表处理标准输出的`os.File`类型变量的指针.接口值可以使用`==`和`!＝`来进行比较。两个接口值相等仅当它们都是nil值。
    ```golang
    w.Write([]byte("hello")) // "hello"
    os.Stdout.Write([]byte("hello")) // "hello" 
    //上下两句是等价的
    ```
- 一个接口值可以持有任意大的动态值

    ```golang
    var x interface{} = time.Now()
    ```

    接口值可以使用==和!＝来进行比较。两个接口值相等仅当它们都是nil值，或者它们的动态类型相同并且动态值也根据这个动态类型的==操作相等。因为接口值是可比较的，所以它们可以用在map的键或者作为switch语句的操作数,然而，如果两个接口值的动态类型相同，但是这个动态类型是不可比较的（比如切片），将它们进行比较就会失败并且panic:

    ```golang
    var x interface{} = []int{1, 2, 3}
    fmt.Println(x == x) // panic: comparing uncomparable type []int
    ```


考虑到这点，接口类型是非常与众不同的。其它类型要么是安全的可比较类型（如基本类型和指针）要么是完全不可比较的类型（如切片，映射类型，和函数），但是在比较接口值或者包含了接口值的聚合类型时，我们必须要意识到潜在的panic。同样的风险也存在于使用接口作为map的键或者switch的操作数。只能比较你非常确定它们的动态值是可比较类型的接口值.



- *警告*: 一个包含nil指针的接口不是nil接口

一个不包含任何值的nil接口值和一个刚好包含nil指针的接口值是不同的。这个细微区别产生了一个容易绊倒每个Go程序员的陷阱。

思考下面的程序。当debug变量设置为true时，main函数会将f函数的输出收集到一个bytes.Buffer类型中。

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
当main函数调用函数f时，它给f函数的out参数赋了一个*bytes.Buffer的空指针，所以out的动态值是nil。然而，它的动态类型是*bytes.Buffer，意思就是out变量是一个包含空指针值的非空接口（如图7.5），所以防御性检查out!=nil的结果依然是true。

![](https://user-images.githubusercontent.com/46363359/182982938-08d67c3f-7aa6-457d-88a5-02646c5e2735.png)

动态分配机制依然决定(*bytes.Buffer).Write的方法会被调用，但是这次的接收者的值是nil。对于一些如*os.File的类型，nil是一个有效的接收者（§6.2.1），但是*bytes.Buffer类型不在这些种类中。这个方法会被调用，但是当它尝试去获取缓冲区时会发生panic。

问题在于尽管一个nil的*bytes.Buffer指针有实现这个接口的方法，它也不满足这个接口具体的行为上的要求。特别是这个调用违反了(*bytes.Buffer).Write方法的接收者非空的隐含先觉条件，所以将nil指针赋给这个接口是错误的。解决方案就是将main函数中的变量buf的类型改为io.Writer，因此可以避免一开始就将一个不完整的值赋值给这个接口：

```golang
var buf io.Writer
if debug {
    buf = new(bytes.Buffer) // enable collection of output
}
f(buf) // OK
```
现在我们已经把接口值的技巧都讲完了，让我们来看更多的一些在Go标准库中的重要接口类型。在下面的三章中，我们会看到接口类型是怎样用在排序，web服务，错误处理中的。



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

