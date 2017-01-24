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

:[Getting started tutorial intro](../../_partials/getting-started-intro.md)

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

Add the following code to the click handler of the floating action button, or in the `onCreate` function to create a `CDAClient` that communicates with the Contentful APIs:

:[Create credentials](../../_partials/credentials.md)

~~~java
CDAClient client = CDAClient.builder()
  .setSpace("<space_id>")
  .setToken("<access_token>")
  .build();
~~~

To fetch all entries:

**STUCK HERE**

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
