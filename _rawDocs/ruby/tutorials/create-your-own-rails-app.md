---
page: :docsRubyOwnRailsProject
name: Using Contentful with a Ruby on Rails app
title: Using Contentful with a Ruby on Rails app
metainformation: 'This guide shows you how to use Contentful in Rails application created from scratch.'
slug: null
tags:
  - SDKs
  - Ruby
nextsteps: null
---

This guide is a follow up walkthrough to our [Rails getting started tutorial][9]. It will
provide you some guidance onto how to use Contentful within a new Rails Application created
from scratch.

## Create a Rails Application

The first step to get you started is the creation of the Rails application itself.

You can do so by running the following command:

~~~bash
$ rails init <YOUR_PROJECT_NAME>
~~~

## Add Contentful to your project dependencies

On your project's `Gemfile`:

~~~ruby
gem 'contentful'
~~~

## Decide how to include Contentful

There are many ways to include Contentful on your project, here we will introduce two of the ones that we consider the
simplest. These will get you started to consume content as fast as possible.

### Contentful as a View Helper

If your project uses a single Contentful Space and reuses content across multiple pages that are not necessarily tied to
your models, you may want to use this approach. It will let you use your Contentful client across your views.

On `app/helpers/application_helper.rb`:

~~~ruby
def contentful
  @client ||= Contentful::Client.new(
    access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
    space: ENV['CONTENTFUL_SPACE_ID'],
    dynamic_entries: :auto,
    raise_errors: true
  )
end
~~~

On your views then you can use it like follows:

~~~erb
<% products = contentful.entries(content_type: ENV['CONTENTFUL_PRODUCT_CT_ID'], include: 2) %>
<% products.each do |product| %>
  <div class="contentful_product">
    <h1><%= product.title %></h1>
    <img src="<%= product.image.first.image_url %>" />
    <p><%= product.description %></p>
    <a href="<%= product.website %>">Buy Now!</a>
  </div>
<% end %>
~~~

### Contentful as a Concern

If your project uses a single Contentful Space but each model instance is related to a specific Entry in Contentful,
the following approach will allow you to accomplish this.

* Create `app/models/concerns/contentful_renderable.rb`

* On the newly created concern, add the following code:

~~~ruby
module ContentfulRenderable
  extend ActiveSupport::Concern

  def self.included(base)
    base.extend(ClassMethods)
  end

  # Overridable
  # Override this method to change the parameters set for your Contentful query on each specific model
  # For more information on queries you can look into: https://www.contentful.com/developers/docs/references/content-delivery-api/#/reference/search-parameters
  def render
    self.class.client.entries(content_type: self.class.content_type_id, include: 2, "sys.id" => contentful_id).first
  end

  module ClassMethods
    def client
      @client ||= Contentful::Client.new(
        access_token: access_token,
        space: space_id,
        dynamic_entries: :auto,
        raise_errors: true
      )
    end

    # Overridable
    # Override this method to change the parameters set for your Contentful query on each specific model
    # For more information on queries you can look into: https://www.contentful.com/developers/docs/references/content-delivery-api/#/reference/search-parameters
    def render_all
      client.entries(content_type: content_type_id, include: 2)
    end
  end
end
~~~

* Add the fields to your Model:

~~~bash
$ rails g migration add_contentful_fields_to_<MODEL_NAME> contentful_id:string
~~~

* Include Concern on your Model:

~~~ruby
class MyModel < ActiveRecord::Base
  include ContentfulRenderable

  self.space_id = YOUR_SPACE_ID
  self.access_token = YOUR_ACCESS_TOKEN
  self.content_type_id = YOUR_CONTENT_TYPE_ID

  # ... your regular model stuff ...
end
~~~

* Now you can use it on your views as follows:

Assuming our model is a Product

* For fetching a single entry:

~~~erb
<% @product.render.tap do |product| %>
  <div class="contentful_product">
    <h1><%= product.title %></h1>
    <img src="<%= product.image.first.image_url %>" />
    <p><%= product.description %></p>
    <a href="<%= product.website %>">Buy Now!</a>
  </div>
<% end %>
~~~

* For fetching the collection:

~~~erb
<% Product.render_all.each do |product| %>
  <div class="contentful_product">
    <h1><%= product.title %></h1>
    <img src="<%= product.image.first.image_url %>" />
    <p><%= product.description %></p>
    <a href="<%= product.website %>">Buy Now!</a>
  </div>
<% end %>
~~~

Using the Concern approach makes each of the instances of your model configurable.
If you want to pull out the configuration to a separate object, you are free to add a `belongs_to` relationship.
That way you can separate your Contentful configuration from your models, this will require some changes on the concern.

## Query data from Contentful

As you might have seen in both previous examples, we're sending parameters to the Entries API endpoint. To learn more about those
parameters, you can look into our [search parameter documentation][7].

## Conclusion

With this basic guide, you should be able to start using Contentful within your Rails applications.

For learning how to create complete Rails applications we recommend the official [Rails Getting Started Tutorial][10].

You can read about the Contentful CDA library in more detail on our [contentful.rb GitHub][1] or our [Getting Started with CDA SDK tutorial][15] and take a look at our [Contentful Rails Example Application][8].

Also check our Rails integration libraries [`contentful_model`][2] and [`contentful_rails`][3], which provide a more Rails-like
approach to create Contentful based applications.

Do you like building static sites? Maybe you want to check how to build static sites using Contentful with [Middleman][4] or [Jekyll][5].

In case you you want to set up your new spaces via the command line we also provide [Contentful Bootstrap][6].

[1]: https://github.com/contentful/contentful.rb
[2]: https://github.com/contentful/contentful_model
[3]: https://github.com/contentful/contentful_rails
[4]: https://github.com/contentful/contentful_middleman_examples
[5]: https://github.com/contentful/contentful_jekyll_examples
[6]: https://github.com/contentful/contentful-bootstrap.rb
[7]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[8]: https://github.com/contentful/contentful_rails_tutorial
[9]: /developers/docs/ruby/tutorials/full-stack-getting-started/
[10]: /developers/docs/ruby/tutorials/getting-started-with-contentful-and-ruby/
