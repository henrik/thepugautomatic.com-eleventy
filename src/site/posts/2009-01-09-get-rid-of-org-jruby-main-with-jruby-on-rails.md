---
wordpress_id: 267
title: Get rid of org.jruby.Main with JRuby on Rails
tags:
- Ruby
- Ruby on Rails
- Java
- Rake
- JRuby
comments: true
---
I just started working for a new <a href="http://www.auktionskompaniet.com/">employer</a>. The site runs Rails on <a href="http://jruby.codehaus.org/">JRuby</a> ("JRuby on Rails").

I found it a little annoying how an "org.jruby.Main" app would appear in the OS X dock when I did stuff like start the server, open a console or run the test suite. Running all this in parallel meant three separate apps in the dock. My colleagues experienced this also, but it didn't bother them enough to have looked into it.

I couldn't find anything on Google, strangely, but IRC was more helpful (thanks, nicksieger). I'm not familiar enough with JRuby to know if there is a better way, or if this has been changed in some later version than we're using, but:

<!--more-->

The <code>jruby</code> app takes a <code>--headless</code> option, explained as "do not launch a GUI window, no matter what".

## <code>jake/rake</code>

I run the test suite with <code>jake spec</code>, where <code>jake</code> is an alias:

``` bash
alias jake='jruby -S rake'
```

To get rid of the dock action, I just changed this to

``` bash
alias jake='jruby --headless -S rake'
```

Obviously, be careful with this if you expect to ever run non-headless stuff through <code>jake</code>.

## <code>script/server</code>, <code>script/console</code> etc

Change

``` ruby
#!/usr/bin/env jruby
```
to

``` ruby
#!/usr/bin/env jruby --headless
```
in your <code>script/*</code> files.

I'm very new to JRuby, so please do correct me if I'm wrong, or suggest better solutions if they exist.
