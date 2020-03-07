# The Pug Automatic

My blog.

Powered by Eleventy and ElevenTail:

## ElevenTail

A project scaffold for quickly starting a site build with:

- [Eleventy](https://11ty.dev) for templates and site generation
- [Tailwindcss](https://tailwindcss.com) for a utility first CSS workflow
- [PurgeCSS](https://www.purgecss.com/) for optimizing CSS output
- [UglifyJS](https://www.npmjs.com/package/uglify-js) for a simple JS build pipeline
- [Netlify CLI](https://www.npmjs.com/package/netlify-cli) for Netlify dev pipeline and local replication of prod environment


### Prerequisites

- [Node and NPM](https://nodejs.org/)


### Running locally

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


### Previewing the production build

When building for production, an extra build step will strip out all CSS classes not used in the site. This step is not performed during the automatic rebuilds which take place during dev.

```bash

# run the production build
npm run build
```
