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

## 2.1 `<script>`元素

|属性  | 值 |   描述|
|---|----|---|
|async|	async	|规定异步执行脚本（仅适用于外部脚本）。|
|charset|	charset	|规定在外部脚本文件中使用的字符编码。|
|crossorigin	| anonymous/use-credentials 将请求模式设置为 |HTTP CORS 请求。|
|defer|	defer	|规定是否对脚本执行进行延迟，直到页面加载为止。|
|language	|script|	不赞成使用。规定脚本语言。请使用 type 属性代替它。|
|referrepolicy|	 no-referrer/no-referrer-when-downgrade/origin/origin-when-cross-origin/same-origin/strict-origin/strict-origin-when-cross-origin/unsafe-url | 规定外部脚本文件的 URL。|
|src|	URL	| 规定外部脚本文件的 URL。|
|xml:space|	preserve|	规定是否保留代码中的空白。|
|type|	MIME-type application/javascript 如果这个值是module，则代码会被当成ES6模块，而且只有这时候代码中才能出现import和export关键字	| 指示脚本的 MIME 类型。|

1. `<script src="example.js"></script>`加载这段代码也会阻塞,HTML5规范要求脚本应 该按照它们出现的顺序执行，因此第一个推迟的脚本会在第二个推迟的
脚本之前执行，而且两者都会在DOMContentLoaded事件之前执行
2. `<script src="http://www.somewhere.com/afile.js"></script>`  这样会发http请求将url中的资源，也会阻塞余下脚本的加载，并且浏览器会按照顺序加载
3. `<script>`标签的integrity属性可以禁止加载不信任域的js代码
4. 把所有`<script>`放在head中执行会印象页面的加载速度。可以选择放在body中延迟加载
5. `defer`属性只在加载外部脚本时候才有效，类似于golang中defer关键字
6. 动态加载脚本
   ```js
   let script = document.createElement('script'); 
   script.src = 'gibberish.js'; 
   script.async = false;
   document.head.appendChild(script);
   ```
   上面这种方式对预加载器是不可见的，会影响性能，需要我们使用`<link rel="preload" href="gibberish.js">`
7. XHMTL使用JavaScript必须指定type属性且值为text/javascript。通过添加`CDATA`可以让我们在区块中使用任何字符
   ```js
   <script type="text/javascript">
   <![CDATA[ 
      function compare(a, b) { 
      if (a < b) { 
         console.log("A is less than B");
      } else if (a > b) { 
         console.log("A is greater than B");
      } else { 
         console.log("A is equal to B");
      }
   }
   ]]></script>
   ```
   非XHTML兼容浏览器中则不行。为此，CDATA标记必须使用JavaScript注释来抵消
8. 在项目中组织js代码
   - 可维护性，就是单独放在某一文件夹中
   - 缓存，如果文件使用两份代码就会只下载一份
      1. 使用CDN（内容分发网络）：将js库上传至CDN，多个页面引用同一CDN链接，这样即使不同页面在不同时间加载，也可以从同一CDN链接中获取js库，避免重复下载。
      2. 版本号控制：每次js库更新时，修改版本号并将版本号与js库文件名关联，当页面需要引用该js库时，引用该版本号对应的js库文件，这样可以保证页面使用的是最新的js库版本，同时避免重复下载。
      3. 使用localStorage或sessionStorage：将js库存储在localStorage或sessionStorage中，当页面需要引用js库时，检查是否已经在缓存中存在，如果存在，则使用缓存中的js库，否则下载js库并存储在缓存中，下次页面再次需要引用时直接从缓存中获取。这种方式适用于js库文件较小的情况。
   - 适应未来。通过把JavaScript放到外部文件中，就不必考虑用 XHTML或前面提到的注释黑科技。包含外部JavaScript文件的语法
在HTML和XHTML中是一样的。

## 2.2 文档模式

## 2.3 `<noscript>`元素
浏览器不支持脚本； 浏览器对脚本的支持被关闭。任何一个条件被满足，包含在`<noscript>`中的内容就会被渲染。否则，浏览器不会渲染`<noscript>`中的内容


# 3.语言基础

