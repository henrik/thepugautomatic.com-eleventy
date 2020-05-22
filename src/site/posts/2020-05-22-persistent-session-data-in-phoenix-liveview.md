---
title: Persistent session data in Phoenix LiveView
tags:
  - Elixir
  - Phoenix LiveView
---

I wrote previously about how to save persistent session data [in the DB](/2019/05/persistent-session-data-via-localstorage-in-phoenix-liveview) or [in localStorage](/2019/05/persistent-session-data-via-a-database-in-phoenix-liveview) with [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view).

Third time's the charm – I now have a solution for storing it in the actual Plug/Phoenix session, based in large part on a solution that [Martin Svalin](https://twitter.com/martinsvalin) shared.

The problem, again, is that there's no obvious way to save persistent session data in LiveView.

For example, I might implement a chat and want it to remember your username even if the page is reloaded, or you quit your browser and come back the next day.

LiveView is stateful, but keeps its state in a process that quits when you leave the page.

And since it only makes a single HTTP request initially to load the page (after that, it's all via WebSocket), we can't just set cookies or modify the Plug/Phoenix session as directly as we're used to – but as it turns out, we can do it in a roundabout way.

By default, Phoenix session data is stored in a cookie that is signed but not encrypted – the user can read it but can't modify it. Like `localStorage`, the data is stored client-side, so there's no need for a database dependency, and no need to worry about when to expire old session data. Unlike `localStorage`, it can be read server-side and can thus be present on the very first render of a LiveView.


## Solution

I'm using LiveView 0.13.0.

A LiveView can't write to the session directly, so we'll instead have it trigger an Ajax request to our Phoenix app, which updates the session.

First, I modified my router to provide the endpoint for that Ajax call:

{% filename "lib/my_app_web/router.ex" %}
``` elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  # …browser pipeline and routes…

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", MyAppWeb do
    pipe_through :api

    post "/session", SessionController, :set
  end
end
```

Then I added the corresponding controller. It accepts only known keys ("username" and "some_other_value"). If we would blindly accept *any* key, users could set keys like "current_user_id", and nothing in the session could be trusted.

{% filename "lib/my_app_web/controllers/session_controller.ex" %}
``` elixir
defmodule MyAppWeb.SessionController do
  use MyAppWeb, :controller

  def set(conn, %{"username" => username}), do: store_string(conn, :username, username)
  def set(conn, %{"some_other_value" => some_other_value}), do: store_string(conn, :some_other_value, some_other_value)

  defp store_string(conn, key, value) do
    conn
    |> put_session(key, value)
    |> json("OK!")
  end
end
```

Then I made sure session cookies survive a restarted browser by setting `max_age`. Without this, your persistent data would only live for the duration of the browser session. If that's what you want, skip this step.

{% filename "lib/my_app_web/endpoint.ex" %}
``` elixir
defmodule MyAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app

  @session_options [
    store: :cookie,
    max_age: 9999999999,  # Over 300 years.
    key: "_my_app_key",
    signing_salt: "abc123"
  ]

  # …
end
```

Next, I define a [LiveView hook](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#module-js-interop-and-client-controlled-dom) to actually make this Ajax request.

In my case, I trigger the requests as you type (with a bit of debouncing so it doesn't happen on every single keystroke), but your needs may differ. You could do this on blur instead, or on submit – with blur, you'd need to attach the hook to each form field and modify it accordingly.

{% filename "assets/js/app.js" %}
``` js
let Hooks = {}
Hooks.SetSession = {
  DEBOUNCE_MS: 200,

  // Called when a LiveView is mounted, if it includes an element that uses this hook.
  mounted() {
    // `this.el` is the form.
    this.el.addEventListener("input", (e) => {
      clearTimeout(this.timeout)
      this.timeout = setTimeout(() => {
        // Ajax request to update session.
        fetch(`/api/session?${e.target.name}=${encodeURIComponent(e.target.value)}`, { method: "post" })

        // Optionally, include this so other LiveViews can be notified of changes.
        this.pushEventTo(".phx-hook-subscribe-to-session", "set_session", [e.target.name, e.target.value])
      }, this.DEBOUNCE_MS)
    })
  },
 }

// Modifying this pre-existing code to include the hook.
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks,
})
```

And finally, I add a `phx-hook` attribute to the form so that this hook will actually run:

{% filename "lib/my_app/live/chat_live.html.leex" %}
``` elixir
<form phx-hook="SetSession">
  <input type="text" name="username" value="<%= @username %>" />
</form>
```

That's it!

Now, any LiveView can load this data on mount:

{% filename "lib/my_app/live/settings_live.ex" %}
``` elixir
defmodule MyAppWeb.SettingsLive do
  use MyAppWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, username: session["username"])}
  end
end
```

If, [like me](https://elixirforum.com/t/tabbed-interface-with-multiple-liveviews/31670), you've got multiple sibling LiveViews mounted at the same time and want an updated session in one to affect another, that's possible too.

The hook above does

``` js
this.pushEventTo(".phx-hook-subscribe-to-session", "set_session", [e.target.name, e.target.value])
```

This means that any LiveView can receive updates by putting the `phx-hook-subscribe-to-session` class anywhere in the rendered output, and listening to the `"set_session"` event:

{% filename "lib/my_app/live/other_live.ex" %}
``` elixir
defmodule MyAppWeb.OtherLive do
  use MyAppWeb, :live_view

  def render(assigns) do
  ~L"""
  <div class="phx-hook-subscribe-to-session">
    <p>Hello, <%= @username %>!</p>
  </div>
  """
  end

  # Loads session data on mount.
  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, username: session["username"]}
  end

  # Also updates session data when notified.
  @impl true
  def handle_event("set_session", ["username", username], socket) do
    {:noreply, assign(socket, username: username)}
  end
end
```

As always, I would love feedback and alternative solutions. Please write a comment below or [on Twitter](https://twitter.com/henrik)!
