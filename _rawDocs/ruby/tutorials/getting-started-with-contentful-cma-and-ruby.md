---
page: :docsGettingStartedRubyCMA
name: Getting Started with Ruby and the CMA
title: Getting Started with Ruby and the CMA
metainformation: 'This post will walk you through your first steps in using the Contentful Management API within your Ruby applications.'
slug: null
tags:
  - SDKs
  - Ruby
nextsteps:
  - text: Create and deploy a Ruby application with Contentful
    link: /developers/docs/ruby/tutorials/full-stack-getting-started/
---

This post will walk you through your first steps in using [Contentful Management API][0]
within your Ruby applications.
We will provide simple steps to create and edit your resources and start using them.
For that, we'll be building a simple blog system with posts, authors, assets and categories
linked to the posts. Of course, the Contentful platform is capable of managing any content model
you can dream up, blogs are just an easy to understand example.

{: .note}
**Note**: This Getting Started guide will be covering the `1.x` version of the gem.
If you're using `0.x` versions, the top-level `client` methods we use in this guide will not be present.
For reference on that check the older version's [README][3]

## Creating a blog space

Let's start with mapping out the type of items we need to publish a blog.
A cursory glance will reveal that a standard blog post contains the following fields:

* Title
* Author
* Body
* Category
* Tags

In order to keep things manageable, we will create separate content types for author and category entries.
Categories are simple, each blog category has two fields:

* Name
* Description

And each author entry will have the following fields:

* Name
* Bio
* Profile picture
* URL

{: .note}
It is always a good idea to plan ahead when designing the model for your content types,
since changing it after creating entries can be a lot of work.
For a better understanding of how to structure your data,
we recommend our [Content Modeling Guide][1]

When using media assets in Contentful keep in mind a simple rule of thumb:
a single asset does not require a separate content type, since it is handled
through the built-in asset type. All assets have a title and description field by default.

However, if you would like to organize assets into a gallery or need to display
additional meta information beyond title and description, then we recommended
creating a wrapper content type (e.g. a "gallery" content type) for your media
assets and linking an entry of that type to your blog post.

## Installation

First, you need to install our [`contentful-management` gem][11].
You can do it either manually on the console:

~~~ bash
$ gem install contentful
~~~

Or you can add it inside your `Gemfile`:

~~~ ruby
gem 'contentful-management', '~> 1.0'
~~~

Once in your `Gemfile`, running `bundle install` will install the gem and all its dependencies.

{: .note}
The gem is compatible with all major Ruby versions including jRuby 1.9.

## Setting up your Contentful Management client

Once you have your gem installed, you can start using it inside your application.

For this example, we'll assume you have already created an account. You can fetch your management token
from [our authentication docs][2]

Once you have the management token, you can create the client:

~~~ ruby
require 'contentful/management'

client = Contentful::Management::Client.new("YOUR_MANAGEMENT_TOKEN")
~~~

## Creating content types

First, we are creating a new space to start from scratch:

~~~ ruby
space = client.spaces.create(name: 'Blog')
~~~

If you happen to be in more than one organization you need to specify an organization ID.
The ID can be found in your account settings in the url once you selected the organization.

Before we can create posts we need to create the content types. A content type consists
of an optional custom id, a name, a type and more fields that can be found in
the [documentation][4].

For the blog post itself we add the following fields:

~~~ ruby
post = space.content_types.create(name: 'Post')
post.fields.create(id: 'title', name: 'Title', type: 'Text')
post.fields.create(id: 'body', name: 'Body', type: 'Text')
~~~

Setting the `displayField` to `'title'` will cause the value of `'title'` to be shown
when listing entries on the Contentful Web App.

~~~ ruby
post.update(displayField: 'title')
~~~

We follow the same procedure to create a content type for category entry:

~~~ ruby
category = space.content_types.create(name: 'Category')
category.fields.create(id: 'name', name: 'Name', type: 'Text')
category.fields.create(id: 'description', name: 'Description', type: 'Text')
category.update(displayField: 'name')
~~~

Last but not least, we add a content type for authors:

~~~ ruby
author = space.content_types.create(name: 'Author')
author.fields.create(id: 'name', name: 'Name', type: 'Text')
author.fields.create(id: 'bio', name: 'Biography', type: 'Text')
author.update(displayField: 'name')
~~~

Now we want to create a relation between blog posts and categories, authors and assets.
To model one-to-many relationships we will be adding `Array` fields to our content types,
and the items in those arrays will be a special _Link_ type.

First we need to create standalone `Link` fields for categories and assets that
will be linked to a post:

~~~ ruby
category_link = Contentful::Management::Field.new
category_link.type = 'Link'
category_link.link_type = 'Entry'

asset_link = Contentful::Management::Field.new
asset_link.type = 'Link'
asset_link.link_type = 'Asset'
~~~

The _type_ specifies that we are dealing with a link,
the _link_type_ describes what we are linking to.
In this case we are linking to other entries and assets.
Then we add  `Array` fields to post content type:

~~~ ruby
post.fields.create(id: 'categories', name: 'Categories', type: 'Array', items: category_link)
post.fields.create(id: 'assets', name: 'Assets', type: 'Array', items: asset_link)
~~~

Finally, we add a field that links from the post to its author,
because the author is not an array we can create the field directly through the content type.

