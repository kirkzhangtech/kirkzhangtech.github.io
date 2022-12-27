---
title: vue.js up and running
categories:
- vue
---

> 文档： <https://vuejs.org/guide/quick-start.html>

A framework is a JavaScript tool that makes it easier for developers to create
rich,interactive websites. Frameworks contain functionality that enable us to
make a fully functional web application: manipulating complicated data and
displaying it on the page, handling routing client-side instead of having to rely
on a server,and sometimes even allowing us to create a full website that needs to
hit the server only once for the initial download. Vue.js is the latest popular
JavaScript framework and is rapidly increasing in popularity. Evan You, then
working at Google, wrote and released the first version of Vue.js in early 2014.
At the time of writing, it has over 75,000 stars on GitHub, making it the eighth
most starred repository on GitHub, and that number is growing rapidly. Vue has
hundreds of collaborators and is downloaded from npm about 40,000 times
every day. It contains features that are useful when developing websites and
applications: a powerful templating syntax to write to the DOM and listen to
events,reactivity so that you don’t need to update the template after your data
changes, and functionality that makes it easier for you to manipulate your data.

<!-- more -->

<!-- toc -->

# 1. Vue.js: The Basics

As explained in the preface, Vue.js is the library at the heart of an ecosystem that
allows us to create powerful client-side applications. We don’t have to use the
whole ecosystem just to build a website, though, so we’ll start by looking at Vue
by itself.

## 1.1 Why Vue.js?

Without a framework,we’d end up with a mess of unmaintainable code, the vast
majority of which would be dealing with stuff that the framework abstracts away
from us. Take the following two code examples, both of which download a list
of items from an Ajax resource and display them on the page. The first one is
powered by jQuery, while the second one is using Vue.

Using jQuery, we download the items, select the ul element, and then if there are
items,we iterate through them, manually creating a list element, adding the is-
blue class if wanted,and setting the text to be the item. Finally, we append it to
the ul element:

```js
<ul class="js-items"></ul>
<script>
$(function () {
    $.get('https://example.com/items.json')
        .then(function (data) {
            var $itemsUl = $('.js-items');
            if (!data.items.length) {
                var $noItems = $('li');
                $noItems.text('Sorry, there are no items.');
                $itemsUl.append($noItems);
            } else {
                data.items.forEach(function (item) {
                    var $newItem = $('li');
                    $newItem.text(item);
                    if (item.includes('blue')) {
                        $newItem.addClass('is-blue');
                    }
                    $itemsUl.append($newItem);
                });
            }
        });
});
</script>
```

This is what the code does:

1. It makes an Ajax request using $.get().
2. It selects the element matching `.js-items` and stores it in the `$itemsUl` object.
3. If there are no items in the list downloaded, it creates an `li` element,
sets the text of the `li` element to indicate that there were no items,and
adds it to the document.If there are items in the list,it iterates through them in a loop.
4. For every item in the list, it creates an `li` element and sets the text to be
the item. Then,if the item contains the string blue, it sets the class of
the element to is-blue. Finally, it adds the element to the document

Every step had to be done manually—every element created and appended to the
document individually. We have to read all the way through the code to work out
exactly what is going on, and it isn’t obvious at all at first glance.
With Vue,the code providing the same functionality is much simpler to read and
understand—even if you’re not yet familiar with Vue:

```js
<ul class="js-items">
<li v-if="!items.length">Sorry, there are no items.</li>
<li v-for="item in items" :class="{ 'is-blue': item.includes('blue') }">
{{ item }}
</li>
</ul>
<script>
new Vue({
    el: '.js-items', 
    data: {
        items: []
    },
    created() {
        fetch('https://example.com/items.json')
            .
            then((res) => res.json())
            .
            then((data) => {
                this.items = data.items;
            });
    }
});
</script>

```

This code does the following:

1. It makes an Ajax request using fetch().
2. It parses the response from JSON into a JavaScript object.
3. It stores the downloaded items in the items data property.

> el is abbrivate of element

That’s all the actual logic in the code. Now that the items have been downloaded
and stored,we can use Vue’s templating functionality to write the elements to
the Document Object Model (DOM), which is how elements are represented on
an HTML page. We tell Vue that we want one li element for every item and that
the value should be item. Vue handles the creation of the elements and the
setting of the class for us.

Don’t worry about fully understanding the code example if you don’t yet. I’ll
slow down and introduce the various concepts one at a time throughout the book.

Not only is the second example significantly shorter, but it’s also a lot easier to
read,as the actual logic of the app is completely separated from the view logic.
Instead of having to wade through some jQuery to work out what is being added when,
we can look at the template: if there are no items, a warning is displayed;
otherwise,the items are displayed as list elements. The difference becomes even
more noticeable with larger examples. Imagine we wanted to add a reload button
to the page that would send a request to the server, get the new items, and update
the page when the user clicks a button. With the Vue example, that’s only a
couple of additional lines of code, but with the jQuery example, things start to
get complicated.

