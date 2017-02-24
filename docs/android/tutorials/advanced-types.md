---
page: :docsAdvancedTypesAndRetrievalAndroid
name: Advanced Type Retrieval
title: Advanced Type Retrieval
metainformation: 'The guide shows you advanced methods to retrieve entries from Contenful using our Java API.'
slug: null
tags:
  - SDKs
  - Java
nextsteps:
  - text: Filtering, ordering, and sorting entries
    link: /developers/docs/android/tutorials/advanced-filtering-and-searching/
---

The guide will show you advanced methods to retrieve entries from Contenful using our Java SDK. We recommend you read the [Android getting started guide](/developers/docs/android/tutorials/getting-started-with-contentful-and-android/) before reading this guide.

## All entries

To fetch all entries of a given space, use:

~~~java
CDAArray array = client.fetch(CDAEntry.class).all();
~~~

~~~
I/Contentful: Hudson Wall Cup
I/Contentful: SoSo Wall Clock
I/Contentful: Whisk Beater
I/Contentful: Playsam Streamliner Classic Car, Espresso
~~~

## A specific entry

To retreieve and individual entry, use the `.one(5KsDBWseXY6QegucYAoacS)` method:

~~~java
CDAEntry entry = client.fetch(CDAEntry.class).one("5KsDBWseXY6QegucYAoacS");
~~~

~~~
I/Contentful: CDAEntry{id='5KsDBWseXY6QegucYAoacS'}
~~~

## All assets

To retrieve all assets of a space, use this method:

~~~java
CDAArray array = client.fetch(CDAAsset.class).all();
for (CDAArray array : result.items()) {
    CDAEntry entry = (CDAEntry) resource;
    Log.i("Contentful", entry.getField(FIELD).toString());
}
~~~

~~~
//images.contentful.com/71rop70dkqaj/1MgbdJNTsMWKI0W68oYqkU/4c2d960aa37fe571d261ffaf63f53163/9ef190c59f0d375c0dea58b58a4bc1f0.jpeg
//images.contentful.com/71rop70dkqaj/4zj1ZOfHgQ8oqgaSKm4Qo2/8c30486ae79d029aa9f0ed5e7c9ac100/playsam.jpg
//images.contentful.com/71rop70dkqaj/3wtvPBbBjiMKqKKga8I2Cu/90b69e82b8b735383d09706bdd2d9dc5/zJYzDlGk.jpeg
//images.contentful.com/71rop70dkqaj/wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg
//images.contentful.com/71rop70dkqaj/6t4HKjytPi0mYgs240wkG/b7ba3984167c53d728e7533e54ab179d/toys_512pxGREY.png
//images.contentful.com/71rop70dkqaj/10TkaLheGeQG6qQGqWYqUI/13c64b63807d1fd1c4b42089d2fafdd6/ryugj83mqwa1asojwtwb.jpg
//images.contentful.com/71rop70dkqaj/Xc0ny7GWsMEMCeASWO2um/190cc760e991d27fba6e8914b87a736d/jqvtazcyfwseah9fmysz.jpg
//images.contentful.com/71rop70dkqaj/2Y8LhXLnYAYqKCGEWG4EKI/44105a3206c591d5a64a3ea7575169e0/lemnos-logo.jpg
//images.contentful.com/71rop70dkqaj/6m5AJ9vMPKc8OUoQeoCS4o/07b56832506b9494678d1acc08d01f51/1418244847_Streamline-18-256.png
//images.contentful.com/71rop70dkqaj/6s3iG2OVmoUcosmA8ocqsG/b55b213eeca80de2ecad2b92aaa0065d/1418244847_Streamline-18-256__1_.png
//images.contentful.com/71rop70dkqaj/KTRF62Q4gg60q6WCsWKw8/ae855aa3810a0f6f8fee25c0cabb4e8f/soso.clock.jpg
~~~

## One asset

To retrieve one specific asset, use this method:

~~~java
CDAAsset asset = client.fetch(CDAAsset.class).one("wtrHxeu3zEoEce2MokCSi");
~~~

