---
page: :docsGettingStartedPhp
name: Getting Started with Contentful and PHP
title: Getting Started with Contentful and PHP
metainformation: This tutorial will walk you through your first steps in using Contentful with a PHP application.
slug: null
tags:
  - SDKs
  - PHP
nextsteps:
  - text: How to only update content that has changed
    link: /developers/docs/php/tutorials/using-the-sync-api-with-php/
---

This guide will show you how to get started using our [PHP SDK](https://github.com/contentful/contentful.php) to consume content.

{: .note}
The Contentful PHP SDK is in beta and the API may change before a stable release.

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

We publish SDKs for various languages to make developing applications easier.

## Pre-requisites

This tutorial assumes you have read and understood [the guide that covers the Contentful data model](/developers/docs/concepts/data-model/).

## Authentication

For every request, clients [need to provide an API key](/developers/docs/references/authentication/), which is created per space and used to delimit applications and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key).

## Installation

The easiest way to install the Contentful PHP SDK is to use [Composer][2] and run the following command:

~~~bash
php composer.phar install contentful/contentful:@beta
~~~

Add the Composer autoloader to the top of your project:

~~~php
require_once 'vendor/autoload.php';
~~~

## Setting up the Contentful client

Once you have installed the SDK you need to create a `Client`.

## Initializing the client

You need an API key and a space ID to initialize a client

_You can use the API key and space ID pre-filled below from our example space or replace them with your own values_.

~~~php
$client = new \Contentful\Delivery\Client('297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971', '71rop70dkqaj');
~~~

## Getting your content

Contentful separates content between entries, which contain your data and relationships with other content or images, and assets, which represent static content, like images, and are served as files. You can read more about this in our [data model concepts guide][3].

### Entries

With the client created, you can start consuming data from the API.

The code below retrieves all entries in your space from the API, but don't print the output yet, as this will result in a lot of JSON, you will learn how to filter the output later:

~~~php
$entries = $client->getEntries();
~~~

Whereas this code retrieves a single entry specified by an ID.

~~~php
$entryId = '5KsDBWseXY6QegucYAoacS';
$entry = $client->getEntry($entryId);
echo $entry->getproductName();
~~~

~~~
Playsam Streamliner Classic Car, Espresso
~~~

To specify more [complex queries][4] you can use the query builder. The example below filters results to a specific content type (the product) and sorts them by price:

~~~php
$query = new \Contentful\Delivery\Query;
$query->setContentType('2PqfXUJwE8qSYKuM0U6w8M')
    ->orderBy('fields.price');

$productEntriesByPrice = $client->getEntries($query);
~~~

### Using the entry

Once you've got the entry, you can access its content through getter methods:

~~~php
foreach ($productEntriesByPrice as $product) {
    echo $product->getproductName(), PHP_EOL;
}
~~~

~~~
Whisk Beater
Playsam Streamliner Classic Car, Espresso
Hudson Wall Cup
SoSo Wall Clock
~~~

If an entry contains a [link][5] to an asset or another entry, the SDK will automatically load it. The example below shows the name of the brand linked to the product:

~~~php
foreach ($productEntriesByPrice as $product) {
    echo $product->getproductName(), ', Brand: ', $product->getBrand()->getcompanyName(), PHP_EOL;
}
~~~

## Using assets

Querying assets works similarly to querying entries. You can retrieve all assets from a space with the following:

~~~php
$assets = $client->getAssets();
~~~

Or to get a single asset:

~~~php
$assetId = 'wtrHxeu3zEoEce2MokCSi';
$asset = $client->getAsset($assetId);
~~~

As with entries you can also use more [complex queries][6]:

~~~php
$query = new \Contentful\Delivery\Query;
$query->orderBy('sys.createdAt');
$assets = $client->getAssets($query);
~~~

Once you have an asset, you can access its metadata and an URL for the actual file:

~~~php
echo $asset->getTitle(), PHP_EOL;
echo $asset->getFile()->getUrl();
~~~

~~~
//images.contentful.com/71rop70dkqaj/wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg
~~~

Using the [Images API][7] you can control how Contentful serves images. For example, to convert an image to a JPEG and resize it to a height of no more than 100 pixels:

~~~php
$options = new \Contentful\Delivery\ImageOptions;
$options->setFormat('jpg')
    ->setHeight(100);
echo $asset->getFile()->getUrl($options);
~~~

~~~
//images.contentful.com/71rop70dkqaj/wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg//images.contentful.com/71rop70dkqaj/wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg?h=100&fm=jpg
~~~

[1]: https://github.com/contentful/contentful.php

[2]: https://getcomposer.org

[3]: /developers/docs/concepts/data-model/

[4]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/

[5]: /developers/docs/concepts/links/

[6]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type/

[7]: /developers/docs/references/images-api/
