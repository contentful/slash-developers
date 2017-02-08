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

:[Getting started tutorial intro](../../_partials/getting-started-intro.md)

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

:[Create credentials](../../_partials/credentials.md)

~~~python
import contentful

client = contentful.Client('<space_id>', '<access_token>')
~~~

## Getting your content

Contentful separates content between entries, which contain your data and relationships with other content or images, and assets, which represent static content, like images, and are served as files. Read more in our [content model guide](/developers/docs/concepts/data-model/).

## Entries

With the client created, you can now start consuming data from the CDA.

For example, to request all entries in a space:

~~~python
entries = client.entries()

for entry in entries:
    print(getattr(entry, 'product_name', 'Not a product'))
~~~

:[Get all entry output](../../_partials/get-all-entry-output-python.md)

Or to request a single entry:

~~~python
entry_id = '<entry_id>'
classic_car = client.entry(entry_id)
~~~

:[Get entry output](../../_partials/get-entry-output.md)

You can specify any of the [query parameters accepted by the API](/developers/docs/references/content-delivery-api/#/reference/search-parameters), for example:

~~~python
products_by_price = client.entries({'content_type': '<product_content_type_id>', 'order': 'fields.price'})

for entry in products_by_price:
  print (entry.product_name)
~~~

:[Sorted entry output](../../_partials/sorted-entries-out.md)

### Using your entry as a Python object

Once you have your entry, you can use it as a Ruby object that follows standard Python conventions:

~~~python
print(product.product_name)
print("it costs {0}".format(product.price))
print("I am tagged with {0}".format(' and '.join(product.tags)))
~~~

:[Python object output](../../_partials/ruby-python-object-output.md)

You can form complicated queries and interaction with your entries:

~~~python
products_with_many_tags = [ product for product in client.entries({'content_type': '<product_content_type_id>', 'include': 2}) if product.tags.size > 2 ]
for product in products_with_many_tags:
   print("I am tagged with {0}".format(' and '.join(product.tags)))
   print("My brand is: {0}".format(product.brand.company_name))
~~~

:[Python object complex output](../../_partials/ruby-python-object-complex-output.md)

In this example you added the `include: 2` parameter, which allows the API to resolve [links](/developers/docs/concepts/links/) to other related entries.

## Using assets

You query assets in a similar way to entries, but the CDA offers more specific features, [such as filtering by the type of file](/developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type/). You can also use our [Images API](/developers/docs/references/images-api/), that allows you to manipulate images as you retrieve them.

To query a single asset:

~~~python
client.asset('<asset_id>').url()
~~~

:[Get single asset](../../_partials/get-asset-output.md)

To query all assets in a space:

~~~python
assets = client.assets()

for asset in assets:
  print(asset.url())
~~~

:[Get all assets](../../_partials/get-all-asset-output.md)
