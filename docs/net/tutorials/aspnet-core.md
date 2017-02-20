---
page: :docsAspNetCore
name: Building ASP.NET core applications with Contentful
title: Building ASP.NET core applications with Contentful
metainformation: This article details how to build Asp.Net core applications with the Contentful .NET SDK.
slug: null
tags:
  - SDKs
  - .NET
nextsteps:
  - text: Explore the .NET SDK GitHub repository
    link: https://github.com/contentful/contentful.net
---

This tutorial will show you how to setup the Contentful SDK for your ASP.NET core application and how to access your
content.

## Pre-requisites

This tutorial assumes you understand the basic Contentful data model as described in the [developer center](/developers/docs/concepts/data-model/) and that you have already read and understand the [getting started tutorial for the .Net SDK](/developers/docs/net/tutorials/using-net-cda-sdk/).

Contentful.net is built on .net core and targets .Net Standard 1.4. The SDK is cross-platform and runs on Linux, macOS and Windows.

## Installation

Add the package to your ASP.NET core solution using the NuGet package manager by running the following command in your NuGet package manager console.

~~~csharp
Install-Package contentful.aspnetcore -prerelease
~~~

Note that this package in turn references the core SDK `contentful.csharp` but includes a number of features specifically for ASP.NET core.

## Configuration

