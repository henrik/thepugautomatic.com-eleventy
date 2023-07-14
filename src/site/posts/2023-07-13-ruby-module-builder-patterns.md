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
  def greet = "Hello!"
end

class MyClass
  include Greeter.new
end

# This works:
Greeter.new.greet

# But this raises NoMethodError:
MyClass.new.greet
```

I haven't fully understood what's going on here (nor have I delved into the Ruby source), but I believe this is down to the dual nature of modules.

Modules are instances (of the `Module` class) but can also (unlike non-module instances) be mixed into other modules or classes via `include`.

And methods on modules are defined either on the module-as-instance or on the module-as-mixin.

After all, with regular modules, we don't define methods inside `class Module` – we use `module MyModule`.

I think about `module` as syntactic sugar for creating a module *instance*, sticking it in a constant, and defining methods on the mixin:

``` ruby
module MyModule
  def greet = "Hello!"
end

MyModule = Module.new do
  def greet = "Hello!"
end
```

### Instance methods

These all define what we might call instance methods, callable on instances of the module, but not on including classes.

``` ruby
class Greeter < Module
  def greet = "Hello!"
end

class Greeter2 < Module
  def initialize
    def greet = "Hello!"
  end
end

$mod = Module.new
def $mod.greet = "Hello!"
```

Meaning this works:

``` ruby
Greeter.new.greet
Greeter2.new.greet
$mod.greet
```

And this doesn't:

``` ruby
class MyClass
  include Greeter.new
  include Greeter2.new
  include $mod
end

MyClass.new.greet
```

### Mixin methods

These all define what we might call mixin methods, callable on including classes, but not on instances of the module.

``` ruby
module Greeter
  def greet = "Hello!"
end

class Greeter2 < Module
  def initialize
    define_method(:greet) { "Hello!" }
  end
end

$mod = Module.new do
  def greet = "Hello!"
end

$mod2 = Module.new
$mod2.define_method(:greet) { "Hello!" }
```

Meaning this works:

``` ruby
class MyClass
  # Any one of these:
  include Greeter
  include Greeter2.new
  include $mod
  include $mod2
end

MyClass.new.greet
```

And this doesn't:


``` ruby
Greeter.new.greet
Greeter2.new.greet
$mod.greet
$mod2.greet
```

There's one more way.

## Using `module_eval`

Sometimes `define_method` is exactly what we need, if we use the passed-in values to determine method names (as in [`SecurePassword`](https://github.com/rails/rails/blob/a5fc471b3f4bbd02e6be38dae023526a49e7d049/activemodel/lib/active_model/secure_password.rb#L149-L152)), or whether to define a method at all.

But especially in a more complex module, it's nice to be able to use `def` for most of it, with `define_method` oneliners only to capture passed-in data.

[`module_eval`](https://ruby-doc.org/core-2.6.5/Module.html#method-i-module_eval) to the rescue:

``` ruby
class Greeter < Module
  def initialize(name)
    private define_method(:greeter_name) { name }

    module_eval do
      def greet = "Hello #{greeter_name}!"
    end
  end
end
```

We still need `define_method` to make the passed-in data available to `def`ed methods – I can't think of a sensible way around that. (A [non-sensible](https://stackoverflow.com/questions/33762366/are-ruby-class-variables-bad) way with [`Concern`](https://api.rubyonrails.org/v7.0.6/classes/ActiveSupport/Concern.html`) could be `included { @@greeter_name = name }` 🙈.)


Note that I'm using `greeter_name` rather than `name`, since this method will be mixed into `MyClass`, where it could otherwise conflict.

## Using `ActiveSupport::Concern`

Here's an example of a Module Builder using [`ActiveSupport::Concern`](https://api.rubyonrails.org/v7.0.6/classes/ActiveSupport/Concern.html#method-i-included), since it took me a few attempts to get right.

``` ruby
require "active_support/concern"

class Greeter < Module
  def initialize(name)
    extend ActiveSupport::Concern

    class_methods do
      define_method(:my_name) { name }

      def classy_greet = "Classy hello #{my_name}!"
    end

    module_eval do
      def greet = "Hello #{self.class.my_name}!"
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

And now we can check for module identity in the usual ways:

``` ruby
MyClass < Greeter.by_name("world")  # => true
MyClass < Greeter.by_name("moon")   # => nil
```
