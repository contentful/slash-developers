---
page: :docsRubyFullStack
---

This guide will walk you through your first steps in using Contentful within your Rails applications.
We will provide simple steps to get your first entries and start using the content you create on Contentful.

## Requirements

* A Heroku account
* Ruby and Git installed
* Basic Command Line Interface, Ruby and Rails knowledge

## Start from a demo application

First we'll start with a [demo project][10], so that you can see it running for yourself.

Run the following commands to get you started.

* Clone the example repository:

```bash
$ git clone https://github.com/contentful/contentful_rails_tutorial.git
```

* Navigate into the repository's directory:

```bash
$ cd contentful_rails_tutorial
```

* Install dependencies:

```bash
$ bundle install
```

* Create and seed the database:

```bash
$ bundle exec rake db:create db:migrate db:seed
```

* Run the server:

```bash
$ bundle exec rails s
```

Everything is now set up. You can new view your data by opening [`http://localhost:3000/contentful_users/1`][11] in your browser

It will look something like this:

![Rails Demo Application](http://i.imgur.com/pR6o4lE.png)

### How to use your own content

You can create your own custom data by following these steps:

* Create an Account in [Contentful][12] or [Log In][13]
* Create a new Space with the `Product` Template
* In the Rails application:
  * Press the `Edit Demo Configuration` button on the top navigation bar
  * Press the `New Contentful Configuration` button and fill in the form with (obtained from [Contentful Web App][13])
    * Configuration name - You can choose how to name it
    * Your newly created Space ID - `Contentful Web App -> APIs -> Content delivery/preview keys -> Website -> Space ID`
    * Production Delivery API Access Token - `Contentful Web App -> APIs -> Content delivery/preview keys -> Website -> Production`
    * Product's Content Type ID - `Contentful Web App -> APIs -> Content model explorer -> Product -> Identifier`
  * Your space will be now displayed on your application

You can then edit your content inside the [Contentful Web App][13] and see the content changed inside your Rails application.

### Deploy the demo to Heroku

To view the demo application live in your own controlled production environment, follow these steps:

* Install Heroku toolbelt (you may skip if you already have it installed):

```bash
$ gem install heroku
```

* Login to Heroku (you may skip if you are already logged in):

```bash
$ heroku login
```

* Create a new instance:

```bash
$ heroku create
```

* Create a Postgres database:

```bash
$ heroku pg
```

* Update the `config/database.yml` file:

Replace `VALUE_OBTAINED_FROM_YOUR_HEROKU_PG_CONFIG` with the database name in your Heroku Dashboard.
To get the name go to: `Heroku Dashboard -> Your instance -> Resources -> Your Postgres instance -> Database name`

* Commit your change:

```bash
$ git add .
$ git commit -m "Update Database Configuration"
```

* Deploy to Heroku:

```bash
$ git push heroku master
```

* Migrate and seed the database:

```bash
$ heroku run env bundle exec rake db:migrate db:seed
```

* Open your application in your browser:

```bash
$ heroku open
```

## Create your own Rails project

Now that you've already seen it in action, you're ready to create your own project.

The first step to get you started is the creation of the Rails application itself.

You can do so by running the following command:

```bash
$ rails init <YOUR_PROJECT_NAME>
```

## Add Contentful to your project dependencies

On your project's `Gemfile`:

```ruby
gem 'contentful'
```

## Decide how to include Contentful

There are many ways to include Contentful on your project, here we will introduce two of the ones that we consider the
simplest. These will get you started to consume content as fast as possible.

### Contentful as a View Helper

If your project uses a single Contentful Space and reuses content accross multiple pages that are not necessarily tied to
your models, you may want to use this approach. It will let you use your Contentful client across your views.

On `app/helpers/application_helper.rb`:

```ruby
def contentful
  @client ||= Contentful::Client.new(
    access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
    space: ENV['CONTENTFUL_SPACE_ID'],
    dynamic_entries: :auto,
    raise_errors: true
  )
end
```

On your views then you can use it like follows:

```erb
<% products = contentful.entries(content_type: ENV['CONTENTFUL_PRODUCT_CT_ID'], include: 2) %>
<% products.each do |product| %>
  <div class="contentful_product">
    <h1><%= product.title %></h1>
    <img src="<%= product.image.first.image_url %>" />
    <p><%= product.description %></p>
    <a href="<%= product.website %>">Buy Now!</a>
  </div>
<% end %>
```

### Contentful as a Concern

If your project uses a single Contentful Space but each model instance is related to a specific Entry in Contentful,
the following approach will allow you to accomplish this.

* Create `app/models/concerns/contentful_renderable.rb`

* On the newly created concern, add the following code:

```ruby
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
```

* Add the fields to your Model:

```bash
$ rails g migration add_contentful_fields_to_<MODEL_NAME> contentful_id:string
```

* Include Concern on your Model:

```ruby
class MyModel < ActiveRecord::Base
  include ContentfulRenderable

  self.space_id = YOUR_SPACE_ID
  self.access_token = YOUR_ACCESS_TOKEN
  self.content_type_id = YOUR_CONTENT_TYPE_ID

  # ... your regular model stuff ...
end
```

* Now you can use it on your views as follows:

Assuming our model is a Product

* For fetching a single entry:

```erb
<% @product.render.tap do |product| %>
  <div class="contentful_product">
    <h1><%= product.title %></h1>
    <img src="<%= product.image.first.image_url %>" />
    <p><%= product.description %></p>
    <a href="<%= product.website %>">Buy Now!</a>
  </div>
<% end %>
```

* For fetching the collection:

```erb
<% Product.render_all.each do |product| %>
  <div class="contentful_product">
    <h1><%= product.title %></h1>
    <img src="<%= product.image.first.image_url %>" />
    <p><%= product.description %></p>
    <a href="<%= product.website %>">Buy Now!</a>
  </div>
<% end %>
```

Using the Concern approach makes each of the instances of your model configurable.
If you want to pull out the configuration to a separate object, you are free to add a `belongs_to` relationship.
That way you can separate your Contentful configuration from your models, this will require some changes on the concern.

## Query data from Contentful

As you might have seen in both previous examples, we're sending parameters to the Entries API endpoint. To learn more about those
parameters, you can look into our [search parameter documentation][7].

## Deploy to Heroku

For seeing your app running in a production environment, we recommend using [Heroku][8] for deploying your applications and services.
To deploy your application simply follow Heroku's [Getting Started with Rails 4.x on Heroku][9] guide, it includes everything you need to know about
running your Rails applications on their platform.

## This is just the beggining

This is a very simple tutorial to get things running, but every project has different needs and we want to provide you
with the best solutions we can.

## Conclusion

With this basic guide, you should be able to start using Contentful within your Rails applications.

You can read about the library in more detail on our [contentful.rb GitHub][1] and take a look at our [Contentful Rails Example Application][10].

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
[8]: https://heroku.com
[9]: https://devcenter.heroku.com/articles/getting-started-with-rails4
[10]: https://github.com/contentful/contentful_rails_tutorial
[11]: http://localhost:3000/contentful_users/1
[12]: https://www.contentful.com/sign-up/#starter
[13]: https://app.contentful.com
