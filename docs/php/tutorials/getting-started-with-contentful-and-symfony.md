---
page: :docsGettingStartedSymfony
name: Getting started with Contentful and Symfony
title: Getting started with Contentful and Symfony
metainformation: 'This tutorial will show you how to setup the ContentfulBundle in your Symfony application and how to access you content inside the framework.'
slug: null
tags:
 - PHP
 - SDKs
nextsteps: null
---

This tutorial will show you how to setup the ContentfulBundle in your Symfony application and how to access you content
inside the framework.

{: .note}
The ContentfulBundle and the PHP SDK are currently in beta and their APIs may change before a stable release.

## Requirements

The ContentfulBundle requires at least PHP 5.5.9 and Symfony 2.7. PHP 7 and Symfony 3 are supported.

## Installation

The easiest way to install the ContentfulBundle is is to use [Composer][2]. If you've downloaded
`composer.phar`, the Bundle can be installed by executing:

~~~ bash
php composer.phar require contentful/contentful:@beta
php composer.phar require contentful/contentful-bundle:@beta
~~~

{: .note}
Currently the SDK and the Bundle both need to be added to your composer.json because both only have had beta quality releases.

### Adding ContentfulBundle to the application kernel

Next you need to enable the Bundle by adding it to `app/Kernel.php`:

~~~ php
<?php
public function registerBundles()
{
    return [
        // ...
        new Contentful\ContentfulBundle\ContentfulBundle(),
        // ...
    ];
}
~~~

## Configuration

To configure the Bundle add the following section to your application's `config.yml`:

~~~ yaml
contentful:
  delivery:
    space: cfexampleapi
    token: b4c0n73n7fu1
~~~

This is the minimum configuration necessary to use ContentfulBundle. To use the Preview API instead of the Content Delivery API,
simply add `preview: true`:

~~~ yaml
contentful:
  delivery:
    space: cfexampleapi
    token: e5e8d4c5c122cf28fc1af3ff77d28bef78a3952957f15067bbc29f2f0dde0b50.
    preview: true
~~~

If you need access to multiple spaces or to both the delivery API and the Preview API you can configure multiple clients:

~~~ yaml
contentful:
  delivery:
    clients:
      default:
        space: cfexampleapi
        token: b4c0n73n7fu1
      preview:
        space: cfexampleapi
        token: e5e8d4c5c122cf28fc1af3ff77d28bef78a3952957f15067bbc29f2f0dde0b50.
        preview: true
~~~

The name `default` is special and used for the default service. You can override which the default service is by
specifying the `default_client`. For example:

~~~ yaml
contentful:
  delivery:
    default_client: example
    clients:
      example:
        space: cfexampleapi
        token: b4c0n73n7fu1
      example_preview:
        space: cfexampleapi
        token: e5e8d4c5c122cf28fc1af3ff77d28bef78a3952957f15067bbc29f2f0dde0b50.
        preview: true
~~~

To confirm that everything is configured as you wish, execute `bin/console contentful:info` in your shell. The output
should look like this:

~~~
+-----------------+--------------------------------------------+----------+--------------+
| Name            | Service                                    | API      | Space        |
+-----------------+--------------------------------------------+----------+--------------+
| example         | contentful.delivery.example_client         | DELIVERY | cfexampleapi |
| example_preview | contentful.delivery.example_preview_client | PREVIEW  | cfexampleapi |
+-----------------+--------------------------------------------+----------+--------------+
~~~

## Using Contentful

You know have the services `contentful.delivery` and `contentful.delivery.default_client` available. Both pointing to the
default client. If you have more than one client configured, or have specified a name, clients will be available in
services following this naming scheme: `contentful.delivery.{name}_client`. A small controller displaying an entry based
on an ID in the URL could look like this:

~~~ php
<?php

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

class DefaultController extends Controller
{
    /**
     * @Route("/entry/{id}", name="entry.item")
     */
    public function entryAction($id)
    {
        $client = $this->get('contentful.delivery');
        $entry = $client->getEntry($id);

        if (!$entry) {
            throw new NotFoundHttpException;
        }

        return $this->render('default/entry.html.twig', [
            'entry' => $entry
        ]);
    }
}
~~~

To discover how to use the Contentful client, check out the
[getting started with Contentful and PHP](/developers/docs/php/tutorials/getting-started-with-contentful-and-php/) tutorial.

## Using the Web Debug Toolbar

The ContentfulBundle integrates with Symfony's Web Debug Toolbar. If the toolbar is shown and there were requests to the
Contentful API, there will be a section showing how many requests haven been made against the API.

{: .img}
![](https://images.contentful.com/256tjdsmm689/4jmWz0SO80iecEIs4Ue2ao/6e8dafc679399db746951aeef77b3a70/symfony-debug-toolbar.png)

Clicking on that section will open the Contentful panel in the web profiler.

{: .img}
![](https://images.contentful.com/256tjdsmm689/3OcfVreme4Uc4guuMCquGC/705f2a7f68dd7c8f95f06ae845a59603/symfony-web-profiler.png?w=800)

This view shows you a all requests that were made against one of Contentful's API including how long they took. Clicking
on the the "Details" in the last column gives you an overview of the request and response and exceptions thrown by
the Contentful SDK.

{: .img}
![](https://images.contentful.com/256tjdsmm689/5jlwmBgQeWWMyuik2Mae6e/a01a4f1c897cfb759ff0b14f4b591bb4/symfony-web-profiler-details.png?w=800)

## Conclusion

Now you should be familiar with the basics of how to use Contentful in a Symfony application. You can find the Bundle on
[GitHub](https://github.com/contentful/ContentfulBundle/) and [Packagist](https://packagist.org/packages/contentful/contentful-bundle).
To get a deeper understanding, read some of our other [PHP tutorials](/developers/docs/php/#tutorials). If you find a bug,
or have an idea how to further integrate with Symfony, please open an [issue on GitHub](https://github.com/contentful/ContentfulBundle/issues).

[2]: https://getcomposer.org
