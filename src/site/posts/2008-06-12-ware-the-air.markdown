---
wordpress_id: 234
title: Ware the Air (core shutdown issue)
categories:
- OS X
- MacBook Air
date: 2008-06-12 19:36
layout: post
comments: true
---
I've had my <a href="http://www.apple.com/macbookair/">MacBook Air</a> for some three months now.

There are many things I love about it: even the lower-end 1.6 GHz version (the one I have) is fast enough for web development and leisure surfing/chatting/mailing; the light weight (as compared to the regular MacBook I had before) makes it painless to bring along just in case you might want to use it, and you can carry it from desk to bed in one hand with no effort; the build quality is amazing, and even durable – I've accidentally scratched it against the stone wall on our porch with no visible marks.

However, I would like to temper the positive reviews (mine and those of others) by pointing out a very, very annoying issue that seems relatively widespread: <a href="http://discussions.apple.com/thread.jspa?threadID=1445521&amp;messageID=7223308">the core shutdown issue</a>.

In a nutshell, every so often the <code>kernel_task</code> process uses a whole lot (usually 60%+) of CPU power on one core, while the other core shuts down completely. This seems to happen a lot more frequently with an external monitor connected, and when performing CPU-intensive tasks like watching Flash video.

I really, really like the computer, but this makes me less productive, makes my neck hurt (from using the external monitor less – class action suit anyone? ;p) and is generally frustrating. This blog post is intended to warn prospective buyers, and to light what small fire I can under Apple.

<!--more-->

It can occur even without a monitor connected and when doing other things than watching videos.

Putting the computer to sleep and waking it again (even immediately) tames <code>kernel_task</code> and brings the other core back to life, but the issue will typically recur pretty soon if you keep doing CPU-intensive things.

Some days this has happened 20+ times, others not at all, depending on how I use the computer.

Sitting in a cool place (temperature-wise!), e.g. the porch in the evening, seems to make it happen less.

I plan on taking my computer to an Apple Store when I have the chance; will update this post or write a new one when there's more to say.

I would be interested to hear from any Air owner that has <em>not</em> run into the issue, by the way. My boss has an Air and has seen this issue also.
