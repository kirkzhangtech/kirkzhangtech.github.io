---
title: javascrip高级程序设计
categories: 
- js
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/204005741-8730914e-f757-43b6-b084-3dcec7123cff.jpg
metaAlignment: center
coverMeta: out
---

JavaScript 是一种非常松散的面向对象语言，也是 Web 开发中极受欢迎的一门语言。JavaScript，尽管它的语法和编程风格与 Java 都很相似，但它却不是 Java 的"轻量级"版本，甚至与 Java 没有任何关系。JavaScript 是一种全新的动态语言，它植根于全球数亿网民都在使用的 Web 浏览器之中，致力于增强网站和 Web 应用程序的交互性.
<!-- more -->

<!-- toc -->

# 1. JavaScript简介

summary:

1. Netscape Navigator研发，早期负责校验perl语言(服务器端)的输入数据.
2. 微软在其虽然开发了vbscript，但是在早期IE浏览器上还是自己实现了JS语言

## 1.1 JavaScript简史

summary:

1. 当时就职于 Netscape 公司的布兰登·艾奇（Brendan Eich），开始着手为计划于 1995 年 2 月发布的Netscape Navigator 2 开发一种名为 LiveScript 的脚本语言——该语言将同时在浏览器和服务器中使用(它在服务器上的名字叫 LiveWire)。为了赶在发布日期前完成 LiveScript 的开发，Netscape 与 Sun 公司建立了一个开发联盟。在 Netscape Navigator 2 正式发布前夕，Netscape 为了搭上媒体热炒 Java 的顺风车，临时把 LiveScript 改名为 JavaScript.

## 1.2 JavaScript实现

summary:

1. 一个完整的js实现应该包括如下三种不同的组分
   1. 核心(ECMAscript)
   2. 文档对象模型(DOM)
   3. 浏览器对象模型(BOM)

### 1.2.1 ECMAScript

summary:

1. web其实是实现了ECMAScript规范，提供了一种运行环境
2. 什么是 ECMAScript 兼容？ 
   1. 持 ECMA-262 描述的所有“类型、值、对象、属性、函数以及程序句法和语义”
   2. 支持 Unicode 字符标准。此外，兼容的实现还可以进行下列扩展。
   3. 添加 ECMA-262 没有描述的“更多类型、值、对象、属性和函数”。ECMA-262 所说的这些新增特性，主要是指该标准中没有规定的新对象和对象的新属性。
   4. 支持 ECMA-262 没有定义的“程序和正则表达式语法”。（也就是说，可以修改和扩展内置的正则表达式语法。）
3. Web 浏览器对 ECMAScript 的支持？这里完全就是历史

由 ECMA-262 定义的 ECMAScript 与 Web 浏览器没有依赖关系。实际上，这门语言本身并不包含输入和输出定义。ECMA-262 定义的只是这门语言的基础，而在此基础之上可以构建更完善的脚本语言。
我们常见的 Web 浏览器只是 ECMAScript 实现可能的**宿主环境**之一,宿主环境不仅提供基本的ECMAScript 实现，同时也会提供该语言的扩展，以便语言与环境之间对接交互。而这些扩展——如
DOM，则利用 ECMAScript 的核心类型和语法提供更多更具体的功能，以便实现针对环境的操作。其他宿主环境包括 Node（一种服务端 JavaScript 平台）和 Adobe Flash.

ECMA-262只是规定了语法，类型，语句，关键字，保留字，操作符，对象，ECMAScript 就是对实现该标准规定的各个方面内容的语言的描述。JavaScript 实现了 ECMAScript，Adobe ActionScript 同样也实现了 ECMAScript

### 1.2.2 文档对象模型(DOM)

summary:

1. 文档对象模型（DOM，Document Object Model）是针对 XML 但经过扩展用于 HTML 的应用程序编程接口（API，Application Programming Interface）。DOM 把整个页面映射为一个多层节点结构。HTML或 XML 页面中的每个组成部分都是某种类型的节点，这些节点又包含着不同类型的数据。看下面这个HTML 页面：这样就可以对其进行增删改查
   ```js
    <html> 
    <head> 
        <title>Sample Page</title> 
    </head> 
    <body> 
        <p>Hello World!</p> 
    </body> 
    </html> 
   ```
2. 为什么要使用DOM?微软和网景早期有意见分歧所以制定了W3C标准
3. DOM 级别？
   1. DOM1 core和DOM HTML
   2. DOM2 视图(DOM Views)
   3. DOM2 事件(DOM Events):定义了事件和事件处理的接口；
   4. DOM2 样式(DOM Style):定义了基于 CSS 为元素应用样式的接口；
   5. DOM2 遍历和范围:定义了遍历和操作文档树的接口。
   6. DOM3 级则进一步扩展了 DOM，引入了以统一方式加载和保存文档的方法——在 DOM 加载和保存（DOM Load and Save）模块中定义；新增了验证文档的方法——在 DOM 验证（DOM Validation）模块中定义。DOM3 级也对 DOM 核心进行了扩展，开始支持 XML 1.0 规范，涉及 XML Infoset、XPath和 XML Base。
4. 其他DOM标准(有需要在看)
5. Web 浏览器对 DOM 的支持?目前，支持 DOM 已经成为浏览器开发商的首要目标，主流浏览器每次发布新版本都会改进对 DOM的支持。下表列出了主流浏览器对 DOM 标准的支持情况

### 1.2.3 浏览器对象模型（BOM）

Internet Explorer 3 和 Netscape Navigator 3 有一个共同的特色，那就是支持可以访问和操作浏览器窗口的浏览器对象模型（BOM，Browser Object Model）发人员使用 BOM 可以控制浏览器显示的页面以外的部分。而 BOM 真正与众不同的地方（也是经常会导致问题的地方），还是它作为 JavaScript 实现的一部分但却没有相关的标准。这个问题在 HTML5 中得到了解决，HTML5 致力于把很多 BOM 功能写入正式规范。HTML5 发布后，很多关于 BOM 的困惑烟消云散。人们习惯上也把所有针对浏览器的 JavaScript 扩展算作 BOM 的一部分。下面就是一些这样的扩展
- 弹出新浏览器窗口的功能；
- 移动、缩放和关闭浏览器窗口的功能；
- 提供浏览器详细信息的 navigator 对象；
- 提供浏览器所加载页面的详细信息的 location 对象；
- 提供用户显示器分辨率详细信息的 screen 对象；
- 对 cookies 的支持；
- 像 XMLHttpRequest 和 IE 的 ActiveXObject 这样的自定义对象。
由于没有 BOM 标准可以遵循，因此每个浏览器都有自己的实现。虽然也存在一些事实标准，例如
要有 window 对象和 navigator 对象等，但每个浏览器都会为这两个对象乃至其他对象定义自己的属
性和方法。现在有了 HTML5，BOM 实现的细节有望朝着兼容性越来越高的方向发展

## 1.3 JavaScript 版本

(不太重要，先记下来，有需要再细读)


# 2. 在 HTML 中使用 JavaScript

本章内容
- 使用< script >元素
- 嵌入脚本与外部脚本
- 文档模式对 JavaScript 的影响
- 考虑禁用 JavaScript 的场景

## 2.1 < script >元素