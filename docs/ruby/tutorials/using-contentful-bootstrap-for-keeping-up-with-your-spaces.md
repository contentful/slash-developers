---
page: :docsContentfulBootstrap
---

This post will walk you through your first steps in using [Contentful Bootstrap][1] to get you jump-started in Contentful.

We will assume that you have basic knowledge of the Command Line Interface and that you have basic understanding of Contentful and Ruby.

We will provide simple steps for doing the following tasks:

* Setup your account from the Command Line
* Create a Space
* Create and use Templates for your Spaces and Entries
* Using your Bootstrap generated Content
* Generate Templates from existing Spaces
* Generate API Access Tokens

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

### Creating an Account via the Command Line

Whenever you run `create_space` or `generate_token` the program will check if you already have Contentful Management API Credentials.
If you don't have them, then you will be asked to create them.

A new browser window will be opened and will try to authenticate you in our [Login System](https://be.contentful.com/login).
If you're not already authenticated, you will be prompted to Log In or Sign Up.

After this, you will be requested permission to create an OAuth token for `contentful_bootstrap` to start creating your Space and Tokens.

### Creating a Space

The most basic use case for `contentful_bootstrap` is to create new Test Spaces.

A Space is a container for your resources, called Entries, and your resource definitions, called Content Types, and can be created by a simple command:

~~~ bash
$ contentful_bootstrap create_space my_first_space
~~~

In this case, the space will be created empty, and you will be provided a URL to access it and manage it.

This simple command also triggers a few other things under the hood, and you will be prompted to decide on them.
You will be offered whether to automatically create Read-Only API keys for our [Content Delivery API][0], and also
if you want to save your credentials in a `~/.contentfulrc` file.

We highly recommend that you do both things as they are really useful, this will be explained in a later section.

#### Using Templates

When creating a Space, in most cases you want to have it pre-populated with content. For that purpose, we offer
the possibility to use Pre-Built templates or using JSON Templates.

##### Pre-Built Templates

For the case of pre-built templates, we have:

* `blog`
* `catalogue`
* `gallery`

Each of these templates come bundled with a few Content Types and Entries.

They are useful for small demos, but do not allow any customization of the content model.
We will cover custom templates in the next section.

To use the pre-built templates use the following command:

~~~ bash
$ contentful_bootstrap create_space my_blog --template blog
~~~

You may replace `blog` for the other two templates.

##### JSON Templates

The real power of `contentful_bootstrap` comes in the form of JSON Templates.
Using this tool along with JSON Templates, you can store blueprints for your Spaces.

A JSON Template is a simplified representation of a Space and all of its contents.

Here I'll show you a very simple example, containing a Content Type with just one Symbol (short text) field and one Entry:

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

### Using your Bootstrap generated Content

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

The `[global]` section will always be present and have only one key containing your CMA API Token.

The following sections will be for each of your Spaces, in the example shown above, you can find the `[simple]` Space created in the previous
section. Each Space section contains two keys, the Read-Only CDA Token and the Space ID.

With this information, you can start using all your Contentful data.

Let's for example use the [CDA Client][5] with the newly generated Space:

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

With this, you can now use your `contentful_bootstrap` generated data. If you want to use [Contentful Management API][4] for managing your content, just make sure to use
the Management Key as explained above.

### Generating Templates from existing Spaces

There will be cases were you might want to make an export of your current Space to have as a blueprint for several cases, for example:

* Creating new Testing or Staging Spaces
* Creating a Demo from existing data
* Version Control your Content outside of Contentful

For those cases, you can use our `generate_json` command:

~~~ bash
$ contentful_bootstrap generate_json -h
Usage: generate_json <space_id> <access_token> [--output-file OUTPUT_PATH]
    -o, --output-file OUTPUT_PATH    Specify Output File
    -h, --help                       Print this message
~~~

With this command, you can generate a JSON Template of your live Spaces, you can optionally automatically export it to a file.

All the files generated can be used as JSON Templates in the `create_space` command.

### Generating Additional API Tokens

There are many cases in which you might want to have separate API Tokens for your Space.

With `contentful_bootstrap` you can create additional tokens by running the following command:

~~~ bash
$ contentful_bootstrap generate_token -h
Usage: generate_token <space_id> [--name TOKEN_NAME] [--config CONFIG_PATH]
    -n, --name TOKEN_NAME            Specify Token Name
    -c, --config CONFIG_PATH         Specify Configuration Path
    -h, --help                       Print this message
~~~

## Conclusion

While not every Field Type is yet supported, you can automate a big part of your Contentful Space creation using `contentful_bootstrap`.
You can keep track of evolving Content Types and create complicated Demo datasets via Templates.

If you want to stay up to date or contribute in the development of `contentful_bootstrap` you can
look in our [GitHub Repository][1] for the latest updates and releases. We're getting new feature updates regularly.

You should also check out how some of our demos use `contentful_bootstrap` for showcasing our
static site generator integrations with [Middleman][2] and [Jekyll][3].

[0]: https://www.contentful.com/developers/docs/references/content-delivery-api/
[1]: https://github.com/contentful/contentful-bootstrap.rb
[2]: https://github.com/contentful/contentful_middleman_examples
[3]: https://github.com/contentful/contentful_jekyll_examples
[4]: https://github.com/contentful/contentful-management.rb
[5]: https://github.com/contentful/contentful.rb
