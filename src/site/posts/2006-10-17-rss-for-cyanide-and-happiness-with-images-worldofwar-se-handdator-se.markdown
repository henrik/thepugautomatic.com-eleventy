---
wordpress_id: 71
title: RSS for Cyanide and Happiness (with images), WorldOfWar.se, Handdator.se
categories:
- PHP
date: 2006-10-17 00:46
layout: post
comments: true
---

## Update 2012-08-07

Sorry, these feeds are going away as I don't use them and don't want to maintain them.

There is a [Cyanide and Happiness feed with images here](http://pipes.yahoo.com/pipes/pipe.run?_id=9b91d1900e14d1caff163aa6fa1b24bd&_render=rss) that seems just as good.

## Old post

I discovered the web comic <a href="http://www.explosm.net/comics">Cyanide and Happiness</a> a few hours ago. Good stuff.

Alas, their RSS feed didn't include the comic images inline. Easily solved &ndash; I wrote a PHP wrapper around the feed that finds and injects the images. Get the <a href="http://henrik.nyh.se/scrapers/cyanide_and_happiness.rss">improved feed</a>.

While I'm blogging this, I'll mention two other feeds I'm <a href="http://en.wikipedia.org/wiki/Web_scraping">scraping</a> since a while back, in case anyone else is interested:

A <a href="http://henrik.nyh.se/scrapers/worldofwar.se.rss">feed</a> for <a href="http://worldofwar.se/">WorldOfWar.se</a>.

A <a href="http://henrik.nyh.se/scrapers/handdator.se.rss">feed</a> for <a href="http://www.handdator.se">Handdator.se</a>, which doesn't interest me anymore, but I'll leave it up until it breaks.

All three scripts cache scraped data, so the site owners should not have cause to complain.
