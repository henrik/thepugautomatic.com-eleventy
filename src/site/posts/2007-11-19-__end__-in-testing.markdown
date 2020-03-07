---
wordpress_id: 193
title: Use __END__ for keeping code around in testing
categories:
- Ruby
- Ruby on Rails
date: 2007-11-19 15:43
layout: post
comments: true
---
If you're a bad boy and sometimes write tests <em>after</em> the code you're testing, here's a quick tip:

It's nice to be able to glance at the code being tested while writing the tests. When working e.g. with Rails, the tests and the code are typically in different files.

Copy the code being tested. Paste it at the bottom of the test file, under an <code>__END__</code> line, and it will in effect be commented out (it actually goes into the <a href="http://www.zenspider.com/Languages/Ruby/QuickRef.html#19">DATA</a> global constant).

So while writing a test, your buffer may now look like so:

``` ruby
require File.dirname(__FILE__) + '/../test_helper'
class MyTest < Test::Unit::TestCase

  def test_something
    # TODO
  end

end

__END__

# This stuff is in effect commented out.
def something(input)
  "hah!"
end
```

I remove the <code>__END__</code> and everything after it once the test has been written.
