---
title: 内存高效golang
categories: 
- golang

---

> 原文链接 : https://dev.to/deadlock/golang-writing-memory-efficient-and-cpu-optimized-go-structs-2ick

<!-- more -->

# Golang编写内存高效和CPU优化的Go结构

结构是一个类型化的field集合，对于将数据分组记录非常有用。这使得与一个`strcut`有关的所有数据都被整齐地封装在一个轻量级的类型定义中，然后可以通过定义结构类型上的函数来实现行为。

这篇博客我将尝试解释我们如何在内存使用和CPU周期方面有效地编写结构。

让我们考虑下面这个结构，为我的一些奇怪的用例定义畸形资源类型。

```golang
type TerraformResource struct {
  Cloud                string                       // 16 bytes
  Name                 string                       // 16 bytes
  HaveDSL              bool                         //  1 byte
  PluginVersion        string                       // 16 bytes
  IsVersionControlled  bool                         //  1 byte
  TerraformVersion     string                       // 16 bytes
  ModuleVersionMajor   int32                        //  4 bytes
}

```
让我们用下面的代码看看TerraformResource结构需要多少内存分配。
```golang

package main

import "fmt"
import "unsafe"

type TerraformResource struct {
  Cloud                string                       // 16 bytes
  Name                 string                       // 16 bytes
  HaveDSL              bool                         //  1 byte
  PluginVersion        string                       // 16 bytes
  IsVersionControlled  bool                         //  1 byte
  TerraformVersion     string                       // 16 bytes
  ModuleVersionMajor   int32                        //  4 bytes
}

func main() {
    var d TerraformResource
    d.Cloud = "aws"
    d.Name = "ec2"
    d.HaveDSL = true
    d.PluginVersion = "3.64"
    d.TerraformVersion = "1.1"
    d.ModuleVersionMajor = 1
    d.IsVersionControlled = true
    fmt.Println("==============================================================")
    fmt.Printf("Total Memory Usage StructType:d %T => [%d]\n", d, unsafe.Sizeof(d))
    fmt.Println("==============================================================")
    fmt.Printf("Cloud Field StructType:d.Cloud %T => [%d]\n", d.Cloud, unsafe.Sizeof(d.Cloud))
    fmt.Printf("Name Field StructType:d.Name %T => [%d]\n", d.Name, unsafe.Sizeof(d.Name))
    fmt.Printf("HaveDSL Field StructType:d.HaveDSL %T => [%d]\n", d.HaveDSL, unsafe.Sizeof(d.HaveDSL))
    fmt.Printf("PluginVersion Field StructType:d.PluginVersion %T => [%d]\n", d.PluginVersion, unsafe.Sizeof(d.PluginVersion))
    fmt.Printf("ModuleVersionMajor Field StructType:d.IsVersionControlled %T => [%d]\n", d.IsVersionControlled, unsafe.Sizeof(d.IsVersionControlled))
    fmt.Printf("TerraformVersion Field StructType:d.TerraformVersion %T => [%d]\n", d.TerraformVersion, unsafe.Sizeof(d.TerraformVersion))
    fmt.Printf("ModuleVersionMajor Field StructType:d.ModuleVersionMajor %T => [%d]\n", d.ModuleVersionMajor, unsafe.Sizeof(d.ModuleVersionMajor))  
}
```
output如下
```golang
==============================================================
Total Memory Usage StructType:d main.TerraformResource => [88]
==============================================================
Cloud Field StructType:d.Cloud string => [16]
Name Field StructType:d.Name string => [16]
HaveDSL Field StructType:d.HaveDSL bool => [1]
PluginVersion Field StructType:d.PluginVersion string => [16]
ModuleVersionMajor Field StructType:d.IsVersionControlled bool => [1]
TerraformVersion Field StructType:d.TerraformVersion string => [16]
ModuleVersionMajor Field StructType:d.ModuleVersionMajor int32 => [4]
```
所以TerraformResource结构需要的总内存分配是88字节。这就是TerraformResource类型的内存分配情况
![TerraformResource类型的内存分配情况](https://res.cloudinary.com/practicaldev/image/fetch/s--HubwVUeX--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/kodelint/blog-assets/raw/main/images/01-golang-struct-memory-map.jpeg)

但为什么会有88个字节，16+16+1+16+1+16+4=70个字节，这额外的18个字节从何而来？

当涉及到结构体的内存分配时，它们总是被分配为连续的、字节对齐的内存块，并且字段是按照它们被定义的顺序分配和存储的。在这种情况下，**字节对齐**的概念意味着连续的内存块以与平台字大小相同的偏移量对齐。
![](https://res.cloudinary.com/practicaldev/image/fetch/s--S_4mkd0a--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/kodelint/blog-assets/raw/main/images/02-golang-struct-memory-map.jpeg)

我们可以清楚地看到，TerraformResource.HaveDSL , TerraformResource.isVersionControlled和TerraformResource.ModuleVersionMajor分别只占用了1个字节、1个字节和4个字节。其余的空间都是用空的焊盘字节填充的。

所以回到同样的数学问题上

> 分配字节=16字节+16字节+1字节+16字节+1字节+16字节+4字节  
空垫字节=7字节+7字节+4字节=18字节  
总字节数=分配字节数+空垫字节数=70字节+18字节=88字节

那么，我们该如何解决这个问题呢？通过适当的数据结构调整，如果我们重新定义我们的结构，就像这样
```golang
type TerraformResource struct {
  Cloud                string                       // 16 bytes
  Name                 string                       // 16 bytes
  PluginVersion        string                       // 16 bytes
  TerraformVersion     string                       // 16 bytes
  ModuleVersionMajor   int32                        //  4 bytes
  HaveDSL              bool                         //  1 byte
  IsVersionControlled  bool                         //  1 byte
}

```
测试代码如下
```golang
package main

import "fmt"
import "unsafe"

type TerraformResource struct {
  Cloud                string                       // 16 bytes
  Name                 string                       // 16 bytes
  PluginVersion        string                       // 16 bytes
  TerraformVersion     string                       // 16 bytes
  ModuleVersionMajor   int32                        //  4 bytes
  HaveDSL              bool                         //  1 byte
  IsVersionControlled  bool                         //  1 byte
}

func main() {
    var d TerraformResource
    d.Cloud = "aws"
    d.Name = "ec2"
    d.HaveDSL = true
    d.PluginVersion = "3.64"
    d.TerraformVersion = "1.1"
    d.ModuleVersionMajor = 1
    d.IsVersionControlled = true
    fmt.Println("==============================================================")
    fmt.Printf("Total Memory Usage StructType:d %T => [%d]\n", d, unsafe.Sizeof(d))
    fmt.Println("==============================================================")
    fmt.Printf("Cloud Field StructType:d.Cloud %T => [%d]\n", d.Cloud, unsafe.Sizeof(d.Cloud))
    fmt.Printf("Name Field StructType:d.Name %T => [%d]\n", d.Name, unsafe.Sizeof(d.Name))
    fmt.Printf("HaveDSL Field StructType:d.HaveDSL %T => [%d]\n", d.HaveDSL, unsafe.Sizeof(d.HaveDSL))
    fmt.Printf("PluginVersion Field StructType:d.PluginVersion %T => [%d]\n", d.PluginVersion, unsafe.Sizeof(d.PluginVersion))
    fmt.Printf("ModuleVersionMajor Field StructType:d.IsVersionControlled %T => [%d]\n", d.IsVersionControlled, unsafe.Sizeof(d.IsVersionControlled))
    fmt.Printf("TerraformVersion Field StructType:d.TerraformVersion %T => [%d]\n", d.TerraformVersion, unsafe.Sizeof(d.TerraformVersion))
    fmt.Printf("ModuleVersionMajor Field StructType:d.ModuleVersionMajor %T => [%d]\n", d.ModuleVersionMajor, unsafe.Sizeof(d.ModuleVersionMajor))
}


```
output如下

```golang
go run golang-struct-memory-allocation-optimized.go

==============================================================
Total Memory Usage StructType:d main.TerraformResource => [72]
==============================================================
Cloud Field StructType:d.Cloud string => [16]
Name Field StructType:d.Name string => [16]
HaveDSL Field StructType:d.HaveDSL bool => [1]
PluginVersion Field StructType:d.PluginVersion string => [16]
ModuleVersionMajor Field StructType:d.IsVersionControlled bool => [1]
TerraformVersion Field StructType:d.TerraformVersion string => [16]
ModuleVersionMajor Field StructType:d.ModuleVersionMajor int32 => [4]

```
现在TerraformResource类型的总内存分配是72字节。让我们看看内存的排列方式是什么样子的

![](https://res.cloudinary.com/practicaldev/image/fetch/s--V9hRLdR1--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/kodelint/blog-assets/raw/main/images/03-golang-struct-memory-map.jpeg)

仅仅通过对结构元素进行适当的数据结构对齐，我们就能够将内存占用从88字节减少到72字节....，很好!

让我们检查一下数学运算

> 分配字节=16字节+16字节+16字节+16字节+4字节+1字节+1字节=70字节
空垫字节=2字节  
总字节数=分配字节数+空垫字节数=70字节+2字节=72字节

适当的数据结构排列不仅可以帮助我们有效地使用内存，还可以帮助CPU读取周期....，如何？

CPU以字为单位读取内存，32位系统为4字节，64位系统为8字节。现在，我们的第一个结构类型TerraformResource的声明将需要11个字来让CPU读取所有内容。

![](https://res.cloudinary.com/practicaldev/image/fetch/s--YxrCrSAs--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/kodelint/blog-assets/raw/main/images/01-golang-struct-word-length.jpeg)

然而，优化后的结构只需要9个字，如下图所示
![](https://res.cloudinary.com/practicaldev/image/fetch/s--_N8r3Z9U--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/kodelint/blog-assets/raw/main/images/02-golang-struct-word-length.jpeg)

通过正确定义结构体的数据结构，我们能够有效地使用内存分配，并使结构体在CPU读取方面也变得快速有效。

这只是一个小例子，想想一个有20或30个不同类型字段的大型结构。对数据结构进行深思熟虑的调整真的很有价值......🤩

希望这篇博客能够对结构的内部结构、其内存分配和所需的CPU读取周期有一些启发。希望这对你有帮助！!