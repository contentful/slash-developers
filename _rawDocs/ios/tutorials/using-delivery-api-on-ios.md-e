---
page: :docsCdaIos
name: Using the Delivery API on iOS
title: Using the Delivery API on iOS
metainformation: 'This guide will show you what our iOS SDK does and how you can use it to build content-driven apps.'
slug: null
tags:
  - CDA
  - iOS
  - Mobile
nextsteps:
  - text: Using our management API with Objective-C
    link: /developers/docs/ios/tutorials/using-management-api-on-ios/
  - text: Using the delivery API with Swift
    link: /developers/docs/ios/tutorials/using-delivery-api-with-swift/
---

Read on to find out what our iOS SDK does and how you can use it to build content-driven apps more easily. The [coffee guide app][1] will provide an example and walk you through building a simple app from start to finish.

## Setup

There are three different ways for integrating the SDK into your own apps, described in detail in the [README][2]. For the purpose of this article, we will use [CocoaPods][8], the dependency manager for Cocoa projects, which makes it easiest to keep the SDK up-to-date:

~~~ ruby
target "Guide" do
  pod 'ContentfulDeliveryAPI'
end
~~~

However, you are free to use Git submodules or [download a static framework][18] if that suits your workflow better.

## Configuring the API client

The class [*CDAClient*][3] manages all requests to the API. For most apps, you will have a single Space which contains all your data. In this case, it is recommended to create a singleton category on top of *CDAClient* to make it simple to dispatch requests from any part of your app:

~~~ objc
@implementation CDAClient (Guide)

  +(instancetype)sharedClient {
    static dispatch_once_t once;
    static CDAClient *sharedClient;
    dispatch_once(&once, ^ {
      sharedClient = [[self alloc] initWithSpaceKey:@"nhkrrfkqkvcv" accessToken:@"4c1379f8fa28be7025968c1163b13e23ded85d5747c06f9634abd9724a70fd17"];
    });
    return sharedClient;
  }

@end
~~~

For creating a client object, the space ID and a Content Delivery API access token are required. We provide an example space for this tutorial, but you can learn more about authentication with our APIs [here][19].

## Accessing data

Now that the client is available everywhere, you can fetch entries:

~~~ objc
[[CDAClient sharedClient] fetchEntriesMatching:@{ @"content_type": @"3hEsRfcKgMGSaiocGQaqCo" }
                                       success:^(CDAResponse *response, CDAArray *array) {
                                           self.places = array.items;
                                       } failure:nil];
~~~

Our API includes supports a variety of parameters to search, filter and sort your content. Those parameters are passed as a dictionary when using the SDK, in this case only entries of a certain content type will be retrieved. You can learn more about search parameters [here][20].

A [*CDAArray*][5] contains a list of [*CDAResource*][6] objects whose concrete type depends on the query. In this case, the *items* property will contain a list of [*CDAEntry*][7] objects.

Each *CDAEntry* has a *fields* property, containing the values for fields defined in the content model. To decouple your app from Contentful, you can register custom subclasses for content types, like this:

~~~ objc
[sharedClient registerClass:[BBUPlace class] forContentTypeWithIdentifier:@"3hEsRfcKgMGSaiocGQaqCo"];
~~~

The *BBUPlace* class defines properties like:

~~~ objc
-(NSString *)name {
  return self.fields[@"name"];
}
~~~

so that you can deal with entries like with any other value object.

In the guide app, the class also implements the *MKAnnotation* protocol, which enables directly showing Entries in a map view.

## Simple views for your data

The initial view of the guide app is a list of all coffee places it knows about. For common tasks like this, the SDK brings some UI components which can be customized to your needs. In this case, we will create a subclass of [*CDAEntriesViewController*][4], a *UITableViewController* optimized for showing a list of Entries matching a certain query.

The basic setup is done in your subclasse's *init* method:

