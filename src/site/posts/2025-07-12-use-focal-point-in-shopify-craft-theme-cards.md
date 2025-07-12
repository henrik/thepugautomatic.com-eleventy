---
title: Use focal point in Shopify "Craft" theme cards
tags:
  - Shopify
---

I'm setting up a Shopify store for my partner using Shopify's own [Craft](https://themes.shopify.com/themes/craft) theme.

When configured to show product card images with a consistent size (square or portrait), Craft would crop images poorly, cutting off heads.

![Screenshot](/images/content/2025-07-12/before.jpg)

Shopify [has support for focal points](https://help.shopify.com/en/manual/online-store/images/theme-images#setting-a-focal-point-on-an-image), but product cards don't make use of them.

I fixed this by editing the theme files, and this is how they look now:

![Screenshot](/images/content/2025-07-12/before.jpg)

Much better!

I keep a local copy of theme changes. This is the diff:

``` diff
diff --git craft-theme/snippets/card-product.liquid craft-theme/snippets/card-product.liquid
index 0a1a5e2..a931c0d 100644
--- craft-theme/snippets/card-product.liquid
+++ craft-theme/snippets/card-product.liquid
@@ -78,6 +78,7 @@
                 {% unless lazy_load == false %}
                   loading="lazy"
                 {% endunless %}
+                style="object-position: {{ card_product.featured_media.presentation.focal_point }}"
                 width="{{ card_product.featured_media.width }}"
                 height="{{ card_product.featured_media.height }}"
               >
@@ -99,6 +100,7 @@
                   alt="{{ card_product.media[1].alt | escape }}"
                   class="motion-reduce"
                   loading="lazy"
+                  style="object-position: {{ card_product.media[1].presentation.focal_point }}"
                   width="{{ card_product.media[1].width }}"
                   height="{{ card_product.media[1].height }}"
                 >
@@ -489,6 +491,7 @@
                                 {% unless lazy_load == false %}
                                   loading="lazy"
                                 {% endunless %}
+                                style="object-position: {{ card_product.featured_media.presentation.focal_point }}"
                                 width="{{ card_product.featured_media.width }}"
                                 height="{{ card_product.featured_media.height }}"
                               >
```

I've asked Shopify Support to pass this on to the theme developers, to get it fixed upstream.
