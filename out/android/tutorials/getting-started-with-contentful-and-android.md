---
page: :docsGettingStartedAndroid
name: Getting Started with Contentful and Android
title: Getting Started with Contentful and Android
metainformation: This guide will help you get started with your first basic hello world style Android app using Contentful with a demo space.
slug: null
tags:
  - Basics
  - SDKs
  - Android
nextsteps:
  - text: Access data offline in your app with Vault
    link: /developers/docs/android/tutorials/offline-persistence-with-vault/
---

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

We publish SDKs for various languages to make developing applications easier. This article details how to get content using the [JavaScript CDA SDK](https://github.com/contentful/contentful.js).

## Pre-requisites

This tutorial assumes you have read and understood [the guide that covers the Contentful data model](/developers/docs/concepts/data-model/).

## Authentication

For every request, clients [need to provide an API key](/developers/docs/references/authentication/), which is created per space and used to delimit applications and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key).

## Create a new Android project

Create a new project in Android Studio using the 'Blank Activity' template, and name it whatever you wish.

## Dependencies and permissions

This guide uses [RXAndroid](https://github.com/ReactiveX/RxAndroid) in the examples, which adds more complexity, but allows you to fetch results without tying up the main Android thread.

To include the CDA SDK, add the following lines to the _build.gradle_ file:

~~~gradle
dependencies {
    // [...]
    compile 'com.contentful.java:java-sdk:7.3.0'
    compile 'io.reactivex:rxandroid:0.23.0'
}
~~~

Add the internet permission to the _AndroidManifest.xml_ file so your app can access the Contentful APIs:

~~~xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
  package="com.example.demospaceexplorer" >

  <uses-permission android:name="android.permission.INTERNET" />
  ...
</manifest>
~~~

## Creating a client

Add the following code to the `onCreate` function to create a `CDAClient` that communicates with the Contentful APIs:

## Initializing the client

You need an API key and a space ID to initialize a client:

_You can use the API key and space ID pre-filled below for our example space or replace them with your own values created earlier_.

~~~java
CDAClient client = CDAClient.builder()
  .setSpace("71rop70dkqaj")
  .setToken("297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971")
  .build();
~~~

Add the [Gson](https://github.com/google/gson) library to make JSON responses easier to read.

~~~java
Gson gson = new GsonBuilder().setPrettyPrinting().create();
~~~

## Fetching specific items

If you want to fetch a specific entry, use the `id` of the entry inside a `.one` method:

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

```
I/Contentful: CDAEntry{id='5KsDBWseXY6QegucYAoacS'}
```

## Fetching all data from a demo space

To fetch all entries, create a new observable that watches for changes, in this case, fetching all entries from the specified space with the `all` method and content type with the `where` method:

~~~java
client.observe(CDAEntry.class)
               .where("content_type", "2PqfXUJwE8qSYKuM0U6w8M")
               .all()
               .observeOn(AndroidSchedulers.mainThread())
               .subscribeOn(Schedulers.io())
               .subscribe(new Subscriber<CDAArray>() {
                   CDAArray result;

                   @Override
                   public void onCompleted() {
                       for (CDAResource resource : result.items()) {
                           CDAEntry entry = (CDAEntry) resource;
                           Log.i("Contentful", entry.getField("productName").toString());
                       }
                   }

                   @Override
                   public void onError(Throwable error) {
                       Log.e("Contentful", "could not request entry", error);
                   }

                   @Override
                   public void onNext(CDAArray cdaArray) {
                       result = cdaArray;
                   }
               });
~~~

```
I/Contentful: Hudson Wall Cup
I/Contentful: SoSo Wall Clock
I/Contentful: Whisk Beater
I/Contentful: Playsam Streamliner Classic Car, Espresso
```

The `onNext` method saves the array of entries and the `onCompleted` method is called once all entries are fetched from the API. The `onError` method allows you to handle any problems.

[1]: https://github.com/contentful/contentful.java

[4]: /developers/docs/android/tutorials/getting-started-with-contentful-and-android/
