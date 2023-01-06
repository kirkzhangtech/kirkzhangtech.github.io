---
title: 深入解析css
categories: 
- js
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/210164183-d8995c70-1555-426d-bc2b-b60ce6a33587.jpg
metaAlignment: center
coverMeta: out
---

摘要：重新学下css,学完了能很快做出东西，而且是看的见东西

<!-- more -->
<!-- toc -->

# 1. 层叠，优先级和继承

## 1.1 层叠

css样式是声明式的，也存在着结构概念。这背后有很多的问题要讨论，首先我们需要理解浏览器如何解析样式规则。每条规则单独来看很简
单，但是当两条规则提供了冲突的样式时会发生什么呢？也就是说对同一个元素使用多个规则会出现冲突

```css

<!-- listing-1.2.html -->

<!doctype html>
<head>
  <style>
h1 {
  font-family: serif;
}

#page-title {
  font-family: sans-serif;
}

.title {
  font-family: monospace;
}
  </style>
</head>
<body>
  <header class="page-header">
    <h1 id="page-title" class="title">
      Wombat Coffee Roasters
    </h1>
    <nav>
      <ul id="main-nav" class="nav">
        <li><a href="/">Home</a></li>
        <li><a href="/coffees">Coffees</a></li>
        <li><a href="/brewers">Brewers</a></li>
        <li><a href="/specials" class="featured">Specials</a></li>
      </ul>
    </nav>
  </header>
</body>
```
最终ID选择器生效，层叠指的就是这一系列规则。它决定了如何解决冲突，是CSS语言的基础。
层叠的规则：
1. 样式表的来源：样式是从哪里来的，包括你的样式和浏览器默认样式等.
   1. 使用优先级更高的声明，作者样式大于默认样式
2. 选择器优先级：哪些选择器比另一些选择器更重要.
   1. 使用更高优先级的声明,是不是内联样式，使用内联样式
3. 源码顺序：样式在样式表里的声明顺序.

**术语解释**
描述问题时候尽量加上html属性和css属性，避免混淆
选择器和生命块组成了一个规则集
```css
body {
    color: back;
    font-family: Helvetica;
}
```


### 1.1.1 样式表的来源

