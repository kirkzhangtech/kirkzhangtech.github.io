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


```css

<!doctype html>
<head>
  <style>
h1 {
  color: #2f4f4f;
  margin-bottom: 10px;
}

#main-nav {
  margin-top: 10px;
  list-style: none;
  padding-left: 0;
}
// id选择器，然后继续选择li 元素
#main-nav li {
  display: inline-block;
}

#main-nav a {
  color: white;
  background-color: #13a4a4;
  padding: 5px;
  border-radius: 2px;
  text-decoration: none;
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
!important声明,标记了!important的声明会被当作更高优先级的来源,它的优先级大于作者优先级


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

    也可以说是优先级表达式，选择器#page-header #page-title有2个ID,所以是[2.0.0],如果加上行内样式则就是[1.0.0.0]

4. 关于优先级的思考

### 1.1.3 源码顺序

[代码清单1-10](https://github.com/kirk-zhang58/CSS-In-Depth/blob/main/ch01/listing-1.10.html)
如果两个声明所影响的元素相同和优先级相同，那么源码后出现的就会起作用
```css
a.featured {
  background-color: orange;
}
```

但是这样的写法，会出现如果其他位置也有a标签和featured的类属性，那么就会渲染到其他地方，所以要设计好html元素和选择器
[代码清单1-10](https://github.com/kirk-zhang58/CSS-In-Depth/blob/main/ch01/listing-1.11.html)

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

浏览器遵循三个步骤，即来源、优先级、源码顺序，来解析网页上每个元素的每个属性。如果一个声明在层叠中“胜出”，它就被称作一个层叠值。元素的每个属性最多只有一个层叠值。网页上一个特定的段落（< p >）可以有一个上外边距和一个下外边距，但是不能有两个不同的上外边距或两个不同的下外边距。如果CSS为同一个属性指定了不同的值，层叠最终会选择一个值来渲染元素，这就是层叠值。层叠值——作为层叠结果，应用到一个元素上的特定属性的值。如果一个元素上始终没有指定一个属性，这个属性就没有层叠值。还是拿段落举例，可能就没有指定的边框或者内边距。


### 1.1.4 两个经验法则

1. 在选择器中不要使用ID。就算只用一个ID，也会大幅提升优先级
2. 不要使用!important。它比ID更难覆盖，一旦用了它，想要覆盖原先的声明，就需要再加上一个!important，而且依然要处理优先级的问题。
3. 关于重要性的一个重要提醒当创建一个用于分发的JavaScript模块（比如NPM包）时，强烈建议尽量不要在JavaScript里使用行内样式。如果这样做了，就是在强迫使用该包的开发人员要么全盘接受包里的样式，要么给每个想修改的属性加上!important