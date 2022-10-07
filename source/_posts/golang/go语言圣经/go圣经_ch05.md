---
title: go语言圣经-chapter05-函数
categories:
- golang
tag: golang
---


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
