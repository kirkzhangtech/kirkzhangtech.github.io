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

## 1.1 构建product hunt项目

整本书都是围绕着一个类product hunt网站的demo进行讲解

如何初始化一个react项目
1. create-react-app 是一个依赖6.14.11版本npm的脚手架react项目
2. `npx create-react-app react-demo` 创建项目，或者`npm install -g create-react-app` 全局安装create-react-app项目(但是不建议全局安装)
   1. `create-react-app -V` 查看版本
3. `yarn start` 启动服务
   1. 安装yarn on ubuntu
   2. `curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -`然后`echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list`
   3. `sudo apt update && sudo apt install yarn`
   4. `yarn --version`
4. yarn基本使用
   1. 初始化项目`yarn init`
   2. 添加依赖包`yarn add {package}`和`yarn add {package}@{version}`
   3. 添加依赖到不同的依赖项中`yarn add {package} --dev`和`yarn add [package] --peer`和`yarn add [package] --optional`
   4. 升级依赖包`yarn upgrade [package]`和`yarn upgrade [package]@[version]`和`yarn upgrade [package]@[tag]`
   5. 移除依赖包`yarn remove [package]`
   6. 安装全部依赖关系`yarn`或者`yarn install`

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
              src= {this.props.submitterAvatarUrl}
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

在JSX内部的任何地方插入一个变量，都需要用大括号（{}）来分隔变量,组件可以通过this.props对象访问所有的props. 这里注意到数组取了下标`Seed.products[0]`

### 1.8.3 渲染多个产品

Array对象的map()方法将函数作为参数。它使用数组内的每个子项,来调用此函数，并使用每个函数调用的返回值来构建一个新数组,因为Seed.products数组有四个子项，所以map()方法会调用此函数四次，每个子项一次。当map()方法调用此函数时，它将每个子项作为第一个参数传入。此函数调用的返回值将插入map()方法正在构建的新数组中。在处理完最后一个子项后，map()方法就会返回这个新数组。这里我们把这个新数组存储在productComponents变量中。
示例代码 voting_app/public/js/app-4.js
```js

class ProductList extends React.Component {
  render() {
    // 对product进行排序

    // const products = Seed.products.sort((a, b) => (
    //   b.votes - a.votes
    // ));
    //这里其实是新数组
    const productComponents = Seed.products.map((product) => (
      <Product
        key={'product-' + product.id}
        id={product.id}
        title={product.title}
        description={product.description}
        url={product.url}
        votes={product.votes}
        submitterAvatarUrl={product.submitterAvatarUrl}
        productImageUrl={product.productImageUrl}
      />
    ));
    return (
      <div className='ui unstackable items'>
        {productComponents}
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

## 1.9 应用程序的第一次交互：投票事件的响应

Product组件无法修改它的票数，因为this.props对象是不可变的。虽然子组件可以读取props但是无法修改它子组件不是props的所有者。
也就是说父组件是props的拥有者，而子组件不拥有props。

Product组件需要有一个方法让ProductList组件知道它的向上投票图标被点击，接着可以让ProductList组件更新子组件的对应的票数，然后更新的数据从父组件流向子组件


### 1.9.1 事件的传递

我们知道父组件通过props向子组件传递数据。因为**props是不可变的**，所以子组件需要某种方式来向父组件传递事件。然后父组件可以进行任何必要的数据更改。记住是父组件拥有props。那么这些是如何运转的呢？ProductList组件中的handleProductUpVote函数只接收一个名为productId的参数。该函数会将产品的id记录到控制台：
首先，html中记录鼠标的点击事件，并绑定到该组件的对应的函数上，然后函数在调用父组件的函数。
如代码voting_app/public/js/app-6.js所示
```js

class ProductList extends React.Component {
  // 定义了函数
  handleProductUpVote(productId) {
    console.log(productId + ' was upvoted.');
  }