1. 严格区分大小写
2. 标识符第一个必须是字母，下划线，或者美元符号
3. ECMAScript标识符使用驼峰命名，跟golang和java一样
4. 注释`//`和`/* */`
5. 严格模式`use strict`也可以单独一个函数使用严格模式
6. 保留的关键字
   ```js
   break case
   catch class const
   continue debugger
   default delete
   do else
   export extends
   finally for
   function if
   import in
   instanceof new
   return super
   switch this
   throw
   try
   typeof var
   void
   while with
   yield
   ```
## 3.1定义变量
1. var关键字
   ```js
   var message; // 创建一个对象
   var message = "hi";
   message=100 // 在js中合法但是不推荐
   //也支持连续定义
   var message = "hi", 
       found = false,
       age = 29;
   ```
   在函数内部定义`var message=100`就是在遵守常规golang，java等变量作用域，不推荐通过省略var来提高变量的作用域

2. var关键字的提升
   ```js
   function foo() { 
      console.log(age); 
      var age = 26;
   }
   foo(); // undefined
   ```
   等价于
   ```js
   function foo() { 
      var age;
      console.log(age); 
      age = 26;
   }
   foo(); // undefined

   ```
3. let声明
   let声明的范围是块作用域，而var声明的范围是函数作用域(这个就像是上面的定义一样)。let的表现更像是其他强类型语言的变量关键字
   - let没有作用域提升，也就是不满足2中的特性
   - 与var关键字不同，使用let在全局作用域中声明的变量不会成 为window对象的属性（var声明的变量则会）。
      ```js
      var name = 'Matt'; console.log(window.name); // 'Matt'
      let age = 26;
      console.log(window.age); // undefined
      ```
   - 在不同`<script>`的块中var可以重复声明，而let不能重复声明，或者可以通过代码try/catch来定义
      ```js
      if (typeof name === 'undefined') { let name;
      }
      ```
4. const声明
   const的行为与let基本相同，唯一一个重要的区别是用它声明变量时 必须同时初始化变量，且尝试修改const声明的变量会导致运行时错误。const声明的限制只适用于它指向的变量的引用。换句话说，如果 const变量引用的是一个对象，那么修改这个对象内部的属性并不违反const的限制
   ```js
   let i = 0; for (const j = 7; i < 5; ++i) { 
      console.log(j);
   } // 7, 7, 7, 7, 7
   for (const key in {a: 1, b: 2}) { 
      console.log(key);
   } // a, b
   for (const value of [1,2,3,4,5]) { 
      console.log(value);
   } // 1, 2, 3, 4, 5
   ```
## 3.2数据类型

1. "undefined"表示值未定义； 
Undefined类型只有一个值，就是特殊值undefined。当使用var或let声明了变量但没有初始化时，就相当于给变量赋予了undefined值,包含undefined值的变量跟未定义变量是有区别的,对未声明的变量，只能执行一个有用的操作， 就是对它调用typeof返回的结果是"undefined"
2. "object"表示值为对象（而不是函数）或null；
创建一个对象时候建议用null来初始化，这样就可以通过检查是不是null来检查引用关系
```js
let message = null; 
let age;
if (message) { // 这个块不会执行
}
if (!message) { // 这个块会执行
}
if (age) { // 这个块不会执行
}
if (!age) { // 这个块会执行
}
```
3. "boolean"表示值为布尔值； 
   - true不等于 1，false不等于0
   - 将一个其他类型的值转换为布尔值，可以调用特定的 Boolean()转型函数：
      ```js
      let message = "Hello world!"; 
      let messageAsBoolean = Boolean(message);
      ```
      |数据类型|转化为true的值|转换为false的值|
      |---|---|---|
      |boolean|true|false|
      |string|非空字符串|""字符串|
      |number|非零数值|0,NaN|
