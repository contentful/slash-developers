---
page: :docsCdaSwift
name: Getting Started with Contentful and Swift
title: Getting Started with Contentful and Swift
metainformation: This tutorial will walk you through building a simple app from start to finish.
slug: null
tags:
  - CDA
  - iOS
  - Mobile
nextsteps:
  - docsCdaIos
  - docsCmaIos
---

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

We publish SDKs for various languages to make developing applications easier. This article details how to get content using the [Swift CDA SDK][22].

## Pre-requisites

This tutorial assumes you have read and understood [the guide that covers the Contentful data model](/developers/docs/concepts/data-model/).

## Authentication

For every request, clients [need to provide an API key][7], which is created per space and used to delimit applications and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key).

## Setup

There are different ways for integrating the SDK into your own apps, described in detail in the [README for the SDK][2]. For this guide, we will use [CocoaPods][3], the dependency manager for Cocoa projects, which helps you keep the SDK up-to-date:

Create the following _Podfile_ for your project:

```ruby
use_frameworks!

target 'Product Catalogue' do
  pod 'Contentful', '~> 0.2.0'
  pod 'ContentfulPersistenceSwift', '~> 0.2.0'
end
```

As you are developing a mobile app, you should provide offline persistence to users and the app integrates the [Contentful persistence library][4]. If you prefer to not use a dependency manager, we also provide dynamic frameworks as part of our GitHub releases, but these might not be compatible depending on the Swift version you use, because there is [no stable Swift ABI yet][5].

## Configuring the API client

The [Client][6] class manages all requests to the API. To create a client object, you will need the authentication token and Space ID from earlier.

```swift
let spaceId = "phq7bbxq15g4"
let token = "885ea645d74c1ba6d3ee5ac4020104bc0e14afdb2552632d67e14b0c02fc06e6"

let client = Client(spaceIdentifier: spaceId, accessToken: token)
```

## Accessing data

Now that you have initialized a client, you can fetch entries:

```swift
client.fetchEntries(["content_type": "product"]).1.next {
    print($0)
}
```

Each content type in Contentful has its own unique ID, and you can find it by looking at the last part of the URL when you have opened it in the web app:

![Finding the Content type ID](content-type-id.png)

The [`fetchEntries(_:)`][8] method returns a tuple of `NSURLSessionDataTask`, for cancellation purposes, and a [signal][10], which will be called on completion of the request. The error is also available via `.error` and if you prefer, there is [a variant][9], which takes a completion closure instead.

Our API supports a variety of parameters to search, filter and sort your content. These parameters are passed as a dictionary when using the SDK, in this case will retrieve entries of a certain content type. You can learn more about search parameters [in this guide][20]. You can also explore more of our API using [this Playground][12].

## Offline persistence

The Contentful persistence library provides a `ContentfulSynchronizer` type which utilizes the [sync API][13] to synchronize a Contentful space with a local data store, relying on a mapping provided by you. There is a default implementation of the [`PersistenceStore` protocol][15] using [Core Data][14], but if you want to use a different local store, you can create your own.

```swift
let store = CoreDataStore(context: self.managedObjectContext)
let synchronizer = ContentfulSynchronizer(client: client, persistenceStore: store)
```

In this case, it's your responsibility to provide the right `NSManagedObjectContext` for your application. If you are working with Core Data in a multi-threaded environment, make sure to read [Apple's Core Data Programming Guide][16]. Depending on your setup, you might need to create different managed object contexts for writing and reading data. While you can use the `CoreDataStore` class for querying, you don't have to.

The best way to replicate your content model from Contentful in your own app is using [our Xcode plugin][17]. This requires management access to the space, so you can only use the plugin for your own spaces. For this tutorial, you can use the [generated model][18] from the example GitHub repository. The generated model contains a class per content type, with fields matching those from Contentful, and there are dedicated classes for assets and spaces. From the data model, you can generate classes using Xcode, but each class must implement a protocol, which requires a manual step (`Resource` for entries, `Asset` for assets and `Space` for spaces).

Using this, you can define a mapping between your content model and the local entities:

