---
page: :docsGettingStartedPython
name: Getting Started with Contentful and Python
title: Getting Started with Contentful and Python
metainformation: This article details how to retrieve entries using the Python CDA SDK.
slug: null
tags:
  - SDKs
  - Python
---

This guide will show you how to get started using our [Python SDK](https://github.com/contentful/contentful.py) to consume content.

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

We publish SDKs for various languages to make developing applications easier.

## Pre-requisites

This tutorial assumes you have read and understood [the guide that covers the Contentful data model](/developers/docs/concepts/data-model/).

## Authentication

For every request, clients [need to provide an API key](/developers/docs/references/authentication/), which is created per space and used to delimit applications and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key).

## Installation

Install the 'contentful' client with [pip](https://pypi.python.org/pypi/pip):

~~~bash
pip install contentful
~~~

{: .note}
On some systems, particularly if you're not using `virtualenv` you may have to use `sudo` to install the SDK.

Or add the SDK to your _requirements.txt_ file:

~~~python
contentful
~~~

And run `pip install -r requirements.txt` to install the client and all dependencies.

## Setting up the Contentful client

Once you have installed the package, you can use it inside your application.

## Initializing the client

You need an API key and a space ID to initialize a client

_You can use the API key and space ID pre-filled below from our example space or replace them with your own values_.

~~~python
import contentful

client = contentful.Client('71rop70dkqaj', '297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971')
~~~

## Getting your content

Contentful separates content between entries, which contain your data and relationships with other content or images, and assets, which represent static content, like images, and are served as files. Read more in our [content model guide](/developers/docs/concepts/data-model/).

## Entries

With the client created, you can now start consuming data from the CDA.

For example, to request all entries in a space:

~~~python
entries = client.entries()
for entry in entries:
    if hasattr(entry, 'product_name'):
        print(entry.product_name)
~~~

~~~
Whisk Beater
Playsam Streamliner Classic Car, Espresso
Hudson Wall Cup
SoSo Wall Clock
~~~

Or to request a single entry:

~~~python
entry_id = '5KsDBWseXY6QegucYAoacS'
classic_car = client.entry(entry_id)
~~~

~~~
Playsam Streamliner Classic Car, Espresso
~~~

You can specify any of the [query parameters accepted by the API](/developers/docs/references/content-delivery-api/#/reference/search-parameters), for example:

~~~python
products_by_price = client.entries({'content_type': '2PqfXUJwE8qSYKuM0U6w8M', 'order': 'fields.price'})

for entry in products_by_price:
  print (entry.product_name)
~~~

~~~
Hudson Wall Cup
Whisk Beater
Playsam Streamliner Classic Car, Espresso
SoSo Wall Clock
~~~

### Using your entry as a Python object

Once you have your entry, you can use it as a Ruby object that follows standard Python conventions:

~~~python
print(product.product_name)
print("it costs {0}".format(product.price))
print("I am tagged with {0}".format(' and '.join(product.tags)))
~~~

~~~
Playsam Streamliner Classic Car, Espresso
it costs 44
I am tagged with wood and toy and car and sweden and design
~~~

You can form complicated queries and interaction with your entries:

~~~python
products_with_many_tags = [ product for product in client.entries({'content_type': '2PqfXUJwE8qSYKuM0U6w8M', 'include': 2}) if product.tags.size > 2 ]
for product in products_with_many_tags:
   print("I am tagged with {0}".format(' and '.join(product.tags)))
   print("My brand is: {0}".format(product.brand.company_name))
~~~

~~~
I am tagged with vase and flowers and accessories
My brand is: Normann Copenhagen
I am tagged with wood and toy and car and sweden and design
My brand is: Playsam
I am tagged with kitchen and accessories and whisk and scandinavia and design
My brand is: Normann Copenhagen
I am tagged with home décor and clocks and interior design and yellow and gifts
My brand is: Lemnos
~~~

In this example you added the `include: 2` parameter, which allows the API to resolve [links](/developers/docs/concepts/links/) to other related entries.

## Using assets

You query assets in a similar way to entries, but the CDA offers more specific features, [such as filtering by the type of file](/developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type/). You can also use our [Images API](/developers/docs/references/images-api/), that allows you to manipulate images as you retrieve them.

To query a single asset:

~~~python
client.asset('wtrHxeu3zEoEce2MokCSi').url
~~~

~~~
//images.contentful.com/71rop70dkqaj/wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg
~~~

To query all assets in a space:

~~~python
assets = client.assets()

for asset in assets:
  print(asset.url)
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
