---
page: :docsAdvancedTypesAndRetrievalAndroid
name: Advanced Type Retrieval
title: Advanced Type Retrieval
metainformation: 'The guide shows you how to retrieve entries from Contenful using our Java API.'
slug: null
tags:
  - SDKs
  - Java
nextsteps:
  - text: Filtering, ordering, and sorting entries
    link: /developers/docs/android/tutorials/advanced-filtering-and-searching/
---

This is a simple `how to` on different aspects of the Contentful JAVA API. All following samples assume a client setup like

~~~ java
CDAClient client = CDAClient.builder()
    .setSpace("developer_bookshelf")
    .setToken("0b7f6x59a0")
    .build();
~~~

as described in our [getting started guide](/developers/docs/android/tutorials/getting-started-with-contentful-and-android/).

## All entries

To fetch all entries of the given space, you could use:

~~~ java
CDAArray array = client.fetch(CDAEntry.class).all();
~~~

This will result in

~~~ json
{
  "total": 2,
  "skip": 0,
  "limit": 100,
  "items": [
    {
      "fields": {
        "author": {
          "en-US": "Larry Wall"
        },
        "name": {
          "en-US": "An introduction to regular expressions. Volume VI"
        },
        "description": {
          "en-US": "Now you have two problems."
        }
      },
      …
    },
    … another item
  ],
  "sys": {
    "type": "Array"
  }
}
~~~

## One specific entry

Using the `.one(`_`YOUR_ITEM_ID`_`)` method of the client, like follows

~~~ java
CDAEntry entry = client.fetch(CDAEntry.class).one("5PeGS2SoZGSa4GuiQsigQu");
~~~

you'll get a response like

~~~ json
{
  "fields": {
    "author": {
      "en-US": "Larry Wall"
    },
    "name": {
      "en-US": "An introduction to regular expressions. Volume VI"
    },
    "description": {
      "en-US": "Now you have two problems."
    }
  },
  …
}
~~~

## All assets

Retrieving all assets of a space, this snippet could help:

~~~ java
CDAArray array = client.fetch(CDAAsset.class).all();
~~~

And this will be the result for a _different_ (`space = cfexampleapi`, `token = b4c0n73n7fu1`) sample space…

~~~ json
{
  "total": 4,
  "skip": 0,
  "limit": 100,
  "items": [
    {
      "fields": {
        "file": {
          "en-US": {
            "fileName": "jake.png",
            "contentType": "image/png",
            "details": {
              "image": {
                "width": 100.0,
                "height": 161.0
              },
              "size": 20480.0
            },
            "url": "//images.contentful.com/cfexampleapi/4hlteQAXS8iS0YCMU6QMWg/2a4d826144f014109364ccf5c891d2dd/jake.png"
          }
        },
        "title": {
          "en-US": "Jake"
        }
      },
      "sys": {
        "type": "Asset",
        "id": "jake",
        …
      }
      …
    },
    …
  ],
  …
}
~~~

## Only one asset

Retrieving one specific asset, take a look at this example:

~~~ java
CDAAsset asset = client.fetch(CDAAsset.class).one("jake");
~~~

And this will be the result in only one asset (again using the `cfexampleapi` space):

~~~ json
{
  "fields": {
    "file": {
      "en-US": {
        "fileName": "jake.png",
        "contentType": "image/png",
        "details": {
          "image": {
            "width": 100.0,
            "height": 161.0
          },
          "size": 20480.0
        },
        "url": "//images.contentful.com/cfexampleapi/4hlteQAXS8iS0YCMU6QMWg/2a4d826144f014109364ccf5c891d2dd/jake.png"
      }
    },
    "title": {
      "en-US": "Jake"
    }
  },
  "sys": {
    "type": "Asset",
    "id": "jake",
    …
  }
  …
}
~~~

## Content types

In order to request all [content types](https://contentful.github.io/contentful.java/index.html?com/contentful/java/cda/CDAContentType.html),
you could use a call like this:

~~~ java
CDAArray array = client.fetch(CDAContentType.class).all();
~~~

Taking the resulting object, it'll be printed as (This example will only contain one content type, since the space only
contains one type).

~~~ json
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

~~~ java
CDASpace space = client.fetchSpace();
~~~

yielding

~~~ json
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

~~~ java
CMAClient cmaClient = new CMAClient.Builder()
    .setAccessToken(CMA_TOKEN)
    .build();

CMAArray<CMASpace> spaces = cmaClient.spaces().fetchAll();
text = gson.toJson(spaces);
System.out.println(text);
~~~

And the result will be:

~~~ json
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
