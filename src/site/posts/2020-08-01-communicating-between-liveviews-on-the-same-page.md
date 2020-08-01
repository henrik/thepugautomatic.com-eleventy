---
title: Communicating between LiveViews on the same page
tags:
  - Elixir
  - Phoenix LiveView
---

If you have multiple LiveViews on the same page, it's perhaps not obvious how they can communicate with one another. This post describes a few ways.

First off, consider whether you want to use multiple LiveViews at all, or if a single LiveView containing components would be more suitable. (In [my case](https://github.com/barsoom/ex-remit), I went with multiple LiveViews so each could be more self-contained, with its own timers and so on.)

I'm using LiveView 0.14.4.


## Parent to child via `:session` and `:id`

A parent LiveView [can pass "session" data](http://hexdocs.pm/phoenix_live_view/0.14.3/Phoenix.LiveView.Helpers.html#live_render/3) to a child LiveView:

{% filename "lib/my_app_web/live/parent_live.ex" %}
``` elixir
def render(assigns) do
  ~L"""
  <%= live_render @socket, MyAppWeb.ChildLive,
      id: :child,
      session: %{"hello" => @world}
  %>
  """
end
```

But it's only passed once, when the child is mounted. If the `world` assign is later changed in the parent, the child won't update automatically.

We can fix this by including the assign in the child's ID:

{% filename "lib/my_app_web/live/parent_live.ex" %}
``` elixir
def render(assigns) do
  ~L"""
  <%= live_render @socket, MyAppWeb.ChildLive,
      id: "child_#{@world}",
      session: %{"hello" => @world}
  %>
  """
end
```

Now, whenever the ID changes, the child will be unmounted and remounted.

A downside to remounting is that all of the child's state will be reset – we're not just updating the `world` value and leaving everything else as-is.

Note that you may need to do `id: "child_#{inspect(@some_assign)}"` [depending on its type](/2016/01/elixir-string-interpolation-for-the-rubyist).


## Child to parent via `send`

Because each LiveView is a process, you can `send` messages between them, as long as you know the PID.

Conveniently, the socket contains the `parent_pid`, so sending a message from a child LiveView to its parent LiveView is easy:

{% filename "lib/my_app_web/live/child_live.ex" %}
``` elixir
# Let's assume this is triggered by clicking some link.
@impl true
def handle_event("say_hello_to_parent", _params, socket) do
  send(socket.parent_pid, {:hello, "world"})
  {:noreply, socket}
end
```

{% filename "lib/my_app_web/live/parent_live.ex" %}
``` elixir
@impl true
def handle_info({:hello, message}, socket) do
  IO.inspect message
  {:noreply, socket}
end
```

There is also a `root_pid` to access the root LiveView, if they're nested more deeply.

Both `parent_pid` and `root_pid` are [documented in the typespec](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Socket.html#t:t/0), which means it's fine to rely on them – they're part of the public API.


## Parent to child via `send`

The socket doesn't include child PIDs out of the box, but we can have children send their PIDs to the parent on [connected mount](http://hexdocs.pm/phoenix_live_view/0.14.3/Phoenix.LiveView.html#connected?/1):

{% filename "lib/my_app_web/live/child_live.ex" %}
``` elixir
# Send child PID to parent on child mount.
@impl true
def mount(_params, _session, socket) do
  if connected?(socket) do
    send(socket.parent_pid, {:child_pid, self()})
  end
end

# Receive message from parent.
@impl true
def handle_info({:hello, message}, socket) do
  IO.inspect message
  {:noreply, socket}
end
```

{% filename "lib/my_app_web/live/parent_live.ex" %}
``` elixir
# Receive and store child PID.
@impl true
def handle_info({:child_pid, pid}, socket) do
  {:noreply, assign(socket, child_pid: pid)}
end

# Send message to child.
# Let's assume this is triggered by clicking some link.
@impl true
def handle_event("say_hello_to_child", _params, socket) do
  send(socket.assigns.child_pid, {:hello, "world"})
  {:noreply, socket}
end
```

Be mindful of the timing here – some callbacks in the parent (like [`handle_params`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_params/3)) may happen before the child PID is known.

If you try to `send` to a child PID after it has been unmounted, it will silently do nothing. (Just like `send`ing to any PID where the process is no longer alive.)


## Sibling to sibling with a shared ancestor via `send`

What about two sibling LiveViews?

If they share an ancestor LiveView, we can use a variation on the previous technique:

The children send their PIDs to their parent or the root, which stores them.

Child 1 can then send a payload like `{:tell_child_2, {:hello, "world"}}` for the parent or root to pass on:

{% filename "lib/my_app_web/live/parent_live.ex" %}
``` elixir
@impl true
def handle_info({:tell_child_2, message}, socket) do
  send(socket.assigns.child_2_pid, message)
  {:noreply, socket}
end
```

{% filename "lib/my_app_web/live/child_2_live.ex" %}
``` elixir
@impl true
def handle_info({:hello, message}, socket) do
  IO.inspect message
  {:noreply, socket}
end
```

## Anything with a shared ancestor via PubSub

Alternatively, we can use [PubSub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html) to communicate between anything on the same page (whether siblings, ancestor/descendant, or cousins twice removed), as long as they have a shared ancestor LiveView.

See [the PubSub docs](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html) for how to set it up. At the time of writing, you just need to add it to your supervision tree.

For the purposes of this blog post, we will restrict PubSub to updates within the current page. If you want to send some update for every user (e.g. new messages in a chat room), or every tab/window opened by the current user, PubSub can do that too.

We'll use the socket's `root_pid` in the PubSub topic as a way of uniquely identifying the current page. Again, this relies on them having a shared ancestor. Two sibling LiveViews without a shared ancestor will each have their own PID as their `root_pid`.

Anyone who wants to receive messages can subscribe on connected mount, and set up a handler:

{% filename "lib/my_app_web/live/child_1_live.ex" %}
``` elixir
@impl true
def mount(_params, _session, socket) do
  if connected?(socket) do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "page_#{inspect(socket.root_pid)}")
  end
end

@impl true
def handle_info({:hello, message}, socket) do
  IO.inspect message
  {:noreply, socket}
end
```

Then any other LiveView with the same `root_pid` can send messages:

{% filename "lib/my_app_web/live/child_2_live.ex" %}
``` elixir
# Let's assume this is triggered by clicking some link.
@impl true
def handle_event("say_hello_to_page", _params, socket) do
  Phoenix.PubSub.broadcast_from!(MyApp.PubSub, self(), "page_#{inspect(socket.root_pid)}", {:hello, "world"})
  {:noreply, socket}
end
```

(By using [`broadcast_from!/5`](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html#broadcast_from!/5) rather than [`broadcast!/4`](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html#broadcast!/4), the sending process won't itself receive the broadcast even if it's a subscriber.)

You could probably use [the process registry](https://hexdocs.pm/elixir/Process.html#register/2) instead of PubSub, but process registry names must be atoms, which aren't garbage collected, so it isn't advisable – each page would use a bit more memory that is never reclaimed, and you might eventually hit [the atom limit](https://til.hashrocket.com/posts/b9giaqz4lc-current-number-of-atoms-in-the-atoms-table).

I assume that using PubSub will use more resources than just relying on `send`, especially on a high-traffic site, since it keeps track of subscribers.

## Anything (without needing a shared ancestor) via PubSub

If you have a user ID or session ID, you could use that with PubSub instead of the `root_pid`… but if the same user has multiple tabs or windows open in the same browser, all those windows would be affected – not just the current one.

To target only the current page, you could generate a unique per-page identifier and use that in the PubSub topic:

{% filename "lib/my_app_web/controllers/my_controller.ex" %}
``` elixir
def show(conn, _params) do
  # Assuming you use Ecto.
  page_id = Ecto.UUID.generate()

  html(conn, """
    <%= live_render @socket, MyAppWeb.OneLive, session: %{"page_id" => page_id} %>
    <%= live_render @socket, MyAppWeb.TwoLive, session: %{"page_id" => page_id} %>
  """)
end
```

{% filename "lib/my_app_web/live/one_live.ex" %}
``` elixir
@impl true
def mount(_params, %{"page_id" => page_id}, socket) do
  if connected?(socket) do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "page_#{page_id}")
  end
end
```

And so on.

## That's it!

I'll leave it to the reader to determine which of these techniques, if any, is most suitable to your use case.

As always, I'm very happy to receive feedback either in the comments or [on Twitter](https://twitter.com/henrik)!
