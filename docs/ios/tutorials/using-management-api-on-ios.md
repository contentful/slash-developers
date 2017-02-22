---
page: :docsCmaIos
name: Using the Management API on iOS
title: Using the Management API on iOS
metainformation: This post will walk you through implementing a simple iOS app for uploading images from the device Camera Roll to Contentful.
slug: null
tags:
  - CMA
  - iOS
  - Mobile
nextsteps:
  - text: The Contentful Management API reference
    link: /developers/docs/references/content-management-api/
---

This post will walk you through implementing a simple iOS app for uploading images from the device's Camera Roll to Contentful.

Like the [CDA SDK][1] before, you simply install the CMA SDK via [CocoaPods][2]:

~~~objc
platform :ios, '7.0'
pod 'ContentfulManagementAPI'
~~~

In the project's [README][3], you can also find explanations for other options, like Git submodules or a pre-built static framework.

After you successfully installed the library you need to create a client object. For this you need to obtain a Content Management API token. A token can easily be obtained in the [developer center][4].

With it, you can instantiate a client object:

~~~objc
CMAClient* client = [[CMAClient alloc] initWithAccessToken:@"your-token"];
~~~

Next we need to fetch a space to use. Contrary to the Content Delivery API, we can just list all spaces the given account has access to:

~~~objc
[client fetchAllSpacesWithSuccess:^(CDAResponse *response, CDAArray *array) {
    self.spaces = array.items;

    [self.tableView reloadData];
} failure:^(CDAResponse *response, NSError *error) {
   NSLog(@"Error: %@", error);
}];
~~~

![In our app, they are displayed as a list of names in a table view](https://images.contentful.com/m5kgizmngfqu/2qSSJ4l0IYQq2WeoaAoUOc/b88666a983860c36385f3d0cccc10244/table-view.png?w=250)

Once we have selected a specific space, we can create resources, in our case an asset. This can be done using the [`-createAssetWithTitle:description:fileToUpload:success:failure:`][5] method. For this, we need to specify an URL to a file, though and we just have a local image in the photo library at the moment. For a temporary upload, we use [this Pod][6], which just gives us a file URL back, as we need it:

~~~objc
[[BBUUploadsImUploader sharedUploader] uploadImage:someImage
completionHandler:^(NSURL *uploadURL, NSError *error) {
  if (!uploadURL) {
    NSLog(@"Error: %@", error);
    return;
  }

  NSLog(@"URL of uploaded image: %@", uploadURL);
}];
~~~

We can obtain the latest photo from the Camera Roll using the `AssetsLibrary` framework quite easily:

~~~objc
-(void)fetchLatestPhotoWithCompletionHandler:(void (^)(UIImage* latestPhoto, NSError* error))handler {
  NSParameterAssert(handler);

  ALAssetsLibrary *library = [ALAssetsLibrary new];

  [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group,
  BOOL *stop) {
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];

    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset,
    NSUInteger index,
    BOOL *innerStop) {
      if (alAsset) {
        ALAssetRepresentation *representation = [alAsset defaultRepresentation];
        UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];

        *stop = YES; *innerStop = YES;

        handler(latestPhoto, nil);
      }
    }];
  } failureBlock: ^(NSError *error) {
    handler(nil, error);
  }];
}
~~~

Using the upload URL, we can create our asset and start the processing of the image:

~~~objc
[self.space createAssetWithTitle:@{ @"en-US": @"Some image caption" }
description:@{ @"en-US": @"Upload from iOS" }
fileToUpload:@{ @"en-US": uploadURL.absoluteString }
success:^(CDAResponse *response, CMAAsset *asset) {
  [asset processWithSuccess:^{
         NSLog(@"Upload successful.");
    } failure:^(CDAResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
} failure:^(CDAResponse *response, NSError *error) {
    NSLog(@"Error: %@", error);
}];
~~~

As you can see, the Content Management API allows us the specify values for different locales in just one API call. Keep in mind that [`-processWithSuccess:failure:`][7] is asynchronous and will not report errors of the actual image processing back. If it was successful, you can publish the resulting asset from the Contentful [web app][8] as you normally would.

![such content, very uploading, wow](https://images.contentful.com/m5kgizmngfqu/31PAoh4jVCqeEKYICEsSkA/0758f8b5bc927ac77a280fa52bf81060/uploading.png?w=250)

When building the app, be aware that it will automatically upload the lastest image from your Camera Roll. Also, we have the SDK [on GitHub][10] and the API documentation [on CocoaDocs][11].

[1]: https://github.com/contentful/contentful.objc
[10]: https://github.com/contentful/contentful-management.objc
[11]: http://cocoadocs.org/docsets/ContentfulManagementAPI
[2]: https://cocoapods.org/
[3]: https://github.com/contentful/contentful-management.objc#installation
[4]: /developers/docs/references/authentication/
[5]: http://cocoadocs.org/docsets/ContentfulManagementAPI/0.5.1/Classes/CMASpace.html#//api/name/createAssetWithTitle:description:fileToUpload:success:failure:
[6]: https://github.com/neonichu/IAmUpload
[7]: http://cocoadocs.org/docsets/ContentfulManagementAPI/0.5.1/Classes/CMAAsset.html#//api/name/processWithSuccess:failure:
[8]: https://app.contentful.com/