4. "number"表示值为数值；
   NaN意思是“不是数值”用于表示本来要返回数值的操作失败了用0除任意数值在其他语言中通常都会导致错误，从而中止代 码执行。但在ECMAScript中，0、+0或-0相除会返回NaN：
   ```js
   console.log(0/0); // NaN
   console.log(-0/+0); // NaN
   ```
   NaN有几个独特的属性。首先，任何涉及NaN的操作始终返回 NaN（如NaN/10），在连续多步计算时这可能是个问题。其 次，NaN不等于包括NaN在内的任何值。例如，下面的比较操作会返回false：为此，ECMAScript提供了isNaN()函数
   ```js
   nsole.log(isNaN(NaN)); // true
   console.log(isNaN(10)); // false，10是数值
   ```
   把一个值 传给isNaN()后，该函数会尝试把它转换为数值。某些非数值的值 可以直接转换成数值，如字符串"10"或布尔值。任何不能转换为数值的值都会导致这个函数返回true
 
   3个函数可以将非数值转换为数值：Number()、parseInt()和 parseFloat()。Number()是转型函数，可用于任何数据类型。后两个函数主要用于将字符串转换为数值
   Number()函数基于如下规则执行转换。
      1. 布尔值，true转换为1，false转换为0。
      2. 数值，直接返回。
      3. null，返回0
      4. undefined，返回NaN
      5. 如果字符串包含数值字符，包括数值字符前面带加、减号的情况，则转换为一个十进制数值。因此，Number("1") 返回1，Number("123")返回123，Number("011")返回11（忽略前面的零）。
      6. 如果字符串包含有效的浮点值格式如"1.1"，则会转换为相应的浮点值（同样，忽略前面的零）
      7. 如果字符串包含有效的十六进制格式如"0xf"，则会转换为与该十六进制值对应的十进制整数值。
      8. 如果是空字符串（不包含字符），则返回0。
      9. 对象，调用valueOf()方法，并按照上述规则转换返回的值。 如果转换结果是NaN，则调用toString()方法，再按照转换字符串的规则转换。
      10. paseInt()函数和pasefloat()函数
5. "string"表示值为字符串；
```js
let firstName = "John"; 
let lastName = 'Jacob';
let lastName = `Jingleheimerschmidt`
```
非打印字符或有其 他用途的字符`let text = "This is the letter sigma: \u03a3.";`6个字符长的转义序列，变量text仍然是 28个字符长。因为转义序列表示一个字符，所以只算一个字符。

- 字符串的特点
   ```js
   let lang = "Java"; lang = lang + "Script";
   ```
- 转换为字符
   ```js
   let age = 11; let ageAsString = age.toString();
   // 字符串"11"
   let found = true;
   let foundAsString = found.toString(); // 字符串"true"
   ```
- String()函数
   ```js
   let value1 = 10; 
   let value2 = true; 
   let value3 = null; 
   let value4;
   console.log(String(value1)); // "10" 
   console.log(String(value2)); // "true" 
   console.log(String(value3)); // "null"
   console.log(String(value4)); // "undefined"
   ```
- 模板字面量：ECMAScript 6新增了使用模板字面量定义字符串的能力。与使用单引号或双引号不同，模板字面量保留换行字符，可以跨行定义字符串：
   ```js
   let myMultiLineString = 'first line\nsecond line'; 
   let myMultiLineTemplateLiteral = `first line second line`;
   console.log(myMultiLineString); // first line // second line"
   console.log(myMultiLineTemplateLiteral); // first line // second line
   console.log(myMultiLineString === myMultiLinetemplateLiteral); // true
   // 这个模板字面量在换行符之后有25个空格符 
   let myTemplateLiteral = `first line
                           second line`;
   // 这个模板字面量以一个换行符开头 
   let secondTemplateLiteral = ` 
   first line
   second line`;
   ```
- 字符串插值: 
   ```js
   let value = 5; 
   let exponent = 'second';
   let interpolatedTemplateLiteral = `${ value } to the ${ exponent } power is ${ value * value }`;
   //将表达式转换为字符串时会调用toString()：
   let foo = { toString: () => 'World' }; 
   console.log(`Hello, ${ foo }!`);
   // Hello, World!
   //在插值表达式中可以调用函数和方法：
   function capitalize(word) { 
      return `${ word[0].toUpperCase() }${ word.slice(1) }`;
   }
   console.log(`${ capitalize('hello') }, ${ capitalize('world') }!`); //

   ```
