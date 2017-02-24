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

This tutorial will show you how to setup the Contentful SDK for an ASP.NET core application and how to access your
content.

## Pre-requisites

This tutorial assumes you understand [the basic Contentful data model](/developers/docs/concepts/data-model/) and that you have read and understand the [getting started tutorial for the .Net SDK](/developers/docs/net/tutorials/using-net-cda-sdk/).

Contentful.net is built on .net core and targets .Net Standard 1.4. The SDK is cross-platform and runs on Linux, macOS, and Windows.

## Installation

Add the package to your ASP.NET core solution using the NuGet package manager by running the following command in your NuGet package manager console.

~~~csharp
Install-Package contentful.aspnetcore -prerelease
~~~

{: .note}
This package references the core `contentful.csharp` SDK but includes features specifically for ASP.NET core.

## Configuration

The Contentful.AspNetCore package implements [the options pattern](https://docs.asp.net/en/latest/fundamentals/configuration.html#options-config-objects) and the simplest way to configure your space id and access token is by using an _appsettings.json_ file. Add the code below, but add your own values.

~~~json
"ContentfulOptions": {
    "DeliveryApiKey": "297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971",
    "ManagementApiKey": "<cma_access_token>",
    "SpaceId": "71rop70dkqaj",
    "UsePreviewApi": false,
    "MaxNumberOfRateLimitRetries": 0
  }
~~~

You can override each separate option with environment specific config, environment variables or by any other
`Microsoft.Extensions.Configuration.IConfigurationSource`. You can even implement your own.

## Register services

Next, register the services that will use the configuration settings in your `Startup.cs` class. Add a using statement for
`Contentful.AspNetCore` and in the `ConfigureServices` method add the following line.

~~~csharp
services.AddContentful(Configuration);
~~~

{: .note}
You must pass in your configuration object to let the services read from the application settings. This will ensure the required services to retrieve content from Contentful are available.

## Your first request

Once you have configured everything, you can now leverage the dependency injection of your ASP.NET core application to retrieve the `IContentfulClient` or `IContentfulManagementClient` in your classes. Here's an example for a controller.

~~~csharp
public class SampleController : Controller {
    private readonly IContentfulClient _client;

    public SampleController(IContentfulClient client)
    {
        _client = client;
    }
}
~~~

By using constructor injection you can automatically retrieve an instance of `IContentfulClient` and use this in your actions to retrieve content.

~~~csharp
public async Task<IActionResult> Index() {
    var entries = _client.GetEntriesAsync<Entry<dynamic>>();
}
~~~

You can use your own models instead of relying on the `Entry<T>` class.

~~~csharp
public async Task<IActionResult> Index() {
    var products = _client.GetEntriesAsync<Product>();
}
~~~

For more information on how to retrieve content using the `IContentfulClient` and `IContentfulManagementClient` refer to our [CDA tutorial](/developers/docs/net/tutorials/using-net-cda-sdk/) and [CMA tutorial](/developers/docs/net/tutorials/management-api/) respectively.

## Working with assets and the image API

A new feature of ASP.NET core is [taghelpers](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/tag-helpers/intro). In the ASP.NET core SDK, there are two taghelpers that you can use when working with assets.

If you have an asset stored in Contentful and wish to output an anchor tag to that asset you can use the `ContentfulAssetTagHelper`. On the anchor tag add an `asset_id` attribute and the taghelper will automatically retrieve it from Contentful and add it to the `href` attribute.

~~~html
<a asset-id="wtrHxeu3zEoEce2MokCSi">link to asset</a>
~~~

If you want to retrieve the asset from a specific locale you can add the `locale` attribute.

~~~html
<a asset-id="wtrHxeu3zEoEce2MokCSi" locale="sv-SE">link to Swedish asset</a>
~~~

If the asset is an image you probably want to output an `img` tag instead of an anchor and can use the `ContentfulImageTageHelper`.

~~~html
<contentful-image asset-id="wtrHxeu3zEoEce2MokCSi" />
~~~

If you have the URL to the image available you can save a request by using the URL property instead.

~~~html
<contentful-image url="//wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg" />
~~~

There are other attributes you can set that will use the [Contentful Image API](/developers/docs/concepts/images/) in the background.

~~~html
<contentful-image url="//wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg" width="50" height="50" format="Png" resize-behaviour="Pad" background-color="#cc0000" image-focus-area="Face" corner-radius="10" />
~~~

These all correspond to similar values in our image API and will set the `src` attribute of the `img` correctly.

-   The `width` and `height` attributes will set the width and height of the image and resize it accordingly.
-   The `format` attribute lets you select if you wish your image to be of a specific format, available values are `Png`, `Jpg` or `Webp`.
-   The `resize-behaviour` attribute lets you specify how the image should be resized to fit within the constraints of the width and height.
    -   Available values are `Pad`, `Crop`, `Fill`, `Thumb` and `Scale`.
-   The `background-color` attribute lets you specify what color the padding of the image should be when using the `Pad` resize behavior.
    -   You can specify your value in using RGB or hash-notation. For example `rgb:000080` or `#000080`.
-   The `image-focus-area` attribute lets you specify which part of an image to focus on when doing resizing. Available values are `Top`, `Left`, `Right`, `Bottom`, `Top_Right`, `Top_Left`, `Bottom_Right`, `Bottom_Left`, `Face` or `Faces`.
-   The `corner-radius` allows you to round the corner of the image by the specified radius.

There are two attributes specifically for jpeg images.

~~~html
<contentful-image url="//wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg" jpg-quality="50" progressive-jpg="True" />
~~~

-   The `jpg-quality` attribute lets you specify a number between 0 and 100 that corresponds to the quality of the outputted JPEG image.
-   The `progressive-jpg` attribute lets you specify whether to use progressive JPEGs or not.

The output from a `contentful-image` will be a regular `img` tag and every attribute added to it that is not part of the taghelper will be retained. This means that you can, for example, specify an alt text or class directly on the taghelper and the outputted image will keep it.

~~~html
<contentful-image url="//wtrHxeu3zEoEce2MokCSi/e86a375b7ad18c25e4ff55de1eac42fe/quwowooybuqbl6ntboz3.jpg" width="50" height="50" alt="Playsam Streamliner" class="custom-class" />
~~~

## Working with webhooks and middleware

Webhooks offer a clean and simple way to let Contentful notify an application when something changes with your content. A simple approach to set a webhook up would be to create a controller with an action and let Contentful call that action when something occurs.

~~~csharp
public class WebHookController : Controller {

    [HttpPost]
    public IActionResult Consumer(Entry<dynamic> payload) {
        //Do something when the hook is triggered

        return Json("All is well");
    }
}
~~~

This works fine, but it can feel overly complicated to have to create a controller to be able to consume a webhook. The ASP.NET core SDK offers another way by using a middleware component that you set up in your `Startup.cs`.

Add the following to your `Configure` method.

~~~csharp
app.UseContentfulWebhooks(consumers => {

});
~~~

This injects the middleware into the pipeline. The middleware will automatically catch any incoming webhook requests from Contentful and iterate through any added consumers and execute them one at a time.

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

Each call to `AddConsumer` takes at least 4 parameters:

-   The webhook name which is the name of the webhook you specified in Contentful.
-   The topic type which is `Entry`, `Asset` or `ContentType`.
-   The topic action which is `create`, `save`, `auto_save`, `archive`, `unarchive`, `publish`, `unpublish` or `delete`. For any of the values, you can pass in `"*"` as a wildcard.
-   `Func<T, object>` where you specify `T` as part of the method signature. This is the actual consumer, the code that will be triggered.

If you, for example, want to add a consumer for a webhook triggered every time an entry is created, you add a consumer like the below.

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

It's valid to add multiple consumers for the same request type. They will execute in order.

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

You can add authorization by setting the `WebhookAuthorization` property.

~~~csharp
app.UseContentfulWebhooks(consumers => {

       consumers.AddConsumer<Entry<dynamic>>("*", "Entry", "create", (s) =>
            {
                return new { Result = "Ok" };
            }
        );

        consumers.WebhookAuthorization = (httpcontext) => false;   
});
~~~

`WebhookAuthorization` is a `Func<HttpContext, bool>` that you can set to any method accepting an `HttpContext` and return a `bool`.

~~~csharp
app.UseContentfulWebhooks(consumers => {

        consumers.WebhookAuthorization = YourAuthorizationMethod;   
});
~~~

In your method, you can then inspect the `HttpContext` and verify that the request is authorized. If it is, return `True`, else return `False` and the request will fail with a 401 error.

You can add per-consumer authorization.

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

This consumer authorization is a `Func<HttpContext, bool>` and the principle is the same, but this authorization will only execute for the specific consumer and not for every request.
