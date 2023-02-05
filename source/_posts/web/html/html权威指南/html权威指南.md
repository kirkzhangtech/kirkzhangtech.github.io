---
title: html权威指南
categories: 
- js
---

摘要： 这本写的是真垃圾

<!--more -->

<!--toc -->
摘要：系统的补一下相关知识

# 第一章

# 第二章

# 第三章

## 3.1 使用元素(标签)
在现代html元素中，我们应该使用具有代表含义，因为会影响呈现方式
```html
<code> apple </code> 
```

上面就是最简单的使用`code`元素的例子

`code`是标签或者教元素，特别注意的是`<code>`是语义元素 ， apple是内容。注意，浏览器不会显示元素的标签，它的任务是解读HTML文档，然后向用户呈现一个体现了HTML元素作用的视图

## 3.1.1 本章用的元素

```html
a
body
button
code
DOCTYPE
head
hr
html
input
label
p
style
table
td
textarea
th
title
tr
```
一个网页的基本布局
```html
<!DDOCTYPE html>
<html>
<head></head>
<body></body>
<html>
```

**空元素**：有标签但是没内容交空元素
**自闭合标签**：
```html
<meta />	定义网页的信息（供搜索引擎查看）
<link />	引入“外部CSS文件”
<br />	    换行标签
<hr />	    水平线标签
<img />	    图片标签
<input />	表单标签
```

**需元素**： 只能使用一个标签，中间放置任何内容都不符合html规范，这类元素成为需元素。`<hr>`元素表示一段的结束，还有另外一种表示方式`<hr />`


## 3.2 使用元素属性

这一节通常是设计到css的知识

## 3.3 创建html文档

