---
title: Systematically removing code
tags:
  - Methodology
---

It's easy to miss something when removing code, leaving behind unused methods, templates, CSS classes or translation keys. (Especially in a dynamic language like Ruby, without a compiler to help you spot dead code.)

I avoid this by removing code systematically, line by line, depth-first.

This is one of those things that seems obvious when you do it, but in my experience, many people do it haphazardly.

Say we wanted to remove the "item box" from this page:

{% filename "page.html.erb" %}
``` erb
<p>Welcome to my page!</p>

<%= render("item_box", item: item) %>
```

{% filename "item_box.html.erb" %}
``` erb
<div class="box box--fancy">
  <h2><%= item.title %></h2>
  <%= format_description(item.description) %>
  <p><%= I18n.translate("my.translation.key") %>
</div>
```

So our end goal is to remove the `<%= render("item_box", item: item) %>` line.

First, we search the project to check that `item_box.html.erb` isn't used somewhere else, or referenced in docs that we'll need to update. It isn't, so we're OK to remove it – but before we do that, we must go through it line by line.

The first line is `<div class="box box--fancy">`. So we search the project for these two CSS classes, checking if they're in use somewhere else. If not, we remove them from the CSS files.

We go deeper if required – perhaps the CSS for `.box--fancy` uses a CSS variable. Then we check if that variable is in use elsewhere. [Stacked searches in Vim](/2014/03/stacked-vim-searches-down-cold/) are helpful here.

Once we've checked a line in the file, we delete that line. This helps us keep track of what we've already checked.

So after we've checked and removed that line, we're left with

{% filename "item_box.html.erb" %}
``` erb
  <h2><%= item.title %></h2>
  <%= format_description(item.description) %>
  <p><%= I18n.translate("my.translation.key") %>
</div>
```

And we continue this way, line by line. Is the `item.title` used elsewhere? If not, we should probably remove it, too. What about `format_description()`, `item.description`, the `my.translation.key` translation key?

Again, we go deeper if required, not removing the `format_description` method until we've gone through *it* line by line.

When we've looked at every line in `item_box.html.erb` and deleted them as we went, the file will be empty, and we can start popping the stack.

We remove the empty `item_box.html.erb` file.

And we can finally remove the `<%= render("item_box", item: item) %>` line, fairly confident that we didn't leave dead code behind.

This probably sounds more tedious than it is. It tends to be quick work, and you can take little shortcuts – removing a swathe of lines that don't reference anything else, or that only call methods that you know are used elsewhere.
