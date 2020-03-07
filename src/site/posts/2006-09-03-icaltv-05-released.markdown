---
wordpress_id: 47
title: iCalTV 0.5 released
categories:
- Ruby
- OS X
date: 2006-09-03 20:19
layout: post
comments: true
---
<img src="http://henrik.nyh.se/uploads/icaltv0.5growl.png" alt="[Screenshot]" class="right" />

Finally, iCalTV 0.5 is finished. A lot of code has been rewritten, and some great stuff added.

Download <a href="http://henrik.nyh.se/filer/iCalTV0.5.zip">the application and README</a> (274 kB), or view <a href="http://henrik.nyh.se/filer/iCalTV.html">the README online</a> (49 kB due to an inline image).

<!--more-->

Because I opened iCal all the time to check stuff during development, it took me a while to realize iCal does in fact not update subscribed-to calendars unless you start the program and trigger it manually, or start it and wait for a couple of minutes. For this reason, I rewrote the code quite a lot, to post events to iCal using AppleScript instead.

Rid of the security restrictions on subscribed calendars, I could also add support for running scripts as reminders. This allows cool stuff like <a href="http://growl.info/">Growl</a> notifications and spoken reminders through <a href="http://www.apple.com/macosx/features/speech/">OS X's speech synthesis</a>. I also added support for multiple reminders.

For most of my favorite shows, I now hear e.g. "Morden i Midsomer on SVT1 in five minutes" along with a pretty, sticky Growl notification. A sticky notification does not hide automatically after a few seconds, so that I don't miss them if I'm temporarily elsewhere. Then one minute before the show starts, I get another spoken alert and a non-sticky Growl notification. It's quite lovely!

<div class="updated">
  <h5>Update 2007-01-02</h5>

  <p>
<a href="http://henrik.nyh.se/2007/01/icaltv-06-released/">iCalTV 0.6 has been released – the above post is outdated.</a></p>
</div>
