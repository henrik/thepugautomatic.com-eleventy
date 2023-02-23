---
title: Passing arguments to osascript in Raycast script commands
tags:
  - AppleScript
  - Shell scripting
  - Raycast
---

I'm writing commands for the [Raycast](https://www.raycast.com/) launcher.

It took me a while to figure out how to robustly pass arguments to AppleScript/osascript in Raycast [script commands](https://github.com/raycast/script-commands). This is how:

``` bash
#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Say something
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "something to say" }

osascript - "$1" <<END
  on run argv
    set arg to (item 1 of argv)
    say arg
  end
END
```

We're passing the shell argument `$1` into `osascript`, where it in turn becomes the first `argv` argument.

If we had just interpolated `$1` directly into the AppleScript like `say "$1"`, we would effectively run an injection attack on ourselves. It would work for simple input like "hello" but would break on input like 'hello "world"'.
