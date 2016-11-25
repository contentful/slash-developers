---
page: ':docsUsingNetCdaSdk'
---

# temp


The Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

To make development easier for our users, we publish SDKs for various languages which make the task easier. This article details how to us the [.Net CDA SDK](https://github.com/contentful/contentful.net).

## Pre-requisites

This tutorial assumes you understand the basic Contentful data model as described in the [developer center](/developers/docs/concepts/data-model/).

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
An `HttpClient` in .Net is special. It implements `IDisposable` but is generally not supposed to be disposed for the lifetime of your application. This is because whenever you make a request with the `HttpClient` and then immediately dispose it you leave the connection open in a `TIME_WAIT` state. It will remain in this state for **240** seconds by default. This means that if you make a lot of requests in a short period of time you might end up exhausting the connection pool, which would result in a `SocketException`. To avoid this you should share a single instance of `HttpClient` for the entire application, and exposing the underlying `HttpClient` of the `ContentfulClient` allows you to do this.

Once you have an `ContentfulClient` you can start querying content. For example, to get a single entry:

```csharp
var entry = await client.GetEntryAsync<Entry<dynamic>>("<entry_id>");
Console.WriteLine(entry.Fields.productName.ToString());
```

The `GetEntry` method is generic and you can pass it any [POCO](https://pocoproject.org/) class. **It would then de-serialize the JSON response from the API into that class for us**. In the example above you passed it an `Entry` class as a generic type parameter. This has the extra benefit of allowing you to also retrieve the system metadata of the entry. If you're not interested in the metadata you can pass any other class of you choice.

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

## Querying for content

There are a couple of methods on `ContentfulClient` that allow you to query for content. Every example below assumes you have an `ContentfulClient` with the name of `client` initialized.

### Get a single Entry

To get a single entry use the `GetEntryAsync<T>` method.

```csharp
var entry = await client.GetEntryAsync<Entry<dynamic>>("<entry_id>");
```

This calls the Contentful Delivery API and returns json in the following format:

```json
{
  "sys": {
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "<space_id>"
      }
    },
    "id": "<entry_id>",
    "type": "Entry",
    "createdAt": "2016-11-03T10:50:05.033Z",
    "updatedAt": "2016-11-08T14:30:23.857Z",
    "revision": 4,
    "contentType": {
      "sys": {
        "type": "Link",
        "linkType": "<content_type>",
        "id": "<content_type_id>"
      }
    },
    "locale": "en-US"
  },
  "fields": {
    "productName": "SoSo Wall Clock",
    "slug": "soso-wall-clock",
    "productDescription": "The newly released SoSo Clock from Lemnos marries simple...",
    "sizetypecolor": "10\" x 2.2\"",
    "image": [
      {
        "sys": {
          "type": "Link",
          "linkType": "Asset",
          "id": "AssetId"
        }
      }
    ],
    "tags": [
      "home décor",
      "clocks",
      "interior design",
      "yellow",
      "gifts"
    ],
    "categories": [
      {
        "sys": {
          "type": "Link",
          "linkType": "Entry",
          "id": "EntryId"
        }
      }
    ],
    "price": 120,
    "brand": {
      "sys": {
        "type": "Link",
        "linkType": "Entry",
        "id": "EntryId"
      }
    },
    "quantity": 3,
    "sku": "B00MG4ULK2",
    "website": "http://store.dwell.com/soso-wall-clock.html"
  }
}
```

The `Entry<T>` class encapsulates the two JSON properties of the returned data in a `SystemProperties` and a `Fields` property. The `Fields` property is generic and can serialize the JSON fields into any POCO class of your choice. In the example above we use the `Entry<dynamic>` which is a convenient way to quickly fetch content.

You can display any property of an entry like this.

```csharp
Console.WriteLine(entry.Fields.productName.ToString()) // => SoSo Wall Clock
Console.WriteLine(entry.Fields.brand.sys.id.ToString()) // => <entry_id>
Console.WriteLine(entry.Fields.sku.ToString()) // => B00MG4ULK2
//Meta data properties can be found in the SystemProperties property
Console.WriteLine(entry.SystemProperties.Id) // => <entry_id>
Console.WriteLine(entry.SystemProperties.Revision?.ToString()) // => 4
```

Often you would rather have a strongly typed generic parameter for your `Entry<T>` like this.

```csharp
public class Product {
    public int Quantity { get; set; }
    public string ProductName { get; set; }
    public string Slug { get; set; }
}

var entry = await client.GetEntryAsync<Entry<Product>>("id of entry");

Console.WriteLine(entry.Fields.ProductName) // => SoSo Wall Clock
Console.WriteLine(entry.Fields.Quantity.ToString()) // => 3
Console.WriteLine(entry.Fields.Slug) // => soso-wall-clock
//We still have access to the meta data properties
Console.WriteLine(entry.SystemProperties.Id) // => id of entry
Console.WriteLine(entry.SystemProperties.Revision?.ToString()) // => 4
```

In certain cases you are not interested in the metadata properties, and can pass any arbitrary class as a generic argument.

```csharp
public class Product {
    public int Quantity { get; set; }
    public string ProductName { get; set; }
    public string Slug { get; set; }
}

var entry = await client.GetEntryAsync<Product>("<entry_id>");

Console.WriteLine(entry.ProductName) // => SoSo Wall Clock
Console.WriteLine(entry.Quantity.ToString()) // => 3
Console.WriteLine(entry.Slug) // => soso-wall-clock
//This does not compile, Product does not contain a definition for SystemProperties
Console.WriteLine(entry.SystemProperties.Id) // => <entry_id>
Console.WriteLine(entry.SystemProperties.Revision?.ToString()) // => 4
```

This would only serialize the fields property of the JSON object.

## Get multiple entries

There are several methods to retrieve multiple entries available in the SDK.

### Get all entries of a space

```csharp
var entries = await client.GetEntriesAsync<Entry<dynamic>>();
//entries would be an IEnumerable of Entry<dynamic>
```

Will return all entries in a space in an `IEnumerable<Entry<dynamic>>`. As with `GetEntryAsync<T>` you can choose to provide `GetEntriesAsync<T>` with another implementation of `T`, for example `Entry<Product>` or if you're not interested in the meta data properties, then `Product`.

```csharp
var entries = await client.GetEntriesAsync<Product>();
//entries would be an IEnumerable of Product
```

Every collection returned by the CDA has this JSON structure:

```json
{
  "sys": {
    "type": "Array"
  },
  "total": 2,
  "skip": 0,
  "limit": 100,
  "items": [
    {
        //...items
    }
  ]
}
```

This is useful if the response returns a large number of entries and you need to paginate the result. The maximum number of entries ever returned for a single result set is 1000 items, the default 100 items.

The `IEnumerable<T>` response above does not correspond to this structure. If you're interested in the `skip`, `total` and `limit` properties you should use the `GetEntriesCollectionAsync<T>` method. This will return a `ContentfulCollection<T>` which includes `Skip`, `Total` and `Limit` properties. The generic `T` parameter is in this case restricted to an `IContentfulResource` but you would normally use it with an `Entry<T>`.

{: .note} `ContentfulCollection` implements `IEnumerable<T>` and thus you can write normal [LINQ syntax](https://en.wikipedia.org/wiki/Language_Integrated_Query) directly against the collection instead of against `collection.Items`, e.g. `entries.First()` as opposed to `entries.Items.First()` which also works.

```csharp
var entries = await client.GetEntriesCollectionAsync<Entry<Product>>();

Console.WriteLine(entries.Total.ToString()); // => 2
Console.WriteLine(entries.Skip.ToString()); // => 0
Console.WriteLine(entries.Limit.ToString()); // => 100
Console.WriteLine(entries.First().Fields.ProductName) // => SoSo Wall Clock
```

### Get and filter entries

Frequntly you're not interested in every entry in a space but would like to filter the entries returned by a number of parameters. The CDA exposes powerful filtering options that you can read more about in our [api documentation][1].

When using the `GetEntries` methods you can filter the query by using the `QueryBuilder` class.

```csharp
var builder = new QueryBuilder().ContentTypeIs("<content_type_id>").FieldEquals("fields.slug","soso-wall-clock")
var entries = await client.GetEntriesAsync<Product>(builder);
//entries would be an IEnumerable of Product
```

This would filter the entries returned to be of content type with the id "

<content_type_id>" and the <code>fields.slug</code> property equal to "soso-wall-clock".</content_type_id>

As filtering by content type id is a common scenario, the `ContentfulClient` exposes a helpful method to help.

```csharp
var entries = await client.GetEntriesByTypeAsync<Product>("ContentTypeId");
//entries would be an IEnumerable of Product
```

This method can take an optional `QueryBuilder` for further filtering.

```csharp
var builder = new QueryBuilder().FieldGreaterThan("sys.updatedAt", DateTime.Now.AddDays(-7).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssK"))
var entries = await client.GetEntriesByTypeAsync<Product>("<content_type_id>");
//entries would be an IEnumerable of Product
```

This would return entries with the content type of the id "<content_type_id>" that has been updated in the last week.

You can pass the query string directly to the `GetEntries` methods if you wish.

```csharp
var entries = await client.GetEntriesAsync<Product>("?content_Type=ContentTypeId&fields.productName[match]=Clock");
//entries would be an IEnumerable of Product
```

While this is possible, the recommended approach is to use the `QueryBuilder` whenever possible as it will make sure your query string is correctly formatted.

## Get a single asset

To get a single asset use the `GetAssetAsync` method.

```csharp
var asset = await client.GetAssetAsync("<asset_id>");
```

This would return an asset as JSON:

```json
{
  "sys": {
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "<space_id>"
      }
    },
    "id": "<asset_id>",
    "type": "Asset",
    "createdAt": "2016-11-03T15:06:48.621Z",
    "updatedAt": "2016-11-03T15:06:48.621Z",
    "revision": 1,
    "locale": "en-US"
  },
  "fields": {
    "title": "ihavenoidea",
    "file": {
      "url": "//images.contentful.com/SpaceId/321/123/ihavenoidea.jpg",
      "details": {
        "size": 46022,
        "image": {
          "width": 600,
          "height": 600
        }
      },
      "fileName": "ihavenoidea.jpg",
      "contentType": "image/jpeg"
    }
  }
}
```

That is then serialized into a strongly typed `Asset`.

```csharp
var asset = await client.GetAssetAsync("<asset_id>");
Console.WriteLine(asset.SystemProperties.CreatedAt.ToShortDateString()); // => 2016-11-03
Console.WriteLine(asset.Title); // => ihavenoidea
Console.WriteLine(asset.File.Url); // => //images.contentful.com/SpaceId/321/123/ihavenoidea.jpg
```

## Get multiple assets

Getting multiple assets is similar to getting multiple entries, but the methods are not generic but all return a variation of an `IEnumerable<Asset>`.

### Get all assets of a space

```csharp
var assets = await client.GetAssetsAsync();
//assets would be an IEnumerable of Asset
```

Every collection returned by the Contentful api has this JSON structure:

```json
{
  "sys": {
    "type": "Array"
  },
  "total": 7,
  "skip": 0,
  "limit": 100,
  "items": [
    {
        //...items
    }
  ]
}
```

This is useful if the response returns a large number of entries and you need to paginate the result. The maximum number of entries ever returned for a single result set is 1000 items, the default 100 items.

The `IEnumerable<Asset>` response above does not correspond to this structure. If you're interested in the `skip`, `total` and `limit` properties you should use the `GetAssetsCollectionAsync` method. This will return a `ContentfulCollection<Asset>` which includes `Skip`, `Total` and `Limit` properties.

{: .note} `ContentfulCollection` implements `IEnumerable<T>` and thus you can write normal LINQ syntax directly against the collection instead of against `collection.Items`, e.g. `assets.First()` as opposed to `assets.Items.First()` which also works.

```csharp
var assets = await client.GetAssetsCollectionAsync();

Console.WriteLine(assets.Total.ToString()); // => 7
Console.WriteLine(assets.Skip.ToString()); // => 0
Console.WriteLine(assets.Limit.ToString()); // => 100
Console.WriteLine(assets.First().Title) // => ihavenoidea
```

### Get and filter assets

As with entries you can filter assets by using your own query string or a `QueryBuilder`.

```csharp
var builder = new QueryBuilder().MimeTypeIs(MimeTypeRestriction.Image).OrderBy("sys.createdAt");
var assets = await client.GetAssetsAsync(builder);
//assets would be an IEnumerable of Asset
```

This returns all assets that are images, ordered by their creation date and would be equivalent of using the following query string.

```csharp
var assets = await client.GetAssetsAsync("?mimetype_group=imageℴ=sys.createdAt");
//assets would be an IEnumerable of Asset
```

## Including referenced assets and entries

When querying for entries it's common that the returned entries reference other assets and entries. For example a blog post entry referencing its author entry and vice versa.

The CDA allows you to do this by specifying how many levels of references you wish to resolve and include in the API response.

Consider the following classes has two different properties that contain references to other assets and entries.

```csharp
public class Product
    {
        public string productName { get; set; }
        public string Slug { get; set; }
        public string productDescription { get; set; }
        public List<Categories> Category { get; set; }
    }

public class Category {
    public string Title { get; set; }
}
```

## Specifying the number of levels to include

To specify the number of levels to include in a call add an `include` query string parameter, manually or by using the QueryBuilder.

```csharp
var builder = new QueryBuilder().ContentTypeIs("<content_type_id>").Include(3);
var entries = await client.GetEntriesAsync<Product>(builder);
```

This queries for entries of a specific content type id and tells the CDA to resolve up to three levels of referenced entries and assets. The default setting for the include parameter is 1\. This means that omitting the query string parameter still resolves up to 1 level of referenced content. If you specifically do not want any referenced content included you need to set the include parameter to 0.

```csharp
var builder = new QueryBuilder().ContentTypeIs("<content_type_id>").Include(0);
var entries = await client.GetEntriesAsync<Product>(builder);
//No referenced content would be included.
```

Including referenced content is only supported for the methods that return collections. Using `GetEntryAsync` will not resolve your references. Instead you could query for a single entry using `GetEntriesAsync`, but adding a restriction to get an entry by a specific id.

```csharp
var builder = new QueryBuilder().FieldEquals("sys.id", "<entry_id>").Include(2);
var entry = await client.GetEntriesAsync<Product>(builder).FirstOrDefault();
```

This fetches an entry with id "123" and includes up to two levels of referenced entries and assets.

## Resolving included assets

To resolve assets when querying for content, add a property of type `Asset` or `IEnumerable<Asset>` and the de-serialization will automatically fill up any referenced assets.

```csharp
var builder = new QueryBuilder().ContentTypeIs("<content_type_id>").Include(1);
var entries = await client.GetEntriesAsync<Product>(builder);
Console.WriteLine(entries.First().FeaturedImage.Title); // => Alice in Wonderland
Console.WriteLine(entries.First().Images.Count.ToString()); // => 2
```

## Resolving included entries

Entries are simple to resolve if you use the generic `Entry<T>` class. For example, if you change the `Tags` property of the `Product` class.

```csharp
public List<Entry<Catgory>> Categories { get; set; }
```

You can now de-serialize the referenced categories and included them in the `Product`.

```csharp
var builder = new QueryBuilder().ContentTypeIs("<content_type_id>").Include(1);
var entries = await client.GetEntriesAsync<Product>(builder);
Console.WriteLine(entries.First().Categories[0].Fields.Title); // => Lewis Carroll
Console.WriteLine(entries.First().Categories[0].SystemProperties.Id); // => 1234
```

If you're not interested in the meta data about the entry you might be tempted to change the property back to this.

```csharp
public List<Category> Categories { get; set; }
```

Unfortunately this will not work as the structure of an entry returned from the CDA consists of two properties `sys` and `fields` there is no way to serialize this into our `Category` class right away. If you decorate the `Category` class with a converter attribute you can get around this. If you add an `EntryFieldJsonConverter` to the `Category` class like this.

```csharp
[JsonConverter(typeof(EntryFieldJsonConverter))]
public class Category {
    public string Title { get; set; }
}
```

The `Category` class is now serialized directly from the `fields` property of the JSON response and you can now skip the use of `Entry<T>` in you `Product`.

```csharp
var builder = new QueryBuilder().ContentTypeIs("<content_type_id>").Include(1);
var entries = await client.GetEntriesAsync<Product>(builder);
Console.WriteLine(entries.First().Categories[0].Title); // => Lewis Carroll
//Compare the above line with Console.WriteLine(entries.First().Categories[0].Fields.Title);
Console.WriteLine(entries.First().Categories[0].SystemProperties.Id); // => This no longer compiles as Author does not contain SystemProperties
```

[1]: https://www.contentful.com/developers/docs/references/content-delivery-api/#/reference/search-parameters
