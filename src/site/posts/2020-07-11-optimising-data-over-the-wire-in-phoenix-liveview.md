---
title: Optimising data-over-the-wire in Phoenix LiveView
tags:
  - Elixir
  - Phoenix LiveView
---

[Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) distinguishes itself from other "server-side reactive" frameworks[¹](#footnote) by automatically sending minimal diffs over the wire. (That is to say, over a WebSocket.)

Well, mostly automatically. The size of those diffs is affected by how you write your app.

I tried three different ways and compared the amount of data sent over the wire.

In these examples, we have a toy app that lists items numbered 1 through 300, with a button on each to replace it with a random new number.

![Screenshot of the toy app](/images/content/2020-07-11/randomise.png)

I'm using LiveView 0.14.1 and looking at the WebSocket data using Chrome's Web Inspector.

![Screenshot of WebSocket data in Web Inspector](/images/content/2020-07-11/inspector.png)

Please verify this information if you're on another version of LiveView – things are moving fast.


## 1. The naive approach

This might be described as the naive approach – simply looping over a list of items.

``` elixir
defmodule MyAppWeb.NaiveLive do
  use Phoenix.LiveView

  defmodule Item do
    defstruct [:id, :name]
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= for item <- @items do %>
      <p id="item-<%= item.id %>">
        <%= item.name %>
        <button phx-click="randomise" phx-value-id="<%= item.id %>">
          Randomise
        </button>
      </p>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    items = Enum.map(1..300, fn i ->
      %Item{id: i, name: "Item #{i}"}
    end)

    {:ok, assign(socket, list: list)}
  end

  @impl true
  def handle_event("randomise", %{"id" => id}, socket) do
    id = String.to_integer(id)

    list = Enum.map(socket.assigns.list, fn item ->
      if item.id == id do
        %{item | name: "Item #{:rand.uniform(999)}"}
      else
        item
      end
    end)

    {:noreply, assign(socket, list: list)}
  end
end
```

The first-render message payload is 7431 bytes (7.4 KB). The bulk of that is the `id` attribute, name and `phx-value-id` of each item:

> ["4","4","lv:phx-FiCy2Z_WdisCVxBD","phx_reply",{"response":{"rendered":{"0":{"d":[["1","Item 1","1"],<span class="truncated">…truncated…</span>,["300","Item 300","300"]],"s":["\n  <p id=\"item-","\">\n    ","\n    <button phx-click=\"randomise\" phx-value-id=\"","\">\n    Randomise\n    </button>\n  </p>\n"]},"s":["","\n"]}},"status":"ok"}]

When I click "Randomise" on Item 50, the update message is 7274 bytes – so almost the same size as the initial message:

> ["4","5","lv:phx-FiCy2Z_WdisCVxBD","phx_reply",{"response":{"diff":{"0":{"d":[["1","Item 1","1"],<span class="truncated">…truncated…</span>,["300","Item 300","300"]]}}},"status":"ok"}]

It doesn't need to send the "statics" again (the non-dynamic parts that are the same for every item), but it re-renders and re-sends all the dynamic parts.

And of course this grows linearly – with 3000 items instead of 300, both payloads are about 10 times bigger.


## 2. Temporary assigns

[Temporary assigns](https://hexdocs.pm/phoenix_live_view/dom-patching.html) is a way of optimising both the amount of data transfered and the memory used in each LiveView process. (Every user gets their own process – one per LiveView on the page.)

With this approach, we'll send all 300 items on the first render, and then the LiveView process stops storing them.

When we update an item, we only re-render that single item on the backend, and only send that diff in the update message to the frontend.

``` elixir
defmodule MyAppWeb.TempLive do
  use Phoenix.LiveView

  defmodule Item do
    defstruct [:id, :name]
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div id="list" phx-update="append">
      <%= for item <- @items do %>
        <p id="item-<%= item.id %>">
          <%= item.name %>
          <button phx-click="randomise" phx-value-id="<%= item.id %>">
            Randomise
          </button>
        </p>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    items = Enum.map(1..300, fn i ->
      %Item{id: i, name: "Item #{i}"}
    end)

    {:ok, assign(socket, items: items), temporary_assigns: [items: []]}
  end

  @impl true
  def handle_event("randomise", %{"id" => id}, socket) do
    id = String.to_integer(id)

    item = %Item{id: id, name: "Item #{:rand.uniform(999)}"}

    {:noreply, assign(socket, items: [item])}
  end
end
```

With temporary assigns, the initial payload is 7498 bytes (it was 7431 with the naive approach):

> ["4","4","lv:phx-FiC0IVgqbVUCtxDG","phx_reply",{"response":{"rendered":{"0":{"d":[["1","Item 1","1"],<span class="truncated">…truncated…</span>,["300","Item 300","300"]],"s":["\n    <p id=\"item-","\">\n      ","\n      <button phx-click=\"randomise\" phx-value-id=\"","\">\n        Randomise\n      \</button>\n    \</p>\n  "]},"s":["<div id=\"list\" phx-update=\"append\">\n  ","\n\</div>\n"]}},"status":"ok"}]

It's almost identical to the first render in the naive approach, just with some extra markup needed for updates to work with temporary assigns.

But now for the fun part – the update is a mere 120 bytes (it was 7274 bytes with the naive approach). Shown here in full:

> ["4","8","lv:phx-FiC0IVgqbVUCtxDG","phx_reply",{"response":{"diff":{"0":{"d":[["50","Item 778","50"]]}}},"status":"ok"}]

LiveView just sends the data for the single item we changed.

And again, temporary assigns also reduce the amount of memory each LiveView process uses. The archetypal example is a chat: with thousands of messages and thousands of users, storing the full list for every user could use significant memory (e.g. 100 bytes per message * 10 000 messages * 10 000 users = 10 GB).

But there is also a downside. Because we no longer have the full list in state, some things get more complicated.

If we want to show a count of chat messages, they're not always there to be counted. We'd need to run a database query, or keep a count as state and make sure to increase it every time a new message comes in.

And note how the naive approach was able to take the original item struct and modify it, whereas this solution can't. In this toy app, we can just build a new one with the same ID. In a real app, we might need to retrieve it from a database.


## 3. Components

Our final approach is identical to the naive approach, except that we extract each item to its own component.


``` elixir
defmodule RemitWeb.ComponentsLive do
  use Phoenix.LiveView

  defmodule Item do
    defstruct [:id, :name]
  end

  defmodule ItemComponent do
    use Phoenix.LiveComponent

    @impl true
    def render(assigns) do
      ~L"""
      <p id="item-<%= @id %>">
        <%= @item.name %>
        <button phx-click="randomise" phx-value-id="<%= @id %>">
        Randomise
        </button>
      </p>
      """
    end
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= for item <- @items do %>
      <%= live_component @socket, ItemComponent, id: item.id, item: item %>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    items = Enum.map(1..300, fn i ->
      %Item{id: i, name: "Item #{i}"}
    end)

    {:ok, assign(socket, items: items)}
  end

  @impl true
  def handle_event("randomise", %{"id" => id}, socket) do
    id = String.to_integer(id)

    items = Enum.map(socket.assigns.items, fn item ->
      if item.id == id do
        %{item | name: "Item #{:rand.uniform(999)}"}
      else
        item
      end
    end)

    {:noreply, assign(socket, items: items)}
  end
end
```

The first-render message for this one is 16 553 bytes. It was 7431 with the naive approach and about the same with temporary assigns.

(It used to be bigger still, but [preparing to write this post](https://github.com/phoenixframework/phoenix_live_view/issues/912) led to some optimisations.)

Since the message is a bit more complex, I've prettified it:

``` json
["4","4","lv:phx-FiDB5JJXb8yL8TpB","phx_reply", {
  "response": {
    "rendered": {
      "0": {
        "d": [[1],…truncated…,[300]],
        "s": ["\n  ", "\n"]
      },
      "c": {
        "1": {
          "0": "1",
          "1": "Item 1",
          "2": "1",
          "s": [
            "<p id=\"item-",
            "\">\n  ",
            "\n  <button phx-click=\"randomise\" phx-value-id=\"",
            "\">\n  Randomise\n  </button>\n</p>\n"
          ]
        },
        "2": {
          "0": "2",
          "1": "Item 2",
          "2": "2",
          "s": 1
        },
        …truncated…,
        "300": {
          "0": "300",
          "1": "Item 300",
          "2": "300",
          "s": 234
        }
      },
      "s": [
        "",
        "\n"
      ]
    }
  },
  "status": "ok"
}]
```

The reason this initial payload is bigger than the others is that components come with some additional bookkeeping.

I don't know the ins and outs of the format, but I think the `[1],…,[300]` list helps track components if they're reordered, moved and so on. And I assume `s: 1` means "use the same statics as in component 1". (But I have no idea why it's not `s: 1` throughout.)

The update clocks in at 1818 bytes. The naive approach had 7274, and temporary assigns had 120.

> ["4","12","lv:phx-FiDB5JJXb8yL8TpB","phx_reply",{"response":{"diff":{"0":{"d":[[1],<span class="truncated">…truncated…</span>,[300]]},"c":{"50":{"1":"Item 450"}}}},"status":"ok"}]

Most of the bulk is the `[1],…,[300]` list, which I again believe is there to track the order of components.


## Summary

So which is the best approach?

I can't in good conscience recommend the naive approach. It *is* simplest, and perhaps it enough for some apps, but in most cases you want smaller update payloads. Otherwise every interaction will pay this tax, and the app may feel slow.

Also note that the naive approach actually *re-renders* all the items on every update, where the other approaches only re-render the (part of the) template for a single item.

Temporary assigns make for the smallest payloads (and memory use), but also give you more things to worry about, since the items don't remain in state.

The component approach comes with a bigger initial payload, which I think is usually acceptable. And it's worth noting that in a real app, there would likely be a lot more statics, and more data in each component, so the relative bulk of the `[1],…,[300]` list would be smaller.

The update payload is bigger than with temporary assigns, but again, in a real app with more data in each component, the difference to the naive approach would be greater, and the difference to temporary assigns would be smaller.

As you may suspect, I've gone with the component approach for [my app](https://github.com/barsoom/ex-remit), but your mileage may vary.

---

<div id="footnote"></div>

### Footnote

I believe other frameworks like [Laravel LiveWire](https://laravel-livewire.com/) and [Stimulus Reflex](https://stimulusreflex.com/) re-render the full page on the server and transfer the full page over the wire (Ajax or WebSocket), and then diff it on the client side.

LiveView's change tracking means it only re-renders the relevant parts of the template, and then (as discussed in this post) only transfers the parts that changed.

I don't know about LiveWire, but Stimulus Reflex lets you render just a template partial, and then target only a part of the page for updates – however, this is a more manual process than in LiveView.
