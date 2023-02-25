---
title: html权威指南
categories: 
- js
---

摘要： 系统的补一下相关知识,这本写的是真垃圾

<!--more -->

<!--toc -->



# 1. html基础
## 1.1 使用元素(标签)
在现代html元素中，我们应该使用具有代表含义，因为会影响呈现方式
```html
<code> apple </code> 
```

上面就是最简单的使用`code`元素的例子

`code`是标签或者教元素，特别注意的是`<code>`是语义元素 ， apple是内容。注意，浏览器不会显示元素的标签，它的任务是解读HTML文档，然后向用户呈现一个体现了HTML元素作用的视图

## 1.2 本章用的元素

**空元素**：有标签但是没内容交空元素
**自闭合标签**：
```html
<meta/>	定义网页的信息（供搜索引擎查看）
<link/>	引入“外部CSS文件”
<br/>	    换行标签
<hr/>	    水平线标签
<img/>	    图片标签
<input/>	表单标签
```

**虚元素**： 只能使用一个标签，中间放置任何内容都不符合html规范，这类元素成为需元素。`<hr>`元素表示一段的结束，还有另外一种表示方式`<hr />`



## 1.3 创建html文档

1. 基本结构请参考[3.1.1](#311-本章用的元素)
2. `<head>`通常放元数据内容，比如
3. 内容主要就是网页主要内容
4. 父元素，子元素，兄弟元素，元素间关系的重要性在HTML中随处可见。一个元素能以什么样的元素为父元素或子元素是有限制的，这些限制通过**元素类型**
5. 元素类型 HTML5规范将元素分为三大类:
   - *元数据元素*(metadata element)、元数据元素用来构建HTML文档的基本结构，以及就如何处理文档向浏览器提供信息和指示
   - *流元素*(lowelement) 流元素是短语元素的超集。这就是说，所有短语元素都是流元素
   - *短语元素*(phrasingelement )。。另外两种元素略有不同，它们的用途是确定一个元素合法的父元素和子元素范围。短语元素是HTML的基本成分。但并非所有流元素都是短语元素



# 2 语义与呈现分离

我的建议是:在语义方面要求严格点不为过，只要有条件，尽量避用那些具有浓重呈现意味或纯粹起呈现作用的元素。定义一个自定义类然后借助它应用所需样式并不复杂。只要做到样式的采用是以内容类型为依据而不是随心所欲，你至少也保持了一颗向着语义的心。


1. 标记只对内容和语义使用，而呈现交给css
2. 切记不要乱用标记
3. 别误用标记




# 3 HTML元素
[参考w3school](https://www.w3school.com.cn/tags/tag_a.asp)

## 19.1 基础标签
```html
<!DOCTYPE> 声明对大小写不敏感。  <!-- 文档类型 --->
<!DOCTYPE html>
<html>
   <head></head>
   <body>
      <h1>h1</h1>
      <h2>h2</h2>
      <h3>h3</h3>
      <h4>h4</h4>
      <h5>h5</h5>
      <h6>h6</h6>
      <p>段落</p> <!--段落-->换行<br />      <!--定义简单的折行-->
      <hr />      <!--定义水平线-->
   </body>

</html>
```



## 19.2 格式化标签

```html
<abbr>
```
<abbr title="People's Republic of China">PRC</abbr> <!-- 鼠标悬浮上去会显示标签的中具体说明-->
<hr>

```html
<address>   <!-- 定义文档作者或拥有者的联系信息。 -->
```
<address>   <!-- 定义文档作者或拥有者的联系信息。 -->
Written by <a href="mailto:webmaster@example.com">Donald Duck</a>.<br> 
Visit us at:<br>
Example.com<br>
Box 564, Disneyland<br>
USA
</address>
<hr>

```html
<b>	      定义粗体文本。
<bdi>	      定义文本的文本方向，使其脱离其周围文本的方向设置。
<bdo>	      定义文字方向。
```
Username <bdi dir="rtl">Bill</bdi>   :80 point <br>
<bdo>	      定义文字方向。
   <bdo dir="rtl">
   Here is some Hebrew text
</bdo>
<hr>

```html
<blockquote>定义长的引用。
<cite>	   定义引用(citation)。
<code>	   定义计算机代码文本。
<del>	      定义被删除文本线。
```
<p>一打有 <del>二十</del> <ins>十二</ins> 件。</p>
<hr>

```html
<dfn>	      定义项目。
<em>	      定义强调文本。斜体</em>
<i>	      定义斜体文本。</i>
<ins>	      定义被插入文本。下划线
<kbd>	      定义键盘文本。

<ins>	 定义被插入文本。下划线</ins><br>
<kbd>Cmd</kbd> + <kbd>C</kbd>
```
<i>	      定义斜体文本。</i><br>
<em>	      定义强调文本。斜体</em><br>
<ins>	 定义被插入文本。下划线</ins><br>
<kbd>Cmd</kbd> + <kbd>C</kbd>
<hr>

```html
<mark>	   定义有记号的文本。
<p>Do not forget to buy <mark>milk</mark> today.</p>
```

<p>Do not forget to buy <mark>milk</mark> today.</p>
<hr>

```html
<meter>	   定义预定义范围内的度量。
<meter value="3" min="0" max="10">十分之三</meter><br>

```

<meter value="3" min="0" max="10">十分之三</meter><br>
<hr>

```html
<pre>	      定义预格式文本。
```

<pre>
&lt;html&gt;

&lt;head&gt;
  &lt;script type=&quot;text/javascript&quot; src=&quot;loadxmldoc.js&quot;&gt;
&lt;/script&gt;
&lt;/head&gt;

&lt;body&gt;

  &lt;script type=&quot;text/javascript&quot;&gt;
    xmlDoc=<a href="dom_loadxmldoc.asp">loadXMLDoc</a>(&quot;books.xml&quot;);
    document.write(&quot;xmlDoc is loaded, ready for use&quot;);
  &lt;/script&gt;

&lt;/body&gt;

&lt;/html&gt;
</pre>
<hr>

```html
<progress>	定义任何类型的任务的进度。
<progress value="22" max="100"></progress> <br>
```

<progress value="22" max="100"></progress> <br>
<hr>

```html
<q>	      定义短的引用。
<q>Here is a short quotation here is a short quotation</q><br>

```

<q>Here is a short quotation here is a short quotation</q><br>
<hr>

```html
<rp>	      定义若浏览器不支持 ruby 元素显示的内容。
<ruby>
漢 <rt><rp>(</rp>ㄏㄢˋ<rp>)</rp></rt>
</ruby>
```
<ruby>
漢 <rt><rp>(</rp>ㄏㄢˋ<rp>)</rp></rt>
</ruby>
<hr>

```html
<rt>	      定义 ruby 注释的解释
<ruby>
漢 <rt> ㄏㄢˋ </rt>
</ruby>
```
<ruby>
漢 <rt> ㄏㄢˋ </rt>
</ruby>
<hr>

```html
<ruby>	   定义 ruby 注释。
<ruby>
漢 <rt><rp>(</rp>ㄏㄢˋ<rp>)</rp></rt>
</ruby>
```
<ruby>
漢 <rt><rp>(</rp>ㄏㄢˋ<rp>)</rp></rt>
</ruby>
<hr>

```html
<s>	      定义加删除线的文本。
在 HTML 5 中，<s>仍然支持</s>已经不支持这个标签了。
```
在 HTML 5 中，<s>仍然支持</s>已经不支持这个标签了。
<hr>

```html
<samp>	   定义文本样本。
```
<samp>
kirkzhang, what you have done before? what was you doing on younth
</samp>
<hr>

```html
<small>	   定义小号文本。
<small>定义小号文本</small>
```
<small>定义小号文本</small>
<hr>

```html
<strike>	   定义加删除线文本。HTML5 中不支持。请使用 <del> 或 <s> 代替。
```
<hr>

```html
<strong>	   定义语气更为强烈的强调文本。
<strong>定义语气更为强烈的强调文本。</strong>
```
<strong>定义语气更为强烈的强调文本。</strong>
<hr>

```html
<sup>	      定义上标文本。
这段文本包含 <sup>上标</sup>
```
这段文本包含 <sup>上标</sup>
<hr>

```html
<sub>	      定义下标文本。
这段文本包含 <sub>下标</sub>
```
这段文本包含 <sub>下标</sub>
<hr>

```html
<template>	定义用作容纳页面加载时隐藏内容的容器。
<button onclick="showContent()">显示被隐藏的内容</button>

<template>
  <h2>Flower</h2>
  <img src="img_white_flower.jpg" width="214" height="204">
</template>

<script>
function showContent() {
  var temp = document.getElementsByTagName("template")[0];
  var clon = temp.content.cloneNode(true);
  document.body.appendChild(clon);
}
</script>
```
<button onclick="showContent()">显示被隐藏的内容</button>

<template>
  <h2>Flower</h2>
  <img src="img_white_flower.jpg" width="214" height="204">
</template>

<script>
function showContent() {
  var temp = document.getElementsByTagName("template")[0];
  var clon = temp.content.cloneNode(true);
  document.body.appendChild(clon);
}
</script>
<hr>

```html
<time>	   定义日期/时间。
<p>我在 <time datetime="2008-02-14">情人节</time> 有个约会。</p>
```
<p>我在 <time datetime="2008-02-14">情人节</time> 有个约会。</p>
<hr>

```html
<tt>	      定义打字机文本。HTML5 中不支持。请使用 CSS 代替。
```
<hr>

```html
<u>	      定义下划线文本。
<p>如果文本不是超链接，就不要<u>对其使用下划线</u>。</p>
类似于单词under的缩写
```
<p>如果文本不是超链接，就不要<u>对其使用下划线</u>。</p>
<hr>

```html
<var>	      定义文本的变量部分。
<code>
<var>person</var>
</code>
<hr>
```
<code>
<var>person</var>
</code>
<hr>

```html
<wbr>	定义可能的换行符。（单词换行时机）
<p>
如果想学习 AJAX，那么您必须熟悉 XML<wbr>Http<wbr>Request 对象。
</p>
```
<samp>this is a new sentence </samp>
<p>
如果想学习 AJAX，那么您必须熟悉 XML<wbr>Http<wbr>Request 对象。
</p>
<hr>

## 19.3 表单和输入

[表单的输入详情](https://www.w3school.com.cn/tags/tag_form.asp)

enctype 属性可能的值：
- application/x-www-form-urlencoded在发送前编码所有字符（默认）（空格被编码为’+’，特殊字符被编码为ASCII十六进制字符）
- multipart/form-data不对字符编码。在使用包含文件上传控件的表单时，必须使用该值。有附件时候需指定
- text/plain空格转换为 “+” 加号，但不对特殊字符编码


[input属性](https://www.w3school.com.cn/tags/tag_input.asp)
[textarea定义多行的文本输入控件](https://www.w3school.com.cn/tags/tag_textarea.asp)
[button](https://www.w3school.com.cn/tags/tag_button.asp)
[select](https://www.w3school.com.cn/tags/tag_select.asp)
[optgroup](https://www.w3school.com.cn/tags/tag_optgroup.asp)
[option定义选择列表中的选项](https://www.w3school.com.cn/tags/tag_option.asp)
[label定义input元素标注](https://www.w3school.com.cn/tags/tag_label.asp)
[fieldset定义围绕表单中元素的边框](https://www.w3school.com.cn/tags/tag_fieldset.asp)
[legend](https://www.w3school.com.cn/tags/tag_legend.asp)
[datalist](https://www.w3school.com.cn/tags/tag_datalist.asp)
[keygen](https://www.w3school.com.cn/tags/tag_keygen.asp)
[output](https://www.w3school.com.cn/tags/tag_output.asp)

## 19.4 框架

[frame]()	定义框架集的窗口或框架。HTML5 中不支持。
[frameset]()	定义框架集。HTML5 中不支持。
[noframes]()	定义针对不支持框架的用户的替代内容。HTML5 中不支持。
[iframe](https://www.w3school.com.cn/tags/tag_iframe.asp)	定义内联框架。

## 19.5 图像

[img定义图像](https://www.w3school.com.cn/tags/tag_img.asp)
[map定义图像映射](https://www.w3school.com.cn/tags/tag_map.asp)
[area定义图像地图内部的区域]
[canvas]	定义图形。
[figcaption]	定义 figure 元素的标题。
[figure]	定义媒介内容的分组，以及它们的标题。
[svg]	定义 SVG 图形的容器。

## 19.6 音视频
```html
[<audio>](sdasd)	定义声音内容。
<source>	定义媒介源。
<track>	定义用在媒体播放器中的文本轨道。
<video>	定义视频。
```
## 19.7 链接
```html
<a>	   定义锚。
<link>	定义文档与外部资源的关系。
<nav>	   定义导航链接。
```

## 19.8 链接
```html
<ul>	定义无序列表。
<ol>	定义有序列表。
<li>	定义列表的项目。
<dir>	定义大号文本。HTML5 中不支持。请使用 CSS 代替。
<dl>	定义定义列表。
<dt>	定义定义列表中的项目。
<dd>	定义定义列表中项目的描述。
<menu>	定义命令的菜单/列表。
<menuitem>	定义用户可以从弹出菜单调用的命令/菜单项目。
<command>	定义命令按钮。
```

## 19.9 表格
```html
<table>	定义表格
<caption>	定义表格标题。
<th>	定义表格中的表头单元格。
<tr>	定义表格中的行。
<td>	定义表格中的单元。
<thead>	定义表格中的表头内容。
<tbody>	定义表格中的主体内容。
<tfoot>	定义表格中的表注内容（脚注）。
<col>	定义表格中一个或多个列的属性值。
<colgroup>	定义表格中供格式化的列组。
```

## 19.10 样式和语义
```
<style>	定义文档的样式信息。
<div>	定义文档中的节。
<span>	定义文档中的节。
<header>	定义 section 或 page 的页眉。
<footer>	定义 section 或 page 的页脚。
<main>	定义文档的主要内容。
<section>	定义 section。
<article>	定义文章。
<aside>	定义页面内容之外的内容。
<details>	定义元素的细节。
<dialog>	定义对话框或窗口。
<summary>	为 <details> 元素定义可见的标题。
<data>	添加给定内容的机器可读翻译。
```

## 19.11 元信息
```
<head>	定义关于文档的信息。
<meta>	定义关于 HTML 文档的元信息。
<base>	定义页面中所有链接的默认地址或默认目标。
<basefont>	定义页面中文本的默认字体、颜色或尺寸。HTML5 中不支持。请使用 CSS 代替。
```
## 19.12 编程

```html
<script>	定义客户端脚本。
```
1. 使用script元素
2. 定义内嵌脚本
3. 载入外部脚本库
4. 推迟脚本的执行，可以使用defer和async的对脚本的执行加以控制，defer会将脚本加载推迟到所有元加载完成之后
5. 异步执行脚本,async属性解决的是另一类问题。前面说过，浏览器遇到script元素时的默认行为是在加和执行脚本的同时暂停处理页面。各个script元素依次(即按其定义的次序)同步(即在脚本加载和执行进程不再管别的事情) 执行。使用了async属性后，浏览器将在继续解析HTML文档中其他元素(包括其他script素)的同时异步加载和执行脚本。如果运用得当，这可以大大提高整体加载性能。代码清单7-24示范了asyn属性的用法。
6. `<noscript>` this javascript is required`<noscript/>`

```html
<noscript>	定义针对不支持客户端脚本的用户的替代内容。
<applet>	定义嵌入的 applet。HTML5 中不支持。请使用 <embed> 和 <object> 代替。
<embed>	为外部应用程序（非 HTML）定义容器。
<object>	定义嵌入的对象。
<param>	定义对象的参数。
```

# 20 使用DOM元素

# 20 浏览器支持情况
[w3school](https://www.w3school.com.cn/tags/html_ref_html_browsersupport.asp)

# 21 全局属性
```
accesskey	      规定激活元素的快捷键。
class	            规定元素的一个或多个类名（引用样式表中的类）。
contenteditable	规定元素内容是否可编辑。
contextmenu	      规定元素的上下文菜单。上下文菜单在用户点击元素时显示。
data-*	         用于存储页面或应用程序的私有定制数据。
dir	            规定元素中内容的文本方向。
draggable	      规定元素是否可拖动。-- 这个可以在网页做出很酷的东西
dropzone	         规定在拖动被拖动数据时是否进行复制、移动或链接。
hidden	         规定元素仍未或不再相关。
id	               规定元素的唯一 id。
lang	            规定元素内容的语言。
spellcheck	      规定是否对元素进行拼写和语法检查。
style	            规定元素的行内 CSS 样式。
tabindex	         规定元素的 tab 键次序。
title	            规定有关元素的额外信息。
translate	      规定是否应该翻译元素内容。
```

# 22 事件

[事件参考手册](https://www.w3school.com.cn/tags/html_ref_eventattributes.asp)

1. Window 事件属性

|事件名|类型|说明|
|---|---|---|
|onafterprint	 | script	  |文档打印之后运行的脚本。|
|onbeforeprint	|  script	|文档打印之前运行的脚本。|
|onbeforeunload|	script	|文档卸载之前运行的脚本。|
|onerror	      |  script	|在错误发生时运行的脚本。|
|onhaschange	  |  script	|当文档已改变时运行的脚本|
|onload	       | script	  |页面结束加载之后触发。|
|onmessage	    |  script	|在消息被触发时运行的脚本|
|onoffline	    |  script	|当文档离线时运行的脚本。|
|ononline	     | script	  |当文档上线时运行的脚本。|
|onpagehide	   | script	  |当窗口隐藏时运行的脚本。|
|onpageshow	   | script	  |当窗口成为可见时运行的脚本。|
|onpopstate	   | script	  |当窗口历史记录改变时运行的脚本。|
|onredo	       | script	  |当文档执行撤销（redo）时运行的脚本。|
|onresize	     | script	  |当浏览器窗口被调整大小时触发。|
|onstorage	    |  script	|在 Web Storage 区域更新后运行的脚本。|
|onundo	       | script	  |在文档执行 undo 时运行的脚本。|
|onunload	     | script	  |一旦页面已下载时触发（或者浏览器窗口已被关闭|

1. Form 事件
```
onblur	script	元素失去焦点时运行的脚本。
onchange	script	在元素值被改变时运行的脚本。
oncontextmenu	script	当上下文菜单被触发时运行的脚本。
onfocus	script	当元素获得焦点时运行的脚本。
onformchange	script	在表单改变时运行的脚本。
onforminput	script	当表单获得用户输入时运行的脚本。
oninput	script	当元素获得用户输入时运行的脚本。
oninvalid	script	当元素无效时运行的脚本。
onreset	script	当表单中的重置按钮被点击时触发。HTML5 中不支持。
onselect	script	在元素中文本被选中后触发。
onsubmit	script	在提交表单时触发。
```

1. 鼠标事件
```html
onkeydown	script	在用户按下按键时触发。
onkeypress	script	在用户敲击按钮时触发。
onkeyup	script	当用户释放按键时触发。
```
1. Mouse事件
```html
onclick	script	元素上发生鼠标点击时触发。
ondblclick	script	元素上发生鼠标双击时触发。
ondrag	script	元素被拖动时运行的脚本。
ondragend	script	在拖动操作末端运行的脚本。
ondragenter	script	当元素元素已被拖动到有效拖放区域时运行的脚本。
ondragleave	script	当元素离开有效拖放目标时运行的脚本。
ondragover	script	当元素在有效拖放目标上正在被拖动时运行的脚本。
ondragstart	script	在拖动操作开端运行的脚本。
ondrop	script	   当被拖元素正在被拖放时运行的脚本。
onmousedown	script	当元素上按下鼠标按钮时触发。
onmousemove	script	当鼠标指针移动到元素上时触发。
onmouseout	script	当鼠标指针移出元素时触发。
onmouseover	script	当鼠标指针移动到元素上时触发。
onmouseup	script	当在元素上释放鼠标按钮时触发。
onmousewheel	script	当鼠标滚轮正在被滚动时运行的脚本。
onscroll	script	   当元素滚动条被滚动时运行的脚本。
```
1. Media 事件
```html
onabort	script	在退出时运行的脚本。
oncanplay	script	当文件就绪可以开始播放时运行的脚本（缓冲已足够开始时）。
oncanplaythrough	script	当媒介能够无需因缓冲而停止即可播放至结尾时运行的脚本。
ondurationchange	script	当媒介长度改变时运行的脚本。
onemptied	script	当发生故障并且文件突然不可用时运行的脚本（比如连接意外断开时）。
onended	script	当媒介已到达结尾时运行的脚本（可发送类似“感谢观看”之类的消息）。
onerror	script	当在文件加载期间发生错误时运行的脚本。
onloadeddata	script	当媒介数据已加载时运行的脚本。
onloadedmetadata	script	当元数据（比如分辨率和时长）被加载时运行的脚本。
onloadstart	script	在文件开始加载且未实际加载任何数据前运行的脚本。
onpause	script	当媒介被用户或程序暂停时运行的脚本。
onplay	script	当媒介已就绪可以开始播放时运行的脚本。
onplaying	script	当媒介已开始播放时运行的脚本。
onprogress	script	当浏览器正在获取媒介数据时运行的脚本。
onratechange	script	每当回放速率改变时运行的脚本（比如当用户切换到慢动作或快进模式）。
onreadystatechange	script	每当就绪状态改变时运行的脚本（就绪状态监测媒介数据的状态）。
onseeked	script	当 seeking 属性设置为 false（指示定位已结束）时运行的脚本。
onseeking	script	当 seeking 属性设置为 true（指示定位是活动的）时运行的脚本。
onstalled	script	在浏览器不论何种原因未能取回媒介数据时运行的脚本。
onsuspend	script	在媒介数据完全加载之前不论何种原因终止取回媒介数据时运行的脚本。
ontimeupdate	script	当播放位置改变时（比如当用户快进到媒介中一个不同的位置时）运行的脚本。
onvolumechange	script	每当音量改变时（包括将音量设置为静音）时运行的脚本。
onwaiting	script	当媒介已停止播放但打算继续播放时（比如当媒介暂停已缓冲更多数据）运行脚本
```
# 23 HTML Canvas 参考手册

# 24 HTML 音频/视频参考手册

