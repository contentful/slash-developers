---
page: :docsOfflinePersistenceIos
name: Offline Persistence in the iOS SDK
title: Offline Persistence in the iOS SDK
metainformation: 'This tutorial shows you how to get offline access to your Contentful content.'
slug: null
tags:
- Offline
- Content model
nextsteps:
 - docsContentfulCma
 - docsSync
nextsteps:
 - text: Further details on our Syncronization endpoint
   link: /developers/docs/references/content-delivery-api/#/reference/synchronization/
---

There are basically two approaches for getting content for offline use (or for any use for that matter):

- Synchronization, which you should use if most of your content is relevant for all users and if it is not timely. Good examples for that would be a travel or reference guide.
- Search queries, which you should use if your content is timely, like a news app. You would not want to synchronize all kinds of old content for new users or people who haven't used the app in a long time in this case.

## Synchronization

You should be familiar with search queries from our [last blog post][1], so here is a quick rundown on how using synchronization works:

~~~ objc
[client initialSynchronizationWithSuccess:^(CDAResponse *response,
                                            CDASyncedSpace *space) {
  self.space = space; // Hold on to the synchronized space
  NSLog(@"Assets: %@", space.assets);
  NSLog(@"Entries: %@", space.entries);
} failure:^(CDAResponse *response, NSError *error) {
  // Handle errors...
}];
~~~

An initial synchronization will download **all** content of a space and return a [*CDASyncedSpace*][4] instance which contains all the resources and also keeps track of the synchronization process. Subsequent synchronizations can be performed like this:

~~~ objc
[space performSynchronization:^{
  // Handle success...
} failure:^(CDAResponse *response, NSError *error) {
  // Handle errors...
}];
~~~

You will be informed about changes by either using [key-value observation][13] on the *assets* / *entries* properties of the space or by specifying a [*CDASyncedSpaceDelegate*][12].

If you want to continue a synchronization session after an app restart, store the *syncToken* and *lastSyncTimestamp* values and create a shallow space like this:

~~~ objc
CDASyncedSpace* space = [CDASyncedSpace shallowSyncSpaceWithToken:syncToken client:client];
space.lastSyncToken = lastSyncToken;

[space performSynchronization:^{
  // Handle success...
} failure:^(CDAResponse *response, NSError *error) {
  // Handle errors...
}];
~~~

Keep in mind that continuing a synchronization session like this will not reinstate the previous data, so you have to use the delegate to keep your own copy of the data current. You can also check the [synchronization documentation][2] for some more information on the synchronization API.

## Persistence

In addition to that, there are many way to actually persist your data, you might want to use property lists, SQLite or something else entirely. If you need more than just persistence, your choice will probably be Core Data. That is why our SDK is very flexible in this regard. Out of the box, all resources and also [*CDASyncedSpace*][4] support *NSCoding* so that you can simply serialise some data to disk. If you need more flexibility, there is the abstract [*CDAPersistenceManager*][5] class with a sample implementation on top of Core Data. Let's look at the options in detail:

### Using NSCoding

Writing any resource to disk can be done like this:

~~~ objc
[resource writeToFile:@"/some/path"];
~~~

For reading it, you can use a class method, depending on the root object:

~~~ objc
CDAArray* someArray = [CDAArray readFromFile:@"/some/path" client:client];
~~~

Such an object will act just like it would if it was just retrieved via the API, including the possibility to continue your synchronization session if you persisted a [*CDASyncedSpace*][4]:

~~~ objc
CDASyncedSpace* space = [CDASyncedSpace readFromFile:@"/some/path"
                                              client:client];
[space performSynchronization:^{
  // Handle success...
} failure:^(CDAResponse *response, NSError *error) {
  // Handle errors...
}];
~~~

This approach makes it easy to just cache some data, but it has the drawback of needing to load all content into memory at once. It also makes it difficult to associate your own local data, for example a read status on news items, to data retrieved from Contentful.

### Using Core Data

To make it easier to store data retrieved from Contentful into any local data store, the [*CDAPersistenceManager*][5] class exists. For our Core Data [examples][6], a subclass of that was created which should cover your basic needs, but feel free to extend it as you see fit, that is why it is not a part of the SDK itself.