The Contentful.AspNetCore package implements [the options pattern](https://docs.asp.net/en/latest/fundamentals/configuration.html#options-config-objects) and
the simplest way to configure your space id and access token is by using `appsettings.json`. Simply add a section similar to this but replace with your own
values.

~~~json
"ContentfulOptions": {
    "DeliveryApiKey": "<content_delivery_api_key>",
    "ManagementApiKey": "<content_management_api_key>",
    "SpaceId": "<space_id>",
    "UsePreviewApi": false,
    "MaxNumberOfRateLimitRetries": 0
  }
~~~

Also bear in mind that each separate option can be overriden by environment specific configs, environment variables or by any other 
`Microsoft.Extensions.Configuration.IConfigurationSource`. You can even implement your own.

## Register services

The next step is to register the services that will use the configuration settings. This is done in your `Startup.cs` class. Just add a using statement for 
`Contentful.AspNetCore` and in you `ConfigureServices` method add the following line.

~~~csharp
services.AddContentful(Configuration);
~~~

Note how you must pass in your configuration object to let the services read from you application settings.

This will now wire everything up and make sure the required services to retrieve content from Contentful are available.

## Your first request

Once everything is configured as specified above you can now leverage the dependency injection of your ASP.NET core application to retrieve your `IContentfulClient` or
`IContentfulManagementClient` in your classes. Here's a simple example for a controller.

~~~csharp
public class SampleController : Controller {
    private readonly IContentfulClient _client;

    public SampleController(IContentfulClient client) 
    {
        _client = client;
    }
}
~~~

By using constructor injection we can automatically retrieve an instance of `IContentfulClient`. This can then be used in our actions to retrieve content.

~~~csharp
public async Task<IActionResult> Index() {
    var entries = _client.GetEntriesAsync<Entry<dynamic>>();
}
~~~

You can of course use your own models instead of relying on the `Entry<T>` class.

~~~csharp
public async Task<IActionResult> Index() {
    var products = _client.GetEntriesAsync<Product>();
}
~~~

For more information about how to retrieve content using the `IContentfulClient` and `IContentfulManagementClient` refer to our [CDA tutorial](/developers/docs/net/tutorials/using-net-cda-sdk/) and 
[CMA tutorial](/developers/docs/net/tutorials/management-api/) respectively.

## Working with assets and the image API

A new feature of ASP.NET core are [taghelpers](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/tag-helpers/intro). In the ASP.NET core SDK there are two
taghelpers that you can use when working with assets.

If you have an asset in Contentful and wish to output an anchor tag to that asset you can use the `ContentfulAssetTagHelper`. On your anchor tag simply add 
an `asset-id` attribute and it will automatically be retrieved from Contentful and added to the `href` attribute.

~~~html
<a asset-id="<asset_id">link to asset</a>
~~~

If you wish to retrieve the asset in a specific locale you can add the `locale` attribute.

~~~html
<a asset-id="<asset_id" locale="sv-SE">link to Swedish asset</a>
~~~

If the asset is an image you probably want to output an `img` tag instead of an anchor. For that purpose, use the `ContentfulImageTageHelper`.

~~~html
<contentful-image asset-id="<asset_id>" />
~~~

If you have the url to the image already available you can save yourself a request by using the url property instead.

~~~html
<contentful-image url="<image_asset_url>" />
~~~

There are a number of other attributes you can set that will use the [Contentful Image API](/developers/docs/concepts/images/) in the background.

~~~html
<contentful-image url="<image_asset_url>" width="50" height="50" format="Png" resize-behaviour="Pad" background-color="#cc0000" image-focus-area="Face" corner-radius="10" />
~~~

These all correspond to similar values in our image API and will make sure that the `src` attribute of the `img` is set correctly.

The `width` and `height` attributes will of course set the width and height of the image and resize it accordingly.

The `format` attribute lets you select if you wish your image to be of a specific format, available values are `Png`, `Jpg` or `Webp`.

The `resize-behaviour` attribute lets you specify how the image should be resized in order to fit in the constraints of the width and height. Available values are
`Pad`, `Crop`, `Fill`, `Thumb` and `Scale`.

The `background-color` attribute lets you specify what color the padding of the image should be when using the `Pad` resize-behaviour. You can specify your value in using
rgb or hash-notation. For example `rgb:000080` or `#000080`.

The `image-focus-area` attribute lets you specify which part of an image to focus on when doing resizing. Available values are `Top`, `Left`, `Right`, `Bottom`,
`Top_Right`, `Top_Left`, `Bottom_Right`, `Bottom_Left`, `Face` or `Faces`.

The `corner-radius` allows you to round the corner of the image by the specified radius.

There are also two attributes specifically for jpg-images.

~~~html
<contentful-image url="<image_asset_url>" jpg-quality="50" progressive-jpg="True" />
~~~

The `jpg-quality` attribute lets you specify a number between 0 and 100 that corresponds to the quality of the outputted jpg image.

The `progressive-jpg` attribute lets you specify whether to use progressive jpgs or not.

The output from an `contentful-image` will be a regular `img` tag and every attribute added to it that is not part of the taghelper will be retained. 
This means that you can for example specify an alt-text or class directly on the taghelper and the outputted image will keep it.

~~~html
<contentful-image url="<image_asset_url>" width="50" height="50" alt="Some alt text" class="custom-class" />
~~~

## Working with webhooks and middleware

Webhooks offer a clean and simple way to let Contentful notify your application when something occurrs with your content. A simple approach to set a webhook up
would be to create a controller with an action and let Contentful call that action when something occurrs.

~~~csharp
public class WebHookController : Controller {

    [HttpPost]
    public IActionResult Consumer(Entry<dynamic> payload) {
        //Do something when the hook is triggered

        return Json("All is well");
    }
}
~~~

This works perfectly fine, but it can feel overly complicated to have to create a controller to be able to consume a webhook. The ASP.NET core SDK offers another
way by using a middleware component that you setup in your `Startup.cs`.

Add the following to your `Configure` method.

~~~csharp
app.UseContentfulWebhooks(consumers => {
               
});
~~~

This injects the middleware into the pipeline. The middleware will automatically catch any incoming webhook requests from Contentful and iterate through
any added consumers and execute them one at a time.

To add a consumer use the `AddConsumer` method.

~~~csharp
app.UseContentfulWebhooks(consumers => {
       consumers.AddConsumer<Entry<dynamic>>("<webhook-name>", "<topic-type>", "<topic-action>", (s) => 
            { 
                //This is the consumer method
                return null; 
            }
        );        
});
~~~

Each call to `AddConsumer` takes at least 4 parameters; The webhook name which is the name of the webhook you specified in Contentful.
The topic type which is `Entry`, `Asset` or `ContentType` The topic action which is `create`, `save`, `auto_save`, `archive`,
 `unarchive`, `publish`, `unpublish` or `delete`. For any of the values you can pass in `"*"` as a wildcard. The final parameter is a `Func<T, object>` where
 you specify `T` as part of the method signature. This is the actual consumer, the code that will be triggered.

If you for example want to add a consumer for a webhook that is triggered every time an entry is created you could add a consumer like this.

~~~csharp
app.UseContentfulWebhooks(consumers => {
       consumers.AddConsumer<Entry<dynamic>>("*", "Entry", "create", (s) => 
            { 
                //Code to notify someone a new entry has been created

                //Return an object that will be serialized into Json and viewable in the Contentful web app
                return new { Result = "Ok" }; 
            }
        );        
});
~~~

It is perfectly valid to add multiple consumers for the same type of request. They will be executed in order.

~~~csharp
app.UseContentfulWebhooks(consumers => {
       
       consumers.AddConsumer<Entry<dynamic>>("*", "Entry", "create", (s) => 
            { 
                return new { Result = "Ok" }; 
            }
        );

        consumers.AddConsumer<Entry<dynamic>>("*", "Entry", "*", (s) => 
            { 
                return new { Result = "Ok again!" }; 
            }
        );     
});
~~~

You can also add authorization by setting the `WebhookAuthorization` property.

~~~csharp
app.UseContentfulWebhooks(consumers => {
       
       consumers.AddConsumer<Entry<dynamic>>("*", "Entry", "create", (s) => 
            { 
                return new { Result = "Ok" }; 
            }
        );

        consumers.WebhookAuthorization = (s) => false;   
});
~~~

`WebhookAuthorization` is a `Func<HttpContext, bool>` that you can set to any method accepting an `HttpContext` and return a `bool`.

~~~csharp
app.UseContentfulWebhooks(consumers => {

        consumers.WebhookAuthorization = YourAuthorizationMethod;   
});
~~~

You can then in your method inspect the HttpContext and verify that the request is authorized. If it is, return `True` else return `False` and 
the request will fail with a 401 error.

There's also an option of adding a per-consumer authorization.

~~~csharp
app.UseContentfulWebhooks(consumers => {
       
       consumers.AddConsumer<Entry<dynamic>>("*", "Entry", "create", (s) => 
            { 
                return new { Result = "Ok" }; 
            },
            (httpContext) => {
                var authorized = false;

                //Check whether the request is authorized and set the authorized variable accordingly.

                return authorized;
            }
        );

});
~~~

This consumer authorization is also a `Func<HttpContext, bool>` and the principle is the same, but this authorization will only be executed for the specific
consumer and not for every request.