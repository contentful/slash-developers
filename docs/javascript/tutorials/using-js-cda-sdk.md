---
page: :docsUsingJsCdaSdk
---

## Overview

Contentful's Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

In order to makes things easier for our users, we publish SDKs for various languages which make the task easier.

This article goes into detail about how to get content using the [JavaScript CDA SDK](https://github.com/contentful/contentful.js).

## Pre-requisites

In this tutorial, it is assumed you have understood the basic Contentful data model as described above and in the [Developer Center](https://www.contentful.com/developers/docs/concepts/data-model/).

## Authentication

To get started, for every request, clients [need to provide an access token](/developers/docs/references/authentication/), which is created per Space and used to delimit audiences and content classes.

You can create an access token using [Contentful's Web Interface](https://be.contentful.com/login) or the [Content Management API](https://www.contentful.com/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key)

## Setting up the client

First off, you need to get the SDK and use it in your project.

### In node.js

If you are running your code in node.js, all you have to do is install the npm package and require it in your code:

~~~ bash
npm install contentful
~~~

~~~ javascript
// main.js
var contentful = require('contentful')
~~~

### In a browser

If you are running your code in a web page, there are multiple ways you can get it ready to use.

The quickest and easiest way is to use the pre built and minified JavaScript file from a CDN:

~~~html
<script src="https://npmcdn.com/contentful@latest/browser-dist/contentful.min.js"></script>
~~~

The recommended way would be to also manage your browser JavaScript code and dependencies with npm and use a build tool suck as browserify or webpack.

In that case, you'd need to first install the package:

~~~bash
npm install contentful
~~~

Then you can use it in your code

~~~javascript
// main.js
var contentful = require('contentful')
~~~

And finally build and use your file:

~~~bash
webpack main.js bundle.js
# or
browserify main.js -o bundle.js
~~~

~~~html
<script src="bundle.js"></script>
~~~

## Initializing the client

In order to be able to access your content, you need to create a client with the necessary credentials.

Having the API key you created before and the space ID, you can initialize your client:

~~~javascript
var client = contentful.createClient({
  space: 'mo94git5zcq9',
  accessToken: 'b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb'
})
~~~

See the [reference documentation](https://contentful.github.io/contentful.js/contentful/latest/contentful.html) for more options.

## Requesting a single Entry

Once you have a client you can start getting content.

In order to retrieve a specific Entry, you need the entry ID for that Entry. If you're looking at an Entry you created in the user interface, it should be the string in the URL after `/entries/`. In this particular case we have an Entry read to be retrieved with the id `O1ZiKekjgiE0Uu84oKqaY`.

~~~javascript
client.getEntry('O1ZiKekjgiE0Uu84oKqaY')
.then(function (entry) {
  // logs the entry metadata
  console.log(entry.sys)

  // logs the field with ID title
  console.log(entry.fields.title)
})
~~~

The object received by the Promise callback represents the Entry `O1ZiKekjgiE0Uu84oKqaY` and contains two objects: `sys`, describing system properties of the Entry, and `fields`, assigning specific values to fields (`title`,`body`,`image`) of its Content Type (`Blog Post`).

For more details on the information contained on `sys` check out the [Common Resource Attributes](https://www.contentful.com/developers/docs/references/content-delivery-api/#/introduction/common-resource-attributes) on the CDA API reference or the Entities definitions on the [SDK reference](https://contentful.github.io/contentful.js/contentful/latest/Entities.html)

## Retrieving all Entries of a Space

Now we're going to retrieve all the entries in a space.

~~~javascript
client.getEntries()
.then(function (entries) {
  // log the title for all the entries that might have it
  entries.items.forEach(function (entry) {
    if(entry.fields.title) {
      console.log(entry.fields.title)
    }
  })
})
~~~

Some entries might have links to each other, so when you retrieve a list of entries, those links are automatically resolved so you don't have to go look for the linked entry separately.

By default, one level of linked entries or assets are resolved.

The following example demonstrates the usage of a linked asset on field `image`:

~~~javascript
client.getEntries()
.then(function (entries) {
  // log the file url of any linked assets on field `image`
  entries.items.forEach(function (entry) {
    if(entry.fields.image) {
      console.log(entry.fields.image.fields.file.url)
    }
  })
})
~~~

If you'd like to have additional levels of links resolved, or none at all, you can use the include parameter:

~~~javascript
client.getEntries({include: 0})
.then(function (entries) {
  // Link wasn't resolved, so it only contains the asset metadata
  console.log(entries.items[0].fields.image.sys.id)
})
~~~

You can also turn off link resolultion when you initialize the SDK or with a `resolveLinks` property on every request.

Check the [Links Reference Page](https://www.contentful.com/developers/docs/concepts/links/) for more information on linked entries.

The entries method can also take additional parameters for filtering and querying.

~~~javascript
client.getEntries({
  'fields.title[match]': 'stars'
})
.then(function (entries) {
  // Logs only fields with a title field matching the string 'stars'
  entries.items.forEach(function (entry) {
    console.log(entry.fields.title)
  })
})
~~~

Check out the [JavaScript CDA SDK](https://contentful.github.io/contentful.js) page for more examples and the [Search Parameters API page](https://www.contentful.com/developers/docs/references/content-delivery-api/#/reference/search-parameters) for more information.

## Conclusion

In this article, we have shown you how to use the Contentful JavaScript SDK to perform some requests and handle their responses by performing the following actions:

1. Retrieve a single Entry
2. Retrieve all Entries of a Space
3. Retrieve all Entries and their linked resources
4. Retrieve all filtered Entries by a search parameter
