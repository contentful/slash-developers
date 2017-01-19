---
page: :docsUsingJsCdaSdk
name: Getting Started with Contentful and JavaScript
title: Getting Started with Contentful and JavaScript
metainformation: This article details how to retrieve entries using the JavaScript CDA SDK.
slug: null
tags:
  - SDKs
  - JavaScript
nextsteps:
  - text: Explore the JavaScript CDA SDK GitHub repository
    link: https://github.com/contentful/contentful.js
  - text: Learn how to use the Sync API with JavaScript
    link: /developers/docs/javascript/tutorials/using-the-sync-api-with-js/
  - text: Create an Express.js application with Contentful
    link: /developers/docs/javascript/tutorials/create-expressjs-app-using-contentful/
---

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

We publish SDKs for various languages to make developing applications easier. This article details how to get content using the [JavaScript CDA SDK](https://github.com/contentful/contentful.js).

## Pre-requisites

This tutorial assumes you have read and understood [the guide that covers the Contentful data model](/developers/docs/concepts/data-model/).

## Authentication

For every request, clients [need to provide an API key](/developers/docs/references/authentication/), which is created per space and used to delimit applications and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key).

## Setting up the client

First you need to get the SDK and include it in your project.

### In node.js

If you are running your code in node.js, install the npm package and require it in your code:

~~~bash
npm install contentful
~~~

~~~javascript
// main.js
var contentful = require('contentful')
~~~

### In a browser

If you are running your code in a web page, there are multiple ways you can get the SDK.

The quickest is to use the pre-built and minified JavaScript file from a CDN:

~~~html
<script src="https://unpkg.com/contentful@latest/browser-dist/contentful.min.js"></script>
~~~

