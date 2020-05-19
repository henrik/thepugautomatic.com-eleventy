---
title: Persistent session data via a database in Phoenix LiveView
tags:
  - Elixir
  - Phoenix LiveView
---

I [wrote previously](/2020/05/persistent-session-data-via-localstorage-in-phoenix-liveview) about how to save persistent session data in [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view) via `localStorage`.

I ultimately ended up storing session data in a PostgreSQL database instead, so I thought I'd write that up as well, with some discussion afterwards.

The problem, again, is that there's no obvious way to save persistent session data in LiveView.

For example, I might implement a chat and want it to remember your username even if the page is reloaded, or you quit your browser and come back the next day.

LiveView is stateful, but keeps its state in a process that quits when you leave the page.

And since it only makes a single HTTP request initially to load the page (after that, it's all via WebSocket), we can't just set cookies or modify the Plug/Phoenix session like we're used to.


## Solution

I'm using LiveView 0.12.1.

First, I modified my router to assign a `session_id` in the session via a Plug:

{% filename "lib/my_app_web/router.ex" %}
``` elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    # …the default ones…
    plug :assign_session_id
  end

  scope "/", MyAppWeb do
    pipe_through :browser

    live "/chat", ChatLive
  end

  defp assign_session_id(conn, _) do
    if get_session(conn, :session_id) do
      # If the session_id is already set, don't replace it.
      conn
    else
      session_id = Ecto.UUID.generate()
      conn |> put_session(:session_id, session_id)
    end
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

Now, every request in the app will have a unique session ID. This session ID is available as part of the session when a live view is mounted. You can use this session ID as a key to store and retrieve any data you like, with whatever database you like.

I went with a PostgreSQL database, since that's what my app uses for other data.

The migration for my table looks something like this:

{% filename "priv/repo/migrations/20200517214350_create_settings.exs" %}
``` elixir
defmodule MyApp.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :username, :string
      add :session_id, :uuid, null: false
      add :read_at, :utc_datetime_usec

      timestamps()
    end
  end
end
```

And the schema file looks something like this:

{% filename "lib/my_app/settings.ex" %}
``` elixir
defmodule MyApp.Settings do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias MyApp.{Repo,Settings}

  @stale_after_days 100

  schema "settings" do
    field :session_id, Ecto.UUID
    field :username, :string
    field :read_at, :utc_datetime_usec

    timestamps()
  end

  @doc false
  def changeset(settings, attrs) do
    settings
    |> cast(attrs, [:username, :session_id])
    |> validate_required([:session_id])
  end

  def for_session(%{"session_id" => sid}) do
    settings = Repo.get_by(Settings, session_id: sid)

    if settings do
      now = DateTime.utc_now()

      # Update `read_at` so we can track stale Settings.
      settings = settings |> Ecto.Changeset.change(read_at: now) |> Repo.update!

      # Delete stale Settings so DB doesn't keep them forever.
      # In this case, we delete them on every `for_session` call for simplicity.
      # If you prefer, do it in a scheduled background process, or skip it entirely.
      stale_before = now |> DateTime.add(-60 * 60 * 24 * @stale_after_days, :second)
      Repo.delete_all(from s in Settings, where: s.read_at < ^stale_before)

      settings
    else
      # Return an unpersisted "null object" for convenience.
      %Settings{session_id: sid}
    end
  end
end
```

And here's an example of how a live view could read and write settings:

{% filename "lib/my_app/live/settings_live.ex" %}
``` elixir
defmodule MyAppWeb.SettingsLive do
  use MyAppWeb, :live_view
  alias MyApp.{Repo,Settings}

  @impl true
  def mount(_params, session, socket) do
    settings = Settings.for_session(session)

    # `@settings` will now be available in templates,
    # and `socket.assigns.settings` in live views.
    socket = assign(socket, settings: settings)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <form phx-change="form_change">
       <input name="username" phx-debounce="100" value="<%= @settings.username %>" />
    </form>
    """
  end

  @impl true
  def handle_event("form_change", %{"username" => username}, socket) do
    settings = socket.assigns.settings
    changeset = settings |> Ecto.Changeset.change(username: username)
    settings = if settings.id, do: Repo.update!(changeset), else: Repo.insert!(changeset)

    {:noreply, assign(socket, settings: settings)}
  end
end
```

And that's it!


## Discussion

This requires a bit more work than [the `localStorage` version](/2020/05/persistent-session-data-via-localstorage-in-phoenix-liveview), but it feels more elegant to me.

Instead of rendering a page with empty session data and re-rendering it when we've loaded the data from the client, we've got the data from the very first render – even the static render that LiveView does before establishing a websocket and doing updates over the wire.

Using a database like this is conceptually very similar to having a database-backed session store, but LiveView accesses this store outside the HTTP request/response cycle. I suspect changing Phoenix to a database-backed session store and then accessing that from LiveView would be more complex than this solution, but I'd love to see it.

I'm still very new to LiveView and would love feedback and alternative solutions. Please write a comment below or [on Twitter](https://twitter.com/henrik)!
