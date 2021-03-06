---
wordpress_id: 51
title: Minor updates to Greasemonkey bundle
tags:
- Greasemonkey
- JavaScript
- OS X
- TextMate
- Firefox
comments: true
---
Updated the Greasemonkey bundle, originally <a href="/2006/08/improved-greasemonkey-bundle-for-textmate/">blogged here</a>.

<a href="/uploads/Greasemonkey.tmbundle.zip">Download</a> (44 kB).

<p class="center"><img src="/uploads/gmbundle2.png" alt="[Screenshot]" class="bordered" /></p>

<!--more-->

Most of the changes are behind the scenes, moving code into the <code>Support</code> folder for easier development and reuse. Error handling when "Enable assistive devices" is off was improved.

## Snippets

The snippets <code>get</code>, <code>set</code>, <code>log</code>, <code>css</code> and <code>xhr</code> were added, tied to the obvious <code>GM_</code> functions.

## Commands

Two commands were added.

### Manage GM_Values

Opens <code>about:config</code> in Firefox and filters by the script being edited, exposing any <code>GM_setValue()</code> values to view and edit.

Caveats: "Enable access for assistive devices" must be toggled on in the Universal Access prefpane, otherwise filtering will not work.

### Open Installed Script (Chronological)&hellip;

Like the previous "Open Installed Script" command, but in descending order of time installed.

<div class="updated">
<h5>Update 2006-03-05</h5>
<p><a href="/2007/03/major-update-to-the-textmate-greasemonkey-bundle/">Updated</a>.</p>
</div>
