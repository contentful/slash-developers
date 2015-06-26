---
page: :docsSync
---

Synchronizing content greatly improves the user experience of applications. Mobile data connections can still be slow and have a very high latency compared to broadband internet connections. When apps sync content to the device and access it from a local database (e.g. CoreData, LocalStorage, SQLite) data access is much faster and apps can provide a much better user experience.

Applications sync periodically: Depending on the use case they may sync every few hours, when being opened or pending user interaction, e.g., on pull to refresh.

To further illustrate this let's think of an example mobile app: A travel guide application which has information about places of interest for a certain area. Users of the travel guide will probably be abroad with a limited data package or no cellular data at all.

Some applications download all available data on every sync, including content they already knew about. This wastes a lot of mobile data and valuable time. This is especially a problem when syncing while on cellular data.

Most applications don't sync at all and require an ongoing internet connection. Many of these apps don't really require a constant connection to work but are still effectively useless when there is no internet. In the case of the travel guide having to hop from wifi to wifi simply to use it would be frustrating.

Instead it makes sense to perform delta updates:

- Get content which has been added or changed since the last sync
- Delete local content which has been deleted since the last sync

Compared to the other sync strategies delta updates have many benefits:

- Use as little data as possible: Most mobile data plans have limits on how much data can be transferred (at full speed) within a given time period. By transferring only actual changes and not transferring everything every time the data footprint of a synchronization is very small. Keeping the sync small also means greatly improved chances of success when a mobile connection is slow.
- Fast synchronization: Because individual syncs are small they will only take a few seconds at most.
- As little resource usage as possible: Less data to process also means less resources required for processing the data and less waiting time for users of mobile applications.

To enable delta updates Contentful provides a special synchronization endpoint. This endpoint delivers only new and changed content and notifies about deleted content (deletions). It will never transfer duplicate content the client has already received before.

Keep in mind that the synchronization endpoint will always give you all the content of a Space or a specific Content Type, so it may not make sense to use it for every use case. If users only want to see the newest content, it would be wasteful to download everything immediately. In that case, it might be better to only fetch selected content based on the date, using search.

## Usage

- The first time you are using the Sync API in your application, you need to specify the `intial` URL parameter:

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

- Using the Sync API for [offline persistence on iOS](/developers/documentation/tutorials/ios/offline-sync/)

<!-- TODO Link back to CDA reference -->