~~~ ruby
post.fields.create(id: 'author', name: 'Post Author', type: 'Link', link_type: 'Entry')
~~~

At this point we have created the basic structure for our blog,
but before we start creating entries we need to publish our content types:

~~~ ruby
post.publish
category.publish
author.publish
~~~

If you now take a look at the Contentful Web App you will see your newly prepared space,
with the well-defined post, category and author content types.

## Creating Entries

Now lets get down to creating some categories:

~~~ ruby
categories = []
categories << category.entries.create(
  name: 'Misc',
  description: 'Misc stuff'
)
categories << category.entries.create(
  name: 'ContentManagement',
  description: 'Basics and principles about content.'
)
categories.map(&:publish)
~~~

And lets add an author whose name will appear in the blog post:

~~~ ruby
post_author = author.entries.create(
  name: 'Janine McKay ',
  bio: 'Technical writer and twitter ninja.'
)
post_author.publish
~~~

Now to create an actual post linked to the _Misc_ and _ContentManagement_ category:

~~~ ruby
post_entry = post.entries.create(
  title: 'First Post',
  body: 'Letterpress sustainable authentic, disrupt semiotics actually kitsch.'\
    ' Direct trade Cosby sweater Austin, Pitchfork flexitarian small batch'\
    ' authentic roof party 8-bit YOLO literally Neutra pour-over American Apparel'\
    ' dreamcatcher. High Life distillery cliche YOLO, flexitarian four loko put a'\
    ' bird on it plaid Marfa Shoreditch seitan Echo Park bicycle rights Pinterest PBR.'\
    ' Drinking vinegar Banksy gastropub, stumptown occupy farm-to-table Blue Bottle'\
    ' tattooed Truffaut single-origin coffee iPhone locavore pug. Blue Bottle cray'\
    ' quinoa farm-to-table Bushwick tousled. beard Kitschgit tousled, American Apparel'\
    ' XOXO vegan readymade Pitchfork church-key 3 wolf moon direct trade lo-fi.'\
    ' Food truck try-hard deep v salvia raw denim.'
)
~~~

Then link our categories array to our freshly created post:

~~~ ruby
post_entry.update(categories: categories)
~~~

To complete the post we want to upload an asset, create a link to it, and add an author:

![Unter den Linden][5]

~~~ ruby
image_file = Contentful::Management::File.new
image_file.properties[:contentType] = 'image/jpeg'
image_file.properties[:fileName] = 'example.jpg'
image_file.properties[:upload] = 'https://farm9.staticflickr.com/8144/6974761828_493d4dc28d_k_d.jpg'

asset = space.assets.create(
  title: "Unter den Linden",
  description: "A nice shot of the TV-Tower in Berlin",
  file: image_file
)
asset.publish
~~~

If we want to update an existing entry with additional links we have to include all
of the existing links:

~~~ ruby
post_entry.update(categories: categories, assets: [asset], author: author)
~~~

The last step now is to publish the entry so we can fetch it through the Content Delivery API
or view it in the web interface. Please note that entries in 'draft' state will not
show up in the Content Delivery API.

~~~ ruby
post_entry.publish
~~~

You are invited to use the [Delivery API Gem][6] to fetch your first entries. You can also
read our [Getting Started With the CDA and Ruby Guide][7].


### Summary

With this basic guide, you should be able to start using the Contentful Management API
within your Ruby applications.

Once you have created your content types, publishing new entries and assets is fairly simple.
For an example of setting up a more complex content model from scratch, we have built a script
that imports the [Open Beer Database][8], creating a structure with breweries, beers and beer
styles and automatically linking them to each other.

You can find the script to try out and study on our [Github account][9].

You can also check out how to get your spaces started with a single command using [Contentful Bootstrap][10].

### Further Reading

* [Content Management API Documentation][0]
* [contentful-management.rb on Github][11]
* [contentful-management.rb on RubyGems][12]
* [contentful-management.rb Documentation][13]
* [Example Script][9] using the [Open Beer Database][8] to create a space with multiple content types and entries.


### License Attributions:

* Image Credits: Picture "Unter den Linden", [Amira A][14] [License: Creative Commons 2.0][15]


[0]: /developers/docs/references/content-management-api/
[1]: /r/knowledgebase/content-modelling-basics/
[2]: /developers/docs/references/authentication/#getting-an-oauth-token
[3]: https://github.com/contentful/contentful-management.rb/blob/01f5b2abfd1c00888197a6f79093b7ae0baee274/README.md
[4]: /developers/docs/references/content-management-api/#/reference/content-types
[5]: https://farm9.staticflickr.com/8144/6974761828_51c4fb1d54_z_d.jpg "Unter den Linden"
[6]: https://github.com/contentful/contentful.rb
[7]: /developers/docs/ruby/tutorials/getting-started-with-contentful-and-ruby/
[8]: https://openbeerdb.com/
[9]: https://github.com/contentful-labs/cma_import_script
[10]: https://github.com/contentful/contentful-bootstrap.rb
[11]: https://github.com/contentful/contentful-management.rb
[12]: https://rubygems.org/gems/contentful-management
[13]: http://www.rubydoc.info/gems/contentful-management/
[14]: https://secure.flickr.com/photos/amira_a/6974761828/in/set-72157629451715908
[15]: https://creativecommons.org/licenses/by/2.0/legalcode
