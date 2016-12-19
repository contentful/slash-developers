---
page: :docsAdvancedFilteringAndSearchingAndroid
name: Advanced Filtering and Searching
title: Advanced Filtering and Searching
metainformation: 'The guide shows you how to use the Android and Java API, to filter, sort and order entries.'
slug: null
tags:
  - SDKs
  - Java
nextsteps:
  - text: Advanced methods for retrieving entries
    link: /developers/docs/android/tutorials/advanced-types/
---

This section will describe advanced usage of the Android and Java API, in order to filter, sort and order responses. The
upcoming samples are using the following setup: `space id = cfexampleapi` and `api token = b4c0n73n7fu1`.

## Searching

In order query for all items, containing the complete string `nyan` in symbol or text fields.

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("query", "nyan")
    .all();
~~~

## Inexact searches

If you want to search for just a part of a text, you could use a `match` operator. Keep in mind, you have to define
the field to be matched, so it won't work on all fields automatically. Also for this request to work, you have to
specify a `content type` to look for:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("content_type", "cat")
    .where("fields.name[match]", "yan")
    .all();
~~~


## Order

In order to order a result by a field, you need to specify `order` as a `where` selector. Please make sure, that you
either just query for fields in `sys`, or specify a `content type` to look for.

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("order", "sys.id")
    .all();
~~~

If you want to invert the result order, feel free to add a `-` in front of the field to be looked for:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("order", "-sys.id")
    .all();
~~~

Having a result ordered in more then one level, take a look at this snippet:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("order", "sys.contentType.sys.id,sys.id")
    .all();
~~~


## Limit

To retrieve a given amount of elements, you can use the `limit` parameter.

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("limit", "1")
    .all();
~~~

Ignoring the first entries, can be accomplished by using the `skip` parameter. This can be used nicely for paging, by
skipping the first 13 elements:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("skip", "13")
    .all();
~~~

## Include

If you do not want the query to return only top level entries, and not its children, you could use the
parameter `include` with the value `0`. Otherwise this value will be used to determine how many hierarchy levels
to be returned. If not set, it will return 1, only the first level of children.

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("include", "0")
    .all();
~~~

## Sequences

Do you want to get elements based on a set of possibilities? Then you came to the right place:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("sys.id[in]", "finn,jake")
    .all();
~~~

Will return all elements whose `sys.id` is either *fin* or *jake*.


If you want to invert this query, you would use the a `nin` (for _`not`_`in`) operator in the query:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("content_type", "cat")
    .where("sys.id[nin]", "nyancat")
    .all();
~~~

## Existence

Querying for all entries having a specific *field* set to something (aka it is existing), you would issue a request
like:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("sys.id[exists]", "false") // entries without id
    .all();
~~~

## Mathematical comparisons

Contentful is also able to query entries, based on a mathematical comparison operator:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("content_type", "cat")
    .where("fields.birthday[lte]", "1980-01-01")
    .all();
~~~

This will return all entries with the `birthday` `less or equal then` *1980-01-01*. Other operators are available too,
[see REST API doc](/developers/docs/references/content-delivery-api/#/reference/search-parameters/ranges)

## Inequality

If you want to filter out specific items, you should be thinking about using the `[ne]` operator:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("sys.id[ne]", "nyancat")
    .all();
~~~

## Location

Did you ever want to query based on a real world location? This is how to do this in java:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("content_type", "1t9IbcfdCk6m04uISSsaIK")
    .where("fields.center[near]", "38,-122")
    .all();
~~~

Which will return the list of results ordered by distance, the closest first.


If you would rather find out if there are entries in a specific area of the world, you could be using something like this:

~~~ java
CDAArray found = client.fetch(CDAEntry.class)
    .where("content_type", "1t9IbcfdCk6m04uISSsaIK")
    .where("fields.center[within]", "40,-124,36,-120")
    .all();
~~~

returning all elements whose `center` is in the given area. (Do not forget the `content_type`)


## Assets mimetype

This last example will tell you how to query for assets, which are only of a specific `mimetype`:

~~~ java
CDAArray found = client.fetch(CDAAsset.class)
    .where("mimetype_group", "image")
    .all();
~~~
