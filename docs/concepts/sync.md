---
page: :docsSync
---

The Sync API allows you to keep a local copy of all content of a Space up-to-date via delta updates.

Synchronizing content greatly improves the user experience of applications. Mobile data connections can be slow and have a very high latency compared to broadband internet connections. When apps sync content to the device and access it from a local database (e.g. CoreData, LocalStorage, SQLite) data access is much faster and apps can provide a much better user experience.

Without a Sync API, applications require an ongoing internet connection and constantly download all data in each synchronization, including content they already knew about. This wastes a lot of mobile data and time, especially when syncing on cellular data.

Instead, using the Sync API, applications sync periodically. Depending on the use case, they may sync every few hours when opened or pending user interaction. To do so, it performs delta updates:

- Get content which has been added or changed since the last sync
- Delete local content which has been deleted since the last sync

To enable delta updates, Contentful provides a special synchronization endpoint. This endpoint delivers only new and changed content and notifies about deleted content (deletions). It will never transfer duplicate content the client has already received before.

## The Upside

Compared to the other strategies, syncing with delta updates has many advantages:

- Use as little data as possible: Most mobile data plans have limits on how much data can be transferred (at full speed) within a given time period. By transferring only actual changes and not transferring everything every time, the amount of data of a synchronization is very small. Keeping the sync small also means improved chances of success when a mobile connection is slow.
- Fast synchronization: Because individual syncs are small they will take much less time than repeatedly loading data that hasn't changed.
- As little resource usage as possible: Less data to process also means less resources required for processing the data and less waiting time for users of mobile applications.
- Entirety of content: the initial sync will transfer all items since the creation of the Space alongside all available localizations, which doesn't happen in the Delivery API.

## The Downside

Keep in mind that the synchronization endpoint will always give you all the content of a Space or a specific Content Type, so it may not make sense to use it for every use case:

- If users only want to see the newest content, it would be wasteful to download everything immediately. In that case, it might be better to only fetch selected content based on the date, using search.
- Because the Sync API retrieves all localized content, it might be better to use the Delivery API to retrieve results of a single locale
- Following the initial sync, removed items will be transfered in the form of Deletions, which may unnecessarily lengthen each response 

## Usage

- The first time you are using the Sync API in your application, you need to specify the `initial` URL parameter:

~~~ bash
curl -X GET \
     -H 'Authorization: Bearer b4c0n73n7fu1' \
     'https://cdn.contentful.com/spaces/cfexampleapi/sync?initial=true'
~~~

- In the response, you will receive a `nextPageUrl` in case your request returned more results than what fits into a single page. Eventually, when retrieving the last page, the response will contain a `nextSyncUrl` which contains an opaque sync token which can be used to receive delta updates of changes performed after your last request.

In addition to the regular `Entry` and `Asset` item types, there can also be `DeletedEntry` and `DeletedAsset` items in the synchronization response, these indicate that a specific resource has been deleted. The delta updates work at the resource level, if a resource has been changed, its whole content will be part of the synchronization response.

## Localization

When syncing Entries or Assets they come in all available localizations instead of just a single one. Usually Resources coming from the Delivery API only come with a single value per field - the value of the locale you requested or the default one. The Sync endpoint returns all locales per field.

## Further information

- Using the Sync API for [offline persistence on iOS](/developers/docs/tutorials/ios/offline-persistence-in-ios-sdk/)

<!-- TODO Link back to CDA reference -->
