---
title: go语言圣经-chapter06-方法
categories:
- golang
tag: golang
---


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

