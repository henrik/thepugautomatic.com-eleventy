// ==UserScript==
// @name          Test iframe
// @namespace     http://henrik.nyh.se
// @description   Description.
// @include       *
// ==/UserScript==


var css = 'position:fixed; top:50%; left:50%; width:30em; height:20em; margin-left:-15em; margin-top:-10em; border:1px solid #000';

var iframe = document.createElement('iframe');
iframe.setAttribute('style', css);
iframe.setAttribute('src', 'about:blank');

document.body.appendChild(iframe);

var iframeWindow = unsafeWindow.frames[unsafeWindow.frames.length-1];
var doc = iframeWindow.document;

doc.body.style.background = 'red';
doc.body.innerHTML = 'TEST';
