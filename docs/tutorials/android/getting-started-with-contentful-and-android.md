---
page: :docsGettingStartedAndroid
---

This walkthrough will help you getting started with your first basic hello world style Android app
of using Contentful with a demo space.

For a more in-depth tutorial containing steps on how to persist this data, please take a look at
[offline persistence with vault][4]

To participate in this tutorial, we assume you do have Android Studio installed, and are familiar
with it.

## Creating a new Android project

Please create a new project, so we can start with a clean environment. We used the `Blank Activity`
template, but you can choose whichever you prefer. After creating the usual project name and folder
structure, summarized in the following image, we continue with creating the dependencies to 
Contentful in the project settings.


## Defining dependency to Contentful

To include `Contentful` please add the following lines to the just created gradle `build.gradle` in
the app folder:

~~~ gradle

dependencies {
    // [...]
    compile 'com.contentful.java:java-sdk:4.0.2'
}
~~~

After a sync, this will download the current java-sdk, so we are able to use it and download our
first data from the demo space, by the press of a button:

## Fetching all data from our demo space

Please add the internet permission to the `AndroidManifest.xml`: 

~~~ xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.demospaceexplorer" >

    <uses-permission android:name="android.permission.INTERNET" />

<!-- ... -->

</manifest>
~~~

Next add this code on the `click handler` of the fab, or in `onCreate`:

~~~ java
CDAClient client = CDAClient.builder()
        .setSpace("cfexampleapi")
        .setToken("b4c0n73n7fu1")
        .build();
~~~

This will create a `CDAClient` which will be used for the communication with Contentful. The `Space` is
a named entity you want to access. Both, the `Space` and the `Token` can be obtained through 
the Contentful UI.

Next step is to actually do a request:

~~~ java
client.fetch(CDAEntry.class).all(new CDACallback<CDAArray>() {
    @Override
    protected void onSuccess(CDAArray result) {
        // do something with the result.
    }
});
~~~

which will call the `onSuccess` handler, once the data got loaded, you can process the results.
Also on production applications you might like to overwrite

~~~ java
protected void onFailure(Throwable error) {   
}
~~~

to handle any error occurring.

## Fetching only specific items

If you only want to get data of a specific entry, you would use the `id` of the entry you want to 
get like this:


~~~ java
client.fetch(CDAEntry.class).one("happycat", new CDACallback<CDAEntry>() {
    @Override
    protected void onSuccess(CDAEntry result) {
        textView.setText(result.toString());
    }
});
~~~


## Conclusion

With this short tutorial, you are able to start using your requests in your Android
applications. For more information, please take a look at [contentful.java GitHub][1]

You can also check out how to [use persistent data storage with Vault][4].

[1]: https://github.com/contentful/contentful.java
[2]: https://github.com/contentful-labs/contentful_middleman_examples
[4]: /developers/docs/tutorials/android/offline-persistence-with-vault/