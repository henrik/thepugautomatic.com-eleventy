---
title: "Transforming hashes in Ruby without inject or each_with_object"
comments: true
tags:
  - Ruby
---

Want to transform a Ruby hash, changing every key or value? There are better options than [`inject`](http://ruby-doc.org/core-2.4.1/Enumerable.html#method-i-inject) or [`each_with_object`](http://ruby-doc.org/core-2.4.1/Enumerable.html#method-i-each_with_object).

Those are relatively low-level methods that expose details (like a reference to the hash itself) that you often don't need:

{% filename "inject.rb" %}
``` ruby inject.rb
{ a: 1, b: 2 }.inject({}) { |h, (k, v)| h.merge(k => v * 2) }
# => { a: 2, b: 4 }
```

{% filename "each_with_object.rb" %}
``` ruby each_with_object.rb
{ a: 1, b: 2 }.each_with_object({}) { |(k, v), h| h[k] = v * 2 }
# => { a: 2, b: 4 }
```

If you're on Ruby 2.4+ and only want to change the hash values, you can instead use [`transform_values`](http://ruby-doc.org/core-2.4.1/Hash.html#method-i-transform_values):

{% filename "transform_values.rb" %}
``` ruby transform_values.rb
{ a: 1, b: 2 }.transform_values { |v| v * 2 }
# => { a: 2, b: 4 }
```

If you're on Ruby 2.0+, you can use [`map`](http://ruby-doc.org/core-2.4.1/Enumerable.html#method-i-map) and [`to_h`](http://ruby-doc.org/core-2.4.1/Array.html#method-i-to_h):

{% filename "map_and_to_h.rb" %}
``` ruby map_and_to_h.rb
{ a: 1, b: 2 }.map { |k, v| [ k, v * 2 ] }.to_h
# => { a: 2, b: 4 }
```
