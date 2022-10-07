---
title: go语言圣经-chapter09-基于共享变量的并发
categories:
- golang
tag: golang
---



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


1. 使用场景: `sync.Cond` 经常用在多个goroutine等待，一个goroutine通知,如果是一读一等待使用`sync.Mutx`和`chan`就可以
2. `sync.Cond`的[方法](https://pkg.go.dev/sync@go1.19#Cond)
    ```golang
    // Each Cond has an associated Locker L (often a *Mutex or *RWMutex),
    // which must be held when changing the condition and
    // when calling the Wait method.
    //
    // A Cond must not be copied after first use.
    type Cond struct {
            noCopy noCopy
            // L is held while observing or changing the condition
            L Locker
            notify  notifyList
            checker copyChecker
    }

    ```

    Cond 实例都会关联一个锁 L（互斥锁 *Mutex，或读写锁 *RWMutex），当修改条件或者调用 Wait 方法时，必须加锁

    ```golang
    // Signal wakes one goroutine waiting on c, if there is any.
    //
    // It is allowed but not required for the caller to hold c.L
    // during the call.
    //Signal 只唤醒任意 1 个等待条件变量 c 的 goroutine，无需锁保护
    func (c *Cond) Signal()
    // Broadcast wakes all goroutines waiting on c.
    //
    // It is allowed but not required for the caller to hold c.L
    // during the call.
    func (c *Cond) Broadcast()

    // Wait atomically unlocks c.L and suspends execution
    // of the calling goroutine. After later resuming execution,
    // Wait locks c.L before returning. Unlike in other systems,
    // Wait cannot return unless awoken by Broadcast or Signal.
    //
    // Because c.L is not locked when Wait first resumes, the caller
    // typically cannot assume that the condition is true when
    // Wait returns. Instead, the caller should Wait in a loop:
    //
    //    c.L.Lock()
    //    for !condition() {
    //        c.Wait()
    //    }
    //    ... make use of condition ...
    //    c.L.Unlock()
    //挂起调用者所在的 goroutine,等待Broadcast或者Signal方法
    func (c *Cond) Wait()
        //代码片段
        c.L.Lock()
        for !condition() {
            c.Wait()
        }
        ... make use of condition ...
        c.L.Unlock()
    



    ```

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
