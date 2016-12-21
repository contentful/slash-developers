---
page: :docsGettingStartedLaravel
name: Getting Started with Contentful and Laravel
title:  Getting Started with Contentful and Laravel
metainformation: 'This tutorial will walk you through your first steps in using Contentful within your PHP application.'
slug: null
tags:
  - SDKs
  - PHP
nextsteps: null
---

This tutorial will show you how to setup the Content Delivery API in your Laravel application and how to access your content
inside the framework.

{: .note}
The ContentfulBundle and the PHP SDK are currently in beta and their APIs may change before a stable release.

## Requirements

The Contentful Laravel integrations requires at least PHP 5.5.9 and Laravel 5. PHP 7 is are supported.

## Installation

The easiest way to install the Laravel integration is is to use [Composer][1]. If you've downloaded
`composer.phar`, the integration can be installed by executing:

~~~ bash
php composer.phar require contentful/contentful:@beta
php composer.phar require contentful/laravel:@beta
~~~

{: .note}
Currently the SDK and the integration both need to be added to your composer.json because both only have had beta quality releases.

### Enable the Service Provider

Next you need to enable the Service Provider by adding it to `config/app.php`:

~~~ php
<?php
return [
    'providers' => [
        // ...
        new Contentful\ContentfulBundle\ContentfulBundle(),
        // ...
    ]
];
~~~

### Configuration

Before the Contentful SDK can be configured, the necessary config files have to be published. To do so execute the following command:

~~~ bash
php artisan vendor:publish
~~~

This will add a file called `contentful.php` to your `/config` folder.

Now open that file and fill in your space ID and API key.

~~~ php
<?php
return [
  'delivery.space' => 'cfexampleapi',
  'delivery.token' => 'b4c0n73n7fu1'
];
~~~

To use the Preview API instead of the Content Delivery API, simply add `'delivery.preview' => true`:

~~~ php
<?php
return [
  'delivery.space' => 'cfexampleapi',
  'delivery.token' => 'e5e8d4c5c122cf28fc1af3ff77d28bef78a3952957f15067bbc29f2f0dde0b50',
  'delivery.preview' => true
];
~~~

## Using Contentful

You now have a service for the class `Contentful\Delivery\Client` available. A small controller displaying an entry
based on an ID in the URL could look like this:

~~~ php
<?php

use Illuminate\Routing\Controller as BaseController;
use Contentful\Delivery\Client as DeliveryClient;

class DefaultController extends Controller
{
    /**
     * @var DeliveryClient
     */
    private $client;

    public function __construct(DeliveryClient $client)
    {
        $this->client = $client;
    }

    public function entryAction($id)
    {
        $entry = $this->client->getEntry($id);

        if (!$entry) {
            abort(404);
        }

        return view('entry', [
            'entry' => $entry
        ]);
    }
}
~~~

To discover how to use the Contentful client, check out the
[getting started with Contentful and PHP](/developers/docs/php/tutorials/getting-started-with-contentful-and-php/) tutorial.

## Conclusion

Now you should be familiar with the basics of how to use Contentful in a Laravel application. You can find the integration on
[GitHub](https://github.com/contentful/contentful-laravel/) and [Packagist](https://packagist.org/packages/contentful/laravel).
To get a deeper understanding, read some of our other [PHP tutorials](/developers/docs/php/#tutorials). If you find a bug,
or have an idea how to further integrate with Laravel, please open an [issue on GitHub](https://github.com/contentful/contentful-laravel/issues).

[1]: https://getcomposer.org
