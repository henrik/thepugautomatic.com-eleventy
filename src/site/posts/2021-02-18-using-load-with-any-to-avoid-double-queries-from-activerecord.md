---
title: Using "load" with "any?" to avoid double queries from Active Record
tags:
  - Ruby on Rails
---

It's common to only list records if there are any – something like this:

{% filename "index.html.erb" %}
``` erb
<% if @items.any? %>
  <ul>
    <% @items.each do |item| %>
      <li><%= item.title %></li>
    <% end %>
  </ul>
<% else %>
  <p>No items!</p>
<% end %>
```

As you may be currently shouting at your screen, this specific implementation is not optimal. The `any?` will trigger one query, and `@items.each` will trigger another.

We can verify this in a Rails console:

``` ruby
>> items = Item.where("false"); items.any?; items.each(&:id)
  Item Exists (1.2ms)  SELECT  1 AS one FROM "items" WHERE (false) LIMIT 1
  Item Load (12.3ms)  SELECT "items".* FROM "items" WHERE (false)
```

Other than the performance implications of running two queries where one would do, there's also a (usually low) risk of timing issues where the `any?` is true, then the records are destroyed, and the second query comes back empty, rendering an empty list.

[The docs](https://api.rubyonrails.org/v6.1/classes/ActiveRecord/Associations/CollectionProxy.html#method-i-empty-3F) currently recommend using `length`, e.g. like this:

``` ruby
>> items = Item.where("false"); items.length.nonzero?; items.each(&:id)
  Item Load (12.3ms)  SELECT "items".* FROM "items" WHERE (false)
```

This does get us a single query, but at what aesthetic cost? `@items.length.nonzero?` or `@items.length > 0` lacks the elegance of `@items.any?`. Surely the framework that gave us [`#forty_two`](https://api.rubyonrails.org/v6.1/classes/ActiveRecord/Associations/CollectionProxy.html#method-i-forty_two) can do better!

So [Calle](https://www.calleluks.com/) and I looked around and came up with something that gets us both:

{% filename "index.html.erb" %}
``` erb
<% if @items.load.any? %>
  <ul>
    <% @items.each do |item| %>
      <li><%= item.title %></li>
    <% end %>
  </ul>
<% else %>
  <p>No items!</p>
<% end %>
```

By just sneaking a [`load`](https://api.rubyonrails.org/v6.1/classes/ActiveRecord/Relation.html#method-i-load) in there, we cause the `@items` collection to be loaded from the database. And [`any?`](https://api.rubyonrails.org/v6.1/classes/ActiveRecord/Relation.html#method-i-any-3F) is implemented (via [`empty?`](https://api.rubyonrails.org/v6.1/classes/ActiveRecord/Relation.html#method-i-empty-3F)) not to fire off an extra query if the collection has already been loaded.

We can confirm in the console that it generates a single query:

``` ruby
>> items = Item.where("false"); items.load.any?; items.each(&:id)
  Item Load (12.3ms)  SELECT "items".* FROM "items" WHERE (false)
```

Alternatively, one could load the records in the controller, of course:

``` ruby
@items = Item.some_scope.load
```

A potential downside to doing it in the controller is that it still *looks* in the view like it will trigger an extra query, if you're used to this Rails gotcha…

Anyway, that's it!

UPDATE: After writing this, I found [an excellent post by Nate Berkopec](https://www.speedshop.co/2019/01/10/three-activerecord-mistakes.html) that covers a bunch of options (including this one!) in depth, with tables and everything.
