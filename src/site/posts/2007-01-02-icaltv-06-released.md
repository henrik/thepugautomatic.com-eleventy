---
wordpress_id: 90
title: iCalTV 0.6 released
tags:
- Ruby
- OS X
comments: true
---
Minor updates to iCalTV.

<a href="/uploads/iCalTV.zip">Download version 0.6 (244 KB).</a>

The download URLs have changed, so this is a necessary update. Just replace the old <code>iCalTV.app</code> with this one.

I also took the opportunity to fix a small bug. Previous versions stored some temporary data in <code>/tmp</code> which caused conflicts if there were multiple iCalTV users on the same computer.

<!--more-->

<div class="updated">
  <h5>Update 2007-01-04</h5>
  <p>Had left a debug line in 0.6 that caused the scheduled clean-up to produce output, which in turn causes a mail to be sent to the user in the terminal. Now fixed.</p>

<h5>Update 2007-01-31</h5>
<p><a href="/2007/01/icaltv-07-released-and-an-applescript-date-object-gotcha/">Version 0.7 has been released.</a></p>
</div>
