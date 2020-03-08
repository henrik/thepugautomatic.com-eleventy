const { DateTime }    = require('luxon');
const util            = require('util');
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
const pluginRss        = require("@11ty/eleventy-plugin-rss");
const slug            = require('@11ty/eleventy/src/Filters/Slug');

module.exports = function(eleventyConfig) {
  // Layout aliases for convenience
  eleventyConfig.addLayoutAlias('default', 'layouts/base.njk');

  // Make it possible to set the "post" tag in the "post.njk" layout while still assigning further tags in the individual post.
  // https://www.11ty.dev/docs/data-deep-merge/
  // https://github.com/11ty/eleventy/issues/401
  eleventyConfig.setDataDeepMerge(true);

  // https://www.11ty.dev/docs/plugins/syntaxhighlight/
  eleventyConfig.addPlugin(syntaxHighlight);

  // https://www.11ty.dev/docs/plugins/rss/
  eleventyConfig.addPlugin(pluginRss);

  eleventyConfig.addShortcode("filename", filename => {
    // The newlines avoid breaking Markdown.
    return `<div class="code-filename">${filename}</div>\n\n`;
  });

  // a debug utility
  eleventyConfig.addFilter('dump', obj => {
    return util.inspect(obj)
  });

  // Date helpers
  eleventyConfig.addFilter('readableDate', dateObj => {
    return DateTime.fromJSDate(dateObj, {
      zone: 'utc'
    }).toFormat('LLLL d, y');
  });
  eleventyConfig.addFilter('htmlDate', dateObj => {
    return DateTime.fromJSDate(dateObj, {
      zone: 'utc'
    }).toFormat('y-MM-dd');
  });
  eleventyConfig.addFilter('slugDate', dateObj => {
    return DateTime.fromJSDate(dateObj, {
      zone: 'utc'
    }).toFormat('y/MM');
  });

  eleventyConfig.addFilter("limit", (array, count) => array.slice(0, count));

  eleventyConfig.addFilter('tagList', list => {
    // "posts" is a magic tag used to determine which pages are blog posts.
    const properTags = list.filter(x => x != "posts");
    if (!properTags) return;

    return "Tagged " + properTags.map(tag => `<a href="/tag/${slug(tag)}">${tag}</a>`).join(", ") + ".";
  });

  // compress and combine js files
  eleventyConfig.addFilter("jsmin", require("./src/utils/minify-js.js") );

  // minify the html output when running in prod
  if (process.env.NODE_ENV == "production") {
    eleventyConfig.addTransform("htmlmin", require("./src/utils/minify-html.js") );
  }

  // Static assets to pass through
  eleventyConfig.addPassthroughCopy("./src/site/fonts");
  eleventyConfig.addPassthroughCopy("./src/site/images");
  eleventyConfig.addPassthroughCopy("./src/site/css");
  eleventyConfig.addPassthroughCopy("./src/site/uploads");

  return  {
    dir: {
      input: "src/site",
      includes: "_includes",
      output: "dist"
    },
    passthroughFileCopy: true,
    templateFormats : ["njk", "md"],
    htmlTemplateEngine : "njk",
    markdownTemplateEngine : "njk",
  };

};
