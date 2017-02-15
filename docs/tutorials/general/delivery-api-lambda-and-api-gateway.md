---
page: :docsExtendingDeliveryApi
name: Extending the Content Delivery API
title: Extending the Content Delivery API with AWS Lambda & API Gateway
metainformation: 'This tutorial will show you how you can use Amazon Lambda and API Gateway with our Content Delivery API.'
slug: null
tags:
  - Workflow
nextsteps: null
---

When using 3rd-party API's sometimes you want (or need) additional functionality on top of what the API provides. Previously your only options were to complicate your API client, or run your own API (often referred to as API orchestration) on your own servers. This tutorial will show you how you can use two new Amazon services, [Lambda][] and [API Gateway][], to provide additional functionality on top of Contentful's [Content Delivery API][cda-description] without running any of your own infrastructure.

Lambda is a new service from Amazon that runs your code in response to various events, and API Gateway is a service for managing HTTP endpoints that can send events to Lambda.

Along with the Content Delivery API these form an extremely powerful combination: with a small amount of code you can customize the API however you like, without maintaining any servers yourself. For example, one could create a Lambda function that combines related entities into a single one, removes sensitive or unnecessary data, renders HTML pages or even integrates data from completely different APIs.

## What we will do

We will keep things simple in this tutorial and implement a straightforward transformation of Contentful entries: converting markdown in `Text` fields to HTML.

In order to demonstrate our new API, we have created [this simple page][demo-page] that displays this tutorial as HTML.

Because our API Gateway is a drop-in replacement for the `/spaces/{id}/entries` [endpoint][docs-entries-endpoint] endpoint of the Content Delivery API, we were able to use the official [contentful.js][] SDK to retrieve the content, and display the HTML result with just a few lines of JavaScript.

You can also check the [other languages][languages] we offer SDKs for.

### Tutorial steps:

- Creating the lambda function
  - Get the code
  - Create a zip file
  - Upload the zip file in the AWS Console
  - Test our lambda function
- Create an API Gateway endpoint
- Test the API endpoint.


## 1. Creating the Lambda function

The [official lambda documentation][lambda-docs] starts you off with pasting some JavaScript code into a web-based editor. While this is good enough for "hello world", we want to deploy code with packages from npm in `node_modules`, so we need to upload a zip file of our code instead.

### Get the code

The code for our lambda is [available on GitHub][project-repository]. You can clone the repository to your machine with the following command:

~~~ bash
git clone git@github.com:contentful-labs/markdown-to-html-lambda
cd markdown-to-html-lambda
ls
~~~

You should see two directories and a `Makefile` here. The `lambda` directory contains the code we will package and deploy to AWS Lambda, while the `deploy` directory contains a script to automate deployment of the code and and API gateway.

{:.note}
**Note:** We'll use the automated deployment later, but if you want to skip ahead you can just run `make deploy`.

### Create a zip file

In the project directory (the one containing `Makefile`) run `make lambda.zip`

### Upload the zip file

1. Sign in to the [AWS Console][]
2. Select "Lambda" from the "Services" section of the top menu.
3. Select "Create a Lambda function"

When asked to select a blueprint, select the "hello-world" blueprint.

On the next screen:

1. Name the new function "contentful-md-to-html"
2. Make sure the "Node.js" runtime is selected
3. Choose the option to upload a zip file, then upload the file created in step 1.2.
4. Leave the "Handler" input set to its default value of `index.handler`.
5. In the "Role" dropdown, select "New Role > Basic execution role". This will pop up a new window where you must confirm the creation of the role.
6. Finally, click "Next" and "Create function" after reviewing the settings.

### Test the lambda function

Now that we've created a lambda function we can easily test it by clicking on the "Test" button. The first time you test a function you will be asked to supply a test JSON object. Our handler will receive this object in its `event` argument.

Recalling that our handler function uses `event.query` to pass  [filter query parameters][docs-query-params] to the Content Delivery API, replace the example payload with the one below:

~~~ json
{
  "spaceId": "oqp9lwuwktba",
  "authorization": "Bearer baba02224a4b6490faa4fff4785d5c9d655ffdfd75b91c617344ed24619b837f",
  "query": "{content_type=2jGJdAHwneiQ6SEkUu0cWu, order=sys.createdAt}"
}
~~~

{:.note}
**Note:** The strange format for query parameters matches what our Lambda will receive from API Gateway.

After clicking "Submit", you should see a response like the following:

