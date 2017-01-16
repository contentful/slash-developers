---
page: :docsContentfulXcode
name: Using the Contentful Xcode Plugin
title: Using the Contentful Xcode Plugin
metainformation: 'Our plugin for Xcode generates a Core Data model directly from your content model, making it easier than ever to use the Content Delivery API in your iOS and macOS projects.'
slug: null
tags:
  - Tools
  - iOS
  - Mobile
nextsteps:
 - text: Learn more about content modelling
   link: /developers/docs/concepts/data-model/
---

If you are using Contentful with Core Data in your iOS app, a painful manual step is recreating your content model inside Xcode. This is often both time consuming and prone to errors because mismatches between the two models can lead to bugs that are hard to spot. Today we are releasing a plugin for Xcode, which generates a Core Data model directly from your content model, making it easier than ever to use the Content Delivery API in your iOS and macOS projects.

## Installation

You can either clone the [repository][1] and build the plugin yourself or install the [binary release][9]. Installing via [Alcatraz][2] is not supported right now.

## Usage

The plugin adds a new "Generate Model from Contentful..." item to the "Product" menu.

![Screen Shot 2014-11-26 at 13.51.52](//images.contentful.com/256tjdsmm689/1Qyzs5KFkkyiIiky0ccYmk/9deb635fae91511e8ceaf9a9cdee858b/Screen_Shot_2014-11-26_at_13.51.52.png)

This will bring up a dialog where, after providing your CMA access token, you will be able to select a space and a target from your Xcode project.

![Screen Shot 2014-11-26 at 13.52.04](//images.contentful.com/256tjdsmm689/6uNk5czVx6COwMy8oauyys/072bbb82082553dd8490262175473638/Screen_Shot_2014-11-26_at_13.52.04.png)

Using this information, a Core Data model for use with our [CoreDataManager class][3] will be generated and added to the specified target. The file itself will reside in the *"Resources"* group or in the root if that doesn't exist.

Keep in mind that your own `NSManagedObject` subclasses will still need to conform to the `CDAPersistedAsset`, `CDAPersistedEntry` and `CDAPersistedSpace` protocols as before. You will not need to provide a mapping between your content model and Core Data anymore, though, as this is [derived automatically][4] if field and property names match, which is always the case when using the plugin.

It is also required that you add [content type validations][5] for any links in your content model, as links in Core Data are always typed. If you require one link field to refer to entries of different content types, your model cannot be represented by Core Data and therefore the model generation will fail and tell you which content type’s field was the culprit.

You can also use the model generator from the commandline:

~~~ bash
ContentfulModelGenerator generate \
	--spaceKey=$CONTENTFUL_SPACE_KEY \
	--accessToken=$CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN
~~~

As there are a lot of ways of building your content model, please report any issues with the generator so that we can continue to improve it in the future.

## Implementation

As an introduction to writing Xcode plugins, you can check out the writing plugins post on the [Alcatraz][2] blog.

This plugin is generally rather small, because the majority of the work does not involve Xcode. The class [XcodeProjectManipulation][6] demonstrates how to interact with the project file using the `PBXProject` class from the `DevToolsCore` framework.

The Core Data model generation revolves around two parts and is encapsulated in a separate commandline utility. This allows its use in build scripts and also avoids problems regarding the use of Swift dependencies in a plugin written in Objective-C.

The first part is converting from the content model to a `NSManagedObjectModel` instance, accomplished by the [ContentfulModelGenerator][7]. A managed object model consists of `NSEntityDescription` instances, which in turn are a container for `NSAttributeDescription` and `NSRelationshipDescription` objects. The latter is the most critical part, because we have to ensure that each relationship is typed and has an inverse to avoid any warnings when using the model. This is done by introspecting the validations on your content model and by creating missing inverse relations where needed.

The second part is handled by the [ManagedObjectModelSerializer][8] framework we created, which generates the XML representation from an in-memory `NSManagedObjectModel` instance. This can be utilized to write other tools which need to generate Core Data models and it has a really simple API:

~~~ swift
let bundleName = "MyModel"
let model: NSManagedObjectModel
let pathURL: NSURL

let error = ModelSerializer(model: model!).generateBundle(bundleName, atPath:pathURL)
~~~

[1]: https://github.com/contentful/ContentfulXcodePlugin
[2]: http://alcatraz.io
[3]: /blog/2014/05/09/ios-content-synchronization/
[4]: https://github.com/contentful/contentful.objc/commit/b82c0f2a68095e28d0d127bd9d070b09daf9b9ed
[5]: /r/knowledgebase/validations/
[6]: https://github.com/contentful/ContentfulXcodePlugin/blob/master/Code/XcodeProjectManipulation.m
[7]: https://github.com/contentful/ContentfulXcodePlugin/blob/master/Code/ContentfulModelGenerator.m
[8]: https://github.com/contentful/ManagedObjectModelSerializer
[9]: https://github.com/contentful/ContentfulXcodePlugin/releases/tag/0.3
