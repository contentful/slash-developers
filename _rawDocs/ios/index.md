---
page: :docsPlatformsIos
name: iOS
title: Using Contentful with iOS
metainformation: 'Our SDKs give you access to our APIs and their features.'
slug: null
tags:
  - Basics
  - SDKs
nextsteps: null
---

- [SDKs](#sdks)
- [Tutorials](#tutorials)
- [Tools](#tools-and-integrations)
- [Example apps](#example-apps)

## SDKs

Our SDKs give you access to our [APIs](/developers/docs/concepts/apis/) and their features.

### Content Delivery API SDK

This SDK interacts with the Content Delivery API, a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to a user's location using our global CDN.

[View on GitHub - Swift](https://github.com/contentful/contentful.swift)

[View on GitHub - ObjC](https://github.com/contentful/contentful.objc)

[API reference - ObjC](http://cocoadocs.org/docsets/ContentfulDeliveryAPI/)

[API Playground - Swift](https://github.com/contentful/ContentfulPlayground)

### Content Management API SDK

This SDK interacts with the Content Management API, and allows you to create, edit, manage, and publish content. The API also offers tools for managing editorial teams and cooperation.

[View on GitHub - ObjC](https://github.com/contentful/contentful-management.objc)

[API reference](http://cocoadocs.org/docsets/ContentfulManagementAPI/)

## Tutorials

### API demo

[This guide](/developers/api-demo/swift/) is the perfect starting point to learn how to make calls to Contentful APIs, explains what responses look like, and suggest next steps.

### Getting started with the Content Delivery API SDK and iOS

These tutorials will walk you through the first steps using the Content Delivery API with an iOS application.

[View the Objective-C tutorial](/developers/docs/ios/tutorials/using-delivery-api-on-ios/)

[View the Swift tutorial](/developers/docs/ios/tutorials/using-delivery-api-with-swift/)

### Getting started with the Content Management API SDK and Objective-C

[This tutorial](/developers/docs/ios/tutorials/using-management-api-on-ios/) will walk you through the first steps using the Contentful Management API with an Objective-C application.

### Delivering content with Contentful and iOS

[This webinar](/blog/2014/09/18/webinar-delivering-content-to-from-ios-with-contentful/) shows you how to use the Content Delivery and Content Management SDKs.

### Offline persistence with the iOS SDK

This tutorial helps you understand how to persist data retrieved from the Contentful Content Delivery API.

[View the tutorial](/developers/docs/ios/tutorials/offline-persistence-in-ios-sdk/)

### Using the Contentful Xcode plugin

[This tutorial](/developers/docs/ios/tutorials/using-contentful-xcode-plugin/) will help you understand how to use [our XCode plugin](https://github.com/contentful/ContentfulXcodePlugin) for generating models from your content types.

## Tools and integrations

### Xcode plugin

This plugin automatically creates Core Data models from your Contentful content model.

[View on GitHub](https://github.com/contentful/ContentfulXcodePlugin)

### ContentfulPersistence (Objective-C)

This Objective-C library makes it easier to persist data retrieved from Contentful into Core Data or other data stores.

[View on GitHub](https://github.com/contentful/contentful-persistence.objc)

[View the tutorial](/developers/docs/ios/tutorials/offline-persistence-in-ios-sdk/)

### ContentfulPersistence (Swift)

This Swift library makes it easier to persist data retrieved from Contentful into Core Data or other data stores.

[View on GitHub](https://github.com/contentful/contentful-persistence.swift)

[View the tutorial](/developers/docs/ios/tutorials/using-delivery-api-with-swift/)

### Concorde

This library helps you display progressive JPEGs with iOS.

[View on GitHub](https://github.com/contentful-labs/Concorde)

## Example apps

You can use these example apps as inspiration for building your own apps.

### iOS

#### Discovery app

This app lets you browse and preview your Contentful spaces.

[Download on the App Store](https://itunes.apple.com/us/app/contentful-discovery-cms-for/id892840015)

[View on GitHub](https://github.com/contentful/discovery-app)

#### Blog

A generic blog app connected to a Contentful example space.

[Download on the App Store](https://itunes.apple.com/us/app/contentful-blog-showcase/id962456216)

[View on GitHub](https://github.com/contentful/blog-app-ios)

#### Gallery

A generic gallery app connected to a Contentful example space.

[Download on the App Store](https://itunes.apple.com/us/app/contentful-gallery-showcase/id975142754)

[View on GitHub](https://github.com/contentful/gallery-app-ios)

#### Product catalogue

A generic product catalogue / e-commerce app connected to a Contentful example space.

[Download on the App Store](https://itunes.apple.com/us/app/contentful-product-catalogue/id963680410)

[View on GitHub](https://github.com/contentful/product-catalogue-ios)

#### Coffee guide

An app that guides users to the nearest café.

[View on GitHub](https://github.com/contentful/guide-app-ios)

#### Swiftful

A demo app that shows how to use Contentful with Swift and iOS.

[View on GitHub](https://github.com/contentful-labs/Swiftful)

### watchOS

You can use these example apps as inspiration for building your own watchOS apps.

#### Brew

A watchOS app for finding bars near you. You can [read more about the app in this blog post](/blog/2015/05/28/brew-app-for-apple-watch/).

[Download on the App Store](https://itunes.apple.com/us/app/brew-discover-craft-beer-pubs/id986830433)

[View on GitHub](https://github.com/contentful/ContentfulWatchKitExample)

### tvOS

#### TVFul

This example shows you how to use the Contentful SDK with tvOS apps.

[View on GitHub](https://github.com/contentful/tvful)
