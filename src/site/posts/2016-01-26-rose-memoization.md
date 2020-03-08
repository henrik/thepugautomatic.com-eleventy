---
title: "Rose memoization"
comments: true
tags:
- Ruby
---

["Memoization"](https://en.wikipedia.org/wiki/Memoization) is caching the results of expensive method calls for speed.

In Ruby, this is often implemented something like this:

``` ruby
def my_expensive_method
  @my_expensive_method ||= one + two * three
end
```

or

``` ruby
def my_expensive_method
  @my_expensive_method ||= begin
    one
    two
    three
  end
end
```

Clearly this needs a name.

I've always thought of it as "rose memoization", because of the `@ ||=` pattern. It looks like an ASCII rose.

I was amazed not to find any (any!) Google results for that term, so now this post exists.

Are there any other terms in use for this construct?

(Parenthetically, I recommend [memoit](https://github.com/jnicklas/memoit) for any non-trivial memoization. I also recommend [not memoizing at all](/2013/08/memoization-is-a-liability/) in many cases.)
