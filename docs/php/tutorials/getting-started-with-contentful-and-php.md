---
page: :docsGettingStartedPhp
---

This tutorial will walk you through your first steps in using Contentful within your PHP application.
With only a few simple steps you will be able to access the content you create on Contentful.

{: .note}
The Contentful PHP SDK is currently in beta and the API may change before a stable release.

## Installation

The easiest way to install the Contentful PHP SDK is to use [Composer][2]. If you've downloaded
`composer.phar`, the SDK can be installed by executing:

~~~ bash
php composer.phar install contentful/contentful:@beta
~~~

If not already done, you'll also need to load the Composer autoloader:

~~~ php
<?php
require_once 'vendor/autoload.php';
~~~

## Setting up your Contentful Client

Once the SDK is installed you can start using it by creating a `Client`. To do so you need the ID of the Space you'd
like to use and an access token for this Space, both of which can be obtained through the Contentful UI.

For this tutorial we'll use the example Space

~~~ php
<?php
$client = new \Contentful\Delivery\Client('b4c0n73n7fu1', 'cfexampleapi');
~~~

## Getting your content

In Contentful, we separate content between Entries, which contain your data and relationships with other
content or images, and Assets, which represent static content, like images, and are served as files. You can read more
about that in our [Data Model Concepts guide][3].

In this section we'll address Entries. Assets will be addressed in a later section.

With the client already created, all that's left to do is to start consuming the data from the API.

To do so, you can request all your Entries from the API:

~~~ php
<?php
$entries = $client->getEntries();
~~~

~~~ php
<?php
$entryId = 'nyancat';
$entry = $client->getEntry($entryId);
~~~

To specify more [complex queries][4] you can use the query builder:

~~~ php
<?php
$query = new \Contentful\Delivery\Query;
$query->setContentType('cat')
      ->orderBy('sys.createdAt');
$catEntriesByDate = $client->getEntries($query);
~~~

### Using your Entry

Once you've got your Entry, you can access the content it holds through getter methods:

~~~ php
<?php
echo $cat->getName(); // "Nyan Cat"
echo "I have $cat->getLives() lives"; // "I have 1337 lives"
~~~

If an entry contains a [link][5] to an Asset or another Entry, it will automatically be loaded when accessing it:

~~~ php
<?php
echo $cat->getBestFriend()->getName(); // "Happy Cat"
~~~

## Using Assets

Querying Assets works just like querying Entries.

You can retrieve all Assets of your Space:

~~~ php
<?php
$assets = $client->getAssets();
~~~

You can get a single asset:

~~~ php
<?php
$assetId = 'nyancat';
$asset = $client->getAsset($assetId);
~~~

Just as with Entries you can also use more [complex queries][6]:

~~~ php
<?php
$query = new \Contentful\Delivery\Query;
$query->orderBy('sys.createdAt');
$assets = $client->getAssets($query);
~~~

Once you have an Asset, you can access its metadata and an URL for the actual file:

~~~ php
<?php
echo $asset->getName(); // "Nyan Cat"
echo $asset->getFile()->getUrl(); // "//images.contentful.com/cfexampleapi/4gp6taAwW4CmSgumq2ekUm/9da0cd1936871b8d72343e895a00d611/Nyan_cat_250px_frame.png"
~~~

Using the [Images API][7] you can control details how images are served by Contentful. To have an image converted to
jpeg and resized to a height of no more than 100 pixel, it would look like this:

~~~ php
<?php
$options = new \Contentful\Delivery\ImageOptions;
$options->setFormat('jpg')
        ->setHeight(100);
$url = $asset->getName()->getFile()->getUrl($options);
~~~

## Conclusion

With this basic guide, you should be able to start using Contentful within your PHP Applications.

You can find the source code and more details about the SDK on [GitHub][1].

[1]: https://github.com/contentful/contentful.php
[2]: https://getcomposer.org
[3]: /developers/docs/concepts/data-model/
[4]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[5]: /developers/docs/concepts/links/
[6]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type
[7]: /developers/docs/references/images-api/
