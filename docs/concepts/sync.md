---
page: :docsSync
name: Synchronization
title: Synchronization
metainformation: 'The Sync API allows you to keep a local copy of all content in a space up-to-date via delta updates, or content that has changed.'
slug: null
tags:
  - Basics
  - Content model
nextsteps:
  - text: How to use the Sync API with a PHP project
    link: /developers/docs/php/tutorials/using-the-sync-api-with-php/
  - text: Syncing offline content to an Android app
    link: /developers/docs/android/tutorials/offline-persistence-with-vault/
  - text: Syncing offline content to an iOS app
    link: /developers/docs/ios/tutorials/offline-persistence-in-ios-sdk/
---

The Sync API allows you to keep a local copy of all content in a space up-to-date via [delta updates](https://en.wikipedia.org/wiki/Delta_update), or content that has changed.

Mobile data connections can be slow with high latency compared to broadband internet connections. When apps sync content to the device and access it from a local database (e.g. Core Data, LocalStorage, SQLite) data access is faster and apps can provide a better user experience.

Without a Sync API, applications require an ongoing internet connection and have to constantly download all data in each synchronization, including content they are already aware of. This wastes a lot of mobile data and time, especially when syncing on cellular data.

Using the Sync API, applications sync periodically, syncing every few hours when opened or pending user interaction. To do this, it performs delta updates:

- **Get** content added or changed since the last sync.
- **Delete** local content deleted since the last sync.

To enable delta updates, Contentful provides [a synchronization endpoint](/developers/docs/references/content-delivery-api/#/reference/synchronization) to the Content Delivery API. This endpoint delivers only new and changed content and notifies about deleted content. It will never transfer duplicate content the client has received before.

If you are creating a mobile application, it's a good idea to package the initial data sync inside the app and update it with each new release.

## The upside

Syncing with delta updates has the following advantages:

- **Data usage reduction**: Most mobile data plans have limits on data transfers. By transferring only content that has changed, the amount of data used is small. Keeping the sync small also means an improved chance of success when a mobile connection is slow.
- **Time saving**: Because individual syncs are small they will take less time than repeatedly loading data that hasn't changed.
- **Less resource usage**: Less data to process also means less resources required for processing the data and less waiting time.
- **Content entirety**: The initial sync will transfer all entries since the creation of the space alongside all available localizations, which doesn't happen in the Content Delivery API.

## The downside

The synchronization endpoint will always return the content of a space or a specific content type, so it may not make sense to use it for every use case:

- If users only want to see the newest content, it would be wasteful to download everything immediately. In this case, it might be better to only fetch selected content based on the date, using search.
- Because the Sync API retrieves all localized content, it might be better to use the delivery API to retrieve results of a single locale.
- Following the initial sync, the API will still transfer deleted entries, which lengthens each response.
- The synchronization endpoint delivers a maximum of 100 items per page. You will need multiple requests to sync large data sets.

## Usage

The first time you use the Sync API in your application, you need to specify the `initial` URL parameter:

~~~bash
curl -X GET \
     -H 'Authorization: Bearer b4c0n73n7fu1' \
     'https://cdn.contentful.com/spaces/cfexampleapi/sync?initial=true'
~~~

The response will contain a `nextPageUrl` value if your request returned more results than fit into a single page. When retrieving the last page, the response will contain a `nextSyncUrl` which contains a sync token you can use to receive delta updates of changes since your last request.

In addition to the regular `Entry` and `Asset` item types, there can also be `DeletedEntry` and `DeletedAsset` items in the synchronization response. These show that a specific resource has been deleted as delta updates work at the resource level, if a resource has changed, its whole content will be part of the synchronization response.

## Localization

Syncing entries or assets returns all available localizations instead of a single one. Usually resources returned from the delivery API have only a single value per field, the value of the locale you requested or the default locale, but the sync endpoint returns all locales per field.

## Further information

- Using the Sync API for [offline persistence on iOS](/developers/docs/ios/tutorials/offline-persistence-in-ios-sdk/).
- Using synchronization with the [Content Delivery API](/developers/docs/references/content-delivery-api/#/reference/synchronization).
- Using synchronization with the [PHP SDK](/developers/docs/php/tutorials/using-the-sync-api-with-php/).
- Using synchronization with the [JavaScript SDK](/developers/docs/javascript/tutorials/using-the-sync-api-with-js/).