The recommended, but longer way is to manage your browser JavaScript code and dependencies with npm and use a build tool such as [browserify](#) or [webpack](#).

In this case, you'd need to first install the package:

~~~bash
npm install contentful
~~~

Then you can use it in your code

~~~javascript
// main.js
var contentful = require('contentful')
~~~

And build and use your file:

~~~bash
webpack main.js bundle.js
# or
browserify main.js -o bundle.js
~~~

~~~html
<script src="bundle.js"></script>
~~~

## Initializing the client

To access your content, you need to create a client with the necessary credentials.

Using the API key you created and the space ID, you can initialize your client:

~~~javascript
var client = contentful.createClient({
  space: '<space_id>',
  accessToken: '<access_token>'
})
~~~

Read the [reference documentation](https://contentful.github.io/contentful.js/contentful/latest/contentful.html) for more options on initializing the client.

## Requesting a single entry

Once you have a client you can start getting content.

To retrieve a specific entry, you need the ID for that entry. If you're looking at an entry you created in the Contentful web app, it should be the string in the URL after _/entries/_. In this example the entry has an id of `O1ZiKekjgiE0Uu84oKqaY`.

~~~javascript
client.getEntry('O1ZiKekjgiE0Uu84oKqaY')
.then(function (entry) {
  // logs the entry metadata
  console.log(entry.sys)

  // logs the field with ID title
  console.log(entry.fields.title)
})
~~~

The object received by the Promise callback represents the Entry `O1ZiKekjgiE0Uu84oKqaY` and contains two objects: `sys`, describing system properties of the entry, and `fields`, assigning specific values to fields (`title`,`body`,`image`) of its content type ('Blog Post').

For more details on the information contained on `sys` read the [common resource attributes](/developers/docs/references/content-delivery-api/#/introduction/common-resource-attributes) guide in the CDA API reference or the entities definitions in the [SDK reference](https://contentful.github.io/contentful.js/contentful/latest/Entities.html)

## Retrieving all entries of a space

Now you're going to retrieve all the entries in a space.

~~~javascript
client.getEntries()
.then(function (entries) {
  // log the title for all the entries that have it
  entries.items.forEach(function (entry) {
    if(entry.fields.title) {
      console.log(entry.fields.title)
    }
  })
})
~~~

It's similar to getting a single entry, except you get an array with all the retrieved entries, and parameters relevant to [pagination](/developers/docs/references/content-delivery-api/#/introduction/collection-resources-and-pagination).

By default you get 100 entries. If you'd like to retrieve more, you can skip the first 100\. You can retrieve more than 100 entries per request, but up to 1000.

~~~javascript
client.getEntries({
  skip: 100,
  limit: 200,
  order: 'sys.createdAt'
})
.then(function (entries) {
  console.log(entries.items.length) // 200
})
~~~

You can specify an ordering parameter to get more predictable results. You can read more about ordering parameters in the [search parameters API](/developers/docs/references/content-delivery-api/#/reference/search-parameters/order) reference guide.

## Retrieving linked entries

Some entries have links to other entries, so when you retrieve a list of entries, those links are automatically resolved so you don't have to retrieve the linked entry separately.

By default, Contentful resolves one level of linked entries or assets.

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

If you'd like to resolve additional levels of links, or none at all, use the `include` parameter:

~~~javascript
client.getEntries({include: 0})
.then(function (entries) {
  // Link wasn't resolved, so it only contains the asset metadata
  console.log(entries.items[0].fields.image.sys.id)
})
~~~

You can turn off link resolution when you [initialize the SDK](#) or with a `resolveLinks` property on every request.

Read the [links reference guide](/developers/docs/concepts/links/) for more information.

## Retrieving entries with search parameters

The entries method can take additional parameters for filtering and querying. You can use these same parameters when getting assets or content types.

The following request filters all entries by a specific content type, using that content type's ID, which is `6tw1zeDm5aMEIikMaCAgGk`:

~~~javascript
client.getEntries({
  'content_type': '6tw1zeDm5aMEIikMaCAgGk'
})
.then(function (entries) {
  // Only entries of the Blog Post content type
  console.log(entries)
})
~~~

You can filter by properties of your entries, for example, the entry id:

~~~javascript
client.getEntries({
  'sys.id': 'O1ZiKekjgiE0Uu84oKqaY'
})
.then(function (entries) {
  // Only entries of the Blog Post content type
  console.log(entries)
})
~~~

Apart from equality filters, you can use operators. The example below is the reverse of the previous example, except it will give you any entries where `sys.id` is not equal (`[ne]`) to the specified id.

~~~javascript
client.getEntries({
  'sys.id[ne]': 'O1ZiKekjgiE0Uu84oKqaY'
})
.then(function (entries) {
  // All entries but the one specified
  console.log(entries)
})
~~~

If you want to filter by any of the fields, you'll also need to specify the content type, as fields are not the same across all content types:

~~~javascript
client.getEntries({
  'content_type': '6tw1zeDm5aMEIikMaCAgGk',
  'fields.image.sys.id': '1Idbf0HVsQeYIC0EmYgiuU'
})
.then(function (entries) {
  // Only entries which link to the specified image
  console.log(entries)
})
~~~

If you're interested in knowing what other filters and operators you can use, read the following guides:

- [Equality/inequality](/developers/docs/references/content-delivery-api/#/reference/search-parameters/equality-operator) ([as well as in array fields](/developers/docs/references/content-delivery-api/#/reference/search-parameters/array-equalityinequality))
- [Inclusion/exclusion](/developers/docs/references/content-delivery-api/#/reference/search-parameters/inclusion)
- [Ranges](/developers/docs/references/content-delivery-api/#/reference/search-parameters/ranges)
- [Full text search](/developers/docs/references/content-delivery-api/#/reference/search-parameters/full-text-search)
- [Geo location searches](/developers/docs/references/content-delivery-api/#/reference/search-parameters/location-proximity-search)

Read the [search parameters API guide](/developers/docs/references/content-delivery-api/#/reference/search-parameters) for more information.