We do not provide an abstraction of Core Data, even though some of the boilerplate code is avoided when using the [CoreDataManager][15] class. At first, you will need to create your data model and managed object classes, which need to conform to the [*CDAPersistedAsset*][16], [*CDAPersistedEntry*][17] and [*CDAPersistedSpace*][18] protocols. The protocols ensure that there is a minimal set of information needed to identify and continue synchronizations. You can now set up your manager instance:

~~~ objc
CoreDataManager* manager = [[CoreDataManager alloc] initWithClient:client dataModelName:@"MyDataModel"];

manager.classForAssets = [MyManagedObjectForAssets class];
manager.classForEntries = [MyManagedObjectForEntries class];
manager.classForSpaces = [MyManagedObjectForSpaces class];
~~~

This will make the data model and managed object subclasses known to the manager. As it only provides a reference implementation, it is assumed that there is only one class for all your entries and also that you do not need to store additional data for assets or the space.

For entries, a mapping is defined to store certain fields in their corresponding properties:

~~~ objc
manager.mappingForEntries = @{
  @"fields.title": @"title",
  @"fields.author": @"author",
  @"fields.abstract": @"abstract",
};
~~~

This will store the field value specified by the key in the property specified by the value of each mapping dictionary entry.

Both the initial fetch as well as subsequent synchronizations can be done like this:

~~~ objc
[manager performSynchronizationWithSuccess:^{
    // Handle success...
} failure:^(CDAResponse *response, NSError *error) {
    // Handle errors...
}];
~~~

The manager will add new resources to the managed object context and delete/update existing ones, until it finally saves the context automatically.

If you want to use a search query to fetch entries, you can use an alternative initializer:

~~~ objc
CoreDataManager* manager = [[CoreDataManager alloc] initWithClient:client
                                                     dataModelName:@"MyDataModel"
                                                             query:@{ @"content_type": @"books" }];
~~~

Using this approach allows you to only fetch a limited data set from your space. It will use *sys.updatedAt* in later queries to only fetch updated resources and use an additional selective synchronization session to also delete no longer existing Resources. Depending on your use case, this will still fetch more data than desirable, in that case, you should also modify the provided reference implementation.

### Seed with initial content

Another [example][7] demonstrates how to ship your app with a pre-seeded SQLite database for Core Data, so that your users will not even need a data connection when they are using your app for the first time.

This is achieved by running a [commandline macOS application][19] which uses the SDK to fetch resources and also all the asset content, which can then be copied into your app as part of your build process or manually. You will have to modify this tool for your needs, specifying the data model, space information and conditions on what asset content to fetch.

The *CDAPersistenceManager* provides a convenience method for copying the database and cached assets from your bundle into the right place:

~~~ objc
[manager seedFromBundleWithInitialCacheDirectory:@"SeededAssets"];
~~~

The method will also ensure that the pre-seeded data is only used after the first launch of your application. After that, you can just update your local content like you normally would.

With this, our overview of synchronizing and keeping your content available for offline use is done. You should be able to provide a great experience for your users regardless of their data connection.

[1]: /blog/2014/09/03/content-management-api-sdk-ios/
[2]: /developers/docs/concepts/sync/
[3]: https://github.com/contentful/contentful.objc/tree/master/Examples
[4]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.0.0/Classes/CDASyncedSpace.html
[5]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.0.0/Classes/CDAPersistenceManager.html
[6]: https://github.com/contentful/contentful.objc/tree/master/Examples/CoreDataExample
[7]: https://github.com/contentful/contentful.objc/tree/master/Examples/SeedDatabase
[8]: https://github.com/contentful/contentful.objc/releases/tag/1.0.0
[9]: https://cocoapods.org/
[10]: https://static.contentful.com/downloads/iOS/ContentfulDeliveryAPI-1.0.0.zip
[11]: https://github.com/contentful/contentful.objc
[12]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.0.0/Protocols/CDASyncedSpaceDelegate.html
[13]: http://nshipster.com/key-value-observing/
[14]: /developers/docs/content-delivery-api/objc/#sync
[15]: https://github.com/contentful/contentful-persistence.objc/blob/master/Code/CoreDataManager.h
[16]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.0.0/Protocols/CDAPersistedAsset.html
[17]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.0.0/Protocols/CDAPersistedEntry.html
[18]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.0.0/Protocols/CDAPersistedSpace.html
[19]: https://github.com/contentful/contentful.objc/blob/master/Examples/SeedDatabase/CommandlineTool/main.m
