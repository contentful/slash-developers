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

We publish SDKs for various languages to make developing applications easier. This article details how to get content using the [JavaScript CDA SDK][1].

## Pre-requisites

This tutorial assumes you have read and understood [the guide that covers the Contentful data model](/developers/docs/concepts/data-model/).

We assume you have [Android Studio installed](https://developer.android.com/studio/index.html), and are familiar with it.

## Authentication

For every request, clients [need to provide an API key](/developers/docs/references/authentication/), which is created per space and used to delimit applications and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key).

## Create a new Android project

Create a new project in Android Studio using the 'Blank Activity' template, and name it whatever you wish.

## Define Contentful as a dependency

To include the CDA SDK in your app, add the following lines to the _build.gradle_ file:

~~~gradle
dependencies {
    // [...]
    compile 'com.contentful.java:java-sdk:7.3.0'
}
~~~

## Fetching all data from a demo space

Add the internet permission to the _AndroidManifest.xml_ file so your app can access the Contentful APIs:

~~~xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.demospaceexplorer" >

    <uses-permission android:name="android.permission.INTERNET" />

<!-- ... -->

</manifest>
~~~

Add the following code to the click handler of the floating action button, or in the `onCreate` function:

~~~java
CDAClient client = CDAClient.builder()
        .setSpace("cfexampleapi")
        .setToken("b4c0n73n7fu1")
        .build();
~~~

This will create a `CDAClient` that communicates with the Contentful APIs using the space id and token you gained earlier.

To fetch all entries:

~~~java
client.fetch(CDAEntry.class).all(new CDACallback<CDAArray>() {
    @Override
    protected void onSuccess(CDAArray result) {
        // do something with the result.
    }
});
~~~

The `onSuccess` handler is called once the data is loaded and you can process the results. In production applications you should override the failure handler to cope with any problems.

~~~java
protected void onFailure(Throwable error) {
}
~~~

## Fetching specific items

If you want to fetch the data of a specific entry, use the `id` of the entry:

~~~java
client.fetch(CDAEntry.class).one("happycat", new CDACallback<CDAEntry>() {
    @Override
    protected void onSuccess(CDAEntry result) {
        textView.setText(result.toString());
    }
});
~~~


[1]: https://github.com/contentful/contentful.java
[4]: /developers/docs/android/tutorials/getting-started-with-contentful-and-android/
