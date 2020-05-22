---
title: Delaying the NProgress indicator in Phoenix LiveView
tags:
  - Elixir
  - Phoenix LiveView
---

A default [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) project shows a [NProgress](http://ricostacruz.com/nprogress/) progress bar on live navigation and form submits.

This makes up for the fact that the browser won't show its regular feedback, since we're not doing traditional navigation or form submissions.

But seeing a progress bar for a quick navigation makes it *feel* slower.

So I modified the default callbacks to introduce a delay. Now it only appears after 100 ms, unless the navigation is done by then.

{% filename "assets/js/app.js" %}
``` js
// Show progress bar on live navigation and form submits
let progressTimeout = null
window.addEventListener("phx:page-loading-start", () => { clearTimeout(progressTimeout); progressTimeout = setTimeout(NProgress.start, 100) })
window.addEventListener("phx:page-loading-stop", () => { clearTimeout(progressTimeout); NProgress.done() })
```

(There is [an open issue](https://github.com/rstacruz/nprogress/issues/169) about adding a `delay` option to NProgress itself.)

From experimentation, 100 ms seemed about right for me, and [the science](https://stackoverflow.com/a/2547903/6962) seems to bear that out.

If you want to experiment with it yourself, LiveView's latency simulator is handy. Run e.g.

``` js
liveSocket.enableLatencySim(200)
```

in your browser's JavaScript console to simulate 200 ms latency from client to server.
