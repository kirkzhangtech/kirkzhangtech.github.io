---
title: go语言圣经-chapter04-复合数据类型
categories:
- golang
tag: golang
---

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
