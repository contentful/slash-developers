---
page: :docsGettingStartedPhp
name: Getting Started with Contentful and PHP
title: Getting Started with Contentful and PHP
metainformation: This tutorial will walk you through your first steps in using Contentful within your PHP application.
slug: null
tags:
  - SDKs
  - PHP
nextsteps:
  - text: How to only update content that has changed
    link: /developers/docs/php/tutorials/using-the-sync-api-with-php/
---

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

We publish SDKs for various languages to make developing applications easier. This article details how to get content using the [PHP CDA SDK](https://github.com/contentful/contentful.php).

{: .note}
The Contentful PHP SDK is in beta and the API may change before a stable release.

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
<?php
require_once 'vendor/autoload.php';
~~~

## Setting up the Contentful client

Once you have installed the SDK you need to create a `Client`, using the space ID and authentication token you created above.

For this tutorial we'll use an example space

~~~php
<?php
$client = new \Contentful\Delivery\Client('b4c0n73n7fu1', 'cfexampleapi');
~~~

## Getting your content

Contentful separates content between entries, which contain your data and relationships with other content or images, and assets, which represent static content, like images, and are served as files. You can read more about this in our [data model concepts guide][3].

In this section we'll address entries and cover assets later on.

With the client created, you can start consuming data from the API.

The code below retrieves all entries in your space from the API:

~~~php
<?php
$entries = $client->getEntries();
~~~

Whereas this code retrieves a single entry specified by an ID.

~~~php
<?php
$entryId = 'nyancat';
$entry = $client->getEntry($entryId);
~~~

To specify more [complex queries][4] you can use the query builder:

~~~php
<?php
$query = new \Contentful\Delivery\Query;
$query->setContentType('cat')
      ->orderBy('sys.createdAt');
$catEntriesByDate = $client->getEntries($query);
~~~

### Using your entry

Once you've got your entry, you can access the content it holds through getter methods:

~~~php
<?php
echo $cat->getName(); // "Nyan Cat"
echo "I have $cat->getLives() lives"; // "I have 1337 lives"
~~~

If an entry contains a [link][5] to an asset or another entry, it will automatically be loaded when accessing it:

~~~php
<?php
echo $cat->getBestFriend()->getName(); // "Happy Cat"
~~~

## Using assets

Querying assets works like querying entries.

You can retrieve all assets of your space:

~~~php
<?php
$assets = $client->getAssets();
~~~

Or you can get a single asset:

~~~php
<?php
$assetId = 'nyancat';
$asset = $client->getAsset($assetId);
~~~

As with entries you can also use more [complex queries][6]:

~~~php
<?php
$query = new \Contentful\Delivery\Query;
$query->orderBy('sys.createdAt');
$assets = $client->getAssets($query);
~~~

Once you have an asset, you can access its metadata and an URL for the actual file:

~~~php
<?php
echo $asset->getName(); // "Nyan Cat"
echo $asset->getFile()->getUrl(); // "//images.contentful.com/cfexampleapi/4gp6taAwW4CmSgumq2ekUm/9da0cd1936871b8d72343e895a00d611/Nyan_cat_250px_frame.png"
~~~

Using the [Images API][7] you can control details how Contentful serves images. For example, to convert an image to a JPEG and resize it to a height of no more than 100 pixels:

~~~php
<?php
$options = new \Contentful\Delivery\ImageOptions;
$options->setFormat('jpg')
        ->setHeight(100);
$url = $asset->getName()->getFile()->getUrl($options);
~~~

## Next steps

- [Explore the PHP CDA SDK GitHub repository](https://github.com/contentful/contentful.php).
- [Getting started with the Sync API and PHP](/developers/docs/php/tutorials/using-the-sync-api-with-php)

[1]: https://github.com/contentful/contentful.php
[2]: https://getcomposer.org
[3]: /developers/docs/concepts/data-model/
[4]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[5]: /developers/docs/concepts/links/
[6]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type
[7]: /developers/docs/references/images-api/
