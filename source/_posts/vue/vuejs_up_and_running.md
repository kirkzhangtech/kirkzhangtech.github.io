---
title: vue.js up and running
categories:
- vue
---



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