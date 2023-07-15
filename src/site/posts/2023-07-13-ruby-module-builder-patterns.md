---
title: Ruby Module Builder patterns
tags:
  - Ruby
  - Metaprogramming
---

I [recently discovered](https://ruby.social/@henrik/110673354335407050) the Ruby [Module Builder pattern](https://dejimata.com/2017/5/20/the-ruby-module-builder-pattern).

It lets you pass in arguments to dynamically generate a module at `include` time:

``` ruby
class Greeter < Module
  def initialize(name)
    define_method(:greet) { puts "Hello #{name}!" }
  end
end

class MyClass
  include Greeter.new("world")
end

MyClass.new.greet
# => "Hello world!"
```

I thought I'd share some insights and patterns I've found when using it.

## The instance-mixin duality

Crucially (and mind-bendingly), you need to set up your module inside the `initialize` block. Methods defined on `Greeter` won't be available on including classes:

``` ruby
class Greeter < Module
  def initialize(name) = # …

  def greet_on_module = "Hello!"
end

class MyClass
  include Greeter.new
end

# This works:
Greeter.new("world").greet_on_module

# But this raises NoMethodError:
MyClass.new.greet_on_module
```

This broke my brain initially, but it makes sense when you think through it.

Modules have a dual nature: they are class instances, and they can also be mixed into classes and other modules.

### Modules are class instances

`Module` is a class. So are its subclasses, like `Greeter` above.

When you do `Greeter.new`, you get an instance of `Greeter`. This instance is a module that you can mix in.

``` ruby
instance = Greeter.new("world")

class MyClass
  include instance
end
```

When you use `module`, you also get an instance, but *assigned to a global constant*:

``` ruby
module OtherGreeter
end

instance = OtherGreeter

class MyClass
  include instance
end
```

<a name="footnote-1-source"></a>

So `Greeter` is a *class* whose instances are modules you can mix in; `OtherGreeter` is not a class, but is *itself* a module you can mix in<a href="#footnote-1" class="footnote-link">¹</a>.

After all, the whole point of `Greeter` is to create *multiple* modules – one for `"world"`, another for `"moon"` – so they can't all be assigned to a single `Greeter` constant.

And this explains why `greet_on_module` can only be called on instances of `Greeter`. It's an instance method and the instances are modules. It's equivalent to

``` ruby
module OtherGreeter
  def self.greet_on_module = "Hello!"
end
```

You would not expect this method to be included when you mix in the module.

### Modules can be mixed in

Classes have instance methods that you call on instances but not on the class itself.

Modules also have [instance methods](https://ruby-doc.org/3.2/syntax/modules_and_classes_rdoc.html#label-Methods) (we might think of them as "mixin methods") that are mixed in, but are not called on the module itself.

With the `module` keyword, we just define those in the module body:

``` ruby
module OtherGreeter
  def greet = "Hello!"
end
```

With [`Module.new`](https://ruby-doc.org/3.2/Module.html#method-c-new), we define them in a block:

``` ruby
Module.new do
  def greet = "Hello!"
end
```

With `class … < Module`, we define them in the initializer:

``` ruby
class Greeter < Module
  def initialize(name)
    define_method(:greet) { puts "Hello #{name}!" }
  end
end
```

It makes sense. This is a class that creates modules. We need to create a module before we can define instance methods on it, and it's only in the initializer that we've created it.

[`define_method`](https://ruby-doc.org/3.2/Module.html#method-i-define_method) defines instance methods on the receiver, which inside the initializer is the module we created.

We can't use `def greet` inside the initializer. As with any class, `def` inside the initializer defines instance methods on the class. It would be just like `greet_on_module`.

There is still a way to use `def`, though.

## Using `module_eval`

Sometimes `define_method` is exactly what we need, if we use the passed-in values to determine method names (as in [`SecurePassword`](https://github.com/rails/rails/blob/a5fc471b3f4bbd02e6be38dae023526a49e7d049/activemodel/lib/active_model/secure_password.rb#L149-L152)), or whether to define a method at all.

But especially in a more complex module, it's nice to be able to use `def` for most of it, with `define_method` oneliners only to capture passed-in data.

[`module_eval`](https://ruby-doc.org/3.2/Module.html#method-i-module_eval) to the rescue:

``` ruby
class Greeter < Module
  def initialize(name:, time:)
    private define_method(:greeter_name) { name }
    private define_method(:greeter_time) { time }

    module_eval do
      def greet = "Good #{greeter_time}, #{greeter_name}!"
    end
  end
end
```

<a name="footnote-2-source"></a>

We still need `define_method` to make the passed-in data available to `def`ed methods – I can't think of a sensible<a href="#footnote-2" class="footnote-link">²</a> way around that.

Note that I'm defining `greeter_name` etc rather than `name`, since this method will be mixed into `MyClass`, where it could otherwise conflict.

## Using `ActiveSupport::Concern`

Here's an example of a Module Builder using [`ActiveSupport::Concern`](https://api.rubyonrails.org/v7.0.6/classes/ActiveSupport/Concern.html#method-i-included), since it took me a few attempts to get right.

``` ruby
require "active_support/concern"

class Greeter < Module
  def initialize(name)
    extend ActiveSupport::Concern

    class_methods do
      define_method(:greeter_name) { name }

      def classy_greet = "Classy hello #{greeter_name}!"
    end

    module_eval do
      def greet = "Hello #{self.class.greeter_name}!"
    end
  end
end

class MyClass
  include Greeter.new("world")
end

puts MyClass.classy_greet
puts MyClass.new.greet
```

Note that `extend ActiveSupport::Concern` goes inside the initializer.

Don't be tempted to replace `module_eval` with [`included`](https://api.rubyonrails.org/v7.0.6/classes/ActiveSupport/Concern.html#method-i-included). Both let you use `def`, but `included` would define methods *on the including class*, not on the module. This means you can't [override them](/2013/07/dsom/) conveniently. `included` is still fine for *calling* class methods, of course.

## Non-initializer builders

[Max mentioned](https://ruby.social/@maxim/110708280090132743) a [variation](https://notes.max.engineer/camelize-json-keys-in-rails) on this technique, where you don't use the initializer.

Arguably this is a little less confusing; `Module.new { … }` is a common pattern.

It also lets you define multiple builders on the same module.

``` ruby
module Greeter
  def self.by_name(name)
    Module.new do
      define_method(:greet) { "Hello #{name}!" }
    end
  end

  def self.loudly_by_name(name)
    Module.new do
      define_method(:greet) { "HELLO #{name.upcase}!!1" }
    end
  end
end

class MyClass
  include Greeter.by_name("world")
end

class MyLoudClass
  include Greeter.loudly_by_name("world")
end

puts MyClass.new.greet
puts MyLoudClass.new.greet
```

## Module identity

Regular modules let you check if they're mixed in:

``` ruby
MyClass.new.is_a?(Greeter)
MyClass < Greeter
Greeter === MyClass.new

MyClass.ancestors
# => [MyClass, Greeter, …]
```

That's harder to do with these built modules.

The modules built from an initializer are *instances* of `Greeter`:

``` ruby
MyClass.ancestors
# => [MyClass, #<Greeter:…>, …]
```

It's easy to see where they come from, but we can't do `MyClass.new.is_a?(Greeter)`. We'd need something like `MyClass.ancestors.any? { _1.is_a?(Greeter) }`.

And the non-initializer ones are just anonymous modules with no knowledge of whence they came:

``` ruby
MyClass.ancestors
# => [MyClass, #<Module:…>, …]
```

### Overriding `inspect`

We can make things nicer by overriding `inspect`:

``` ruby
module Greeter
  def self.by_name(name)
    Module.new do
      define_singleton_method(:inspect) { "#<Greeter:#{name}>" }
    end
  end
end

class MyClass
  include Greeter.by_name("world")
end

MyClass.ancestors
# => [MyClass, <#Greeter:world>, …]
```

### Assigning a constant

If we wanted to go completely overboard (and we do), we could do something like [this](/2013/07/dsom/#:~:text=Polishing%20the%20inheritance%20chain):

``` ruby
require "digest"

module Greeter
  def self.by_name(name)
    module_name = "ByName#{Digest::SHA1.hexdigest(name)}"
    return const_get(module_name) if const_defined?(module_name, false)

    const_set(module_name, Module.new do
      define_method(:greet) { "Hello #{name}!" }
    end)
  end
end

class MyClass
  include Greeter.by_name("world")
end

MyClass.ancestors
# => [MyClass, Greeter::ByName7c211433f02071597741e6ff5a8ea34789abbf43, …]
```

If we instead build in the initializer, we need to override `.new`:

``` ruby
class Greeter < Module
  def self.new(name)
    module_name = "ByName#{Digest::SHA1.hexdigest(name)}"
    return const_get(module_name) if const_defined?(module_name, false)

    const_set(module_name, super)
  end

  def initialize(name)
    define_method(:greet) { "Hello #{name}!" }
  end
end
```

And now we can check for module identity in the usual ways:

``` ruby
MyClass < Greeter.new("world")  # => true
MyClass < Greeter.new("moon")   # => nil
```

---

<a name="footnote-1"></a>

### Footnote 1 <a href="#footnote-1-source">^</a>

I say "a module you can mix in" because [`Class`](https://ruby-doc.org/3.2/Class.html) inherits from [`Module`](https://ruby-doc.org/3.2/Module.html). [All classes are modules](https://ruby-doc.org/3.2/syntax/modules_and_classes_rdoc.html#label-Classes), but not ones you can mix in.

Classes are modules with extra stuff. Both hold methods and constants and can have modules mixed into them. Classes add instantiation and state.

If you try to `include` or `extend` with a class as argument, you get a `TypeError`. They're still modules; Ruby just won't let you mix them in.

---

<a name="footnote-2"></a>

### Footnote 2 <a href="#footnote-2-source">^</a>

A [non-sensible](https://stackoverflow.com/questions/33762366/are-ruby-class-variables-bad) way with [`Concern`](https://api.rubyonrails.org/v7.0.6/classes/ActiveSupport/Concern.html`) could be this 🙈:

``` ruby
included { @@greeter_name = name }
```
