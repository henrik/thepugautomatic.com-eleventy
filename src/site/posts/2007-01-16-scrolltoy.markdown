---
wordpress_id: 95
title: ScrollToY
categories:
- Greasemonkey
- JavaScript
- Bookmarklets
date: 2007-01-16 23:34
layout: post
comments: true
---
I hate it when image galleries have lots of content (often big headers) above the images, so that you end up scrolling down, going to the next image, scrolling down&hellip;

<a href="http://www.fz.se/bildarkiv/image.php?id=38805">This gallery</a> is one example.

On my 1280 x 800 pixel resolution screen, with Firefox maximized (in Windows terms), I have to scroll down 300 pixels or so every time I access a new image.

Or rather, had to. Lacking a larger screen, I wrote <a href="http://userscripts.org/scripts/show/7126">a small Greasemonkey script</a> that interacts with a tiny bookmarklet to ameliorate this problem.

<!--more-->

Once installed, every time you load a page, the script will check for a saved vertical scroll-to position for that host, and scroll there if there was one. It also creates a method to store the current position. The method is exposed so that it can be triggered by a bookmarklet.

I suggest you bookmark this with a keyword like "y": <a href="javascript:GM_setY()">Set ScrollToY</a>.

Using the script/bookmarklet combo is very easy. Scroll down below the header, and then trigger the bookmarklet. For all subsequent page visits on that host, you'll be automatically scrolled to that position.

The script considers a host to be the domain name along with any subdomains. <code>http://www.example.com/foo</code> and <code>http://www.example.com/bar</code> are on the same host. <code>http://www.example.com/</code> and <code>http://two.example.com</code> are not, because the subdomains differ. Hosts are normalized for <code>www.</code> though, so <code>http://www.example.com/</code> and <code>http://example.com</code> are considered the same.

To reset the scroll, just scroll to the very top and store that.
