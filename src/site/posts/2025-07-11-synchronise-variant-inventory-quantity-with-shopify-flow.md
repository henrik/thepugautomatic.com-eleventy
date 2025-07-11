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
*Updating inventory on one variant, reloading after several seconds, seeing a new inventory on another.*

(If there's a better/simpler way of doing it without pricy plans or apps, let me know! It's a big ecosystem and I'm a new arrival.)

## Shopify Flow

First, install [Shopify Flow](https://apps.shopify.com/flow). (It's free.) It lets you automate things.

This blog post won't hold your hand with exactly how to install or use Shopify Flow – please find a tutorial for that. I will describe what goes into this specific flow, and hopefully you can piece it together.

Please be aware that workflows can take several seconds to run, so if two variants of the same product are sold at the same time in a high-traffic store, each may update the other based only on its own inventory count, leaving the inventory count too high. (A "race condition".) Perhaps this could be mitigated by further checks in the workflow; I have not bothered.

## Create the workflow

Now, create your workflow.

It will look something like this when you're done:

![Screenshot of workflow](/images/content/2025-07-12/workflow.png)

### Trigger

As the trigger, select "Shopify &gt; Product variant inventory quantity changed".

This means that when an inventory quantity changes (whether we edit it manually or through a sale), the following things will happen.

### Trigger condition

If you want to limit this only to certain items (certain collections, certain metafields etc), click "Then", select "Condition", and add that condition.

If you want this to apply to *every* item with variants in your store, don't add a condition.

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

In a word, no. This does not happen. I have not looked into the whys and wherefores.
