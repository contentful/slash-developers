---
page: :docsExpressjsApp
name: Creating an Express JavaScript application with Contentful
title: Creating an Express JavaScript application with Contentful
metainformation: 'This guide will walk you through your first steps using Contentful with an Express Node.js application.'
slug: null
tags:
  - JavaScript
  - SDKs
nextsteps:
  - text: Using the Contentful Delivery API in a JavaScript app
    link: /developers/docs/javascript/tutorials/using-js-cda-sdk/
  - text: Explore the Contentful JavaScript SDKs
    link: https://github.com/contentful/contentful.js
  - text: Try the product catalogue example application
    link: https://github.com/contentful/product-catalogue-js
---

This guide will walk you through your first steps using Contentful with an Express Node.js application. It will provide a step-by-step guide on how to get your first entries and start using your content.

## Requirements

-   A [Heroku][1] account
-   [Heroku CLI][14] installed
-   [Node.js][2] 6.2.1 installed
-   Npm 3.10.7 which you should install with `Node.js`
-   [Git][12] installed
-   Basic command line knowledge

## Try the final project

Click the button below to deploy the final project to Heroku and see how it works.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/contentful/contentful_express_tutorial)

## Start from a demo application

Start with a [demo project][3], which is a simple Express.js application using Contentful's 'Product Catalogue' template, you can see it running for yourself.

Run the following command to clone the example repository:

~~~bash
git clone https://github.com/contentful/contentful_express_tutorial.git
~~~

Navigate into the repository directory:

~~~bash
cd contentful_express_tutorial
~~~

Install dependencies:

~~~bash
npm install
~~~

Run the server:

~~~bash
npm run dev
~~~

You can now view the application by opening _http://localhost:3000_ in your browser. It should look something like this:

![Express js Demo Application](https://images.contentful.com/tz3n7fnw4ujc/7s7GMqTvSoE08m8YIQUaaI/31a7f52e6d80ed4ea4f8f31ffd313ff4/default_website.png)

### Using your own content

You can create your own custom data by following these steps:

-   Create an account with [Contentful][6] or [Log In][5].
-   Create a new Space with the 'Product Catalogue' template, name it whatever you like.
-   Copy the space Id and API key as shown in the screenshot

![Keys Page](https://images.contentful.com/tz3n7fnw4ujc/674J5NCI5amOyoaskCuOG4/115aa2814fa889462e430de498956196/keys_and_ids.png)

In the Express js application:

-   Open the _package.json_ file, change `accessToken` and `space` in the `config` section to your own values, and save.
-   run `npm run dev` to start the server.
-   Your space will be now displayed in your application.

Next in the _[Contentful web app][6] -> Content_ menu:

-   Open the product called 'Playsam Streamliner Classic Car, Espresso'.
-   Change the value of the _Product name_ field to a new value,
-   Click the _Publish changes_ button
-   Wait for the changes to propagate to the CDN.
-   Reload the Express.js application and you will see the new product name.

You can continue to edit your content inside the [Contentful web app][13] and see the content change inside your application.

### Deploy the demo to Heroku

To view the demo application live in your own production environment, follow these steps:

Install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli), and login to Heroku if you're not already:

~~~bash
heroku login
~~~

Create a new instance:

~~~bash
heroku create
~~~

Commit your change:

~~~bash
git add .
git commit -m "Add Website"
~~~

Deploy to Heroku:

~~~bash
git push heroku master
~~~

Open the application in your browser:

~~~bash
heroku open
~~~

[1]: https://www.heroku.com

[10]: https://github.com/contentful/product-catalogue-js

[11]: https://github.com/contentful-labs/contentful-metalsmith-example

[12]: https://git-scm.com/downloads

[14]: https://devcenter.heroku.com/articles/heroku-cli#download-and-install

[2]: https://nodejs.org

[3]: https://github.com/contentful/contentful_express_tutorial

[5]: /sign-up/#starter

[6]: https://app.contentful.com

[7]: /developers/docs/references/content-delivery-api/#/reference/search-parameters

[8]: https://github.com/contentful/contentful.js

[9]: /developers/docs/javascript/tutorials/using-js-cda-sdk/
