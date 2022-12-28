---
title: React全家桶 前端开发与实例详解
categories:
- js
thumbnailImagePosition: bottom
coverImage: https://user-images.githubusercontent.com/46363359/209692120-121acd97-15cc-4d34-b007-a871f9ba79d7.jpg
metaAlignment: center
coverMeta: out
---

摘要：讲react非常详细的一本书

<!-- more -->
<!-- toc -->

# 1 第一个react web应用

## 1.1 构建productt hunt项目

整本书都是围绕着一个类product hunt网站的demo进行讲解

## 1.2 配置开发环境

### 1.2.1 代码编辑器

个人还是非常喜欢使用vscode作为代码编辑器来使用。相对neovim还是比较好上手，但是最后还是过渡到neovim编辑器上

### 1.2.2 nodejs和npm的安装

`npm -v`查看npm版本，在ubuntu上面装nodejs并适配hexo工具会要求装很高版本的nodejs这里就要换安装方式

### 1.2.3 安装git

安装简单，直接`sudo apt install git`,但是使用还不太清楚

### 1.2.4 浏览器

没什么好说的推荐使用chrome浏览器

## 1.3 针对windows用户的特殊说明

我用的ubuntu所以不涉及，直接跳过

## 1.4 javascript ES6/ES7 

不同浏览器具有不同的执行JavaScript代码的解释器JavaScript作为互联网的客户端脚本语言被广泛采用，从而形成了标准组织来管理它的规范。规范的名称就是ECMAScript或ES。ES6有时称为ES2015，2015即它最终完成的年份。相应地，ES7通常被称为ES2016。

## 1.5 开始

直接download源码，然后`cd`到对应目录下执行`npm install`安装相关依赖，`npm start` 启动服务器，http://localhost:3000来查看正在运行的应用程序

## 1.6 什么组件

构架react应用程序的的基础就是组件（一个class），可以将单独的react组件是为应用程序的一个UI组件，正如图中product hunt程序那样，包括了了一个父组件productList，和一个product子组件。

React组件可以清晰的映射到UI组件，而且是独立的，标记代码，试图逻辑以及组件的特定样式集中的在一个地方。
比如父组件productList组件对应着一个product集合，然后是product组件对应着每一个UI中展示的组件，样式代码是不互相干扰的

### 1.6.1 第一个组件

示例代码 voting_app/public/js/app-1.js

```js
class ProductList extends React.Component {
  render() {
    return (
      <div className='ui unstackable items'>
        Hello, friend! I am a basic React component.
      </div>
    );
  }
}

ReactDOM.render(
  <ProductList />,
  document.getElementById('content')
);
```

- ProductList组件继承了React.Component类的ES6库，index页面也引用了React框架库，ES6引入了`类`声明语法。ES6类是JavaScript基于原型的继承模型的语法糖
- 声明组件有两种方式
  - 第一种就是上面那种，像是java创建类一样，但是render方式是固定要实现的
  - 第二种就是使用create-response-class库中createReactClass()方法
    ```js
    import createReactClass from 'create-react-class';

    const HelloWorld = createReactClass({
        render() { return(<p>Hello, world!</p>) }
    })
    ```
    返回值的语法看起来和传统的JavaScript有些不像。该语法称为JavaScript扩展语法JSX,JSX代码最后会编译成vanilla JavaScript（原生JavaScript）

### 1.6.2 JSX
**React组件最终渲染为浏览器中显示的HTML**,这个是我一开始使用没想明白的，其实React在做的根本的动作就是将所有东西都组装成HTML展示出来，这里面就涉及虚拟DOM对象，建JSX的目的是使表示HTML的JavaScript看起来更像HTML
常规js代码渲染
```js
React.createElement('div', {className: 'ui items'},
'
Hello, friend! I am a basic React component.'
)
```
JSX代码渲染
```js
<div className='ui items'>
Hello, friend! I am a basic React component.
</div>
```
后者的代码看起来更加的舒服，JSX在JavaScript版本上提供了轻量级抽象，虽然上面的JSX代码看起来与HTML几乎相同，但要记住JSX实际上是编译成了JavaScript

### 1.6.3 开发者控制台

可以与application进行交互

### 1.6.4 Babel

Babel是一个JavaScript转译器,可以将ES6代码转译为ES5代码，它的另一个使用功能就是理解JSX语法.
在index页面我们带入babel
```js
<head>
<!-- ... -->
<script src="vendor/babel-standalone.js"></script>
<!-- ... -->
</head>
```
然后我们再告诉js运行时，代码需要由babel编译，通过设置如下选项
```js
<script src="./js/seed.js"></script>
<script
  type="text/babel"
  data-plugins="transform-class-properties"
  src="./js/app.js">
</script>

```
index页面导入了相关的js代码和react代码，所以就在调用react相关的功能

