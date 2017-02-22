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
  .one("<entry_id>")
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