~~~
//images.contentful.com/71rop70dkqaj/1MgbdJNTsMWKI0W68oYqkU/4c2d960aa37fe571d261ffaf63f53163/9ef190c59f0d375c0dea58b58a4bc1f0.jpeg
//images.contentful.com/71rop70dkqaj/4zj1ZOfHgQ8oqgaSKm4Qo2/8c30486ae79d029aa9f0ed5e7c9ac100/playsam.jpg
//images.contentful.com/71rop70dkqaj/3wtvPBbBjiMKqKKga8I2Cu/90b69e82b8b735383d09706bdd2d9dc5/zJYzDlGk.jpeg
//images.contentful.com/71rop70dkqaj/wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg
//images.contentful.com/71rop70dkqaj/6t4HKjytPi0mYgs240wkG/b7ba3984167c53d728e7533e54ab179d/toys_512pxGREY.png
//images.contentful.com/71rop70dkqaj/10TkaLheGeQG6qQGqWYqUI/13c64b63807d1fd1c4b42089d2fafdd6/ryugj83mqwa1asojwtwb.jpg
//images.contentful.com/71rop70dkqaj/Xc0ny7GWsMEMCeASWO2um/190cc760e991d27fba6e8914b87a736d/jqvtazcyfwseah9fmysz.jpg
//images.contentful.com/71rop70dkqaj/2Y8LhXLnYAYqKCGEWG4EKI/44105a3206c591d5a64a3ea7575169e0/lemnos-logo.jpg
//images.contentful.com/71rop70dkqaj/6m5AJ9vMPKc8OUoQeoCS4o/07b56832506b9494678d1acc08d01f51/1418244847_Streamline-18-256.png
//images.contentful.com/71rop70dkqaj/6s3iG2OVmoUcosmA8ocqsG/b55b213eeca80de2ecad2b92aaa0065d/1418244847_Streamline-18-256__1_.png
//images.contentful.com/71rop70dkqaj/KTRF62Q4gg60q6WCsWKw8/ae855aa3810a0f6f8fee25c0cabb4e8f/soso.clock.jpg
~~~

**UP_TO_HERE**

## Content types

To request all [content types](https://contentful.github.io/contentful.java/index.html?com/contentful/java/cda/CDAContentType.html), use this method:

~~~java
CDAArray array = client.fetch(CDAContentType.class).all();
~~~

Taking the resulting object, it'll be printed as (This example will only contain one content type, since the space only
contains one type).

~~~json
{
  "total": 1,
  "skip": 0,
  "limit": 100,
  "items": [
    {
      "fields": [
        {
          "name": "Name",
          "id": "name",
          "type": "Symbol",
          "disabled": false,
          "required": false,
          "localized": false
        },
        {
          "name": "Author",
          "id": "author",
          "type": "Symbol",
          "disabled": false,
          "required": false,
          "localized": false
        },
        {
          "name": "Description",
          "id": "description",
          "type": "Symbol",
          "disabled": false,
          "required": false,
          "localized": false
        }
      ],
      "name": "Book",
      "displayField": "name",
      "description": "",
      …
    }
  ],
  "assets": {},
  "entries": {},
  "sys": {
    "type": "Array"
  }
}
~~~

## Fetching details of the current space

To fetch the current space meta information, you could use

~~~java
CDASpace space = client.fetchSpace();
~~~

yielding

~~~json
{
  "name": "Developer Bookshelf",
  "locales": [
    {
      "code": "en-US",
      "name": "U.S. English",
      "default": true
    }
  ],
  "defaultLocale": {
    "code": "en-US",
    "name": "U.S. English",
    "default": true
  },
  "sys": {
    "type": "Space",
    "id": "developer_bookshelf"
  }
}
~~~

## Fetching all spaces

For this example, you will need to [get a CMA API token](/developers/docs/references/authentication/#the-management-api)
and create a [CMAClient](https://contentful.github.io/contentful-management.java/index.html?com/contentful/java/cma/CMAClient.html) using it:

~~~java
CMAClient cmaClient = new CMAClient.Builder()
    .setAccessToken(CMA_TOKEN)
    .build();

CMAArray<CMASpace> spaces = cmaClient.spaces().fetchAll();
text = gson.toJson(spaces);
System.out.println(text);
~~~

And the result will be:

~~~json
{
  "items": [
    {
      "name": "Your Space here!",
      "sys": {
        "createdAt": "…",
        "updatedBy": {
          …
        },
        "createdBy": {
        …
        },
        "id": "…",
        "type": "Space",
        "version": 2.0,
        "updatedAt": "…"
      }
    },
    … (More spaces, as much as you own)
  ],
  "total": …,
  "skip": 0,
  "limit": 25,
  "sys": {
    "type": "Array"
  }
}
~~~
