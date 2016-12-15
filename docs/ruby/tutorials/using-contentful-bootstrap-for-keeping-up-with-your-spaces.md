---
page: :docsContentfulBootstrap
name: Contentful Bootstrap
title: Contentful Bootstrap
metainformation: 'This tutorial will walk you through your first steps in using Contentful Bootstrap to get you jump-started in Contentful.'
slug: null
tags:
  - Workflow
  - Ruby
nextsteps:
  - text: Create and deploy a Ruby application with Contentful
    link: /developers/docs/ruby/tutorials/full-stack-getting-started/
---

This post will walk you through your first steps in using [Contentful Bootstrap][1] to get you jump-started in Contentful.

We will assume that you have basic knowledge of the command line interface and that you have basic understanding of Contentful and Ruby.

We will provide simple steps for doing the following tasks:

* Setup your account from the command line
* Create a space
* Create and use templates for your spaces and entries
* Using your bootstrap generated content
* Generate templates from existing spaces
* Generate API tokens

## Installation

First, you need to install our `contentful_bootstrap` gem. You can do it either manually on the console:

~~~ bash
$ gem install contentful_bootstrap
~~~

Or you can add it inside your `Gemfile`:

~~~ ruby
gem 'contentful_bootstrap'
~~~

Once in your `Gemfile`, running `bundle install` will install the gem and all its dependencies.

## Using Contentful Bootstrap

Once you have `contentful_bootstrap` installed. You can check the following command:

~~~ bash
$ contentful_bootstrap -h
Usage: contentful_bootstrap <command> <space_name> [options]

    Available commands are:
        create_space
        generate_json
        generate_token
~~~

There you have all the available commands:

* `create_space`
* `generate_json`
* `generate_token`

If you want to, and I leave this as an exercise to the reader, you can look for the help of each individual command.

We will now proceed to explain some of their use cases.

### Creating an account via the command line

Whenever you run `create_space` or `generate_token` the program will check if you already have credentials for the Content Management API.
If you don't have them, then you will be asked to create them.

