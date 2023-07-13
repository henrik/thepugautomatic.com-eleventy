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

When you define a method on a module, effectively you either define it on the module-as-instance or on the module-as-mixin.

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
```

There's one more way.

## Using `module_eval`

Sometimes `define_method` is exactly what we need, if we use the passed-in values to determine method names (like [`SecurePassword`](https://github.com/rails/rails/blob/a5fc471b3f4bbd02e6be38dae023526a49e7d049/activemodel/lib/active_model/secure_password.rb#L149-L152)), or whether to define a method at all.

But if we're only using the passed-in values inside our module's methods, `define_method` can feel unnecessary. `module_eval` to the rescue:

``` ruby
class Greeter < Module
  def initialize(name)
    define_method(:my_greeter_name) { name }

    module_eval do
      def greet = "Hello #{my_greeter_name}!"
    end
  end
end
```

We still need `define_method` to make the passed-in data available to `def`ed methods – I can't think of a sensible way around that. (A [non-sensible](https://stackoverflow.com/questions/33762366/are-ruby-class-variables-bad) way with [`Concern`](https://api.rubyonrails.org/v7.0.6/classes/ActiveSupport/Concern.html`) could be `included { @@my_greeter_name = name }` 🙈.)

Especially in a more complex class with more and longer methods, it's nice to be able to use `def` for most of it, with `define_method` oneliners only to store passed-in data.

Note that I'm using `my_greeter_name` rather than `name`, since this method will be mixed into `MyClass`, where it could otherwise conflict.


## Using `ActiveSupport::Concern`

Finally, here's an example of a Module Builder using [`ActiveSupport::Concern`](https://api.rubyonrails.org/v7.0.6/classes/ActiveSupport/Concern.html#method-i-included), since it took me a few attempts to get right.

``` ruby
require "active_support/concern"

class Greeter < Module
  def initialize(name)
    extend ActiveSupport::Concern

    class_methods do
      define_method(:my_greeter_name) { name }

      def classy_greet = "Classy hello #{my_greeter_name}!"
    end

    module_eval do
      def greet = "Hello #{self.class.my_greeter_name}!"
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

Don't be temped to replace `module_eval` with [`included`](https://api.rubyonrails.org/v7.0.6/classes/ActiveSupport/Concern.html#method-i-included). Both let you use `def`, but `included` would define the methods *on the including class*, not on the module. This means you can't [override them](/2013/07/dsom/) conveniently. `included` is still fine for *calling* class methods, of course.
