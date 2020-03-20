---
title: Conversational implicature in testing
tags:
  - Testing
---

[Conversational implicature](https://en.wikipedia.org/wiki/Implicature) is the idea that we don't have to say everything explicitly; the other person will fill in the blanks according to certain shared maxims (principles).

## The maxim of quantity

For example, [the maxim of quantity](https://en.wikipedia.org/wiki/Cooperative_principle#Maxim_of_quantity) states:

1. Make your contribution as informative as is required (for the current purposes of the exchange).
2. Do not make your contribution more informative than is required.

So if I say "I ate some of the cookies", you will assume I didn't eat *all* of them.

But I did. I ate some. Then the rest. My statement is technically correct, but I've been less informative than required for our exchange. I haven't cooperated in our mutual understanding, and broken the maxim of quantity.

This can be applied to writing automated tests as well.

Test code, like other code, is conversational. You write statements, and someone else (or future you) attempts to understand them later, filling in the blanks according to certain shared maxims.


## Don't add unnecessary detail

If I'm testing a price calculation, the product title probably isn't relevant.

Instead of

``` ruby
it "doubles the price" do
  item = Item.new(title: "My item", price: 100)
  expect(item.fancy_price).to eq(200)
end
```

I should do

``` ruby
it "doubles the price" do
  item = Item.new(price: 100)
  expect(item.fancy_price).to eq(200)
end
```

The first test implies to the reader that the title is somehow relevant, but it's not.

Sometimes, you need an attribute for incidental reasons – the title isn't necessary for the price calculation, but initialising an item without a title would raise an exception. Then you can still hide it with a bit of indirection:

``` ruby
it "doubles the price" do
  item = build_item(price: 100)
  expect(item.fancy_price).to eq(200)
end

def build_item(attributes)
  defaults = { title: "My item" }
  Item.new(defaults.merge(attributes))
end
```

(In Ruby, you can write methods like this more elegantly [with double splats](/2017/02/double-splat-to-merge-hashes/).)

It doesn't have to be a method – it can be a factory object, like Ruby's [factory_bot](https://github.com/thoughtbot/factory_bot).

This can be a good thing to do after you've made a test pass – just as you would refactor the code to make it nicer, go through the test and remove or hide unnecessary detail.


## Stay close to the limit

Similarly, when you've got some sort of limit, test right up against it.

If you want to make sure that your 10-per-page pagination works, test that 10 items means one page and 11 items means two pages.

You *could* test 10 items vs. 15 items, but that implies that 15 is an interesting number. The reader may wonder what's supposed to happen at 14. No cookie for you.
