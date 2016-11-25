---
page: ':docsUsingNetCdaSdk'
---

# temp

## Overview

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

To makes things easier for our users, we publish SDKs for various languages which make the task easier.

This article goes into detail about how to get content using the [.Net CDA SDK](https://github.com/contentful/contentful.net).

## Pre-requisites

In this tutorial, we assume you understand the basic Contentful data model as described in the [developer center](/developers/docs/concepts/data-model/).

Contentful.Net is built on .net core and targets .Net Standard 1.6\. The SDK is cross platform and runs on Linux, macOS or Windows.

## Installation

Add the package to your .Net solution using the NuGet package manager by running the following command in your NuGet package manager console.

```csharp
Install-Package contentful.csharp -prerelease
```

### Installation via the Package Manager Dialog

_Right click_ your solution in Visual Studio and select _Manage NuGet Packages for Solution..._.

![add package to solution](https://images.contentful.com/tz3n7fnw4ujc/nbMJHwZkekqUAGwQSyGcw/8d858067e4b14994f44b0b652b51d862/add-package.png)

Search in the package manager for "Contentful", select the "Contentful.csharp" package, check the projects you want to add the package to, and click _install_. The package will now download and install to your selected projects.

## Your first request

To communicate with the Contentful Delivery API you use the `ContentfulClient` class that requires three parameters:

1. An `HttpClient` that makes the http requests to the Contentful Delivery API.
2. An access token. You can create access tokens in the _APIs_ tab of each space in the Contentful web app.
3. A space id. This is the unique identifier of your space that you can find in the Contentful web app.

```csharp
var httpClient = new HttpClient();
var client = new ContentfulClient(httpClient, "<content_delivery_api_key>", "<space_id")
```

{: .note}
Why do you need to supply you own `HttpClient`? An `HttpClient` in .Net is special. It implements `IDisposable` but is generally not supposed to be disposed for the lifetime of your application. This is because whenever you make a request with the `HttpClient` and then immediately dispose it you leave the connection open in a `TIME_WAIT` state. It will remain in this state for **240** seconds by default. This means that if you make a lot of requests in a short period of time you might end up exhausting the connection pool, which would result in a `SocketException`. To avoid this you should share a single instance of `HttpClient` for the entire application, and exposing the underlying `HttpClient` of the `ContentfulClient` allows you to do this.

Once you have an `ContentfulClient` you can start querying content. For example, to get a single entry:

```csharp
var entry = await client.GetEntryAsync<Entry<dynamic>>("<entry_id>");
Console.WriteLine(entry.Fields.productName.ToString());
```

The `GetEntry` method is generic and you can pass it any [POCO](https://pocoproject.org/) class. **It would then deserialize the JSON response from the API into that class for us**. In the example above you passed it an `Entry` class as a generic type parameter. This has the extra benefit of allowing you to also retrieve the system metadata of the entry. If you're not interested in the metadata you can pass any other class of you choice.

```csharp
public class Product {
    public string ProductName { get; set; }
    public string Price { get; set; }
    public string Description { get; set; }
}
```

If you pass this class to the `GetEntry` method you will get a response as a strongly typed `Product`.

```csharp
var product = await client.GetEntryAsync<Product>("<entry_id");

Console.WriteLine(book.ProductName); // => How to manage content in a developer-friendly manner
Console.WriteLine(book.Price); // => Contentful
Console.WriteLine(book.Description); // => Make an API request, get JSON in return.
```

The `Entry` class is generic, which means you can combine the two approaches if you are interested in the system metadata properties but also want to take advantage of strong typing.

```csharp
var productEntry = await client.GetEntryAsync<Entry<Product>>("<entry_id>");

Console.WriteLine(entry.Fields.ProductName); // => Contentful
Console.WriteLine(entry.SystemProperties.Id); // => <entry_id>
```
