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

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

We publish SDKs for various languages to make developing applications easier. This article details how to get content using the [Ruby CDA SDK][1].

## Pre-requisites

This tutorial assumes you have read and understood [the guide that covers the Contentful data model][6].

## Authentication

For every request, clients [need to provide an API key](/developers/docs/references/authentication/), which is created per space and used to delimit applications and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key).

## Installation

First, you need to install the 'contentful' gem, you can do this with the console:

~~~bash
gem install contentful
~~~

Or you can add it inside your _Gemfile_:

~~~ruby
gem 'contentful'
~~~

And then run `bundle install` to install the gem and all its dependencies.

## Setting up the Contentful client

Once you have the gem installed, you can start using it inside your application.

To create a Contentful client you will need the authentication key created earlier and the ID of a space:

~~~ruby
require 'contentful'

client = Contentful::Client.new(
  space: 'cfexampleapi',
  access_token: 'b4c0n73n7fu1',
  dynamic_entries: :auto
)
~~~

{: .note}
**Note**: The `dynamic_entries: :auto` attribute will automatically map the fields in your entries to methods, so that you can use them directly as objects.

## Getting your content

Contentful seperates content between entries, which contain your data and relationships with other content or images, and assets, which represent static content, like images, and are served as files. Read more in our [content model guide][6].

In this section we'll address entries, and we'll address assets later.

With the client created, you can now start consuming data from the API.

For example, to request all entries in a space from the API:

~~~ruby
entries = client.entries
~~~

Or to request a single entry:

~~~ruby
entry_id = 'nyancat'
cat = client.entry(entry_id)
~~~

You can specify any of the [query parameters accepted by the API][5], for example:

~~~ruby
cat_entries_by_date = client.entries(content_type: 'cat', order: 'sys.createdAt')
~~~

### Using your entry as a Ruby object

Once you've got your entry, you can use it as a Ruby object:

~~~ruby
puts cat.name # => "Nyan Cat"
puts "I like #{cat.likes.join(' and ')}" # => "I like rainbows and fish"
puts "I have #{cat.lives} lives" # => "I have 1337 lives"
~~~

You can form complicated queries and interaction with your entries:

~~~ruby
cats_with_many_likes = client.entries(content_type: 'cat', include: 2).select { |cat| cat.likes.size > 1 }
cats_with_many_likes.each do |cat|
  puts "I like #{cat.likes.join(' and ')}"
  puts "My Best Friend is: #{cat.best_friend.name}"
end
~~~

In this case you've added the `include: 2` parameter, which allows the API to resolve [links][4] to other entries that are related.

## Using assets

You query assets in a similar way to entries, but the CDA offers more specific features, [such as filtering by the type of file](7). You can also use our [Images API](8), that allows you to manipulate images as you retrieve them.

To query a single asset:

~~~ruby
client.asset('happycat').image_url
~~~

Will return a URL for the image, something like:

~~~
"//images.contentful.com/cfexampleapi/3MZPnjZTIskAIIkuuosCss/382a48dfa2cb16c47aa2c72f7b23bf09/happycatw.jpg"
~~~

To query all assets in a space:

~~~ruby
assets = client.assets
~~~

[1]: https://github.com/contentful/contentful.rb
[2]: https://github.com/contentful/contentful_middleman_examples
[3]: https://github.com/contentful/contentful-bootstrap.rb
[4]: /developers/docs/concepts/links/
[5]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[6]: /developers/docs/concepts/data-model/
[7]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type
[8]: /developers/docs/references/images-api/
[9]: https://github.com/contentful/contentful_jekyll_examples
