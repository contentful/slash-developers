---
page: :docsGettingStartedRuby
name: Getting Started with Contentful and Ruby
title: Getting Started with Contentful and Ruby
metainformation: This article details how to retrieve entries using the Ruby CDA SDK.
slug: null
tags:
  - SDKs
  - Ruby
nextsteps:
  - text: Using the Contentful Management API with Ruby
    link: /developers/docs/ruby/tutorials/getting-started-with-contentful-cma-and-ruby/
  - text: Create and deploy a Ruby application with Contentful
    link: /developers/docs/ruby/tutorials/full-stack-getting-started/
---

This guide will show you how to get started using our [Ruby SDK](https://github.com/contentful/contentful.rb) to consume content.

:[Getting started tutorial intro](../../_partials/getting-started-intro.md)

## Installation

First, install the 'contentful' gem, with the terminal:

~~~bash
gem install contentful
~~~

Or you can add it to your _Gemfile_:

~~~ruby
gem 'contentful'
~~~

And run `bundle install` to install the gem and all its dependencies.

## Setting up the Contentful client

Once you have installed the gem, you can start using it inside your application.

:[Create credentials](../../_partials/credentials.md)

~~~ruby
require 'contentful'

client = Contentful::Client.new(
  space: '<space_id>',
  access_token: '<access_token>',
  dynamic_entries: :auto
)
~~~

{: .note}
**Note**: The `dynamic_entries: :auto` attribute will automatically map the fields in your entries to methods, so that you can use them directly as objects.

## Getting your content

Contentful separates content between entries, which contain your data and relationships with other content or images, and assets, which represent static content, like images, and are served as files. Read more in our [content model guide][/developers/docs/concepts/data-model/].

### Entries

With the client created, you can now start consuming data from the API.

For example, to request all entries in a space from the API:

~~~ruby
entries = client.entries

entries.each do |entry|
  if entry.fields[:productName]
    puts entry.fields[:productName]
  end
end
~~~

:[Get all entry output](../../_partials/get-all-entry-output.md)

Or to request a single entry:

~~~ruby
entry_id = '<entry_id>'
classic_car = client.entry(entry_id)

puts classic_car.fields[:productName]
~~~

:[Get entry output](../../_partials/get-entry-output.md)

You can specify any of the [query parameters accepted by the API][/developers/docs/references/content-delivery-api/#/reference/search-parameters], for example:

~~~ruby
products_by_price = client.entries(content_type: '<product_content_type_id>', order: 'fields.price')

products_by_price.each do |entry|
  if entry.fields[:productName]
    puts entry.fields[:productName]
  end
end
~~~

:[Sorted entry output](../../_partials/sorted-entries-out.md)

### Using your entry as a Ruby object

Once you have your entry, you can use it as a Ruby object that follows standard Ruby conventions:

~~~ruby
puts product.product_name
puts "it costs #{product.price}"
puts "I am tagged with #{product.tags.join(' and ')}"
~~~

:[Ruby object output](../../_partials/ruby-python-object-output.md)

You can form complicated queries and interactions with your entries:

~~~ruby
products_with_many_tags = client.entries(content_type: '<content_type>', include: 2).select { |product| product.tags.size > 2 }
products_with_many_tags.each do |product|
  puts "I am tagged with #{product.tags.join(' and ')}"
  puts "My brand is #{product.brand.company_name}"
end
~~~

:[Ruby object complex output](../../_partials/ruby-object-complex-output.md)

In this example you added the `include: 2` parameter, which allows the API to resolve [links][4] to other related entries.

## Using assets

You query assets in a similar way to entries, but the CDA offers more specific features, [such as filtering by the type of file](/developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type/). You can also use our [Images API](/developers/docs/references/images-api/), that allows you to manipulate images as you retrieve them.

To query for a single asset:

~~~ruby
asset_file = client.asset('<asset_id>').image_url
puts asset_file
~~~

:[Get single asset](../../_partials/get-asset-output.md)

To query all assets in a space:

~~~ruby
assets = client.assets

assets.each do |abeausset|
  puts asset.image_url
end
~~~

:[Get single asset](../../_partials/get-all-asset-output.md)

[1]: https://github.com/contentful/contentful.rb

[2]: https://github.com/contentful/contentful_middleman_examples

[3]: https://github.com/contentful/contentful-bootstrap.rb

[4]: /developers/docs/concepts/links/
