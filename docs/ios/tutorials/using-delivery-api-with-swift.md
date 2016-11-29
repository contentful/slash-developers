---
page: :docsCdaSwift
---

Read on to find out what our iOS SDK does and how you can use it to build content-driven apps more easily. This tutorial will walk you through building a simple app from start to finish with the [product catalogue app][1] being used as an example.

## Setup

There are different ways for integrating the SDK into your own apps, described in detail in the [README][2]. For the purpose of this article, we will use [CocoaPods][3], the dependency manager for Cocoa projects, which makes it easiest to keep the SDK up-to-date:

~~~ ruby
use_frameworks!

target 'Product Catalogue' do
  pod 'Contentful', '~> 0.2.0'
  pod 'ContentfulPersistenceSwift', '~> 0.2.0'
end
~~~

Since we also want to provide offline persistence to our users, the app integrates the [Contentful persistence library][4] as well. If you prefer to not use a dependency manager, we also provide dynamic frameworks as part of our GitHub releases, but keep in mind that those might not be compatible depending on the Swift version you use, because there is [no stable Swift ABI, yet][5].

## Configuring the API client

The class [Client][6] manages all requests to the API. For creating a client object, the space ID and a Content Delivery API access token are required. We provide an example Space for this tutorial, but you can learn more about authentication with our APIs [here][7].

~~~ swift
let spaceId = "phq7bbxq15g4"
let token = "885ea645d74c1ba6d3ee5ac4020104bc0e14afdb2552632d67e14b0c02fc06e6"

let client = Client(spaceIdentifier: spaceId, accessToken: token)
~~~

## Accessing data

Now that we have initialized a client, we can fetch entries:

~~~ swift
client.fetchEntries(["content_type": "product"]).1.next {
    print($0)
}
~~~

Each content type in Contentful has its own unique ID, you can find it by looking at the last part of the URL when you have opened it in the web app:

![](content-type-id.png)

The [`fetchEntries(_:)`][8] method returns a tuple of `NSURLSessionDataTask`, for cancellation purposes, and a [signal][10], which will be called on completion of the request. The error is also available via `.error` and if you prefer, there is [a variant][9], which takes a completion closure instead.

Our API supports a variety of parameters to search, filter and sort your content. Those parameters are passed as a dictionary when using the SDK, in this case only entries of a certain content type will be retrieved. You can learn more about search parameters [here][20]. You can also explore more of our API using [this Playground][12].

## Offline persistence

Since the app should also have offline persistence, we are going a different route, though. The persistence library provides a `ContentfulSynchronizer` type which utilizes the [sync API][13] to synchronize a Contentful space with a local data store, relying on a mapping provided by you. There is a default implementation of the [`PersistenceStore` protocol][15] using [Core Data][14], but if you want to use a different local store, it is fairly straightforward to create your own implementation.

~~~ swift
let store = CoreDataStore(context: self.managedObjectContext)
let synchronizer = ContentfulSynchronizer(client: client, persistenceStore: store)
~~~

It is your own responsibility to provide the right `NSManagedObjectContext` for your application here. If you are working with Core Data in a multi-threaded environment, make sure to check out [Apple's Core Data Programming Guide][16]. Depending on your setup, you might also want to create different managed object contexts for writing and reading data. While the `CoreDataStore` class can be used for querying, you don't have to use it.

The best way to replicate your content model from Contentful in your own app is using [our Xcode plugin][17]. This requires management access to the space, though, so you can only use the plugin on your own spaces. For the purpose of this tutorial, you can use the [generated model][18] from the example's GitHub repository. The generated model contains a class per content type, with fields matching the ones from Contentful, and there are also dedicated classes for assets and spaces. From the data model, you can generate classes using Xcode -- each class must implement a protocol, which requires a manual step (`Resource` for entries, `Asset` for assets and `Space` for spaces).

Using this, a mapping can be defined between your content model and the local entities:

~~~ swift
synchronizer.mapAssets(to: Asset.self)
synchronizer.mapSpaces(to: SyncInfo.self)

synchronizer.map(contentTypeId: "brand", to: Brand.self)
synchronizer.map(contentTypeId: "category", to: ProductCategory.self)
synchronizer.map(contentTypeId: "product", to: Product.self)
~~~

By default, Contentful fields are automatically mapped to properties of the same name, but you can optionally specify a custom mapping, if needed. Keep in mind that for assets, the URL will be stored, but no caching of the actual documents is performed -- for caching images look into [FastImageCache][19], for example.

## Displaying the data

To display the list of products, we will use a regular `UITableView` based on a `NSFetchedResultsController`:

~~~ swift
func fetchedResultsController(forContentType type: Any.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) throws -> NSFetchedResultsController {
    let fetchRequest = try store.fetchRequest(type, predicate: predicate)
    fetchRequest.sortDescriptors = sortDescriptors
    return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
}
~~~

Using the fetched results controller as a table view data source is done through some glue code in a `CoreDataFetchDataSource` class, which is out of scope to discuss here, but you can check it out in [the example on GitHub][20].

All the Contentful synchronization specific code is placed into a single class `ContentfulDataManager` ([see here on GitHub][21]):

~~~ swift
class ProductList: UITableViewController {
    lazy var dataManager: ContentfulDataManager = {
        return ContentfulDataManager()
    }()
~~~

Finally, we can instantiate a specific data source for our table view:

~~~ swift
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
~~~

With this, our walk through the [product catalogue app][1] is done. You should have everything you need to start building your own iOS apps with Contentful. Check out [the SDK][22] and start building.


[1]: https://github.com/contentful/product-catalogue-swift
[2]: https://github.com/contentful/contentful.swift#installation
[3]: https://cocoapods.org
[4]: https://github.com/contentful/contentful-persistence.swift
[5]: https://developer.apple.com/swift/blog/?id=2
[6]: http://cocoadocs.org/docsets/Contentful/0.2.1/Classes/Client.html
[7]: /developers/docs/references/authentication/
[8]: http://cocoadocs.org/docsets/Contentful/0.2.1/Classes/Client.html#/s:FC10Contentful6Client12fetchEntriesFTGVs10DictionarySSPs9AnyObject___TGSqCSo20NSURLSessionDataTask_GC12Interstellar6SignalGVS_5ArrayVS_5Entry___
[9]: http://cocoadocs.org/docsets/Contentful/0.2.1/Classes/Client.html#/s:FC10Contentful6Client12fetchEntriesFTGVs10DictionarySSPs9AnyObject__10completionFGO12Interstellar6ResultGVS_5ArrayVS_5Entry__T__GSqCSo20NSURLSessionDataTask_
[10]: http://cocoadocs.org/docsets/Interstellar/1.4.0/Classes/Signal.html
[11]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[12]: https://github.com/contentful/ContentfulPlayground
[13]: developers/docs/concepts/sync/
[14]: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/index.html
[15]: http://cocoadocs.org/docsets/ContentfulPersistenceSwift/0.2.0/Protocols/PersistenceStore.html
[16]: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/Concurrency.html
[17]: /developers/docs/ios/tutorials/using-contentful-xcode-plugin/
[18]: https://github.com/contentful/product-catalogue-swift/tree/master/Resources/Product%20Catalogue.xcdatamodeld
[19]: https://github.com/path/FastImageCache
[20]: https://github.com/contentful/product-catalogue-swift/blob/master/Code/DataSource.swift
[21]: https://github.com/contentful/product-catalogue-swift/blob/master/Code/ContentfulDataManager.swift
[22]: https://github.com/contentful/contentful.swift
