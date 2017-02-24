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

:[Get all entry output](../../_partials/get-all-entry-output-android.md)

## A specific entry

To retreieve and individual entry, use the `.one(<entry_id>)` method:

~~~java
CDAEntry entry = client.fetch(CDAEntry.class).one("<entry_id>");
~~~

:[Get entry output](../../_partials/get-entry-output-android.md)

## All assets

To retrieve all assets of a space, use this method:

~~~java
CDAArray array = client.fetch(CDAAsset.class).all();
for (CDAArray array : result.items()) {
    CDAEntry entry = (CDAEntry) resource;
    Log.i("Contentful", entry.getField(FIELD).toString());
}
~~~

:[Get all assets](../../_partials/get-all-asset-output-android.md)

## One asset

To retrieve one specific asset, use this method:

~~~java
CDAAsset asset = client.fetch(CDAAsset.class).one("<asset_id>");
~~~

:[Get all assets](../../_partials/get-all-asset-output-android.md)

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
