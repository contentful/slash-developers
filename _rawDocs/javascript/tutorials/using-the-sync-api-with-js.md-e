---
page: :docsSyncApiWithJS
name: Using the Sync API with JavaScript
title: Using the Sync API with JavaScript
metainformation: 'The sync API allows you to keep a local copy of all content of a space up to date via delta updates. This tutorial will show you how to use the Sync API with the Contentful JavaScript SDK.'
slug: null
tags:
  - Basics
  - Content model
nextsteps:
 - text: Further details on our Syncronization endpoint
   link: /developers/docs/references/content-delivery-api/#/reference/synchronization/
---

The [sync](/developers/docs/concepts/sync/) API allows you to keep a local copy of all content of a space up to date via delta updates. This tutorial will show you how to use the Sync API with the Contentful JavaScript SDK.

This tutorial shows some examples using the [localStorage](https://developer.mozilla.org/en/docs/Web/API/Window/localStorage) API on a browser, but you can also use any other [storage](https://github.com/localForage/localForage) [wrapper](https://pouchdb.com/) or any [storage layer](https://github.com/Level/levelup) in Node.js.

## Getting started

After you've [installed the SDK](/developers/docs/javascript/tutorials/using-js-cda-sdk/#setting-up-the-client) you'll need to setup the client with your credentials:

~~~javascript
var client = contentful.createClient({
  space: 'cfexampleapi',
  accessToken: 'b4c0n73n7fu1'
})
~~~

Now you can run your first sync:

~~~javascript
client.sync({initial: true})
.then((response) => {
  console.log(response.entries)
  console.log(response.assets)
})
~~~

As this is the first sync, your response will contain all existing entries and assets.

Any links from entries to other entries and assets will also be resolved. If you don't want that to happen, you can turn it off:

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

If you'd like to store the retrieved content, you can use the convenient `toPlainObject` method or `stringifySafe` to prevent issues with circular links:

~~~javascript
client.sync({initial: true})
.then((response) => {
  const stringifiedResponse = response.stringifySafe()
  window.localStorage.setItem('contentfulEntries', stringifiedResponse.entries)
})
~~~


Your response will also contain a token, which you should store:

~~~javascript
client.sync({initial: true})
.then((response) => {
  window.localStorage.setItem('contentfulSyncToken', response.nextSyncToken)
})
~~~

### Continuing the sync

The next time you want to get updated content, you can use the token you previously stored. This will give you only new, and updated content, as well as a list of what content has been deleted:

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

Every time you perform a sync you get a new token, which represents that point in time for your space, so don't forget to store it again.

You can then loop through the content you have previously stored and removed any content that is now marked as deleted, but that is left as an exercise to the reader.

## Conclusion

Using the Sync API, you can keep your users easily up to date with your latest content.

You can find the JavaScript SDK on [Github](https://github.com/contentful/contentful.js). Don't forget to open an issue if you run into any trouble.