- 模板字面量标签函数
   ```js
   let a = 6; let b = 9;
   function simpleTag(strings, ...expressions) { 
      console.log(strings); 
      for(const expression of expressions) { 
         console.log(expression);
      } 
      return 'foobar';
   } 
   let taggedResult = simpleTag`${ a } + ${ b } = ${ a + b }`; 
   // ["", " + ", " = ", ""] 
   // 6 
   // 9 
   // 15
   console.log(taggedResult); 
   // "foobar"
   ```
   对于有 个插值的模板字面量，传给标签函数的表达式参数的个数 始终是 ，而传给标签函数的第一个参数所包含的字符串个数则始 终是 。因此，如果你想把这些字符串和对表达式求值的结果拼接起来作为默认返回的字符串，可以这样做：
   ```js
   let a = 6; 
   let b = 9;
   function zipTag(strings, ...expressions) { 
      return strings[0] + expressions.map((e, i) => `${e}${strings[i + 1]}`) .join('');
   } 
   let untaggedResult =`${ a } + ${ b } = ${ a + b }`; 
   let taggedResult = zipTag`${ a } + ${ b } = ${ a + b }`;
   console.log(untaggedResult); 
   // "6 + 9 = 15" 
   console.log(taggedResult);
   // "6 + 9 = 15"
   ```
- 原始字符串:
  使用模板字面量也可以直接获取原始的模板字面量内容（如换行符 或Unicode字符），而不是被转换后的字符表示。为此，可以使用String.raw标签函数：
  ```js
   console.log(String.raw`first line\nsecond line`); // "first line\nsecond line
  ```
  或者是通过使用标签函数的第一个参数
  ```js
   function printRaw(strings) { 
      console.log('Actual characters:'); 
      for (const string of strings) { 
         console.log(string);
   }
   console.log('Escaped characters;'); 
      for (const rawString of strings.raw) { 
         console.log(rawString);
   }
   }
  ```

- function表示值为函数；
- symbol表示值为符号

## 3.3 操作符

- 一元操作符
  - 递进操作符 ++age,--age,age++,age--跟其他静态语言特性一样和一些规则
  - 一元加减操作符
   
      把负号放在数字前面就变成响应的负值，放在非数值前面就会进行转换然后取负值
      ```js
      let s1 = "01"; 
      let s2 = "1.1"; 
      let s3 = "z"; 
      let b = false; 
      let f = 1.1; 
      let o = { 
         valueOf() { 
            return -1;
         } 
      };
      s1 = +s1; // 值变成数值1 
      s2 = +s2; // 值变成数值1.1 
      s3 = +s3; // 值变成NaN ，根本原因是不能转换为shuzhi
      b = +b;   // 值变成数值0
      f = +f;   // 不变，还是1.1
      o = +o;   // 值变成数值-1
      ```

- 位操作符顾好
  
  如单字节的5的原码为：0000 0101；-5的原码为1000 0101。
  反码：正数的反码就是其原码；负数的反码是将原码中，除符号位以外，每一位取反。如单字节的5的反码为：0000 0101；-5的反码为1111 1010。
  补码：正数的补码就是其原码；负数的`反码`+1就是补码。如单字节的5的补码为：0000 0101；-5的补码为1111 1011。
  - 按位非：就是取这个数的补数

      ```js
         let num1 = 25; // 二进制00000000000000000000000000011001
         let num2 = ~num1; // 二进制11111111111111111111111111100110 
         console.log(num2); // -26
      ```
  - 按位与

      按位与操作符用和号（&）表示，有两个操作数。本质上，按位与 就是将两个数的每一个位对齐，然后基于真值表中的规则，对每一位执行相应的与操作。如何快速计算
      |第一位置数值的位|第二位数值的位|结果|
      |---|---|---|
      |1|1|1|
      |1|0|0|
      |0|1|0|
      |0|0|0|
  - 按位或

      按位或操作符用管道符（|）表示，同样有两个操作数。按位或操作在至少一位是1时返回1，两位都是0时返回0，按位或遵循如下真值表：
      |第一位置数值的位|第二位数值的位|结果|
      |---|---|---|
      |1|1|1|
      |1|0|1|
      |0|1|1|
      |0|0|0|
  - 按位异或

      按位异或与按位或的区别是，它只在一位上是1的时候返回1（两位 都是1或0，则返回0。
  - 左移

      ```js
      let oldValue = 2; // 等于二进制10
      let newValue = oldValue << 5; // 等于二进制1000000，即十进制64
      ```
      注意在移位后，数值右端会空出5位。左移会以0填充这些空位，左移会保留它所操作数值的符号。比如，如果-2左移5位， 将得到-64，而不是正64
  - 有符号右移

      有符号右移由两个大于号（>>）表示，会将数值的所有32位都向右 移，同时保留符号（正或负）。有符号右移实际上是左移的逆运算。比如，如果将64右移5位，那就是2同样，移位后就会出现空位。不过，右移后空位会出现在左侧，且 在符号位之后（见图3-3）。ECMAScript会用符号位的值来填充这些空位，以得到完整的数值
  - 无符号右移

      如果是正数与上面有符号右移一样，这里面的无符号意思是指把最高位的符号位当成数值位对待也进行右移
