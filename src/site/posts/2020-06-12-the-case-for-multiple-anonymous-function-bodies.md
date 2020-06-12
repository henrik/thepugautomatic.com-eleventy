---
title: The case for multiple anonymous function bodies
tags:
  - Elixir
---

Here's a dollop of developer delight in Elixir.

Named functions can have multiple bodies, as you probably know:

``` elixir
def present_result(:ok), do: "Success!"
def present_result(:error), do: "Failure!"
```

It's perhaps less well know that the same applies to anonymous functions. You can use this to simplify situations where you'd otherwise use `case`.

For example, instead of:

``` elixir
Enum.each(results, fn (result) ->
  case result do
  when :ok -> IO.puts "Success!"
  when :error -> IO.puts "Failure!"
  end
end)
```

You can do:

``` elixir
Enum.each(results, fn
  :ok -> IO.puts "Success!"
  :error -> IO.puts "Failure!"
end)
```

And you can pattern match just like in any function definition, of course. I did something like this recently:

``` elixir
results = [
  {:ok, "It worked"},
  {:ok, "It also worked"},
  {:error, "It fell on its face"},
]

counts = Enum.frequencies_by(results, fn {status, _count} -> status end)
# => [{:ok, 2}, {:error, 1}]

Enum.each(counts, fn
  {:ok, 1} -> IO.puts "1 success!"
  {:ok, count} -> IO.puts "#{count} successes!"
  {:error, 1} -> IO.puts "1 failure!"
  {:error, count} -> IO.puts "#{count} failures!"
end)
```

Pretty nice!
