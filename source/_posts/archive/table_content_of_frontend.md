---
title: knowledge tree of front end
categories:
- archive
thumbnailImagePosition: bottom
coverImage: https://user-images.githubusercontent.com/46363359/209688317-8fa54e46-c9c7-444c-bc73-c8ce8d4d5d19.jpg
metaAlignment: center
coverMeta: out
date: 2022-12-23
---

先存着留着日后慢慢学习

<!-- more -->

## 1、HTML/HTML5基础：
1.0、语义化H5标签
1.1、H5引进了一些新的标签，特别注意article、header、footer、aside、nav等，注意HTML的标题结构
1.2、理解浏览器解析HTML的过程，理解DOM的树形结构，及相应API
1.3、理解HTML标签在各个浏览器上的默认样式（代理样式），理解CSS中的重置样式表的概念
1.4、理解Canvas、SVG、video等功能性标签
1.5、理解form、iframe标签，理解文件提交过程
推荐书籍：
A、《HTML5秘籍》

## 2、高健壮性CSS
2.1、学习基础知识，包括大部分常用属性、选择器的用法，要对大多数标签有个基础概念,在日常使用的基础上，尝试学习浏览器兼容性问题，要知道兼容性的主要问题及解决方法
2.2、深入理解盒子模型，区分块级元素、行内元素，有几个比较重要的属性：display、float、position，一定要弄清楚区分盒子、行内盒子的概念另外可以考虑学一些预编译语言：sass、less，都很简单
2.3、学习常用框架，可以使用bootstrap构建项目
2.4、学习框架的代码组织方式包括：12格栅系统、组件化、组件的风格化等
2.5、学习CSS 3的新功能，特别是动画效果、选择器
2.6、认真学习一些CSS对象化思想，学习编写简洁性、高复用性、高健壮性的CSS
2.7、有空的话，可以看看所谓的扁平化设计，还有简洁性
2.8、理解CSSOM、render、reflow、CSS性能、CSS阻塞概念
学习方法：
1、多看别人的代码，一些设计的不错的网站就是很好的学习素材，比如拉勾网
2、一定要学会使用grunt、gulp压缩CSS
3、display + position + float 可以组合出很复杂的效果，多想想盒子模型
4、尝试在不用float，且position不为absolute的情况下实现等高、等宽等布局
推荐书籍：
1、《图灵程序设计丛书:HTML5与CSS3设计模式》
2、《Web开发技术丛书:深入理解Bootstrap》
3、《高流量网站CSS开发技术》
4、《CSS设计彻底研究》 这个一定要
5、《Web开发技术丛书:深入理解Bootstrap》
6、可以找一些专门讲SASS的书，但是我没找到
7、《CSS权威指南(第3版)》

## 3、深入学习JS
3.1、重新学习JS语法，注意：表达式（特别是函数访问表达式）、语句、类型（包括类型判断)注意，这个时候主要倾向于“原生”JS哦，不要使用框架
3.2、深入理解JS的“一级函数”、对象、类的概念,学会使用函数来构造类、闭包，学会用面向对象的方式组织代码
3.3、深入理解JS的作用域、作用域链、this对象（在各种调用形式中，this的指向）理解函数的各种调用方法（call、apply、bind等）
3.4、理解对象、数组的概念
理解对象的“[]”调用，理解对象是一种“特殊数组”
理解for语句的用法
深入理解JS中原始值、包装对象的概念（重要）
3.5、学习一些常用框架的使用方法，包括：JQUERY、underscore、EXTJS，加分点有：backbone、angularjs、ejs、jade
通过比较多个框架的使用方法，想清楚“JS语言极其灵活”这一事实
总结常见用法，提高学习速度
学习模块化开发（使用require.js、sea.js等）
3.6、适当看一些著名框架的源码，比如jQuery（不建议看angularjs，太复杂了）
重要的是学习框架中代码的组织形式，即设计模式
3.7、了解JS解释、运行过程，理解JS的单线程概念
深入理解JS事件、异步、阻塞概念
3.8、理解浏览器组成部件，理解V8的概念
学习V8的解释-运行过程
在V8基础上，学会如何提高JS性能
学会使用chrome的profile进行内存泄露分析
学习方法：
1、提高对自己的要求，要有代码洁癖
2、适当的时候看看优秀框架的源码，特别是框架的架构模式、设计模式
3、多学学设计模式
4、学习原生JS、DOM、BOM、Ajax
推荐书籍：
1、《O’Reilly精品图书系列:​JavaScript权威指南(​第6版)》 必看
2、《JavaScript设计模式》
3、《WebKit技术内幕》
4、《JavaScript框架高级编​程:应用Prototype YUI Ext JS Dojo MooTools》
5、《用AngularJS开发下一代Web应用》
6、跨终端
6.1、理解混合APP的概念
6.2、理解网页在各类终端上的表现
6.3、理解网页与原生app的区同，重在约束
6.4、理解单页网站，特别要规避页面的内存泄露问题
6.5、入门nodejs，对其有个基础概念，知道它能做什么，缺点是什么
推荐书籍：
1、《单页Web应用:JavaScript从前端到后端 》
2、《Web 2.0界面设计模式》
3、《响应式Web设计:HTML5和​CSS3实战》
5、工具
学会使用grunt进行JS、CSS、HTML 压缩，特别是模块化js开发时候的压缩
会用PS进行切图、保存icon
入手sublime、webstorm
学会使用chrome调试面板，特别是：console、network、profile、element

进阶：

## 4、性能
1.1、理解资源加载的过程
包括：TCP握手连接、HTTP请求报文、HTTP回复报文
1.2、理解资源加载的性能约束，包括：TCP连接限制、TCP慢启动
1.3、理解CSS文件、JS文件压缩，理解不同文件放在页面不同位置后对性能的影响
1.4、理解CDN加速
1.5、学会使用HTTP头控制资源缓存，理解cache-control、expire、max-age、ETag对缓存的影响
1.6、深入理解浏览器的render过程
推荐书籍：
1、《Web性能权威指南》
2、雅虎网站页面性能优化的34条黄金守则

5、HTTP及TCP协议族
2.1、学习http协议，理解http请求-响应模式
2.2、理解http是应用层协议，它是构建在TCP/IP协议上的
2.3、理解http报文（请求-响应报文）
2.4、理解http代理、缓存、网关等概念，指定如何控制缓存
2.5、理解http协议内容，包括：状态码、http头、长连接（http1.1）
2.6、学习http服务器的工作模型，对静态文件、CGI、DHTML的处理流程有个大致概念
推荐书籍：
1、《HTTP权威指南》
2、《TCP/IP详解》
3、《图解TCP/IP(第5版)》