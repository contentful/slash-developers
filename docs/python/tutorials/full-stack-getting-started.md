---
page: :docsPythonFullStack
name: Getting Started with Contentful
title: Getting Started with Contentful
metainformation: 'This guide will walk you through your first steps using Contentful within a Rails application.'
slug: null
tags:
  - SDKs
  - Python
  - Django
nextsteps:
  - text: The Contentful Management API reference
    link: /developers/docs/references/content-management-api/
  - text: The Contentful Delivery API reference
    link: /developers/docs/references/content-delivery-api/
---

This guide will walk you through your first steps using Contentful within a Django application. It will provide a step-by-step guide on how to get your first entries and start using the content you create on Contentful.

## Requirements

- A [Heroku][7] account
- Python 2.7+ or 3.3+
- [Git][5] installed
- Basic Command Line Interface, Python and Django knowledge

{: .note}
**Note:** During this guide we'll assume that you're running inside a `virtualenv`. If not, append `sudo` when installing dependencies if you are using system-provided Python.

Optionally:

- Ruby 1.9+ for running `contentful-bootstrap` to create your own space with the provided template

## Start from a demo application

First we'll start with a [demo project][2], which is a simple Django application using a basic Blog template, so that you can see it running for yourself.

Run the following commands to get started.

- Clone the example repository:

~~~bash
git clone https://github.com/contentful/contentful_django_tutorial.git
~~~

- Navigate into the repository's directory:

~~~bash
cd contentful_django_tutorial
~~~

- Install dependencies:

~~~bash
pip install -r requirements.txt
~~~

- *Optional* Create your space using Contentful Bootstrap:

{: .note}
**Note**: If skipped, the example will use a read-only space that's already provided for you.

~~~bash
bundle install
bundle exec contentful_bootstrap create_space django_demo -j bootstrap/template.json
~~~

After following the steps, the tool will provide you with a Space ID and Access Token. Then run the following commands replacing the values where they correspond:

~~~bash
export CTF_SPACE_ID=YOUR_SPACE_ID
export CTF_DELIVERY_KEY=YOUR_ACCESS_TOKEN
~~~

It should look something like this:

![Bootstrap Tool Output](https://i.imgur.com/RkmNaes.png)

This will allow the application to use your own space, allowing you to edit content and allowing you to see your application changing. You can edit content freely in our [Web App][3].

- Run the application:

~~~bash
python manage.py runserver
~~~

Everything is now set up. You can view your space by opening _http://localhost:8000_ in your browser.

It should look something like this:

![Django Demo Application](https://i.imgur.com/Zmum6k4.png)

### Deploy the demo to Heroku

To view the demo application live in your own production environment, follow these steps:

- Install the [Heroku toolbelt](https://devcenter.heroku.com/articles/heroku-cli#download-and-install) if you don't already have it.
- Login to Heroku if you're not already:

~~~bash
heroku login
~~~

- Create a new instance:

~~~bash
heroku create
~~~

- Set Python Buildpack:

~~~bash
heroku buildpacks:set heroku/python
~~~

- Deploy to Heroku:

~~~bash
git push heroku master
~~~

- *Optional* Add your personalized credentials to your Heroku Instance:

  1. Open [Heroku](https://dashboard.heroku.com)
  2. Go to your application
  3. Go to Settings
  4. Press _Reveal Config Vars_
  5. Add `CTF_SPACE_ID` and `CTF_DELIVERY_KEY` with their respective values
  6. Go to Resources and restart your application

- Open the application in your browser:

~~~bash
heroku open
~~~

## Next Steps

After this guide, you should be able to start using Contentful with your Django applications, but every project has different needs and we want to provide you with the best solutions we can.

You can read about the Contentful CDA library in more detail on our [contentful.py GitHub][1] or our [Getting Started with CDA SDK tutorial][4], we also suggest taking a look at our [Contentful Django Example Application][2].

If you want to set up new spaces via the command line we also provide [Contentful Bootstrap][6].

[1]: https://github.com/contentful/contentful.py
[2]: https://github.com/contentful/contentful_django_tutorial
[3]: https://app.contentful.com
[4]: /developers/docs/python/tutorials/getting-started-with-contentful-and-python/
[5]: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
[6]: https://github.com/contentful/contentful-bootstrap.rb
[7]: https://www.heroku.com
