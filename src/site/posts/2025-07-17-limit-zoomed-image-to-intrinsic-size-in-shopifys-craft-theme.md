---
title: Limit zoomed image to intrinsic size in Shopify's "Craft" theme
tags:
  - Shopify
---

I've just set up [a Shopify store](https://johannaost.com) for my partner using Shopify's own [Craft](https://themes.shopify.com/themes/craft) theme.

When clicking an image to zoom/enlarge it, Craft can show it larger than its actual ("intrinsic") size, making it blurry:
- On small (typically mobile) screens, they show at 1100 pixels wide for you to pan around in, even if that's more (or less) than their intrinsic size.
- On larger screens, they would stretch to fill the width of the viewport (minus a strangely generous margin), even if that's more (or less) than their intrinsic size.

So I fixed it. Now:

- On small (typically mobile) screens, they still show for you to pan around in, but at the smallest of either their intrinsic size or 1100 pixels wide.
- On larger screens, they may stretch to fill the width of the viewport, but with a narrower margin, and only to the smallest of either their intrinsic size or 4096 pixels wide.

## The diff

I keep a local copy of theme changes. This is the diff:

{% raw %}
``` diff
diff --git craft-theme/assets/section-main-product.css craft-theme/assets/section-main-product.css
index c9dfc58..176379e 100644
--- craft-theme/assets/section-main-product.css
+++ craft-theme/assets/section-main-product.css
@@ -706,13 +706,17 @@ a.product__text {

 @media screen and (min-width: 750px) {
   .product-media-modal__content {
-    padding: 2rem 11rem;
+    padding: 1rem;
   }

   .product-media-modal__content > * {
     width: 100%;
   }

+  .product-media-modal__content > img {
+    max-width: fit-content;
+  }
+
   .product-media-modal__content > * + * {
     margin-top: 2rem;
   }
@@ -724,10 +728,6 @@ a.product__text {
 }

 @media screen and (min-width: 990px) {
-  .product-media-modal__content {
-    padding: 2rem 11rem;
-  }
-
   .product-media-modal__content > * + * {
     margin-top: 1.5rem;
   }
diff --git craft-theme/snippets/product-media.liquid craft-theme/snippets/product-media.liquid
index 0d6cb41..bc1becb 100644
--- craft-theme/snippets/product-media.liquid
+++ craft-theme/snippets/product-media.liquid
@@ -15,6 +15,10 @@
 {% endcomment %}

 {%- if media.media_type == 'image' -%}
+  {%- assign outer_max_width_on_small_displays = 1100 -%}
+  {%- assign outer_max_width_on_large_displays = 4096 -%}
+  {%- assign max_width_on_small_displays = media.preview_image.width | at_most: outer_max_width_on_small_displays -%}
+  {%- assign max_width_on_large_displays = media.preview_image.width | at_most: outer_max_width_on_large_displays -%}
   <img
     class="global-media-settings global-media-settings--no-shadow{% if variant_image %} product__media-item--variant{% endif %}"
     srcset="
@@ -28,12 +32,12 @@
       {%- if media.preview_image.width >= 4096 -%}{{ media.preview_image | image_url: width: 4096 }} 4096w,{%- endif -%}
       {{ media.preview_image | image_url }} {{ media.preview_image.width }}w
     "
-    sizes="(min-width: 750px) calc(100vw - 22rem), 1100px"
-    src="{{ media.preview_image | image_url: width: 1445 }}"
+    sizes="(min-width: 750px) min(calc(100vw - 2rem), {{ max_width_on_large_displays }}px), {{ max_width_on_small_displays }}px"
+    src="{{ media.preview_image | image_url: width: max_width_on_large_displays }}"
     alt="{{ media.alt | escape }}"
     loading="lazy"
-    width="1100"
-    height="{{ 1100 | divided_by: media.preview_image.aspect_ratio | ceil }}"
+    width="{{ max_width_on_large_displays }}"
+    height="{{ max_width_on_large_displays | divided_by: media.preview_image.aspect_ratio | ceil }}"
     data-media-id="{{ media.id }}"
   >
 {%- else -%}
```
{% endraw %}

Much better!

## The nerdy details

The `srcset` remains unchanged, meaning the browser will still request an appropriate image size based on viewport size and pixel density (retina displays). The max image it offers up is 4096 pixels wide, which explains that magic number above. (Also [see the rationale for similar srcset values in the "Dawn" theme](https://github.com/Shopify/dawn/pull/668#issuecomment-975832897).)

I picked a `1rem` padding because it Looked Good™ – the default `11rem` is inexplicably large, leaving too little room for the image itself.

The `max-width: fit-content` defeats a `width: 100%` that would otherwise stretch the image beyond its intrinsic size.

I have not considered videos or other media types, for now. They remain unchanged, other than the smaller container padding.
