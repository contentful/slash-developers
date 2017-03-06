---
page: :docsGettingStarted
name: Getting Started with Contentful
title: Getting Started with Contentful
metainformation: tb
slug: null
tags: null
nextsteps: null
---

## What you can do with Contentful and what problems it solves for you

## An introduction to Contentful concepts

### Four APIs

Contentful offers four REST APIs for working with your content. Each of these APIs serve a different purpose, so which one to use depends on what you want to do:

-   If you're retrieving content to display to users in an app or website, use the [Content Delivery API](/developers/docs/concepts/apis/#content-delivery-api) (CDA).
-   If you want to programmatically create or update content items, use the [Content Management API](/developers/docs/concepts/apis/#content-management-api) (CMA).
-   If you want to retrieve unpublished content to show in-context previews to content creators and editors, use the [Preview API](/developers/docs/concepts/apis/#preview-api) (CPA). This API behaves like the Content Delivery API, but includes content that has not yet been published.
-   If you want to retrieve and apply transformations to images stored in Contentful, use the [Images API](/developers/docs/concepts/apis/#images-api).

### Organizing your content

Contentful organizes content into _spaces_, that allows you to group all the related resources for a project together, this includes content entries, media assets, and settings for localizing content into different languages.

Each space has a _content model_ that represents the _content types_ you create.

Each _content type_ consists of a set of up to **50** fields that you define, these fields can be one of the following.

![Contentful content model](https://images.contentful.com/tz3n7fnw4ujc/4qEZ2g13fycuysMyaW4A2I/112a48fabadefe1b4674bf56e3d7f7c6/Resource_Model.png)

{: .note}
**Learn more** about content modeling [in this guide](/developers/docs/concepts/data-model/).

## Get an SDK

Contentful maintains SDKs that expose API endpoints to make developing in your language easier.

## NodeJS

Run the following command in your terminal:

~~~bash
npm install contentful
~~~

## JavaScript

Run the following command in your terminal:

## Ruby

~~~bash
gem install 'contentful'
~~~

Run the following command in your terminal:

## Python

~~~bash
pip install contentful
~~~

## .Net

Create a new Console application and run the following in your NuGet package manager console:

~~~csharp
Install-Package contentful.csharp -prerelease
~~~

## PHP

Install [Composer](https://getcomposer.org/doc/00-intro.md) and run the following command in your terminal:

~~~bash
php composer.phar contentful/contentful:@beta
~~~

## Objective-C

## Swift

Get the Swift SDK and use it in your project by adding the following to your Podfile:

~~~ruby
platform :ios, '9.0'
use_frameworks!
pod 'Contentful'
~~~

Or your Cartfile:

~~~bash
github "contentful/contentful.swift"
~~~

You can find more details about SDK versions to suit Swift versions [here](https://github.com/contentful/contentful.swift#swift-versioning).

## Java

Add the following lines to your pom.xml file:

~~~xml
<dependency>
  <groupId>com.contentful.java</groupId>
  <artifactId>java-sdk</artifactId>
  <version>7.2.0</version>
</dependency>
~~~

## Android

Add the following lines to your _build.gradle_ file:

~~~groovy
dependencies {
    // [...]
    compile 'com.contentful.java:java-sdk:7.4.0'
    // compile 'io.reactivex:rxandroid:0.23.0'
    // MAYBE ABOVE NOT NEEDED IF .observeOn(AndroidSchedulers.mainThread())` if they need this import, most of them should need it.
}
~~~

## Create a client to get the space and inferred content model

Creating a client to communicate with the CDA requires two parameters.

First is an ID of the space you want to connect to, which you can find in the web app, either in the URL of the space or under the _Settings_ tab.

![Space ID in the web app](https://images.contentful.com/tz3n7fnw4ujc/8CYfuWpkXYCQqgKGsgSIk/45445657bc516548e27bb10d41912f07/Space_ID.png)

You also need a valid API key for accessing that space, which you can find under the _APIs_ tab.

![Space ID in the web app](https://images.contentful.com/tz3n7fnw4ujc/1a1WEezqJQkYWGwU6uWm6o/b05e831c9e75ef67875355a0477f8c77/api-keys.png)

Creating a client will connect to the space, and make the content model available to your application.

## NodeJS

~~~javascript
var contentful = require('contentful')
var client = contentful.createClient({
  space: '71rop70dkqaj',
  accessToken: '297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971'
})
~~~

## JavaScript

Run the following command in your terminal:

~~~javascript

~~~

## Ruby

~~~ruby
client = Contentful::Client.new(
  access_token: '297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971',
  space: '71rop70dkqaj'
)
~~~

## Python

~~~python
import contentful

client = contentful.Client('71rop70dkqaj', '297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971')
~~~

## .Net

~~~csharp
var httpClient = new HttpClient();
var options = new ContentfulOptions()
{
    DeliveryApiKey = "297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971",
    SpaceId = "71rop70dkqaj"
}
var client = new ContentfulClient(httpClient, options);
~~~

## PHP

~~~php
$client = new \Contentful\Delivery\Client('297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971', '71rop70dkqaj');
~~~

## Objective-C

~~~objective-c
CDAClient* client = [[CDAClient alloc] initWithSpaceKey:@"71rop70dkqaj" accessToken:@"297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971"];
~~~

## Swift

~~~swift
let client = Client(spaceIdentifier: "71rop70dkqaj", accessToken: "297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971")
~~~

## Java

~~~java
CDAClient client = CDAClient.builder()
    .setSpace("71rop70dkqaj")
    .setToken("297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971")
    .build();
~~~

## Android

~~~java
CDAClient client = CDAClient.builder()
    .setSpace("71rop70dkqaj")
    .setToken("297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971")
    .build();
~~~

## Get all entries from the space

Now you have a connection to the space you can fetch content from it. Start by fetching all the entries.

## NodeJS

~~~javascript
var entries = client.getEntries();
~~~

## JavaScript

~~~javascript

~~~

## Ruby

~~~ruby
entries = client.entries()
~~~

## Python

~~~python
entries = client.entries()
~~~

## .Net

~~~csharp
var entries = await client.GetEntriesAsync<Entry<dynamic>>();
~~~

## PHP

~~~php
$entries = $client->getEntries($query);
~~~

## Objective-C

~~~objective-c

~~~

## Swift

~~~swift
let entries = client.fetchEntries()
~~~

## Java

~~~java
CDAArray array = client.fetch(CDAEntry.class).all();
~~~

## Android

~~~java
client.observe(CDAEntry.class)
  .one("5KsDBWseXY6QegucYAoacS")
  .observeOn(AndroidSchedulers.mainThread())
  .subscribeOn(Schedulers.io())
  .subscribe(new Subscriber<CDAEntry>() {
    CDAEntry result;

    @Override public void onCompleted() {
      Log.i("Contentful", gson.toJson(result));
    }

    @Override public void onError(Throwable error) {
      Log.e("Contentful", "could not request entry", error);
    }

    @Override public void onNext(CDAEntry cdaEntry) {
      result = cdaEntry;
    }
  });
~~~

{: .note}
All Android examples require the usage of RxAndroid, the reactive extension for Android. Find instructions on how to include it in your project [here](https://www.contentful.com/developers/docs/android/tutorials/getting-started-with-contentful-and-android/#dependencies-and-permissions).
