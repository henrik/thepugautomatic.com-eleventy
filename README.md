# The Pug Automatic

My blog, powered by [Eleventy](https://11ty.dev) and deployed to [Netlify](https://netlify.com).

- Based on the project scaffold [ElevenTail](https://github.com/philhawksworth/eleventail).
- Utility-first CSS via [Tailwindcss](https://tailwindcss.com).
- [PurgeCSS](https://www.purgecss.com/) for optimizing CSS output.
- [UglifyJS](https://www.npmjs.com/package/uglify-js) for a simple (?) JS build pipeline.
- [Netlify CLI](https://www.npmjs.com/package/netlify-cli) for dev.


### Running locally

You need [Node and NPM](https://nodejs.org/).

```bash
# install Netlify CLI globally
npm install netlify-cli -g

# install the project dependencies
npm install

# run the build and server locally
netlify dev
```

You may need to `touch src/site/css/tailwind.css` for the CSS to generate the first time.

Don't edit the `src/site/css/styles.css` file manually. It's generated from `tailwind.css` (and then copied into `dist` when generating the site).

The `blog.11tydata.json` file relies on <https://www.11ty.dev/docs/data-template-dir/> to magically assign the right template to posts.


### Previewing the production build

When building for production, an extra build step will strip out all CSS classes not used in the site. This step is not performed during the automatic rebuilds which take place during dev.

```bash

# run the production build
npm run build
```
