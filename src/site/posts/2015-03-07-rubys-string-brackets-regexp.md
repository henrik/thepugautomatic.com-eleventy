---
title: "Ruby's String#[/regexp/]"
comments: true
tags:
  - Ruby
  - Regular expressions
---

One of my favorite Ruby methods is [`String#[]`](http://ruby-doc.org/core-2.2.0/String.html#method-i-5B-5D) when given a regular expression:

``` ruby
"fooobar"[/o+/]  # => "ooo"
"fooobar"[/o+(.)/, 1]  # => "b"
```

The first form returns the matched part of the string. The second form returns capture group number 1.

For one thing, it's short and sweet.

For another, it's robust. `"fooobar".match(/x(.)/)[1]` will raise "undefined method \`[]' for nil:NilClass". `"fooobar"[/x(.)/, 1]` will just return `nil`.

It's a great choice for extracting a regexp match from a string.