~~~ objc
-(id)init {
  self = [super initWithCellMapping:@{ @"textLabel.text": @"fields.name",
                                       @"detailTextLabel.text": @"fields.type" }];
  if (self) {
    self.client = [CDAClient sharedClient];
    self.query = @{ @"content_type": @"3hEsRfcKgMGSaiocGQaqCo" };
  }
  return self;
}
~~~

The cell mapping is a dictionary for specifying which property of the *UITableViewCell* corresponds to properties in the content model. In addition to that, the shared client is specified as the client to use and the entries are limited to a certain content type. Setting the *query* property is optional, in that case all entries will be shown.

<img alt="*CDAEntriesViewController* in action" style="width: initial; display: block;
  margin: 0 auto;" src="https://raw.githubusercontent.com/contentful-labs/guide-app-ios/master/Screenshots/menu.png" />

If you want to show resources in a *UICollectionView*, there is [*CDAResourcesCollectionViewController*][9]. It works similar to the Entries view controller:

~~~ objc
self = [super initWithCollectionViewLayout:layout cellMapping:@{ @"imageURL": @"URL" }];
if (self) {
    self.client = [CDAClient sharedClient];
    self.resourceType = CDAResourceTypeAsset;
}
~~~

You need to specify a layout, just like in a normal *UICollectionViewController* and there is also the cell mapping again. For convenience, there is a ready made collection view cell class which fetches images from the URL in its *imageURL* property, so that is what we are going to use in this example. The *resourceType* property defines which type of Resource is going to be fetched, in this case Assets. A [*CDAAsset*][10] has a direct accessor for the *URL* which is used in the cell mapping here. Finally, the client needs to be specified, like in the previous example.

<img alt="*CDAResourcesCollectionViewController* in action" style="width: initial; display: block;
  margin: 0 auto;" src="https://raw.githubusercontent.com/contentful-labs/guide-app-ios/master/Screenshots/pictures.png" />

## Presenting data your own way

Of course, it is also possible and often needed to write normal *UIViewController* subclasses and just pull in some data from Contentful. The class [*BBULocationViewController*][11] from the guide app does just that, utilising the *BBUPlace* class mentioned earlier. That way, it does not have specific knowledge about the Contentful SDK.

Two things to consider here:

* [Links][12] might not be resolved, depending on your query. If that is the case, use the *resolveWithSuccess:failure:* method on any *CDAResource*. This should be done inside your custom class, look at the *fetchPictureAssetsWithCompletionBlock:* method from *BBUPlace* for an example. You can also add the `include` parameter to your query to adjust how many levels of links are automatically included as part of the API response. This helps to keep the number of API requests your app has to make low and therefore improves performance. You learn more about includes [here][21].
* Fields can include [Markdown][14]. There is [another example app][15] which shows how to use the [Bypass][16] library for converting Markdown into *NSAttributedString* which can be displayed in a *UITextView* since iOS 7. Depending on your use case and target platform, you might want to evaluate other options, for example converting to HTML. Also keep in mind that the library does not support the whole range of GitHub flavoured Markdown syntax available in the Contentful entry editor.

With this, our walk through the [coffee guide app][1] is done. You should have everything you need to start building your own iOS apps with Contentful. Check out [the SDK][17] and start building.

[1]: https://github.com/contentful/guide-app-ios
[2]: https://github.com/contentful/contentful.objc/blob/master/README.md
[3]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAClient.html
[4]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAEntriesViewController.html
[5]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAArray.html
[6]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAResource.html
[7]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAEntry.html
[8]: https://cocoapods.org/
[9]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAResourcesCollectionViewController.html
[10]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAAsset.html
[11]: https://github.com/contentful/guide-app-ios/blob/master/Code/BBULocationViewController.m
[12]: /developers/docs/concepts/links/
[14]: /blog/2014/02/28/here-be-bold-headlines/
[15]: https://github.com/contentful/blog-app-ios
[16]: https://uncodin.github.io/bypass/
[17]: https://github.com/contentful/contentful.objc
[18]: https://static.contentful.com/downloads/iOS/ContentfulDeliveryAPI-1.9.2.zip
[19]: /developers/docs/references/authentication/
[20]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[21]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/including-linked-entries
