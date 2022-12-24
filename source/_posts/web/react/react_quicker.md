---
title: react快速上手开发
categories:
- 非技术类
thumbnailImagePosition: bottom
coverImage: https://user-images.githubusercontent.com/46363359/209441599-8240edd3-c8b8-437e-93df-ef48502cb631.jpg
metaAlignment: center
coverMeta: out
---

## hello world

React.DOM 对象是React框架帮我们初始化了浏览器的DOM对象。借由react框架我们可以操作各种html元素，可以通过 React.DOM 对象把各种各样的 HTML 元素当作 React 组件使用。在例子中我们看到React.DOM.h1()函数的第一次参数是可以传入html元素的属性
```js
      ReactDOM.render(
        React.DOM.h1(
          {
            style: {
              background: "black",
              color: "white",
              fontFamily: "Verdana",
            },
            className: "pretty",
            htmlFor: "me",
          },

          "Hello world!"
        ),      
        
        document.getElementById('app')
      );

browser:
<h1 data-reactroot="" class="pretty" for="me" style="background: black; color: white; font-family: Verdana;">Hello world!</h1>
```

## 组件的声明周期

1. 自定义组件
我们要实现render方法
```js
      var Component = React.createClass({
        render: function() {
          return React.DOM.span(null, "My name is ");
        }
      });

```
然后我们在应用中使用自定义组件
```js
ReactDOM.render(
 React.createElement(Component), 
 document.getElementById("app") 
);
```

2. 属性 this.props属性
props属性可以获得所有的属性，请把 this.props 视作只读属性。从父组件传递配置到子组件时，属性非常重
要。
```js
      var Component = React.createClass({
        render: function() {
          return React.DOM.span(null, "My name is " + this.props.name);
        }
      });
<!-- 在应用中使用 -->

ReactDOM.render( 
    React.createElement(Component, { 
        name: "Bob", 
        }), 
    document.getElementById("app") 
);
```

3. propTypes
优点：
    1. 通过预先声明组件期望接收的参数，让使用组件的用户不需要在 render() 方法的源代码中到处寻找该组件可配置的属性
    2. React 会在运行时验证属性值的有效性。这使得你可以放心编写 render() 函数，而不需要对组件接收的数据类型有所顾虑


```js
    <script>
      var Component = React.createClass({
        propTypes: {
          name: React.PropTypes.string.isRequired,
        },
        render: function() {
          return React.DOM.span(null, "My name is " + this.props.name);
        }
      });
      ReactDOM.render(
        React.createElement(Component, {
          name: "Bob",
          // name: 123,
        }),
        document.getElementById("app")
      );
    </script>
```
默认值，如果我们不小心提供属性的情况，还要保证正确运行，这样难免会导致一些防御性代码
```js
 <script>
      var TextAreaCounter = React.createClass({

        propTypes: {
          text: React.PropTypes.string,
        },
        
        getDefaultProps: function() {
          return {
            text: '',
          };
        },

        render: function() {
          return React.DOM.div(null,
            React.DOM.textarea({
              defaultValue: this.props.text,
            }),
            React.DOM.h3(null, this.props.text.length)
          );
        }
      });

      ReactDOM.render(
        React.createElement(TextAreaCounter, {
          text: "Bob",
        }),
        document.getElementById("app")
      );
    </script>
```

4. state与带状态的文本框组件
```js
  <script>
      var TextAreaCounter = React.createClass({

        propTypes: {
          text: React.PropTypes.string,
        },

        getDefaultProps: function() {
          return {
            text: '',
          };
        },

        getInitialState: function() {
          return {
            text: this.props.text,
          };
        },

        _textChange: function(ev) {
          this.setState({
            text: ev.target.value,
          });
        },

        render: function() {
          return React.DOM.div(null,
            React.DOM.textarea({
              value: this.state.text,
              onChange: this._textChange,
            }),
            React.DOM.h3(null, this.state.text.length)
          );
        }
      });

      ReactDOM.render(
        React.createElement(TextAreaCounter, {
          text: "Bob",
        }),
        document.getElementById("app")
      );
    </script>
```


5. 关于DOM事件的说明
