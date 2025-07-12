---
title: Synchronise variant inventory quantity with Shopify Flow
tags:
  - Shopify
---

I've been learning the Shopify ecosystem lately, and a friend asked if there's a way to synchronise variant inventory quantity.

Say you're selling pendants, with variants for "with chain" or "no chain".

In Shopify, each variant has its own separate inventory count. But you might want them to share the same count – if you run out of pendants, you run out of pendants.

The following is a way to do it using [Shopify Flow](https://help.shopify.com/en/manual/shopify-flow), on the Shopify Basic plan with no paid apps. It assumes you have a single inventory location.

![Screen recording](/images/content/2025-07-12/pendant.gif)

<p class="caption">Updating inventory on one variant, reloading after several seconds, seeing a new inventory on the other.</p>

(If there's a better/simpler way of doing it without pricy plans or apps, let me know! It's a big ecosystem and I'm a new arrival.)

## Gotchas and alternatives

There are a few gotchas and alternatives. I'm offering this as one alternative, and also to show what's possible with Shopify Flow.

Workflows can take several seconds to run, so if two variants of the same product are sold at the same time in a high-traffic store, each may update the other based only on its own inventory count, leaving the inventory count too high. (A "race condition".) Perhaps this could be mitigated by further checks in the workflow; I have not bothered.

Also, if someone places an order mixing variants, they would be able to over-purchase, and the inventory count would be left too high. Say you have 10 pendants left, shown as 10 in stock of each inventory item. If someone then orders 6 pendants with chain and 6 without in a single order, it would go through, marking 4 as left in stock of each. But you'd have an order for 12 pendants.

A more robust solution could be to have a single product with no variants, and represent the chain as its own add-on product. There are apps to facilitate this (only paid ones to my knowledge – though [Selleasy](https://apps.shopify.com/upsell-cross-sell-kit-1) is freemium), or you could keep it cheap and cheerful by linking to the add-on product from the main product's description. Or use a [metafield](https://help.shopify.com/en/manual/custom-data/metafields) to point a product to its add-ons, and then have a "Custom Liquid" [block](https://help.shopify.com/en/manual/online-store/themes/theme-structure/sections-and-blocks) generate product links.

If I haven't discouraged you, read on.

## Shopify Flow

First, install [Shopify Flow](https://apps.shopify.com/flow). (It's free.) It lets you automate things.

This blog post won't hold your hand with exactly how to install or use Shopify Flow – please find a tutorial for that. I will describe what goes into this specific flow, and hopefully you can piece it together.

## Create or import the workflow

Now, create your workflow.

It will look something like this when you're done:

![Screenshot of workflow](/images/content/2025-07-12/workflow.png)

You can import [this workflow file](/uploads/2025-07-12/Synchronise variant inventory quantity.flow), and then reference the instructions below to understand what you can tweak and how it fits together.

Or create a new workflow and follow the instructions to set it up from scratch.

### Trigger

As the trigger, select "Shopify &gt; Product variant inventory quantity changed".

This means that when an inventory quantity changes (whether we edit it manually or through a sale), the following things will happen.

### Trigger condition

If you want to limit this only to certain items (certain collections, certain metafields etc), click "Then", select "Condition", and add that condition.

If you want this to apply to *every* item with variants in your store, don't add a condition.

In the importable workflow file above, I included a condition that will always be true ("the product ID is the same as the product ID") to have a placeholder condition that you can tweak.

### Action: For each loop

Click "Then" on the condition if you added one, or on the trigger if you didn't.

Select "Flow &gt; For each loop (iterate)". Select variable: "Product &gt; Variants".

This means that when a variant's inventory quantity changes, we will do something to each of that product's variants.

### Loop condition

Click "Repeat for each item", select "Condition", "Add a variable".

Select "variantsForeachitem > id".

Select "Not equal to".

In the "Variant Id" field, click "&lt;/&gt;" to pick a variable. Select "productVariant &gt; id".

This means that when we look at each of the product's variants in turn, we will skip past the variant that triggered this flow. It already has the right count.

### Action: Update quantities

Click "Then" on the condition. Select "Action".

Select "Shopify &gt; Send Admin API request".

In the "Select mutation" list, select "inventorySetQuantities".

In the "Mutation inputs" field, put:

{% raw %}
``` liquid
{
  "input": {
    "reason": "other",
    "name": "available",
    "quantities": [
      {
        "inventoryItemId": "{{variantsForeachitem.inventoryItem.id}}",
        "locationId": "{% assign invLevel = productVariant.inventoryItem.inventoryLevels | first %}{{ invLevel.location.id }}",
        "quantity": {{productVariant.inventoryQuantity}}
      }
    ],
    "ignoreCompareQuantity": true
  }
}
```
{% endraw %}

This means that for each of the product's variants (except the one that triggered the flow), we set the inventory quantity to that of the triggering variant.

### Ship it

Click "Turn on workflow". You are done!

You should now be able to edit a variant quantity on the product page, reload the page after a few seconds and see that other variants are also updated.

The workflow page will list recent runs – you can use this to confirm whether it has run, and look for error messages if it failed to run.

Godspeed!

## Won't this cause an endless loop?

If the workflow updates inventory count, won't that cause the workflow to trigger itself?

In a word, no. This does not happen. I have not looked into why. Count your blessings.
