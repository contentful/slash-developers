---
page: :docsGettingStartedRuby
---

This post will walk you through your first steps in using Contentful within your Ruby applications.
We will provide simple steps to get your first entries and start using the content you create on Contentful.

## Installation

First, you need to install our `contentful` gem. To do so, you can do it manually on the console by doing:

```bash
$ gem install contentful
```

Or you can add it inside your `Gemfile`:

```ruby
gem 'contentful'
```

Once in your `Gemfile`, running `bundle install` will install the gem and all its dependencies.

## Setting up your Contentful Client

Once you have your gem installed, you can start using it inside your application.

In this example, we'll use the Example Space:

```ruby
require 'contentful'

client = Contentful::Client.new(
  space: 'cfexampleapi',
  access_token: 'b4c0n73n7fu1',
  dynamic_entries: :auto
)
```

You'll need to create a Contentful Client, for that, you'll need your **Space ID** and **Access Token**,
both of which can be obtained through the Contentful UI.

> **Note**: The `dynamic_entries`, will automatically map the fields in your Entries to methods,
> so that you can use them directly as objects.

## Getting your content

In Contentful, we separate content between Entries, which contain your data and relationships with other
content or images, and Assets, which represent static content, like images, and are served as files. You can read more
about that in our [Data Model Concepts guide][6].

In this section we'll address Entries, Assets will be addressed on a later section.

With the client already created, all that's left to do, is to start consuming the data from the API.

To do so, you can request all your entries to the API:

```ruby
entries = client.entries
```

Or request a single entry:

```ruby
entry_id = 'nyancat'
cat = client.entry(entry_id)
```

You can also specify the same [query parameters the API accepts][5]:

```ruby
cat_entries_by_date = client.entries(content_type: 'cat', order: 'sys.createdAt')
```

### Using your Entry

Once we've got our entry, we can just use it as any Ruby object

```ruby
puts cat.name # => "Nyan Cat"
puts "I like #{cat.likes.join(' and ')}" # => "I like rainbows and fish"
puts "I have #{cat.lives} lives" # => "I have 1337 lives"
```

You can even do more complicated querying and interacting with your entries

```ruby
cats_with_many_likes = client.entries(content_type: 'cat', include: 2).select { |cat| cat.likes.size > 1 }
cats_with_many_likes.each do |cat|
  puts "I like #{cat.likes.join(' and ')}"
  puts "My Best Friend is: #{cat.best_friend.name}"
end
```

In this case we've added the `include: 2` parameter, which allows the API to resolve [Links][4] into Entries.
This allows us to get the properties from our cat's best friend.

## Using Assets

Assets have a similar querying API than Entries.
You can see more [specific queries][7] and also can use the [Images API][8].

To query a Single Asset:

```ruby
client.asset('happycat').image_url
# => "//images.contentful.com/cfexampleapi/3MZPnjZTIskAIIkuuosCss/
#     382a48dfa2cb16c47aa2c72f7b23bf09/happycatw.jpg"
```

To query all Assets in Space:

```ruby
assets = client.assets
```

## Conclusion

With this basic guide, you should be able to start using Contentful within your Ruby Applications.

You can read about the library in more detail on our [contentful.rb GitHub][1]

You can also check out how to [Create a Static Site using Contentful and Middleman][2], and how to
get your Spaces started with a single command using [Contentful Bootstrap][3]

[1]: https://github.com/contentful/contentful.rb
[2]: https://github.com/contentful-labs/contentful_middleman_examples
[3]: https://github.com/contentful-labs/contentful-bootstrap.rb
[4]: /developers/docs/concepts/links/
[5]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[6]: /developers/docs/concepts/data-model/
[7]: /developers/docs/references/content-delivery-api/#/reference/search-parameters/filtering-assets-by-mime-type
[8]: /developers/docs/references/images-api/
