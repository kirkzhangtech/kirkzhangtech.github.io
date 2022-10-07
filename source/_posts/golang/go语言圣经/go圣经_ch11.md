---
title: go语言圣经-chapter11-测试
categories:
- golang
tag: golang
---

# 11. 测试

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