### 1.6.5 ReactDOM.render()方法
voting_app/public/js/app-1.js 。 我们要再特定的DOM节点渲染这个ProductList组件
```js
class ProductList extends React.Component {

render() {
return (
    <div className='ui unstackable items'>
    Hello, friend! I am a basic React component.
    </div>
      );
    }
}

ReactDOM.render(
<ProductList />,
document.getElementById('content')
);
```
这个ReactDOM.render继承自React库，其中有两个参数，一个是what，也就是你要渲染渲染哪个组件，第二个参数是where，也就是在哪个DOM节点进行渲染
一般情况下我们自己编写的组件使用ProductList这样的名字，原生的HTML使用小写的。

现在刷新页面我们发现整个流程是babel将JSX代码转译为ES5然后ReactDOM.render()将组件写入DOM


## 1.7 构建Product组件

代码样例是voting_app/public/js/app-2.js,

```js

class ProductList extends React.Component {
  render() {
    return (
      <div className='ui unstackable items'>
        <Product />
      </div>
    );
  }
}

class Product extends React.Component {
  render() {
    return (
      <div className='item'>
        <div className='image'>
          <img src='images/products/image-aqua.png' />
        </div>
        <div className='middle aligned content'>
          <div className='description'>
            <a>Fort Knight</a>
            <p>Authentic renaissance actors, delivered in just two weeks.</p>
          </div>
          <div className='extra'>
            <span>Submitted by:</span>
            <img
              className='ui avatar image'
              src='images/avatars/daniel.jpg'
            />
          </div>
        </div>
      </div>
    );
  }
}

ReactDOM.render(
  <ProductList />,
  document.getElementById('content')
);

```
这里可以看到Product组件引用了外部的css样式，jsx代码会被转译为常规的js代码，所以我们不能在jsx中使用js保留字`class`是保留字，但是react让我们使用className作为属性名称
如示例代码所示，jsx不是最终渲染到HTML的代码，要使用Product组件，我们要修改ProductList父组件的render()方法输出，换个思路想其实就是在父组件的render方法中渲染子组件的jsx代码，然后子组件在调用自己render()方法进行渲染

## 1.8 让数据驱动Product组件

### 1.8.1 数据模型

这节也就是使用如何在使用seed.js这个预定义的数组数据，并定义了generateVoteCount()函数来模拟票数

```js

window.Seed = (function () {
  function generateVoteCount() {
    return Math.floor((Math.random() * 50) + 15);
  }

  const products = [
    {
      id: 1,
      title: 'Yellow Pail',
      description: 'On-demand sand castle construction expertise.',
      url: '#',
      votes: generateVoteCount(),
      submitterAvatarUrl: 'images/avatars/daniel.jpg',
      productImageUrl: 'images/products/image-aqua.png',
    },
    {
      id: 2,
      title: 'Supermajority: The Fantasy Congress League',
      description: 'Earn points when your favorite politicians pass legislation.',
      url: '#',
      votes: generateVoteCount(),
      submitterAvatarUrl: 'images/avatars/kristy.png',
      productImageUrl: 'images/products/image-rose.png',
    },
    {
      id: 3,
      title: 'Tinfoild: Tailored tinfoil hats',
      description: 'We already have your measurements and shipping address.',
      url: '#',
      votes: generateVoteCount(),
      submitterAvatarUrl: 'images/avatars/veronika.jpg',
      productImageUrl: 'images/products/image-steel.png',
    },
    {
      id: 4,
      title: 'Haught or Naught',
      description: 'High-minded or absent-minded? You decide.',
      url: '#',
      votes: generateVoteCount(),
      submitterAvatarUrl: 'images/avatars/molly.png',
      productImageUrl: 'images/products/image-yellow.png',
    },
  ];

  return { products: products };
}());

```

### 1.8.2 使用props

我们可以使用props属性在父组件和子组件中进行传递数据，这里就需要使用props属性
示例代码voting_app/public/js/app-3.js
```js

class ProductList extends React.Component {
  render() {
    const product = Seed.products[0];
    return (
      <div className='ui unstackable items'>
        <Product
          id={product.id}
          title={product.title}
          description={product.description}
          url={product.url}
          votes={product.votes}
          submitterAvatarUrl={product.submitterAvatarUrl}
          productImageUrl={product.productImageUrl}
        />
      </div>
    );
  }
}

class Product extends React.Component {
  render() {
    return (
      <div className='item'>
        <div className='image'>
          <img src={this.props.productImageUrl} />
        </div>
        <div className='middle aligned content'>
          <div className='header'>
            <a>
              <i className='large caret up icon' />
            </a>
            {this.props.votes}
          </div>
          <div className='description'>
            <a href={this.props.url}>
              {this.props.title}
            </a>
            <p>
              {this.props.description}
            </p>
          </div>
          <div className='extra'>
            <span>Submitted by:</span>
            <img
              className='ui avatar image'
              src={this.props.submitterAvatarUrl}
            />
          </div>
        </div>
      </div>
    );
  }
}

ReactDOM.render(
  <ProductList />,
  document.getElementById('content')
);


```