1. 基本结构请参考[3.1.1](#311-本章用的元素)
2. `<head>`通常放元数据内容，比如
3. 内容主要就是网页主要内容
4. 父元素，子元素，兄弟元素，元素间关系的重要性在HTML中随处可见。一个元素能以什么样的元素为父元素或子元素是有限制的，这些限制通过**元素类型**
5. 元素类型 HTML5规范将元素分为三大类:
   - *元数据元素*(metadata element)、元数据元素用来构建HTML文档的基本结构，以及就如何处理文档向浏览器提供信息和指示
   - *流元素*(lowelement) 流元素是短语元素的超集。这就是说，所有短语元素都是流元素
   - *短语元素*(phrasingelement )。。另外两种元素略有不同，它们的用途是确定一个元素合法的父元素和子元素范围。短语元素是HTML的基本成分。但并非所有流元素都是短语元素

## 3.4 使用html实体
实体就是浏览器替代特殊字符的一种代码
|字符|实体名称|实体编号|
|---|----|---|
|	|空格	|`&nbsp;	&#160;`|
|<|	小于号	|`&lt;	&#60;`|
|>|	大于号	|`&gt;	&#62;`|
|&|	和号	|`&amp;	&#38;`|
|"|	引号	|`&quot;	&#34;`|
|'|	撇号 	|`&apos; (IE不支持)	&#39;`|
|￠|	分（cent）|	`&cent;	&#162;`|
|£|	镑（pound）|	`&pound;	&#163;`|
|¥|	元（yen）	|`&yen;	&#165;`|
|€|	欧元（euro）	|`&euro;	&#8364;`|
|§|	小节	|`&sect;	&#167;`|
|©|	版权（copyright）	|`&copy;	&#169;`|
|®|	注册商标	|`&reg;	&#174;`|
|™|	商标	|`&trade;	&#8482;`|
|×|	乘号	|`&times;	&#215;`|
|÷|	除号	|`&divide;	&#247;`|

## 3.5 全局属性

### 3.5.1 accesskey设置快捷键
`alt+n`就会聚焦到第一个input标签
`alt+p`聚焦到第二个input标签
`alt+s`聚焦到第三个input标签
```html
<!DOCTYPE HTML>
<html>
head>
<title>Example</title>
</head><body>
<form>
Name: <input type="text” name="name” accesskey="n"/>

Password: <input type="password” name="password” accesskey="p"/>

<input type="submit”value="Log In” accesskey="s"/>

</form>
</body>
</html>
```
### 3.5.2 标签的属性
1. `class`属性在设计css样式时使用,一个元素可以定义多个class元素
2. `contenteditable`允许用户修改页面内容
3. `contextmenu` 没有浏览器支持这种属性
4. `dir`属性规定内容方向即从左往右读，还是从右往左读
5. `draggable`支持拖放操作
6. `dropzone`支持拖放操作
7. `hidden` 把hidden属性应用到一个元素之后，浏览器干脆不去显示该元素
8. `id`属性是元素唯一标识符
9. `lang` lang属性还可以用来选择指定语言的内容，以便只显示用户所选语言的内容或对其应用样式。
10. `spellcheck`属性用来表明浏览器是否应该对元素的内容进行拼写检查。这个属性只有用在用户可以编辑的元素上时才有意义
11. `style` 一般不用，因为样式等级太高
12. `tabindex` HTML页面上的键盘焦点可以通过按Tab键在各元素之间切换。用tabindex属性可以改变默认的转移顺序。代码清单3-25示范了其用法。
13. `title` 提供元素的额外信息，比如鼠标悬停到元素上就会显示其他信息


# 第四章 css

这章与css书对应

# 第五章 初探javascript

这章与js书对应

# 第六章 语义与呈现分离

我的建议是:在语义方面要求严格点不为过，只要有条件，尽量避用那些具有浓重呈现意味或纯粹起呈现作用的元素。定义一个自定义类然后借助它应用所需样式并不复杂。只要做到样式的采用是以内容类型为依据而不是随心所欲，你至少也保持了一颗向着语义的心。


1. 标记只对内容和语义使用，而呈现交给css
2. 切记不要乱用标记
3. 别误用标记

**HTML元素集合**

# 第七章 创建HTML文档

本章介绍的是最基础的HTML5元素:文档元素和元数据元素。它们是用来创建HTML文档和说明其内容的元素。

## 7.1 head基本元素

## 7.2 用元数据说明文档

`title` 正式反应网络页上那个文字

`<base href="" />` base元素可用来设置一个基准URL，让HTML文档中的相对链接在此基础上进行解析。相对链接省略了URL中的协议、主机和端口部分，需要根据别的URL(要么是base元素中指定的URL，要么是用以加载当前文档的URL)得出其完整形式。base元素还能设定链接在用户点击时的打开方式，以及提交表单时浏览器如何反应,提示如果不用base元素，或不用其href属性设置一个基准URL，那么浏览器会将当前文档的URL认定为所有相对URL的解析基准。

`<target>` 告诉浏览器打开哪个网页


`meta` 元素定义文档各种元数据(元素具体详情要谷歌)
1. `<meta name="" content=""/>`预定义的几种元数据类型![扩展元数据](https://zh.wikipedia.org/wiki/Meta%E5%85%83%E7%B4%A0)
   1. `<meta name="robots" content="nofollow"/>` 不让机器人继续搜索后面网页`noindex`和`noarchive`
   2. `<meta name="author" content=""/>`           网页作者
   3. `<meta name="application name" content=""/>` 当前application系统的名称
   4. `<meta name="description" content=""/>`      页面说明
   5. `<meta name="keywords" content=""/>`         一些描述页面的内容
   6. `<meta name="generator" content=""/>`        描述生成html的软件名称
2. `<meta charset="utf-8">`
3. `<meta http-equiv="refresh" content="5">`meta元素的最后一种用途是改写HTTP(超文本传输协议)标头字段的值。服务器和浏览器之间传输HTML数据时一般用的就是HTTP
   1. `default-style`指定页面优先使用的样式表。对应的content属性值应与同一文档中某个style元素或link元素的title属性值相同
   2. <meta http-equiv="content-type"” content="text/htm" charset="UTF-8"/>这是另一种声明HTML页面所用字符编码的方法
4. `style`属性,不指定scoped值，就会作用所有整个页面
   ```html
    <style media="screen" type="text/css"> </style>
    
    <style media="print"> </style> 指定的是打印时候的样式
    /*
    all         将样式用于所有设备
    aural       语音合成器
    braille     盲文设备
    handheld
    projection
    print
    screen
    tty
    tv          将样式用于电视机
    */
   ```
   具体的响应式布局，，可以参考css相关书籍
5. 指定外部资源
   ```html
   <link rel="stylesheet" type="text/css" href="style.css">
   ```
   为网页设置icon
   ```html
   <link rel="shortcut" href="favicon.ico" type="image/x-icon">
   ```
   预先获取关联的数据
   ```html
   <link rel="prefetch" href="/page2.html"
   ```

## 7.3 使用脚本
   1. 使用script元素
   2. 定义内嵌脚本
   3. 载入外部脚本库
   4. 推迟脚本的执行，可以使用defer和async的对脚本的执行加以控制，defer会将脚本加载推迟到所有元素加载完成之后
   5. 异步执行脚本,async属性解决的是另一类问题。前面说过，浏览器遇到script元素时的默认行为是在加载和执行脚本的同时暂停处理页面。各个script元素依次(即按其定义的次序)同步(即在脚本加载和执行进程中不再管别的事情) 执行。使用了async属性后，浏览器将在继续解析HTML文档中其他元素(包括其他script元素)的同时异步加载和执行脚本。如果运用得当，这可以大大提高整体加载性能。代码清单7-24示范了async属性的用法。
   6. `<noscript>` this javascript is required`<noscript/>`

# 第八章 标记文字

## 8.1 生成超链接

`<a href="https:// " >`如果指定http协议就会认为是互联网资源，如果不指定协议就会当成是相对路径认为在同一路径下
`<a href="#fruit">` 这个超链接就会跳转到id为`fruit`的元素，如果找不到就会通过name查找
`<a>`标签的target属性  
```html
_blank      Opens the linked document in a new window or tab
_self	      Opens the linked document in the same frame as it was clicked (this is default)
_parent	   Opens the linked document in the parent frame
_top	      Opens the linked document in the full body of the window
framename	Opens the linked document in the named iframe
```

## 8.2 用基本的文字元素标记内容

`<b>`          加粗
`<em>`         斜体
`<i>`
`<strong>`
`<u>`          为文字加下划线
`<small>`      小号字体
`<sub><sup>`   下标，上标
`<br>`         换行 
`wbr`

## 8.3 输入输出
`<code>`
`var`
`samp`
`kdd`
`<abbr title=Florida>`
`dfn`
`<q>`
`<cite>`
`<ruby>`
`<rt>`
`<rp>`
`<bdo>`
`<bdi>`
`<span>`

# 第九章 组织内容
`p`元素使用div元素
`pre`元素
`blockquote`元素
`hr`元素
`ol`元素和li元素
`ul`元素和li元素
`ol`元素和li元素，并设置l元素的value属性
`dl`、
`dt`和
`dd`元素
`ul`元素，并配合使用CSS的 :before选择器和counter特性
`figure`
`figcaption`


# 第十章 文档分节
`h1-h3`
`hgroup`
`section`
`header`
`footer`
`nav`
`artical`
`<aside`
`<adress`
`<details`
`<summary>`

# 第十一章 表格元素
`<table>`
`<th>`
`<thead>`
`<tbody>`
`<tfoot>`


# 第十二章 表单
`<form>`
`<input>`
`<button>`
1. 配置表单的action属性，action属性是，此处还可以配合使用`<base>`
2. method属性配置http的传输方式，POST，GET
3. 配置数据编码`enctype`
   1. `application/x-www-form-urlencoded`不能用来上传文件到服务器上，但是和任何表单
   2. `multipart/form-data`用来上传文件
   3. `text/plain` 要谨慎
4. 在`input`标签控制表单自动完成功能`autocomplete`
5. `name`属性，不发给服务器，仅限于dom使用
6. 在表单中添加标签`<p><label for="fav"><input name="fav" /> </label><p>`
7. 自动聚焦input标签使用autofocus
8. `<input disable id="name" />`
9. 对表单分组`<fieldset>`,`<legend>`为fieldset标签添加说明，`<fieldset disable>`禁用掉input元素
10. 使用<button type="reset/submit/button">元素
11. 使用表单外元素
    ```html
    <form id="voteform">
    <input >
    </form>
    <button id="voteform" ></buton>
    ```

# 第十三章 定制inout元素

## 13.1 使用input输入文字
```html
dirname     指定文字方向
maxlength   文字最大长度
pattern     指定用户输入验证的正则表达式
placeholder 关于所需数据类型的提示
readonly    只读
required    表明用户必须输入一个值否则无法通过验证
size        通过之地不过文本框中可见字符数目设定其宽度
value       这是文本框初始值
disable     禁用
```
1. 使用数据列表
```html
<input list="fruitlist">
<datils id="fruitlist">
   <option value-"apple">lovely apple</option>
</datails>
```

## 13.2 为input输入密码
type类型设置为password的元素用于输入密码
```html
<input type="password">

maxlength
pattern
placeholder
readonly
required
size
value
```
## 13.3 用input生成按钮

```html
<input type="submit/reset/button"/>

```
# 13.4 用input元素为输入数据把关

```html
<input type="button">
<input type="checkbox">
<input type="color">
<input type="date">
<input type="datetime-local">
<input type="email">
<input type="file">
<input type="hidden">
<input type="image">
<input type="month">
<input type="number">
<input type="password">
<input type="radio">
<input type="range">
<input type="reset">
<input type="search">
<input type="submit">
<input type="tel">
<input type="text">
<input type="time">
<input type="url">
<input type="week">
```
1. 用input元素获取值
   ```html
   <input type="email/tel/url">
   <input type="hidden"> 用户提交表单时，浏览器会将那个hidden型input元素的name和value属性值作为一个数据项纳人发送内容。上图中的表单提交后来自Nodejs脚本的反馈信息如图
   ```
2. 用图片展示按钮
   `<inpput type="img" src="" name="submit">`
3. 用input标签上传文件
   ``
   ```html
   <form method="POST" action="www" enctype="multipart/form-data">
   </form>
   ```
# 第十三章 理解DOM
DOM就是一组对象的集合，这些对象代表了HTML文档里的各个元素，所以DOM就是个模型，由众多文档对象组成，它保存了文档对象之间的关系
很重要:文档模型里任何代表某个元素的对象都至少能支持HTMLEement功能，其中一些还支持额外的功能。
不是所有可供使用的对象都代表了HTML元素。正如你即将看到的，一些对象代表元素的集合，另一些则代表DOM自身的信息，当然还有Document这个对象，它是我们探索DOM的人口也是第26章的主题。




