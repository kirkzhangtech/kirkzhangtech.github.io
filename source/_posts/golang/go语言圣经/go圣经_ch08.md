---
title: go语言圣经-chapter08-Goroutines和Channels
categories:
- golang
tag: golang
---


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

## 8.5 Appendind

1. 线程内再重启一个线程，然后就可以通过加锁，进行隔离开，但此时任然是两个线程的间的交替