~~~ json
{
  "sys": {
    "type": "Array"
  },
  "total": 1,
  "skip": 0,
  "limit": 100,
  "items": [
    {
      "sys": {
        /** Sys properties **/
      },
      "fields": {
        "title": "Extending Contentful API's with API Gateway",
        "body": "<p>This tutorial will show you how you can ...",
        "author": "Stephen Sugden",
        "tags": [
          "AWS",
          "API Gateway"
        ]
      }
    }
  ]
}
~~~

As you can see, we have a normal Contentful response, but the markdown content of the `fields.body` property has been transformed to HTML.

## Create an API

While it's possible to call Lambda functions directly over HTTP by sending a signed `PUT` request to the Lambda service endpoint, we're going to go a bit further and create an [API Gateway][] to more easily query the entries in our space. This API gateway will mimic the URL structure of the Content Delivery API so that we can query it directly with any of the [official SDKs][sdks].

The web UI for API gateway is a bit cumbersome, so at this point we're going to use the scripts in our `deploy` directory to take care of the rest.

{:.note}
**Note:** These scripts assume that you have correctly configured your AWS credentials using the official `aws` command line interface. If you haven't yet done so, please follow [these directions][aws-setup] to install and configure the AWS CLI.

### Deploying the API

In the project root, simply run `make AWS_ACCOUNT_ID=111111 deploy` (replacing "111111" with your actual AWS account ID). You should see output something like the following:

~~~
Created lambda function cf-md-to-html
Created API cf-md-to-html
Created Resource /{spaceId}/entries
Created Method GET /{spaceId}/entries
Granting invoke permission to arn:aws:execute-api:eu-west-1:718539334177:xfdge7afx6/*/GET/*/entries
Deployed https://jjs7c3mvxj.execute-api.eu-west-1.amazonaws.com/spaces/{spaceId}/entries
~~~

{:.note}
**Note:** If you see an error like `TimeoutError: Missing credentials in config` you need to [install and configure the AWS CLI][aws-setup].

Now you can go ahead and query your new API Gateway exactly as though it were the Content Delivery API. For example, let's query it for this tutorial:

~~~ bash
curl 'https://jjs7c3mvxj.execute-api.eu-west-1.amazonaws.com/spaces/oqp9lwuwktba/entries?sys.id=1XhtUhV2sc6kIMo6GMgACU&access_token=baba02224a4b6490faa4fff4785d5c9d655ffdfd75b91c617344ed24619b837f'
~~~

The output will be the JSON entry for this tutorial, with `fields.body` formatted as HTML.

Now we can use the Contentful API even more easily in our client-side apps. For example [the demo page][demo-page] mentioned earlier is rendered using the following 15 lines of JavaScript:

~~~ javascript
var client = contentful.createClient({
  host: 'jjs7c3mvxj.execute-api.eu-west-1.amazonaws.com',
  space: 'oqp9lwuwktba',
  accessToken: 'baba02224a4b6490faa4fff4785d5c9d655ffdfd75b91c617344ed24619b837f'
})

var ContentTypes = { Tutorial: '2jGJdAHwneiQ6SEkUu0cWu' }

client.entries({ content_type: ContentTypes.Tutorial }).then(function (tutorials) {
  document.body.innerHTML = tutorials.map(function (t) {
    return '<article><h1>' + t.fields.title + '</h1>' + t.fields.body + '</article>'
  }).join('\n')
}).catch(function (error) {
  var pre = document.createElement('pre')
  pre.innerText = error.stack
  document.body.appendChild(pre)
})
~~~

## 3. Review

Now we have shown you how to:

1. Create a Lambda function that uses the Content Delivery API.
2. Deploy that function.
3. Expose that Lambda function to your client-side apps with API Gateway.
4. Layer any functionality you want on our API.

One can easily imagine going a bit further than this example and create an API gateway that renders full HTML pages using predefined templates. By combining this with CloudFront integration you can have an extremely scalable page-delivery mechanism without administering a single server. One could even combine data from multiple sources, the only limit is yourself.

<!-- much links -->
[Lambda]: https://aws.amazon.com/lambda/
[API Gateway]: https://aws.amazon.com/api-gateway/
[AWS Console]: https://console.aws.amazon.com/
[aws-setup]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
[lambda-docs]: https://aws.amazon.com/documentation/lambda/

[project-repository]: https://github.com/contentful-labs/md-to-html-lambda
[demo-page]: https://contentful-labs.github.io/md-to-html-lambda/

[contentful.js]: https://github.com/contentful/contentful.js
[languages]: /developers/docs/#libraries
[cda-description]: /developers/docs/concepts/apis/#content-delivery-api
[docs-entries-endpoint]: /developers/docs/references/content-delivery-api/#/reference/entries/entries-collection
[docs-query-params]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[contentful-resource-transform]: https://github.com/contentful/contentful-resource-transform

[marked]: https://github.com/chjj/marked