- 布尔操作符
      <samp>
      如果操作数是对象，则返回false。 
      如果操作数是空字符串，则返回true。 
      如果操作数是非空字符串，则返回false。 
      如果操作数是数值0，则返回true。 
      如果操作数是非0数值（包括Infinity），则返回false。 
      如果操作数是null，则返回true。 
      如果操作数是NaN，则返回true。
      如果操作数是undefined，则返回true。
      </samp>
- 乘/除/加/减法/指数操作符
  `console.log(3**2)`和`Math.pow()`
  - 乘法
      ```
      如果操作数都是数值，则执行常规的乘法运算，即两个正值相 乘是正值，两个负值相乘也是正值，正负符号不同的值相乘得 到负值。
      如果ECMAScript不能表示乘积，则返回Infinity 或-Infinity。
      如果有任一操作数是NaN，则返回NaN。 
      如果是Infinity乘以0，则返回NaN。 
      如果是Infinity乘以非0的有限数值，则根据第二个操作数的符号返回Infinity或-Infinity。 
      如果是Infinity乘以Infinity，则返回Infinity。 
      如果有不是数值的操作数，则先在后台用Number()将其转换为数值，然后再应用上述规则。
      ```
  - 除法
      ```
      如果操作数都是数值，则执行常规的除法运算，即两个正值相 除是正值，两个负值相除也是正值，符号不同的值相除得到负 值。
      如果ECMAScript不能表示商，则返回Infinity或Infinity。
      如果有任一操作数是NaN，则返回NaN。
      如果是Infinity除以Infinity，则返回NaN。 
      如果是0除以0，则返回NaN。 
      如果是非0的有限值除以0，则根据第一个操作数的符号返回 Infinity或-Infinity。
      如果是Infinity除以任何数值，则根据第二个操作数的符号 返回Infinity或-Infinity。 
      如果有不是数值的操作数，则先在后台用Number()函数将其转换为数值，然后再应用上述规则。
      ```
  - 取模
      ```
      如果操作数是数值，则执行常规除法运算，返回余数。 
      如果被除数是无限值，除数是有限值，则返回NaN。 
      如果被除数是有限值，除数是0，则返回NaN。 
      如果是Infinity除以Infinity，则返回NaN。 
      如果被除数是有限值，除数是无限值，则返回被除数。 
      如果被除数是0，除数不是0，则返回0。 
      如果有不是数值的操作数，则先在后台用Number()函数将其转换为数值，然后再应用上述规则。
      ```
   - 加法
   - 减法
- 全等与不全等
  ```js
   let result1 = ("55" == 55); // true，转换后相等 
   let result2 = ("55" === 55); // false，不相等，因为数据类型不同
   let result1 = ("55" != 55); // false，转换后相等 
   let result2 = ("55" !== 55); // true，不相等，因为数据类型不同
  ```
- 条件操作符  
  `variable = boolean_expression ? true_value : false_value;`
- 逗号操作符  
  ```js
  let num1 = 1, num2 = 2, num3 = 3;
  let num = (5, 1, 4, 8, 0); // num的值为0
  ```

## 3.4 语句

- if 语句
- do-while
- while
- for
- for in
```js
for (const propName in window) {
    document.write(propName);
}
```
这个例子使用for-in循环显示了BOM对象window的所有属性,这里控制语句中的const也不是必需的。但为了确保这个局部变量不被修改，推荐使用const。

