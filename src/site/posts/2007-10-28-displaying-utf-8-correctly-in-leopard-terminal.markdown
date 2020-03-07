---
wordpress_id: 187
title: Displaying UTF-8 correctly in Leopard Terminal
categories:
- OS X
date: 2007-10-28 21:32
layout: post
comments: true
---
On my fresh Leopard install, UTF-8 didn't quite work in Terminal.

<div class="updated">
<h5>Update</h5>

After discussions with <a href="http://macromates.com">Allan</a> who had noticed similar issues, it seems that this issue is due to some bug you may run into when customizing your region formats in the International preference pane; so see this post as a solution if you run into that as well.

If you haven't customized the formats, or you selected a region and later customized that, you probably don't have this issue.
</div>

A file named <code>täst</code> was displayed by e.g. <code>ls</code> as

    t??st

<!--more-->

This was even after adding

``` bash
export LC_CTYPE=sv_SE.UTF-8
```
as described in <a href="http://desp.night.pl/terminal.html">desp's guide</a>. You might want to set <code>en_US.UTF-8</code> if you're American, and so on.

Unchecking the "Set LANG environment variable on startup" checkbox in the Terminal settings, under the "Advanced" tab, fixes it though. I've tested this in both bash and zsh.

<p class="center"><img src="http://henrik.nyh.se/uploads/leopard-terminal-langcheck.png" class="bordered" alt="" /></p>

When the box is checked, the <code>locale</code> command returns (among other things)

``` text
LANG="UTF-8"
LC_CTYPE="C"
```
It seems to overwrite my <code>LC_CTYPE</code>. With it unchecked, I get

``` text
LANG=
LC_CTYPE="sv_SE.UTF-8"
```
and <code>ls</code> now displays

    täst

as it should.
