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

## Conclusion

This is a very simple tutorial to get things running, but every project has different needs and we want to provide you
with the best solutions we can.

With this basic guide, you should be able to start using Contentful within your Rails applications.

You can read about the Contentful CDA library in more detail on our [contentful.rb GitHub][1] or our [Getting Started with CDA SDK tutorial][15] and take a look at our [Contentful Rails Example Application][10].

Now that you've already seen it in action, you're ready to create your own project. Create your own Rails project by following this [tutorial][14].

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
[14]: /developers/docs/ruby/tutorials/create-your-own-rails-app/
[15]: /developer/docs/ruby/tutorials/getting-started-with-contentful-and-ruby/
