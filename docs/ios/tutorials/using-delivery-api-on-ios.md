---
page: ':docsCdaIos'
name: Using the Delivery API on iOS
title: Using the Delivery API on iOS
metainformation: This guide will show you what our iOS SDK does and how you can use it to build content-driven apps.
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

:[Getting started tutorial intro](../../_partials/getting-started-intro.md)

This article details how to get content using the [Objective-C CDA SDK](https://github.com/contentful/contentful.objc).

## Setup the client

There are three different ways to integrate the SDK into your own apps, described in detail in the [README][2]. For this article, we will use [CocoaPods][8], the dependency manager for Cocoa projects, which makes it easiest to keep the SDK up-to-date:

~~~ruby
target "Guide" do
  pod 'ContentfulDeliveryAPI'
end
~~~

You are free to use Git submodules or [download a static framework][18] if that suits your workflow better.

## Configuring the API client

The class [_CDAClient_][3] manages all requests to the API. For most apps, you will have a single Space which contains all your data. In this case, we recommend you create a singleton category on top of _CDAClient_ to make it simple to dispatch requests from any part of your app:

:[Create credentials](../../_partials/credentials.md)

~~~objc
@implementation CDAClient (Guide)

  +(instancetype)sharedClient {
    static dispatch_once_t once;
    static CDAClient *sharedClient;
    dispatch_once(&once, ^ {
      sharedClient = [[self alloc] initWithSpaceKey:@"<space_id>" accessToken:@"<access_token>"];
    });
    return sharedClient;
  }

@end
~~~

## Accessing data

Now that the client is available everywhere, you can fetch entries:

~~~objc
[[CDAClient sharedClient] fetchEntriesMatching:@{ @"content_type": @"3hEsRfcKgMGSaiocGQaqCo" }
                                       success:^(CDAResponse *response, CDAArray *array) {
                                           self.places = array.items;
                                       } failure:nil];
~~~

The CDA supports a variety of parameters to search, filter and sort your content. The SDK passes these parameters as a dictionary, which in this case will retrieve entries of a certain content type. You can learn more about search parameters [in this guide][20].

A [_CDAArray_][5] contains a list of [_CDAResource_][6] objects whose concrete type depends on the query. In this case, the _items_ property will contain a list of [_CDAEntry_][7] objects.

Each _CDAEntry_ has a _fields_ property, containing the values for fields defined in the content model. To decouple your app from Contentful, you can register custom subclasses for content types, like this:

~~~objc
[sharedClient registerClass:[BBUPlace class] forContentTypeWithIdentifier:@"3hEsRfcKgMGSaiocGQaqCo"];
~~~

The _BBUPlace_ class defines properties, so that you can deal with entries like with any other value object:

~~~objc
-(NSString *)name {
  return self.fields[@"name"];
}
~~~

In the guide app, the class also implements the _MKAnnotation_ protocol, which enables directly showing Entries in a map view.

## Simple views for your data

The initial view of the guide app is a list of all cafes it knows about. For common tasks like this, the SDK adds UI components which you can customize to your needs. In this case, you will create a subclass of [_CDAEntriesViewController_][4], a _UITableViewController_ optimized for showing a list of Entries matching a certain query.

You create the basic setup in your subclasse's _init_ method:

~~~objc
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

The cell mapping is a dictionary for specifying which property of the `UITableViewCell` corresponds to properties in the content model. In addition to that, the shared client is specified as the client to use and the entries are limited to a certain content type. Setting the `query` property is optional, in that case all entries will be shown.

![*CDAEntriesViewController* in action](https://raw.githubusercontent.com/contentful-labs/guide-app-ios/master/Screenshots/menu.png)

If you want to show resources in a `UICollectionView`, there is [`CDAResourcesCollectionViewController`][9], which works in a similar way to the Entries view controller:

~~~objc
self = [super initWithCollectionViewLayout:layout cellMapping:@{ @"imageURL": @"URL" }];
if (self) {
    self.client = [CDAClient sharedClient];
    self.resourceType = CDAResourceTypeAsset;
}
~~~

You need to specify a layout and cell mapping, as with a normal `UICollectionViewController`. For convenience, there is a ready made collection view cell class which fetches images from the URL in its `imageURL` property, which this example will use. The `resourceType` property defines which resource type is fetched, in this case 'Assets'. A [`CDAAsset`][10] has a direct accessor for the `URL`, used in the field mapping. Like the previous example, you need to specifiy the client.

![*CDAResourcesCollectionViewController* in action](https://raw.githubusercontent.com/contentful-labs/guide-app-ios/master/Screenshots/pictures.png)

## Presenting data your own way

It's possible and often necessary to write normal `UIViewController` subclasses and fetch content from Contentful. The [`BBULocationViewController`][11] class in the guide app does this, utilizing the `BBUPlace` class mentioned earlier in the tutorial. This way, it does not have specific knowledge about the Contentful SDK.

[Links][12] might not be resolved, depending on your query. If this is the case, use the `resolveWithSuccess:failure:` method on any `CDAResource` inside your custom class. Look at the `fetchPictureAssetsWithCompletionBlock:` method from `BBUPlace` for an example. You can add the `include` parameter to your query to adjust how many levels of links are automatically included as part of the API response. This helps to keep the number of API requests your app has to make low and therefore improves performance. You learn more about includes [in this guide][21].

Fields can include [Markdown][14]. This [example app][15] which shows how to use the [Bypass][16] library to converting Markdown into a `NSAttributedString` which you can display in a `UITextView`. Depending on your use case and target platform, you might want to evaluate other options, for example converting to HTML. Keep in mind that the library does not support the whole range of GitHub flavoured Markdown syntax available in the Contentful entry editor.

[1]: https://github.com/contentful/guide-app-ios
[10]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAAsset.html
[11]: https://github.com/contentful/guide-app-ios/blob/master/Code/BBULocationViewController.m
[12]: /developers/docs/concepts/links/
[14]: /blog/2014/02/28/here-be-bold-headlines/
[15]: https://github.com/contentful/blog-app-ios
[16]: https://uncodin.github.io/bypass/
[17]: https://github.com/contentful/contentful.objc
[18]: https://static.contentful.com/downloads/iOS/ContentfulDeliveryAPI-1.9.2.zip
[19]: /developers/docs/references/authentication/
[2]: https://github.com/contentful/contentful.objc/blob/master/README.md
[20]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[21]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/including-linked-entries
[3]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAClient.html
[4]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAEntriesViewController.html
[5]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAArray.html
[6]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAResource.html
[7]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAEntry.html
[8]: https://cocoapods.org/
[9]: http://cocoadocs.org/docsets/ContentfulDeliveryAPI/1.9.2/Classes/CDAResourcesCollectionViewController.html
