---
wordpress_id: 230
title: Secure note in Keychain for credit card details
categories:
- OS X
date: 2008-04-23 17:55
layout: post
comments: true
---
OS X uses <a href="http://en.wikipedia.org/wiki/Keychain_%28Mac_OS%29">Keychain</a> to store encrypted passwords under a single master password (by default, your login password).

You can use <code>/Applications/Utilities/Keychain Access.app</code> to manage entries.

One kind of entry is the secure note: a piece of encrypted text.

I find it pretty handy to store my credit card details in a secure note. If I need to provide it when ordering something, I can copy-and-paste it right out of the note. You could store them in a plain text file, but then they wouldn't be password-protected and encrypted.

A related hint is to scratch the <a href="http://en.wikipedia.org/wiki/Card_Security_Code">CVV code</a> off of your card, after learning it by heart or storing it in your keychain – that way, if your card is lost or stolen, others can in many cases no longer use it for Internet transactions.
