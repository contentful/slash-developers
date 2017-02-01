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

:[Getting started tutorial intro](../../_partials/getting-started-intro.md)

## Installation

The easiest way to install the Contentful PHP SDK is to use [Composer][2] and run the following command:

```bash
php composer.phar install contentful/contentful:@beta
```

Add the Composer autoloader to the top of your project:

```php
require_once 'vendor/autoload.php';
```

## Setting up the Contentful client

Once you have installed the SDK you need to create a `Client`.

:[Create credentials](../../_partials/credentials.md)

```php
$client = new \Contentful\Delivery\Client('<access_token>', '<space_id>');
```

## Getting your content

Contentful separates content between entries, which contain your data and relationships with other content or images, and assets, which represent static content, like images, and are served as files. You can read more about this in our [data model concepts guide][3].

### Entries

With the client created, you can start consuming data from the API.

The code below retrieves all entries in your space from the API, but don't print the output yet, as this will result in a lot of JSON, you will learn how to filter the output later:

```php
$entries = $client->getEntries();
```

Whereas this code retrieves a single entry specified by an ID.

```php
$entryId = '<entry_id>';
$entry = $client->getEntry($entryId);
echo $entry->getproductName();
```

:[Get entry output](../../_partials/get-entry-output.md)

To specify more [complex queries][4] you can use the query builder. The example below filters results to a specific content type (the product) and sorts them by price:

```php
$query = new \Contentful\Delivery\Query;
$query->setContentType('<product_content_type_id>')
    ->orderBy('fields.price');

$productEntriesByPrice = $client->getEntries($query);
```

### Using the entry

Once you've got the entry, you can access its content through getter methods:

```php
foreach ($productEntriesByPrice as $product) {
    echo $product->getproductName(), PHP_EOL;
}
```

:[Get all entry output](../../_partials/get-all-entry-output.md)

If an entry contains a [link][5] to an asset or another entry, the SDK will automatically load it. The example below shows the name of the brand linked to the product:

```php
foreach ($productEntriesByPrice as $product) {
    echo $product->getproductName(), ', Brand: ', $product->getBrand()->getcompanyName(), PHP_EOL;
}
```

## Using assets

Querying assets works similarly to querying entries. You can retrieve all assets from a space with the following:

```php
$assets = $client->getAssets();
```

Or to get a single asset:

```php
$assetId = '<assest_id>';
$asset = $client->getAsset($assetId);
```

As with entries you can also use more [complex queries][6]:

```php
$query = new \Contentful\Delivery\Query;
$query->orderBy('sys.createdAt');
$assets = $client->getAssets($query);
```

Once you have an asset, you can access its metadata and an URL for the actual file:

```php
echo $asset->getTitle(), PHP_EOL;
echo $asset->getFile()->getUrl();
```

:[Get single asset](../../_partials/get-asset-output.md)

Using the [Images API][7] you can control how Contentful serves images. For example, to convert an image to a JPEG and resize it to a height of no more than 100 pixels:

```php
$options = new \Contentful\Delivery\ImageOptions;
$options->setFormat('jpg')
    ->setHeight(100);
echo $asset->getFile()->getUrl($options);
```

:[Get single asset](../../_partials/get-asset-processed-output.md)

[1]: https://github.com/contentful/contentful.php

[2]: https://getcomposer.org

[3]: /developers/docs/concepts/data-model/

[4]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/

[5]: /developers/docs/concepts/links/

[6]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type/

[7]: /developers/docs/references/images-api/