  render() {
    const products = Seed.products.sort((a, b) => (
      b.votes - a.votes
    ));
    const productComponents = products.map((product) => (
      <Product
        key={'product-' + product.id}
        id={product.id}
        title={product.title}
        description={product.description}
        url={product.url}
        votes={product.votes}
        submitterAvatarUrl={product.submitterAvatarUrl}
        productImageUrl={product.productImageUrl}
        // 属性名是onVote,然后将定义的函数handleProductUpVote赋值给onVote
        onVote={this.handleProductUpVote}
      />
    ));
    return (
      <div className='ui unstackable items'>
        {productComponents}
      </div>
    );
  }
}

class Product extends React.Component {
  constructor(props) {
    super(props);

    this.handleUpVote = this.handleUpVote.bind(this);
  }

  // Inside `Product`
  handleUpVote() {
    //然后函数调用了父组件传递过来的函数，换句话说就是再次调用了父组件中方法
    this.props.onVote(this.props.id);
  }

  render() {
    return (
      <div className='item'>
        <div className='image'>
          <img src={this.props.productImageUrl} />
        </div>
        {/* Inside `render` for Product` */}
        <div className='middle aligned content'>
          <div className='header'>
            //onClick接收点击事件， 然后传递给该组件的handleUpVote函数。
            <a onClick={this.handleUpVote}>
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
这里是比较奇怪的部分：在render()函数中工作时，我们已目睹了this总是绑定到当前组件，但在自定义的组件方法handleUpVote()中，this的值实际上是null。

### 1.9.2 绑定自定义组件方法

原来自定义组件中的自定义方法的this指针不指向当前组件，见鬼！简而言之就是React的方法都已经绑定了this
对于自定义组件的自定义方法，需要用些手段进行绑定。

```js

class Product extends React.Component {
  
  constructor(props) {
  super(props);
  this.handleUpVote = this.handleUpVote.bind(this);
}

```
那么上面代码是如何运行的，首先先到用constructor(props)函数来进行初始化，然受super(props)会调用父组件的constructor()函数
`this.handleUpVote = this.handleUpVote.bind(this);`通过这行代码我们重新定义了组件的handleUpVote()方法，并将其赋值到相同的函数，但绑定到this变量（组件）下。现在，每当handleUpVote()函数执行时，this将引用当前组件而不是null。


### 1.9.3 使用state

props是不可变的并且由组件的父级所拥有，而state由组件拥有。this.state是组件私有的，我们将看到它可以使用this.setState()方法进行更改。
当组件的state更新时就是重新渲染页面，每个React组件都是作为一个由this.props和this.state组成的函数来渲染的。这种渲染是确定性的。这意味着若给定一组props和一组
state，React组件将始终以一种方式渲染。

ProductList组件将此状态的所有者，会将state作为props传递给Product组件

接下来的例子将会进行初始化state初始值，voting_app/public/js/app-7.js 
```js

class ProductList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      products: [],
    };
  }

  componentDidMount() {
    this.setState({ products: Seed.products });
  }

  handleProductUpVote(productId) {
    console.log(productId + ' was upvoted.');
  }

  render() {
    const products = this.state.products.sort((a, b) => (
      b.votes - a.votes
    ));
    const productComponents = products.map((product) => (
      <Product
        key={'product-' + product.id}
        id={product.id}
        title={product.title}
        description={product.description}
        url={product.url}
        votes={product.votes}
        submitterAvatarUrl={product.submitterAvatarUrl}
        productImageUrl={product.productImageUrl}
        onVote={this.handleProductUpVote}
      />
    ));

    return (
      <div className='ui unstackable items'>
        {productComponents}
      </div>
    );
  }
}

class Product extends React.Component {
  constructor(props) {
    super(props);

    this.handleUpVote = this.handleUpVote.bind(this);
  }

  handleUpVote() {
    this.props.onVote(this.props.id);
  }

  render() {
    return (
      <div className='item'>
        <div className='image'>
          <img src={this.props.productImageUrl} />
        </div>
        <div className='middle aligned content'>
          <div className='header'>
            <a onClick={this.handleUpVote}>
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
ProductList组件现在已由自己拥有的状态驱动了。如果现在保存并刷
新，所有的产品都会消失。这是因为在ProductList组件中没有任何机
制可以将产品添加到它的state中。

### 1.9.4 使用this.setState()设置state

React指定了一组生命周期方法。在组件挂载到页面之后，React会调用`componentDidMount()`生命周期方法。我们将在此方法中为ProductList组件的state赋值。React为组件提供了this.setState()方法，用于state初始化之后的所有修改操作。除此之外，该方法会触发React组件重新渲染，这在state更改后非常重要。

> 永远不要在this.setState()方法之外修改state。它为state修改提供了重要的Hook，我们不能绕过它。

该组件在挂载时state是一个空的this.state.products数组。挂载后，我们使用Seed对象的数据为state赋值。该组件将重新渲染，产品也将显示出来。这是以用户察觉不到的速度发生的。
voting_app/public/js/app-8.js 
```js
class ProductList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      products: [],
    };
  }