In addition to the core Vue framework,several libraries work great with Vue and
are maintained by the same people who maintain Vue itself. For routing—
displaying different content depending on the URL of the application—there’s
vue-router. For managing state—sharing data between components in one global
store—there’s vuex,and for unit testing Vue components, there’s vue-test-utils. I
cover all three of those libraries and give them a proper introduction later in the
book: vue-router in Chapter 5, vuex in Chapter 6, and vue-test-utils in Chapter 7.
> all of above text just only illustrated one thing ,Vue is better than jquery, a good framework.
> including vue-router, which depending on the URL of the application to display different content.
> vuex managing state—sharing data between components in one global store.
> vue-test-utils, unit testing utility.

## 1.2 Installation and Setup

You don’t need any special tools to install Vue. The following will do just fine:
```js
<div id="app"></div>
<script src="https://unpkg.com/vue"></script>
// <script src="https://cdn.jsdelivr.net/npm/vue@2.6.0"></script> 非常重要
<script>
new Vue({
el: '#app',
created() {
// This code will run on startup
}
});
</script>
```
This example contains three important things. First, there is a div with the ID app, which is where we’re going to initiate Vue onto—for various reasons, we can’t initiate it onto the body element itself. Then, we’re downloading the CDN version of Vue onto our page. You can also use a local copy of Vue, but for the sake(n.目的;利益) of simplicity(n. 朴素；简易；天真), we’ll go with this for now. Finally, we’re running some JavaScript of our own, which creates a new instance of Vue with the `el` property set pointing at the div previously mentioned.

That works great on simple pages, but with anything more complicated, you probably want to use a bundler such as webpack. Among other things, this will
allow you to write your JavaScript using ECMAScript 2015 (and above), write
one component per file and import components into other components, and write
CSS scoped to a specific component (covered in more detail in Chapter 2).

**vue-loader and webpack**
vue-loader is a loader for webpack that allows you to write all the HTML,JavaScript, and CSS for a component in a single file. We’ll be exploring it
properly in Chapter 2, but for now all you need to know is how to install it. If you have an existing webpack setup or favorite webpack template, you can
install it by installing vue-loader through npm, and then adding the following to your webpack loader configuration:
```js
module: {
    loaders: [
        {
            test: /\.vue$/,
            loader: 'vue',
                },
            // ... your other loaders ...
            ]
}
```

NOTE: loader configuration 号有很多东西要深挖

If you don’t already have a webpack setup or you’re struggling with adding vue-
loader,don’t worry! I’ve never managed to set up webpack from scratch either.
There is a template you can use to set up a vue project using webpack that
already has vue-loader installed. You can use it through vue-cli:

```shell
#1.
$ npm install --global vue-cli
#1.
# 官网给的是这个命令npm install -g @vue/cli
# 验证 vue --version
# 升级 npm update -g @vue/cli
# npm 添加镜像源 npm config set registry http://mirrors.cloud.tencent.com/npm/
# vue create hello_world 
# npm run serve
#2.
# `npm i -g @vue/cli-init`  安装组件 -> npm uninstall -g  @vue/cli-init 卸载
# `vue init webpack`
# `npm run dev`

```
Try this now, and then follow the instruction it outputs to start the server.
Congratulations—you’ve just set up your first Vue project!

summary:

1. vue-loader是webpack的一个加载器，允许你创建一个初始化vue项目，可以自定义模板，然后配置vue-loader
2. 通过上面简单的两行命令就安装了vue-loader，并初始化了项目,init是vue-cli旧版的命令
   1. 旧版本的命令
      ```js
      `npm i -g @vue/cli-init`  安装组件 -> npm uninstall -g  @vue/cli-init 卸载
      `vue init webpack`
      `npm run dev`
      ```
    2. 新版本命令
      ```js
      `npm install -g @vue/cli`
      `vue create hello_world`
      `npm run serve`
      ```
    3. vue CDN:`<script src="https://cdn.jsdelivr.net/npm/vue@2.6.0"></script>`

## 1.3 Templates, Data, and Directives

