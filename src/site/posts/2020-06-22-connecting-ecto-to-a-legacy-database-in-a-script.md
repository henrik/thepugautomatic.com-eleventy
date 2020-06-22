---
title: Connecting Ecto to a legacy database in a script
tags:
  - Elixir
  - Ecto
---

I wanted to use Ecto in a script to read data from a legacy database, transform the data, and stick it in the new database.

The documentation focuses mostly on how to use Ecto with app-level configuration, in `config/config.exs` and friends.

But I didn't want to add app-level configuration for this one-off script. I just wanted to pass in the database URL.

After some experimentation, this works with Ecto 3.4:


{% filename "priv/repo/migrate_data.ex" %}
``` elixir
old_db_url = System.get_env("OLD_DB_URL") || raise("Missing OLD_DB_URL!")

defmodule OldRepo do
  use Ecto.Repo,
    otp_app: :my_app,
    adapter: Ecto.Adapters.Postgres,
    read_only: true  # Let's be safe, if we don't need to write.
end

# This bit is completely optional.
# You can skip it and do schemaless queries.
defmodule OldItem do
  use Ecto.Schema

  schema "items" do
    field :name, :string
    # and so on
  end
end

OldRepo.start_link(url: old_db_url, ssl: true)

# Verify it works, if you defined a schema.
IO.inspect count: OldRepo.aggregate(OldItem, :count)

# Verify it works, if you're schemaless.
IO.inspect count: OldRepo.aggregate("items", :count)
```

In my case, I wanted to run the code from my local machine but against production databases. So I also added a `new_db_url` and a `NewRepo` to the script, but used the schemas I already had in the app, e.g. `MyApp.Item`.

If I had been running the script in production, or wanted to copy to the development database, I could have used `MyApp.Repo` instead of creating a `NewRepo`.

Anyway, that's it! Not a lot of code, but took me a little while to piece together.
