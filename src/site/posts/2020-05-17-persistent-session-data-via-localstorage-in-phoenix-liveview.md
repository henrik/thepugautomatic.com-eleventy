---
title: Persistent session data via localStorage in Phoenix LiveView
tags:
  - Elixir
  - Phoenix LiveView
---

There's no obvious way to save persistent session data in [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view).

For example, I might implement a chat and want it to remember your username even if the page is reloaded, or you quit your browser and come back the next day.

LiveView is stateful, but keeps its state in a process that quits when you leave the page.

And since it only makes a single HTTP request initially to load the page (after that, it's all via WebSocket), we can't just set cookies or modify the Plug/Phoenix session like we're used to.

I solved this by putting data in client-side [`localStorage`](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) using [LiveView hooks](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#module-js-interop-and-client-controlled-dom).

## Solution

I'm using LiveView 0.12.1.

First, I modified `app.js` to define a "StoreSettings" hook:

{% filename "assets/js/app.js" %}
``` js
let Hooks = {}
Hooks.StoreSettings = {
  // Called when a LiveView is mounted, if it includes an element that uses this hook.
  mounted() {
    // Send a "restore" event to the LiveView, including the stored username.
    // If nothing is stored yet, we'll send a `null` value.
    this.pushEvent("restore", {
      username: localStorage.getItem("username"),
    })

    // `this.el` will be a form, so `this.el.username` will be the field named "username".
    // When this field is changed, store its value.
    this.el.username.addEventListener("input", e => {
      localStorage.setItem("username", e.target.value)
    })
  },
}

// Modifying this pre-existing code to include the hook.
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
})
```

Then, in my LiveView module, I handle the "restore" event we pushed above:

{% filename "lib/my_app/live/chat_live.ex" %}
``` elixir
def handle_event("restore", %{"username" => username}, socket) do
  {:noreply, assign(socket, username: username)}
end
```

And finally, I add a `phx-hook` attribute to the form so that this hook will actually run:

{% filename "lib/my_app/live/chat_live.html.leex" %}
``` elixir
<form phx-hook="StoreSettings">
  <input type="text" name="username" value="<%= @username %>" />
</form>
```

And that's all we need!

When the LiveView mounts, it receives a "restore" event containing any stored data, and updates its state.

When the username changes in the form, the value is immediately put in localStorage, so it can be restored later.

## Discussion

One downside of this solution is that the LiveView will first render without the stored data, so there will be a brief flash of an empty value (or whatever default value you set on `mount`) before the value is restored.

Another solution I considered would be to store a unique identifier in the session, make sure this is passed to the LiveView when it's mounted, then store the data under this identifier in a relational database or somewhere like Redis. The LiveView can then get or set data as it pleases.

That is conceptually very similar to having a database-backed session store, but LiveView would access this store outside the HTTP request/response cycle. I didn't go this route simply because it seemed more complex, though it would avoid that brief flash of the default value, and avoid one round of re-rendering.

Chris McCord, creator of LiveView, has shared [example code for storing form data in URL params](https://gist.github.com/chrismccord/5d2f6e99112c9a67fedb2b8501a5bcab) – this means data will survive reloads, but will not (by design) survive revisiting the site without those params. He also [seems to suggest](https://news.ycombinator.com/item?id=21101081) there may be a "stash" feature to come in LiveView, though I don't know how persistent that is intended to be.

I'm new to LiveView and would love feedback and alternative solutions. Please write a comment below or [on Twitter](https://twitter.com/henrik/status/1262007554881839106)!