A new browser window will be opened and will try to authenticate you in our [login system](https://be.contentful.com/login).
If you're not already authenticated, you will be prompted to log in or sign up.

After this, you will be requested permission to create an OAuth token for `contentful_bootstrap` to start creating your space and tokens.

### Creating a space

The most basic use case for `contentful_bootstrap` is to create new test spaces.

A space is a container for your resources, called entries, and your resource definitions, called content types, and can be created by a simple command:

~~~ bash
$ contentful_bootstrap create_space my_first_space
~~~

In this case, the space will be created empty, and you will be provided a URL to access it and manage it.

This simple command also triggers a few other things under the hood, and you will be prompted to decide on them.
You will be offered whether to automatically create read-only API keys for our [Content Delivery API][0], and also
if you want to save your credentials in a `~/.contentfulrc` file.

We highly recommend that you do both things as they are really useful, this will be explained in a later section.

#### Using templates

When creating a space, in most cases you want to have it pre-populated with content. For that purpose, we offer
the possibility to use pre-built templates or using JSON templates.

##### Pre-built templates

For the case of pre-built templates, we have:

* `blog`
* `catalogue`
* `gallery`

Each of these templates come bundled with a few content types and entries.

They are useful for small demos, but do not allow any customization of the content model.
We will cover custom templates in the next section.

To use the pre-built templates use the following command:

~~~ bash
$ contentful_bootstrap create_space my_blog --template blog
~~~

You may replace `blog` for the other two templates.

##### JSON templates

The real power of `contentful_bootstrap` comes in the form of JSON templates.
Using this tool along with JSON templates, you can store blueprints for your spaces.

A JSON template is a simplified representation of a space and all of its contents.

Here I'll show you a very simple example, containing a content type with just one symbol (short text) field and one entry:

~~~ json
{
  "version": 3,
  "content_types": {
    "id": "simple",
    "name": "Simple",
    "displayField": "myText",
    "fields": [
      {
        "id": "myText",
        "name": "My Text",
        "type": "Symbol"
      }
    ]
  },
  "entries": {
    "simple": [
      {
        "sys": {
          "id": "my_entry"
        },
        "fields": {
          "myText": "some fancy text"
        }
      }
    ]
  },
  "assets": []
}
~~~

After saving this template to a file named `templates/simple.json` you can call the bootstrap command as follows:

~~~ bash
$ contentful_bootstrap create_space simple --json-template templates/simple.json
~~~

### Using your Bootstrap generated content

Now that your content has been created, your tokens ready to use and saved into `~/.contentfulrc`, we can start consuming it.

But first, let's dissect the contents of `~/.contentfulrc`

~~~ ini
[global]
CONTENTFUL_MANAGEMENT_ACCESS_TOKEN = 2a105ed1e85eabcabcabcccc123543bca2a22da3e2043087654e1facf31d84c507344

[simple]
CONTENTFUL_DELIVERY_ACCESS_TOKEN = d65077d23de1bb749012345676bbc1fea5b00acbdef123d278f8ab7aa123eded
SPACE_ID = wbpasdkseprz
~~~

The content of this file is an `.ini` formatted file. You will find only one or multiple sections, depending on how many spaces you've created
through `contentful_bootstrap`.

The `[global]` section will always be present and have only one key containing your CMA API key.

The following sections will be for each of your spaces, in the example shown above, you can find the `[simple]` space created in the previous
section. Each space section contains two keys, the read-only CDA key and the space ID.

With this information, you can start using all your Contentful data.

Let's for example use the [CDA Client][5] with the newly generated space:

~~~ ruby
require 'contentful'
require 'inifile'

simple_config = IniFile.load(File.join(ENV['HOME'], '.contentfulrc'))['simple']

client = Contentful::Client.new(
  access_token: simple_config['CONTENTFUL_DELIVERY_ACCESS_TOKEN'],
  space: simple_config['SPACE_ID'],
  dynamic_entries: :auto
)

client.entries.first.my_text
# => "some fancy text"
~~~

With this, you can now use your `contentful_bootstrap` generated data. If you want to use the [Content Management API][4] for managing your content, just make sure to use
the CMA key as explained above.

### Generating templates from existing spaces

There will be cases were you might want to make an export of your current space to have as a blueprint for several cases, for example:

* Creating new testing or staging spaces
* Creating a demo from existing data
* Version control your content outside of Contentful

For those cases, you can use our `generate_json` command:

~~~ bash
$ contentful_bootstrap generate_json -h
Usage: generate_json <space_id> <access_token> [--output-file OUTPUT_PATH]
    -o, --output-file OUTPUT_PATH    Specify Output File
    -h, --help                       Print this message
~~~

With this command, you can generate a JSON template of your live spaces, you can optionally automatically export it to a file.

All the files generated can be used as JSON templates in the `create_space` command.

### Generating additional API tokens

There are many cases in which you might want to have separate API tokens for your space.

With `contentful_bootstrap` you can create additional tokens by running the following command:

~~~ bash
$ contentful_bootstrap generate_token -h
Usage: generate_token <space_id> [--name TOKEN_NAME] [--config CONFIG_PATH]
    -n, --name TOKEN_NAME            Specify token name
    -c, --config CONFIG_PATH         Specify configuration path
    -h, --help                       Print this message
~~~

## Conclusion

While not every field type is yet supported, you can automate a big part of your Contentful space creation using `contentful_bootstrap`.
You can keep track of evolving content types and create complicated demo datasets via templates.

If you want to stay up to date or contribute in the development of `contentful_bootstrap` you can
look in our [GitHub Repository][1] for the latest updates and releases. We're getting new feature updates regularly.

You should also check out how some of our demos use `contentful_bootstrap` for showcasing our
static site generator integrations with [Middleman][2] and [Jekyll][3].

[0]: /developers/docs/references/content-delivery-api/
[1]: https://github.com/contentful/contentful-bootstrap.rb
[2]: https://github.com/contentful/contentful_middleman_examples
[3]: https://github.com/contentful/contentful_jekyll_examples
[4]: https://github.com/contentful/contentful-management.rb
[5]: https://github.com/contentful/contentful.rb