1. 程序员编写的样式表属于作者样式表，可以覆盖浏览器默认样式
2. 用户代理样式表=浏览器默认样式，用户代理样式表优先级低
正如上面[示例代码1.2](https://github.com/kirk-zhang58/CSS-In-Depth/blob/main/ch01/listing-1.2.html)所示，这个css主要是修饰`h1`元素的，然后css代码listing-1.2.html中作者样式覆盖了原先的默认样式

!important声明,标记了!important的声明会被当作更高优先级的来源,它的优先级大于作者样式优先级


### 1.1.2 理解优先级

如果无法用来源解决冲突声明，浏览器会尝试检查它们的优先级。
1. 行内样式
   实际上行内元素属于“带作用域的”声明，它会覆盖任何来自样式表或者 < style > 标签的样式。行内样式没有选择器，因为它们直接作用于所在的元素。**为了在样式表里覆盖行内声明**，需要为声明添加!important，这样能将它提升到一个更高优先级的来源。但如果行内样式也被标记为!important，就无法覆盖它了。最好是只在样式表内用!important。将以上修改撤销，我们来看看更好的方式。!important作用更像是将样式级别提升到最高

2. 选择器优先级

    如果设置相同属性，那么即使应用了两个选择器，那么ID选择器的样式会生效
   ```css
    #main-nav a {
        color: white;
        background-color: #13a4a4;  // id选择器的样式会生效
        padding: 5px;
        border-radius: 2px;
        text-decoration: none;
    }

    .featured {
        background-color: orange;   // 类选择器不生效，优先级不高
    }
   ```
   优先级的准确规则如下。
   - id选择器 > 类选择器 > 标签选择器 
   - 如果选择器的ID数量更多，则它会胜出（即它更明确）。
   - 如果ID数量一致，那么拥有最多类的选择器胜出。
   - 如果以上两次比较都一致，那么拥有最多标签名的选择器胜出。

    比如下面例子，判断哪些属性会生效
    ```css
    html body header h1 {    ←---- ❶ 4个标签
        color: blue;
    }
    body header.page-header h1 {  ←---- ❷ 3个标签和1个类
        color: orange;
    }
    .page-header .title {       ←---- ❸ 2个类
        color: green;
    }
    #page-title {           ←---- ❹ 1个ID
        color: red;
    }
    ```
    4的id选择器优先级最高，因此标题是红色，3有两个类选择器，删除4,就会展示3的样式，两个类选择器比一个类选择器更明确

    说明 伪类选择器（如:hover）和属性选择器（如[type="input"]）与一个类选择器的优先级相同。通用选择器（*）和组合器（>、+、~）对优先级没有影响。

    如果你在CSS里写了一个声明，但是没有生效，一般是因为被更高优先级的规则覆盖了。很多时候开发人员使用ID选择器，却不知道它会创建更高的优先级，之后就很难覆盖它。如果要覆盖一个ID选择器的样式，就必须要用另一个ID选择器。

3. 优先级标记

    也可以说是优先级表达式，选择器#page-header #page-title有2个ID,所以是[2.0.0],如果加上行内样式则就是[1.2.0.0]

4. 关于优先级的思考

### 1.1.3 源码顺序

[代码清单1-10](https://github.com/kirk-zhang58/CSS-In-Depth/blob/main/ch01/listing-1.10.html)

如果两个声明所影响的元素相同和优先级相同，那么源码(html的源码,不是样式源码)后出现的就会起作用

```css
a.featured {
  background-color: orange;
}
```

但是这样的写法，会出现如果其他位置也有a标签和featured的类属性，那么就会渲染到其他地方，所以要设计好html元素和选择器

[代码清单1-11](https://github.com/kirk-zhang58/CSS-In-Depth/blob/main/ch01/listing-1.11.html)

1. 链接样式和源码顺序
正如之前所说，在CSS中最好的答案通常是“这得看情况”。实现相同的
效果有很多途径。多想些实现方法，并思考每一种方法的利弊，这是很
有价值的。面对一个样式问题时，我经常分两个步骤来解决它。首先确
定哪些声明可以实现效果。其次，思考可以用哪些选择器结构，然后选
择最符合需求的那个。

[代码清单1-12](https://github.com/kirk-zhang58/CSS-In-Depth/blob/main/ch01/listing-1.12.html)

```css
<!doctype html>
<head>
  <style>
a:link {
  color: blue;
  text-decoration: none;
}

a:visited {
  color: purple;
}

a:hover {
  text-decoration: underline;
}

a:active {
  color: red;
}

h1 {
  color: #2f4f4f;
  margin-bottom: 10px;
}

.nav {
  margin-top: 10px;
  list-style: none;
  padding-left: 0;
}

.nav li {
  display: inline-block;
}

.nav a {
  color: white;
  background-color: #13a4a4;
  padding: 5px;
  border-radius: 2px;
  text-decoration: none;
}

.nav .featured {
  background-color: orange;
}
  </style>
</head>
<body>
  <header class="page-header">
    <h1 id="page-title" class="title">Wombat Coffee Roasters</h1>
    <nav>
      <ul id="main-nav" class="nav">
        <li><a href="/">Home</a></li>
        <li><a href="/coffees">Coffees</a></li>
        <li><a href="/brewers">Brewers</a></li>
        <li><a href="/specials" class="featured">Specials</a></li>
      </ul>
    </nav>
  </header>
</body>

```

书写顺序之所以很重要，是因为层叠。优先级相同时，后出现的样式会覆盖先出现的样式。如果一个元素同时处于两个或者更多状态，最后一个状态就能覆盖其他状态。如果用户将鼠标悬停在一个访问过的链接上，悬停效果会生效。如果用户在鼠标悬停时激活了链接（即点击了它），激活的样式会生效。

这个顺序的记忆口诀是“LoVe/HAte”（“爱/恨”），即link（链接）、visited（访问）、hover（悬停）、active（激活）。注意，如果将一个选择器的优先级改得跟其他的选择器不一样，这个规则就会遭到破坏，可能会带来意想不到的结果。

2. 层叠值

浏览器遵循三个步骤，即来源、优先级、源码顺序，来解析网页上每个元素的每个属性。在 CSS 中指的是多个样式规则对同一个元素的样式属性进行规定时，会发生的覆盖和继承的现象。每个样式规则都有一个权值，样式规则的权值越大，则该规则对元素的样式属性的影响越大。当多个样式规则同时作用于同一个元素时，系统会根据规则的权值进行排序，将权值大的规则应用到元素上，而权值小的规则会被忽略


### 1.1.4 两个经验法则

1. 在选择器中不要使用ID。就算只用一个ID，也会大幅提升优先级
2. 不要使用!important。它比ID更难覆盖，一旦用了它，想要覆盖原先的声明，就需要再加上一个!important，而且依然要处理优先级的问题。
3. 关于重要性的一个重要提醒当创建一个用于分发的JavaScript模块（比如NPM包）时，强烈建议尽量不要在JavaScript里使用行内样式。如果这样做了，就是在强迫使用该包的开发人员要么全盘接受包里的样式，要么给每个想修改的属性加上!important


## 1.2 继承

某些元素，在我们不指定属性值（没有层叠值）时候，他就会考虑从父标签中继承。但并不是所有的标签属性都会被进程，只有些特定的。主要是跟文本相关的属性会被继承
```css
color
font
font-family
font-size
font-weight
font-variant
font-style
line-height
letter-spacing
text-align
text-indent
text-transform
white-space
word-spacing
```
list-style、list-style-type、list-style-position以及list-style-image。表格的边框属性border-collapse和border-spacing也能被继承。注意，这些属性控制的是表格的边框行为，而不是常用于指定非表格元素边框的属性

[代码1-13](https://github.com/kirk-zhang58/CSS-In-Depth/blob/main/ch01/listing-1.13.html)
在body元素上修改了字体属性，子元素如果没有修改对应元素，那么就会继承body元素中的关于字体的定义

##  1.3 特殊值

有两个特殊值可以赋给任意属性，用于控制层叠：inherit和 initial。

### 1.3.1 使用inherit

[代码1-15](https://github.com/kirk-zhang58/CSS-In-Depth/blob/main/ch01/listing-1.15.html)

通常会给页面的所有链接的字体加一个醒目的蓝色，但是有个有需求说要让页脚的链接字体跟页脚一个颜色。那么我们就可以使用继承就可以解决问题

### 1.3.2 initial关键字

每一个CSS属性都有初始（默认）值。如果将initial值赋给某个属性，那么就会有效地将其重置为默认值，这种操作相当于硬复位了该值。这么做的好处是不需要思考太多。如果想删除一个元素的边框，设置border: initial即可。如果想让一个元素恢复到默认宽度，设置width: initial即可。

正如代码1-15所以，如果不指定inherit的话，那么也就会使用后面的样式值，因为它的样式表达式值权重更高

auto不是所有属性的默认值，对很多属性来说甚至不是合法的值。比如border-width: auto和padding: auto是非法的，因此不会生效。可以花点时间研究一下这些属性的初始值，不过使用initial更简单。

## 1.4 简写属性

比如`font: italic bold 18px/1.2 "Helvetica", "Arial", sans-serif;`就指定了font-style、font-weight、font-size、font-height以及font-family
更多的还有
- background是多个背景属性的简写属性：background-color、background-image、background-size、background-repeat、background-position、background-origin、background-chip以及background-attachment。
- border是border-width、border-style以及border-color的简写属性，而这几个属性也都是简写属性。
- border-width是上、右、下、左四个边框宽度的简写属性。

简写属性会设置省略值为其初始值
```css
title {
font: 32px Helvetica, Arial, sans-serif;
}
```
代码展开来写就是
```css

h1 {
  font-weight: bold;
}

.title {
  font-style: normal;
  font-variant: normal;
  font-weight: normal;
  font-stretch: normal;
  line-height: normal;
  font-size: 32px;
  font-family: Helvetica, Arial, sans-serif;
}

```
在所有的简写属性里，font的问题最严重，因为它设置的属性值太多了。因此，要避免在<body>元素的通用样式以外使用font。当然，其他简写属性也可能会遇到一样的问题，因此要当心。

### 1.4.1 理解简写样式的顺序

简写属性会尽量包容指定的属性值的顺序。可以设置`border: 1px solid black`或者`border: black 1px solid`，两者都会生效。这是因为浏览器知道宽度、颜色、边框样式分别对应什么类型的值

1. 上、右、下、左

```css
.
nav a {
color: white;
background-color: #13a4a4;
padding: 10px 15px 0 5px; ←---- 上、右、下、左内边距
border-radius: 2px;
text-decoration: none;
}
```
这种模式下的属性值还可以缩写。如果声明结束时四个属性值还剩一个没指定，没有指定的一边会取其对边的值。指定三个值时，左边和右边都会使用第二个值。指定两个值时，上边和下边会使用第一个值。如果只指定一个值，那么四个方向都会使用这个值。因此下面的声明都是等价的。
```css
padding: 1em 2em;
padding: 1em 2em 1em;
padding: 1em 2em 1em 2em;
```
但是下面代码就是上，下，左，右
```css
padding: 1em ;
```

2. 水平、垂直

有些属性包括background-position、box-shadow、text-shadow，比如background-position: 25% 75%则先指定水平方向的右/左属性值，然后才是垂直方向的上/下属性值。
虽然看起来顺序相反的定义违背了直觉，原因却很简单：这两个值代表了一个笛卡儿网格。笛卡儿网格的测量值一般是按照 （水平，垂直）的顺序来的。比如，如图1-15所示，要给元素加上一个阴影，就要先指定 （水平）值。
```css
.nav .featured {
background-color: orange;
box-shadow: 10px 2px #6f9090; ←---- 阴影向右偏移10px，向下偏移2px
}
```
如果属性需要指定从一个点出发的两个方向的值，就想想“笛卡儿网格”。如果属性需要指定一个元素四个方向的值，就想想"时钟"。


# 2. 相对单位

em的单位难以把握，像素单位相对简单