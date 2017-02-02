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
    link: 'https://github.com/contentful/contentful.js'
  - text: Learn how to use the Sync API with JavaScript
    link: /developers/docs/javascript/tutorials/using-the-sync-api-with-js/
  - text: Create an Express.js application with Contentful
    link: /developers/docs/javascript/tutorials/create-expressjs-app-using-contentful/
---

This guide will show you how to get started using our [JavaScript SDK](https://github.com/contentful/contentful.js) to consume content.

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

We publish SDKs for various languages to make developing applications easier.

## Pre-requisites

This tutorial assumes you have read and understood [the guide that covers the Contentful data model](/developers/docs/concepts/data-model/).

## Authentication

For every request, clients [need to provide an API key](/developers/docs/references/authentication/), which is created per space and used to delimit applications and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key).

## Setting up the client

First you need to get the SDK and include it in your project.

### In node.js

If you are running your code in node.js, install the npm package and require it in your code:

```bash
npm install contentful
```

```javascript
// main.js
var contentful = require('contentful')
```

### In a browser

If you are running your code in a web page, there are multiple ways you can get the SDK.

The quickest is to use the pre-built and minified JavaScript file from a CDN:

```html
<script src="https://unpkg.com/contentful@latest/browser-dist/contentful.min.js"></script>
```

