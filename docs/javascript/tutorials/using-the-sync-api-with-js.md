---
page: :docsSyncApiWithJS
name: Using the Sync API with JavaScript
title: Using the Sync API with JavaScript
metainformation: 'This tutorial will show you how to use the Sync API with the Contentful JavaScript SDK to keep a local copy of content up to date via delta updates.'
slug: null
tags:
  - Basics
  - Content model
nextsteps:
 - text: More details on our Syncronization endpoint
   link: /developers/docs/references/content-delivery-api/#/reference/synchronization/
---

The [sync](/developers/docs/concepts/sync/) API allows you to keep a local copy of all content of a space up to date in your application via delta updates. This tutorial will show you how to use the Sync API with the Contentful JavaScript SDK.

This tutorial shows examples using the [localStorage](https://developer.mozilla.org/en/docs/Web/API/Window/localStorage) API in a browser, but you can also use any other [storage](https://github.com/localForage/localForage) [wrapper](https://pouchdb.com/) or any [storage layer](https://github.com/Level/levelup) in Node.js.

## Pre-requisites

If you haven't used the Contentful JavaScript SDK before we recommend you read our [getting started guide](/developers/docs/javascript/tutorials/using-js-cda-sdk) first.

To run your first sync:

~~~javascript
client.sync({initial: true})
.then((response) => {
  console.log(response.entries)
  console.log(response.assets)
})
~~~

As this is the first sync, the response will contain all existing entries and assets.

Any links from entries to other entries and assets will be resolved. If you don't need this, you can disable it:

~~~javascript
client.sync({
  initial: true,
  resolveLinks: false
})
.then((response) => {
  console.log(response.entries)
  console.log(response.assets)
})
~~~

If you want to store the retrieved content, you can use the `toPlainObject` or `stringifySafe` methods to prevent issues with circular links. For example:

~~~javascript
client.sync({initial: true})
.then((response) => {
   const responseObj = JSON.parse(response.stringifySafe());
   const entries = responseObj.entries;
   window.localStorage.setItem('contentfulEntries', JSON.stringify(entries))
})
~~~

The response will contain a token, which you should store:

~~~javascript
client.sync({initial: true})
.then((response) => {
  window.localStorage.setItem('contentfulSyncToken', response.nextSyncToken)
})
~~~

### Continuing the sync

The next time you want to updated content, you can use the stored token. This will return you only new, and updated content, as well as a list of what content has been deleted:

~~~javascript
client.sync({nextSyncToken: window.localStorage.getItem('contentfulSyncToken')})
.then((response) => {
  console.log(response.entries)
  console.log(response.assets)
  console.log(response.deletedEntries)
  console.log(response.deletedAssets)
  // store the new token
  window.localStorage.setItem('contentfulSyncToken', response.nextSyncToken)
})
~~~

Every time you perform a sync you receive a new token, which represents that point in time for the space, so don't forget to store it again.

You can then loop through the content previously stored and remove any content that is now marked as deleted.
