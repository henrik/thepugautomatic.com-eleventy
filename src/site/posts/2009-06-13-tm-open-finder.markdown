---
title: TextMate "Open Finder" command
categories: [OS X, TextMate, Finder]
date: 2009-06-13 11:55
layout: post
comments: true
---

[TextMate](http://macromates.com) comes with an "Open Terminal" (<code class="kb">⌃⇧O</code>) command, in the Shell Script bundle.

This command will open a new Terminal window in the directory of the active TextMate file. Quite handy.

I made an "Open Finder" (<code class="kb">⌃⇧O</code>) command to go with it. The command goes into the "TextMate" bundle.

If you have a file open or selected in the project drawer, its containing directory is opened in Finder with the file selected (the OS X term is "revealed"). With a directory, it's just plain opened in Finder. With an unsaved file, your home directory is opened.

Both commands intentionally have the same shortcut, so TextMate presents you with a disambiguation menu. "Open Terminal" can be triggered with <code class="kb">⌃⇧O</code>, then <code class="kb">1</code> or <code class="kb">T</code>, then <code class="kb">↩</code> and "Open Finder" with <code class="kb">⌃⇧O</code>, then <code class="kb">2</code> or <code class="kb">F</code>, then <code class="kb">↩</code>.

The command is available as [a Gist](http://gist.github.com/129167). [Download it](http://gist.github.com/gists/129167/download), unpack it and double-click `Open Finder.tmCommand` to install.

I think I've written a command for this before, but I couldn't find it, so I made a new one. If you have my old command, it would be interesting to see.