  componentDidMount() {
    this.setState({ products: Seed.products });
  }

  handleProductUpVote(productId) {
    console.log(productId + ' was upvoted.');
  }

  render() {
    const products = this.state.products.sort((a, b) => (
      b.votes - a.votes
    ));
    const productComponents = products.map((product) => (
      <Product
        key={'product-' + product.id}
        id={product.id}
        title={product.title}
        description={product.description}
        url={product.url}
        votes={product.votes}
        submitterAvatarUrl={product.submitterAvatarUrl}
        productImageUrl={product.productImageUrl}
        onVote={this.handleProductUpVote}
      />
    ));
    return (
      <div className='ui unstackable items'>
        {productComponents}
      </div>
    );
  }
}

class Product extends React.Component {
  constructor(props) {
    super(props);

    this.handleUpVote = this.handleUpVote.bind(this);
  }

  handleUpVote() {
    this.props.onVote(this.props.id);
  }

  render() {
    return (
      <div className='item'>
        <div className='image'>
          <img src={this.props.productImageUrl} />
        </div>
        <div className='middle aligned content'>
          <div className='header'>
            <a onClick={this.handleUpVote}>
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

## 1.10 更新state和不变性

我们刚刚讨论过只能使用this.setState()方法修改state。因此，虽然组件可以修改它的state，但我们应该将this.state对象视为不可变的。
```js
const nextNums = this.state.nums;
nextNums.push(4);
console.log(nextNums);
// [ 1, 2, 3, 4]
console.log(this.state.nums);
// [ 1, 2, 3, 4] <-- Nope!
```
新变量nextNums与this.state.nums引用的是内存中的相同数组

不过可以使用Array对象的concat()方法代替。concat()方法创建了一个新数组，该数组包含调用它的数组元素，后面是作为参数传入的元素。

> 将state对象视为不可变的，对于了解这些对象是被哪些Array和Object的方法调用并修改的非常重要。

products初始化为this.state.products时，products与this.state.products都引用内存中相同的数组,如例子voting_app/public/js/app-8.js 所示。Products和this.state.products两个变量都引用内存中的相同数组.因此，当我们通过forEach()方法增加某个product的票数来修改该product对象时，同时也修改了state中的原始product对象
正确写法应该是voting_app/public/js/app-9.js所示
```js
/* eslint-disable no-param-reassign, operator-assignment */

class ProductList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      products: [],
    };

    this.handleProductUpVote = this.handleProductUpVote.bind(this);
  }

  componentDidMount() {
    this.setState({ products: Seed.products });
  }

  // Inside `ProductList`
  handleProductUpVote(productId) {
    // map函数只是遍历数组
    const nextProducts = this.state.products.map((product) => {
      if (product.id === productId) {
        return Object.assign({}, product, {
          votes: product.votes + 1,
        });
      } else {
        return product;
      }
    });
    this.setState({
      products: nextProducts,
    });
  }

  render() {
    const products = this.state.products.sort((a, b) => (
      b.votes - a.votes
    ));
    const productComponents = products.map((product) => (
      <Product
        key={'product-' + product.id}
        id={product.id}
        title={product.title}
        description={product.description}
        url={product.url}
        votes={product.votes}
        submitterAvatarUrl={product.submitterAvatarUrl}
        productImageUrl={product.productImageUrl}
        onVote={this.handleProductUpVote}
      />
    ));
    return (
      <div className='ui unstackable items'>
        {productComponents}
      </div>
    );
  }
}

class Product extends React.Component {
  constructor(props) {
    super(props);

    this.handleUpVote = this.handleUpVote.bind(this);
  }

  handleUpVote() {
    this.props.onVote(this.props.id);
  }

  render() {
    return (
      <div className='item'>
        <div className='image'>
          <img src={this.props.productImageUrl} />
        </div>
        <div className='middle aligned content'>
          <div className='header'>
            <a onClick={this.handleUpVote}>
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
首先，使用map()方法遍历products数组。重要的是，map()方法返回新数组，而不是修改this.state.products数组。其次，比较当前product是否与productId匹配。如果两者匹配，那么创建新对象并复制原始product对象的属性。然后重写新product对象上的votes属性，并将其赋值为增加后的票数。我们使用Object的assign()方法来执行这些操作：最后使用setState()方法来更新state。说白了就是这个例子做了change是在副本上做的change而没有更新元数据

Object.assign()方法详解
1. 第四行代码为什么是true
```js
const target = { a: 1, b: 2 };
const source = { b: 4, c: 5 };
const returnedTarget = Object.assign(target, source);
console.log(target);
// expected output: Object { a: 1, b: 4, c: 5 }
console.log(returnedTarget === target);
// expected output: true
```
这是因为这样的写法Object.assign(target, source);是返回的修改的target，就是说并没有创建新的对象

2. Cloning an object
```js
const obj = { a: 1 };
const copy = Object.assign({}, obj);
console.log(copy); // { a: 1 }
```
这种写法是创建了一个新对象

3. Merging objects
```js
const o1 = { a: 1 };
const o2 = { b: 2 };
const o3 = { c: 3 };
const obj = Object.assign(o1, o2, o3);
console.log(obj); // { a: 1, b: 2, c: 3 }
```
If the source value is a reference to an object, it only copies the reference value.只是merge
4. merging objects and create new reference
```js
const o1 = { a: 1, b: 1, c: 1 };
const o2 = { b: 2, c: 2 };
const o3 = { c: 3 };
const obj = Object.assign({}, o1, o2, o3);
console.log(obj); // { a: 1, b: 2, c: 3 }
```


## 1.11 用Babel插件重构transform-class-properties

### 1.11.2 属性初始化器


### 1.11.3 重构Product组件

如上文所讲，handleUpVote()方法是自定义组件的自定义方法，所以React不会将该方法内部的this绑定到组件。因此我们必须在构造函
数中手动执行绑定：
```js
class Product extends React.Component {
constructor(props) {
super(props);
this.handleUpVote = this.handleUpVote.bind(this);
}
handleUpVote() {
this.props.onVote(this.props.id);
}
render() {}
```
使用transform-class-properties插件，我们可以将handleUpVote
写为箭头函数。这会确保函数内部的this能绑定到当前组件，正如预
期：
```js
class Product extends React.Component {
handleUpVote = () => (
this.props.onVote(this.props.id)
);
render() {}
```
使用此特性，可以删除constructor()函数，无须手动绑定调用。

### 1.11.4 重构ProductList组件

同样道理ProductList组件也可以使用箭头函数进行重构