```swift
synchronizer.mapAssets(to: Asset.self)
synchronizer.mapSpaces(to: SyncInfo.self)

synchronizer.map(contentTypeId: "brand", to: Brand.self)
synchronizer.map(contentTypeId: "category", to: ProductCategory.self)
synchronizer.map(contentTypeId: "product", to: Product.self)
```

By default, Contentful fields are automatically mapped to properties of the same name, but you can optionally specify a custom mapping, if needed. Keep in mind that for assets, the URL will be stored, but no caching of the actual documents is performed, for caching images look into [FastImageCache][19], for example.

## Displaying the data

To display the list of products, use a `UITableView` based on a `NSFetchedResultsController`:

```swift
func fetchedResultsController(forContentType type: Any.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) throws -> NSFetchedResultsController {
    let fetchRequest = try store.fetchRequest(type, predicate: predicate)
    fetchRequest.sortDescriptors = sortDescriptors
    return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
}
```

Using the fetched results controller as a table view data source is done through glue code in a `CoreDataFetchDataSource` class, which is out of scope to discuss here, but you can check it out in [the example on GitHub][20].

All the Contentful synchronization specific code is in a single class, `ContentfulDataManager` ([read more on GitHub][21]):

```swift
class ProductList: UITableViewController {
    lazy var dataManager: ContentfulDataManager = {
        return ContentfulDataManager()
    }()
```

You can instantiate a specific data source for the table view:

```swift
lazy var dataSource: CoreDataFetchDataSource<ProductCell> = {
        let resultsController = try! self.dataManager.fetchedResultsController(forContentType: Product.self, predicate: self.predicate, sortDescriptors: [NSSortDescriptor(key: "productName", ascending: true)])
        return CoreDataFetchDataSource<ProductCell>(fetchedResultsController: resultsController, tableView: self.tableView)
    }()

    var predicate: NSPredicate = NSPredicate(value: true)

    override func viewDidLoad() {
      super.viewDidLoad()

      tableView.dataSource = dataSource
    }
}
```

## Conclusion

That completes the explanation of the [product catalogue app][1] and you have enough knowledge to start building your own iOS apps with Contentful.

[1]: https://github.com/contentful/product-catalogue-swift
[10]: http://cocoadocs.org/docsets/Interstellar/1.4.0/Classes/Signal.html
[11]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[12]: https://github.com/contentful/ContentfulPlayground
[13]: /developers/docs/concepts/sync/
[14]: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/index.html
[15]: http://cocoadocs.org/docsets/ContentfulPersistenceSwift/0.2.0/Protocols/PersistenceStore.html
[16]: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/Concurrency.html
[17]: /developers/docs/ios/tutorials/using-contentful-xcode-plugin/
[18]: https://github.com/contentful/product-catalogue-swift/tree/master/Resources/Product%20Catalogue.xcdatamodeld
[19]: https://github.com/path/FastImageCache
[2]: https://github.com/contentful/contentful.swift#installation
[20]: https://github.com/contentful/product-catalogue-swift/blob/master/Code/DataSource.swift
[21]: https://github.com/contentful/product-catalogue-swift/blob/master/Code/ContentfulDataManager.swift
[22]: https://github.com/contentful/contentful.swift
[3]: https://cocoapods.org
[4]: https://github.com/contentful/contentful-persistence.swift
[5]: https://developer.apple.com/swift/blog/?id=2
[6]: http://cocoadocs.org/docsets/Contentful/0.2.1/Classes/Client.html
[7]: /developers/docs/references/authentication/
[8]: http://cocoadocs.org/docsets/Contentful/0.2.1/Classes/Client.html#/s:FC10Contentful6Client12fetchEntriesFTGVs10DictionarySSPs9AnyObject___TGSqCSo20NSURLSessionDataTask_GC12Interstellar6SignalGVS_5ArrayVS_5Entry___
[9]: http://cocoadocs.org/docsets/Contentful/0.2.1/Classes/Client.html#/s:FC10Contentful6Client12fetchEntriesFTGVs10DictionarySSPs9AnyObject__10completionFGO12Interstellar6ResultGVS_5ArrayVS_5Entry__T__GSqCSo20NSURLSessionDataTask_
