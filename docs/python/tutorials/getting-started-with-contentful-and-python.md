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

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

We publish SDKs for various languages to make developing applications easier. This article details how to get content using the [Python CDA SDK][1].

## Pre-requisites

This tutorial assumes you have read and understood [the guide that covers the Contentful content model][3].

## Authentication

For every request, clients [need to provide an API key](/developers/docs/references/authentication/), which is created per space and used to delimit applications and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key).

## Installation

First, you need to install the 'contentful' client, you can do this with the console:

~~~bash
pip install contentful
~~~

> In some systems, particularly if not using `virtualenv` you may have to use `sudo` to install it.

Or you can add it inside your _requirements.txt_ file:

~~~
contentful==1.0.3
~~~

And then run `pip install -r requirements.txt` to install the client and all its dependencies.

## Setting up the Contentful client

Once you have the gem installed, you can start using it inside your application.

To create a Contentful client you will need the authentication key created earlier and the ID of a space:

~~~python
import contentful

client = contentful.Client('cfexampleapi', 'b4c0n73n7fu1')
~~~

## Getting your content

Contentful seperates content between entries, which contain your data and relationships with other content or images, and assets, which represent static content, like images, and are served as files. Read more in our [content model guide][3].

In this section we'll address entries, and we'll address assets later.

With the client created, you can now start consuming data from the API.

For example, to request all entries in a space from the API:

~~~python
entries = client.entries()
~~~

Or to request a single entry:

~~~python
entry_id = 'nyancat'
cat = client.entry(entry_id)
~~~

You can specify any of the [query parameters accepted by the API][5], for example:

~~~python
cat_entries_by_date = client.entries({'content_type': 'cat', 'order': 'sys.createdAt'})
~~~

### Using your entry as a Python object

Once you've got your entry, you can use it as a Python object:

~~~python
print(cat.name) # "Nyan Cat"
print("I like {0}".format(' and '.join(cat.likes))) # => "I like rainbows and fish"
print("I have {0} lives".format(cat.lives)) # => "I have 1337 lives"
~~~

You can form complicated queries and interaction with your entries:

~~~python
cats_with_many_likes = [ cat for cat in client.entries({'content_type': 'cat', 'include': 2}) if cat.likes.size > 1 ]
for cat in cats_with_many_likes:
    print("I like {0}".format(' and '.join(cat.likes)))
    print("My Best Friend is: {0}".format(cat.best_friend.name))
~~~

In this case you've added the `'include': 2` parameter, which allows the API to resolve [links][2] to other entries that are related.

## Using assets

You query assets in a similar way to entries, but the CDA offers more specific features, [such as filtering by the type of file](/developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type/). You can also use our [Images API](/developers/docs/references/images-api/), that allows you to manipulate images as you retrieve them.

To query a single asset:

~~~python
client.asset('happycat').image_url
~~~

Will return a URL for the image, something like:

~~~
"//images.contentful.com/cfexampleapi/3MZPnjZTIskAIIkuuosCss/382a48dfa2cb16c47aa2c72f7b23bf09/happycatw.jpg"
~~~

To query all assets in a space:

~~~python
assets = client.assets()
~~~

[1]: https://github.com/contentful/contentful.py
[2]: /developers/docs/concepts/links/
[3]: /developers/docs/concepts/data-model/