At the heart of Vue is a way to display data on the page. This is done using templates. Normal HTML is embellished using special attributes—known as
directives—that we use to tell Vue what we want to happen and what it should do with the data we’ve provided it. Let’s jump straight into an example. The following example will display “Good morning!” in the morning, “Good afternoon!” until 6 p.m., and “Good evening!”
after that:
```js
<div id="app">
<p v-if="isMorning">Good morning!</p>
<p v-if="isAfternoon">Good afternoon!</p>
<p v-if="isEvening">Good evening!</p>
</div>
<script>
var hours = new Date().getHours();
new Vue({
el: '#app',
data: {
isMorning: hours < 12,
isAfternoon: hours >= 12 && hours < 18,
isEvening: hours >= 18
}
});
</script>
```
Let’s talk about the last bit,first: the data object. This is how we tell Vue what data we want to display in the template. We’ve set three properties of the object—isMorning, isAfternoon, and isEvening—one of which is true, and two of which are false,depending what time of day it is.Then,in the template, we’re using the v-if directive to show only one of the three greetings, depending on what the variable is set to. The element that v-if is set on is displayed only if the value passed to it is truthy; otherwise, the
element is not written to the page. If the time is 2:30 p.m., the following is output to the page:
```js
<div id="app">
<p>Good afternoon!</p>
</div>
```
NOTE : Although Vue has reactive functionality, the preceding example is not reactive(adj. 反应的；电抗的；反动的), and the page will not update when the time changes. We’ll cover reactivity in more detail later.

Quite a bit of duplication occurs in the previous example, though: it would be
better if we could set the time as a data variable and then do the comparison
logic in the template. Luckily, we can! Vue evaluates simple expressions inside
v-if:
```js
<div id="app">
<p v-if="hours < 12">Good morning!</p>
<p v-if="hours >= 12 && hours < 18">Good afternoon!</p>
<p v-if="hours >= 18">Good evening!</p>
</div>
<script>
new Vue({
    el: '#app',
    data: {
    hours: new Date().getHours()
        }
});
</script>

```
Writing code in this manner, with the business logic in the JavaScript and the
view logic in the template, means that we can tell at a glance exactly what will
be displayed when on the page. This is a much better approach than having the
code responsible for deciding whether to show or hide the element in some
JavaScript far away from the element in question.
Later,we'll be looking at computed properties, which we can use to make the
preceding code a lot cleaner—it’s a bit repetitive.
In addition to using directives, we can also pass data into templates by using
interpolation, as follows:
```js
<div id="app">
<p>Hello, {{ greetee }}!</p>
</div>
<script>
new Vue({
el: '#app', // 元素选择器，但是记住，这里<div>是第一层
data: {
greetee: 'world'  // 给元素定义的变量
}
});
</script>
```
This outputs the following to the page:
```js
<div id="app">
<p>Hello, world!</p>
</div>
```
We can also combine the two ,using both directives and interpolation to show some text only if it is defined or useful. See if you can figure out what the
following code displays on the page and when:
```js
<div id="app">
<p v-if="path === '/'">You are on the home page</p>
<p v-else>You're on {{ path }}</p>
</div>
<script>
new Vue({
el: '#app',
data: {
path: location.pathname
}
});
</script>

```
location.pathname is the path in the URL of the page, so it can be “/” when on the root of the site,or“/post/1635” when somewhere else on the site. The preceding code tells you whether you’re on the home page of the site: in a v-if directive,it tests whether the path is equal to “/” (and the user is therefore on the root page of the site), and then we’re introduced to a new directive, v-else. It’s pretty simple: when used after an element with v-if, it works like the else statement of an if-else statement. The second element is displayed on the page only when the first element is not.In addition to being able to pass through strings and numbers, as you’ve seen,it’s also possible to pass other types of data into templates. Because we can execute simple expressions in the templates, we can pass an array or object into the template and look up a single property or item:
```js
<div id="app">
<p>The second dog is {{ dogs[1] }}</p>
<p>All the dogs are {{ dogs }}</p>
</div>
<script>
new Vue({
el: '#app',
data: {
dogs: ['Rex', 'Rover', 'Henrietta', 'Alan']
}
});
</script>
```
The following is output to the page:
The second dog is Rover
All the dogs are [ "Rex", "Rover", "henrietta", "Alan" ]

As you can see, if you output a whole array or object to the page, Vue outputs the JSON-encoded value to the page. This can be useful when debugging instead of logging to console, as the value displayed on the page will update whenever the value changes.

summary:
1. `<p v-if="isMorning">Good morning!</p>` 说明如果是v-if变量，如果是真就显示，false就不显示
2. `<p v-if="hours >= 12 && hours < 18">Good afternoon!</p>` 在标签中可以对变量进行逻辑判断
3. `<p>Hello, {{ greetee }}!</p>` 可以读取变量内容
4. `<p v-if="path === '/'">You are on the home page</p>`和`<p v-else>You're on {{ path }}</p>`说明可以进行逻辑判断if-else`===` 判断是否相等
5. `<p>The second dog is {{ dogs[1] }}</p>` 可以对数组元素进行取值