- for of

for-in和for-of的区别

for-in语句和for-of语句是 JavaScript 中的两种循环语句，用于遍历对象和数组等集合类型。

区别如下：

for-in循环语句遍历的是对象的可枚举属性，而for-of循环语句遍历的是集合对象的可迭代元素，例如数组中的元素。

for-in循环语句不仅可以遍历对象自身的属性，也可以遍历继承自原型链上的属性，而for-of循环语句只能遍历集合对象自身的元素。

for-in循环语句的遍历顺序是不确定的，而for-of循环语句的遍历顺序是按照元素在集合对象中的顺序进行遍历。

for-in循环语句遍历的是对象的键名，而for-of循环语句遍历的是对象的键值。

例如，下面的示例代码演示了如何使用for-in循环语句和for-of循环语句遍历数组中的元素：
```js
const arr = ['apple', 'banana', 'orange'];

// 使用 for-in 循环遍历数组
for (const index in arr) {
  console.log(index); // 0, 1, 2
}

// 使用 for-of 循环遍历数组
for (const value of arr) {
  console.log(value); // 'apple', 'banana', 'orange'
}
```
- 标签语句
- break 和 continue语句
- with语句
with语句的用途是将代码作用域设置为特定的对象，
```js
let qs = location.search.substring(1); 
let hostName = location.hostname;
let url = location.href;
```
就可以改为
```js
with(location) { 
   let qs = search.substring(1); 
   let hostName = hostname; 
   let url = href;
}
```
严格模式不允许使用with语句，否则会抛出错误。with语句影响性能且难于调试其中的代码，通常不推 荐在产品代码中使用with语句
- switch语句
- 函数

# 4.变量，作用域与内存

## 4.1 原始值与引用值

原始数据类型就是js自定义的数据那6种类型，JavaScript不允许直接 访问内存位置，因此也就不能直接操作对象所在的内存空间。在操作对 象时，实际上操作的是对该对象的引用（reference）而非实际的对象本身

## 4.1.1 动态类型

引用值：可以随时添加、修改和删除其属性和方法，原始值不能添加属性，尽管尝试给属性值添加属性不会报错会出现undefined的情况
原始数据类型： 可以直接用字面量创建变量（对象），也可以使用`new`关键字初始化
```js
let name1 = "Nicholas"; 
let name2 = new String("Matt"); 
name1.age = 27;
name2.age = 26;
console.log(name1.age); // undefined 
console.log(name2.age); // 26
console.log(typeof name1); // string
console.log(typeof name2); // object
```

### 4.1.2 复制
原始值的复制是值的复制在内存中生成两个独立对象，而引用类型的复制是地址

### 4.1.3 传递参数

```js
function setName(obj) { 
   obj.name = "Nicholas"; 
   obj = new Object(); 
   obj.name = "Greg";
   console.log(obj.name)
}
let person = new Object(); 
setName(person);
console.log(person.name); // "Nicholas"
```
这表明函数中参数的值改变之后，原始的引用仍然没变。当obj在函数内部被重写时， 它变成了一个指向本地对象的指针。而那个本地对象在函数执行结束时就被销毁了。那么这时指针是不是指向了已经不存在的对象？

### 4.1.4 确定类型
typeof关键字可以用来判断原始数据类型，但是用来判断null或者对象就会返回object
```js
let s = "Nicholas"; 
let b = true; 
let i = 22; 
let u; 
let n = null;
let o = new Object(); 
console.log(typeof s); // string 
console.log(typeof i); // number 
console.log(typeof b); // boolean 
console.log(typeof u); // undefined 
console.log(typeof n); // object
console.log(typeof o); // object
```
可以使用instanceof关键字判断对象，在这里重申一件事情所有的对象都是object.所以所有的对于object的判断都是true,instanceof检测原始值，则始终会返回false
```js
console.log(person instanceof Object); // 变量person是Object吗？
console.log(colors instanceof Array); // 变量colors是Array吗？ 
console.log(pattern instanceof RegExp); // 变量pattern是RegExp吗？
```

## 4.2