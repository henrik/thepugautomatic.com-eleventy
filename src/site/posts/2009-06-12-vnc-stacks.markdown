---
title: VNC Stacks in OS X
categories: [OS X, Leopard, VNC, Screen Sharing, Stacks]
date: 2009-06-12 21:10
layout: post
comments: true
---

![VNC stack screenshot](/images/content/2009-06-vnc-stack.png)

OS X Leopard comes with a VNC client, `/System/Library/CoreServices/Screen Sharing.app`.

Connecting to favorite servers isn't as easy as it should be. If the remote computer is in your local network, you can click "Share Screen" in Finder. You can also type a `vnc://` URI in a browser, do `open vnc://…` from Terminal etc.

As has been blogged [elsewhere](http://lifehacker.com/software/remote-control/add-more-functionality-to-leopards-screen-sharing-334759.php), you can run

    defaults write com.apple.ScreenSharing ShowBonjourBrowser_Debug 1

in Terminal to see a list of local and manually added computers on launching Screen Sharing. Turn it off again with

    defaults write com.apple.ScreenSharing ShowBonjourBrowser_Debug 0

What's less well known is that you can drag the computer names from this list to e.g. the desktop. This creates a `.vncloc` shortcut file. Double-click it to connect to that computer.

If you don't want to bother with the Bonjour browser, you can create them manually. They look like this:

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>URL</key>
	<string>vnc://Nyx.local.</string>
</dict>
</plist>
```

Just change the URI.

These shortcuts are handy, but I don't like them on my desktop, so I put them in a Stack.

First, I created a `~/Library/Remote Machines` directory and put the shortcuts in there. Then, I dragged it to the right-hand side (or bottom, in my case) of the dock, next to the Trash, where Stacks go.

That's it, really. The effect is a nice menu for your VNC favorites.

To make it look nicer, find an icon in `/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources`. It's one of the `com.apple.` files for a Mac, or `public.generic-pc` otherwise. Select the icon, run <code class="kb">⌘I</code>. Click the icon in the top left of the info pane (not the proxy icon in the title bar) so that it's highlighted, and copy it with <code class="kb">⌘C</code>. Select the `.vncloc` file, run <code class="kb">⌘I</code>, select its icon and paste with <code class="kb">⌘V</code>. Done!
