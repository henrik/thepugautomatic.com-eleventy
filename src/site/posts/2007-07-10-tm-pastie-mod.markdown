---
wordpress_id: 164
title: TextMate "Paste Line/Selection Online" command mod
categories:
- Ruby
- OS X
- TextMate
date: 2007-07-10 00:33
layout: post
comments: true
---
The "Paste Line/Selection Online" (a.k.a. "<a href="http://pastie.caboo.se/">Pastie</a>") command in TextMate is great. You can send code straight from the buffer to a paste service with a keyboard shortcut (<code>&#x2303;&#x2325;&#x21E7;V</code>).

The command opens a very full-featured dialog:

<p class="center"><img src="http://henrik.nyh.se/uploads/tm_pastie-standard.png" alt="[The standard dialog]" /></p>

You can have the pastie URL sent to <a href="http://colloquy.info/">Colloquy</a> (IRC) or <a href="http://adiumx.com/">Adium</a> (IM). I never use this. I just want it to go into my clipboard. From there, I can paste it into an IRC or IM message. Selecting the right conversation in the dialog is more work, and only the URL is sent: you have to set things up before or quickly explain yourself.

<!--more-->

Furthermore, sometimes pasting will take several seconds. I've found myself pasting and undoing repeatedly until the URL appears. TextMate will flash a tooltip when pasting is done, but that doesn't help you if you're in another app by then.

Oh, and the only thing I really want to choose is the privacy level: if the paste should be public for everyone to see, or private. In the standard dialog, the privacy setting is a checkbox that requires using the mouse or tabbing extensively.

<h4>Bah!</h4>

I made a new front-end for the command that does what I want and nothing more:

<p class="center"><img src="http://henrik.nyh.se/uploads/tm_pastie-mod.png" alt="[Modified dialog]" /></p>

You just press <code>&#x21A9;</code> to paste it as private, hit the space bar to paste it as public, or <code>&#x238B;</code> to cancel. The URL is copied to clipboard.

The rationale for having "Private" be the default button is that it's the less "dangerous" action – it's no big deal to make code private that was really meant to be public, but it would suck to get it wrong the other way around. Also, most of the time, I don't care to have pastes available to people I didn't give the URL to.

Oh, and the command <a href="http://growl.info/">Growl</a>s when done:

<p class="center"><img src="http://henrik.nyh.se/uploads/tm_pastie-growl.png" alt="[Growl dialog]" /></p>

<a href="http://henrik.nyh.se/uploads/pastie_mod.tmCommand">Get it here</a>. Note that it replaces the default Pastie command (same guid).

You need <a href="http://growl.info/">Growl</a> with <a href="http://growl.info/documentation/growlnotify.php">growlnotify</a>.

There is no option for soft-wrapping. I never used that checkbox. The default smarts is to soft-wrap text and not wrap code (based on the grammar scope). Works for me.

You can easily configure the script to not Growl or copy to clipboard, and to <em>do</em> open the URL in the default browser or whatever else you prefer that the old dialog did.

<div class="updated">
<h5>Update 2007-07-11</h5>
I realized I'd prefer it to pastie <em>document</em> or selection, not <em>line</em> or selection. If you agree, get <a href="http://henrik.nyh.se/uploads/pastie_mod2.tmCommand">this version of the command</a> instead. So if no text is selected, it will pastie the entire document contents instead of the current line.

I also updated both the old and the new versions of the command to ensure they finish copying to clipboard before growling; before this update, it would actually growl just before copying.
</div>

<div class="updated">
<h5>Update 2007-09-21</h5>
Both versions of the command have been updated to use the URL <code>http://pastie.textmate.org/pastes</code> instead of the deprecated <code>http://pastie.textmate.org/pastes/create</code>.
</div>

<div class="updated">
<h5>Update 2007-10-27</h5>
Both versions of the command have been updated since the way to get the user's name has changed.

By default, your name will go to Pastie as "Real Name (username)". If you want to use something else, set the <code>TM_AUTHOR</code> <a href="http://macromates.com/textmate/manual/environment_variables#static_variables">environment variable</a>.

Another minor change is that the command now uses <code>/usr/local/bin/growlnotify</code> if it can't be found elsewhere in your PATH. This means no <a href="http://macromates.com/textmate/manual/shell_commands#search_path">painful search path configuration</a> if you stick it where it wants to go.
</div>