The recommended, but longer way is to manage your browser JavaScript code and dependencies with npm and use a build tool such as [browserify](http://browserify.org/) or [webpack](https://webpack.github.io/).

In this case, you'd need to first install the package:

```bash
npm install contentful
```

Then you can use it in your code:

```javascript
// main.js
var contentful = require('contentful')
```

And build and use your file:

```bash
webpack main.js bundle.js
# or
browserify main.js -o bundle.js
```

```html
<script src="bundle.js"></script>
```

## Initializing the client

You need an API key and a space ID to initialize a client

_You can use the API key and space ID pre-filled below from our example space or replace them with your own values.

```javascript
var client = contentful.createClient({
  space: '71rop70dkqaj',
  accessToken: '297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971'
})
```

Read the [reference documentation](https://contentful.github.io/contentful.js/contentful/latest/contentful.html) for more options on initializing the client.

## Requesting a single entry

Once you have a client you can start getting content.

To retrieve a specific entry, you need the ID for that entry. If you're looking at an entry you created in the Contentful web app, it should be the string in the URL after _/entries/_. In this example the entry has an id of `5KsDBWseXY6QegucYAoacS`.

```javascript
client.getEntry('5KsDBWseXY6QegucYAoacS')
.then(function (entry) {
  // logs the entry metadata
  console.log(entry.sys)

  // logs the field with ID title
  console.log(entry.fields.productName)
})
```

```
Playsam Streamliner Classic Car, Espresso
```

The object received by the Promise callback represents the Entry `5KsDBWseXY6QegucYAoacS` and contains two objects: `sys`, describing system properties of the entry, and `fields`, assigning specific values to the fields of its content type ('Product').

For more details on the information contained on `sys` read the [common resource attributes](/developers/docs/references/content-delivery-api/#/introduction/common-resource-attributes) guide in the CDA reference or the entities definitions in the [SDK reference](https://contentful.github.io/contentful.js/contentful/latest/Entities.html)

## Retrieving all entries of a space

Now you're going to retrieve all the entries in a space.

```javascript
client.getEntries()
.then(function (entries) {
  // log the title for all the entries that have it
  entries.items.forEach(function (entry) {
    if(entry.fields.productName) {
      console.log(entry.fields.productName)
    }
  })
})
```

```
Whisk Beater
Playsam Streamliner Classic Car, Espresso
Hudson Wall Cup
SoSo Wall Clock
```

It's similar to getting a single entry, except you get an array with all the retrieved entries, and parameters relevant to [pagination](/developers/docs/references/content-delivery-api/#/introduction/collection-resources-and-pagination).

By default you get 100 entries. If you'd like to retrieve more, you can skip the first 100. You can retrieve more than 100 entries per request, up to 1000.

```javascript
client.getEntries({
  skip: 100,
  limit: 200,
  order: 'sys.createdAt'
})
.then(function (entries) {
  console.log(entries.items.length) // 200
})
```

You can specify an ordering parameter to get more predictable results. You can read more about ordering parameters in the [search parameters](/developers/docs/references/content-delivery-api/#/reference/search-parameters/order) reference guide.

## Retrieving linked entries

Entries have links to other entries, so when you retrieve a list of entries, those links are automatically resolved so you don't have to retrieve the linked entry separately.

By default, Contentful resolves one level of linked entries or assets.

The following example demonstrates the usage of a linked asset on field `logo` for the 'brand' content type you can find in our product catalog example space:

```javascript
client.getEntries()
    .then(function (entries) {
        entries.items.forEach(function (entry) {
            if(entry.fields.companyName) {
                console.log(entry.fields.logo.fields.file.url)
            }
        })
    })
```

```
{"url":"//images.contentful.com/71rop70dkqaj/2Y8LhXLnYAYqKCGEWG4EKI/44105a3206c591d5a64a3ea7575169e0/lemnos-logo.jpg","details":{"size":7149,"image":{"width":175,"height":32}},"fileName":"lemnos-logo.jpg","contentType":"image/jpeg"}
{"url":"//images.contentful.com/71rop70dkqaj/3wtvPBbBjiMKqKKga8I2Cu/90b69e82b8b735383d09706bdd2d9dc5/zJYzDlGk.jpeg","details":{"size":12302,"image":{"width":353,"height":353}},"fileName":"zJYzDlGk.jpeg","contentType":"image/jpeg"}
{"url":"//images.contentful.com/71rop70dkqaj/4zj1ZOfHgQ8oqgaSKm4Qo2/8c30486ae79d029aa9f0ed5e7c9ac100/playsam.jpg","details":{"size":7003,"image":{"width":100,"height":100}},"fileName":"playsam.jpg","contentType":"image/jpeg"}
```

If you'd like to resolve additional levels of links, or none at all, use the `include` parameter. The example below resolves no links, and only contains metadata about the image, so will return an error:

```javascript
client.getEntries({include: 0})
    .then(function (entries) {
        // log the file url of any linked assets on field `image`
        entries.items.forEach(function (entry) {
            if(entry.fields.companyName) {
                console.log(JSON.stringify(entry.fields.logo.fields.file.url))
            }
        })
    })
```

You can turn off link resolution when you [initialize the SDK](https://contentful.github.io/contentful.js/contentful/latest/contentful.html) or with a `resolveLinks` property on every request.

Read the [links reference guide](/developers/docs/concepts/links/) for more information.

## Retrieving entries with search parameters

The entries method can take parameters for filtering and querying. You can use these same parameters when getting assets or content types.

The following request filters all entries by a specific content type, using that content type's ID.

_You can use the content type pre-filled below for our example space or replace it with your own value_.

The example below filters entries to the 'Brand' content type:

```javascript
client.getEntries({
  'content_type': 'sFzTZbSuM8coEwygeUYes'
})
.then(function (entries) {
    console.log(JSON.stringify(entries))
            entries.items.forEach(function (entry) {
            console.log(JSON.stringify(entry.fields.companyName))
    })
})
```

```json
"Normann Copenhagen"
"Lemnos"
"Playsam"
```

You can filter by properties of your entries, for example, a product SKU:

```javascript
client.getEntries({
  'fields.sku': 'B00E82D7I8',
  'content_type': '2PqfXUJwE8qSYKuM0U6w8M'
})
.then(function (entries) {
            entries.items.forEach(function (entry) {
            console.log(JSON.stringify(entry.fields.sku))
    })
})
```

```json
"B00E82D7I8"
```

{: .note}
When you filter by the value of a field, you need to include the content type you are filtering, as fields are not the same across all content types.

Apart from equality filters, you can use operators. The example below is the reverse of the previous example, giving you any entries where `fields.sku` is not equal (`[ne]`) to the specified value.

```javascript
client.getEntries({
  'fields.sku[ne]': 'B00E82D7I8',
  'content_type': '2PqfXUJwE8qSYKuM0U6w8M'
})
.then(function (entries) {
            entries.items.forEach(function (entry) {
            console.log(JSON.stringify(entry.fields.sku))
    })
})
```

```json
"B00MG4ULK2"
"B0081F2CCK"
"B001R6JUZ2"
```

If you're interested in knowing what other filters and operators you can use, read the following guides:

-   [Equality/inequality](/developers/docs/references/content-delivery-api/#/reference/search-parameters/equality-operator) ([as well as in array fields](/developers/docs/references/content-delivery-api/#/reference/search-parameters/array-equalityinequality))
-   [Inclusion/exclusion](/developers/docs/references/content-delivery-api/#/reference/search-parameters/inclusion)
-   [Ranges](/developers/docs/references/content-delivery-api/#/reference/search-parameters/ranges)
-   [Full text search](/developers/docs/references/content-delivery-api/#/reference/search-parameters/full-text-search)
-   [Geo location searches](/developers/docs/references/content-delivery-api/#/reference/search-parameters/location-proximity-search)

Read the [search parameters guide](/developers/docs/references/content-delivery-api/#/reference/search-parameters) for more information.
