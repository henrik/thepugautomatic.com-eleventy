---
wordpress_id: 214
title: "del.ishli.st \xE2\x80\x93 a del.icio.us wishlist"
categories:
- Ruby
- Merb
date: 2008-02-23 21:44
layout: post
comments: true
---
Like <a href="http://del.icio.us/tags/wishlist">many others</a>, I tag things I want with <code>wishlist</code> on <a href="http://del.icio.us">del.icio.us</a>.

I've long been wanting a decent wishlist site, and at one point I realized I could build one on top of del.icio.us. It's not done (whatever that means), but I think it's ready for public use.

I call it <a href="http://del.ishli.st">del.ishli.st</a>.

<p class="center"><a href="http://del.ishli.st/malesca"><img src="http://henrik.nyh.se/uploads/delishlist.png" class="bordered"></a></p>

<!--more-->

The url scheme is the same as on del.icio.us: <a href="http://del.ishli.st/malesca">del.ishli.st/malesca</a> is my list, and <a href="http://del.ishli.st/malesca/book+nonfiction">del.ishli.st/malesca/book+nonfiction</a> are my wishlist items with both those tags.

<a href="http://del.ishli.st#features">The "Features" column on del.ishli.st</a> is required reading.

Two caveats:

It's a bit messed up in Internet Explorer. I'll get to that some day when I deserve it.

The list (and the tag description) is cached for 15 minutes. So if you edit or add something, you may have to wait 15 minutes before you can see it.

I stumbled across <a href="http://wantz.it/">wantz.it</a> the other day, which is another site that also builds a wishlist around del.icio.us. I haven't really tried it out, but it seems quite different: it requires authentication (my site doesn't), lists are non-public, lists are not pretty… ;) For the record, the <code>del.ishli.st</code> domain name (and the first, non-advertised version of the site) predates <code>wantz.it</code>, though I'm sure it was conceived independently.

For the nerds in the audience: the site was my excuse to toy with <a href="http://merbivore.com/">Merb</a> and <a href="http://jquery.com/">jQuery</a>.

I'd be very interested to hear feedback on the site.
