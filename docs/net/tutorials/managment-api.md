---
page: :docsUsingNetCdmSdk
name: Using the management api with Contentful and .NET
title: Using the management api with Contentful and .NET
metainformation: This article details how to use the management api using the .NET SDK.
slug: null
tags:
  - SDKs
  - .NET
nextsteps:
  - text: Explore the .NET SDK GitHub repository
    link: 'https://github.com/contentful/contentful.net'
---

The Content Management API (CMA) is a restful API for managing content in your Contentful spaces. You can create, update, delete and retrieve content using well-known HTTP verbs.

To make development easier for our users, we publish SDKs for various languages which make the task easier. This article details how to use the [.Net SDK](https://github.com/contentful/contentful.net) to create, update and delete content.

## Pre-requisites

This tutorial assumes you understand the basic Contentful data model as described in the [developer center](/developers/docs/concepts/data-model/) and that you have already read and understand the [getting started tutorial for the .Net SDK](/developers/docs/net/tutorials/using-net-cda-sdk/).

Contentful.net is built on .net core and targets .Net Standard 1.4. The SDK is cross-platform and runs on Linux, macOS and Windows.

## Your first request

To communicate with the CMA we use a similar approach as when we call the CDA, but instead of a `ContentfulClient` youuse a `ContentfulManagementClient` that, like the CDA client, requires three parameters.

1.  An `HttpClient` that makes the HTTP requests to the CMA.
2.  An access token. The token has to be a valid management token created using OAuth. To learn more about creating a management token please refer to the [documentation](/developers/docs/references/authentication/#the-management-api).
3.  A space id. The id is the unique identifier of your space that you can find in the Contentful web app. This will be the default space for all operations in the SDK, but you can also specify a different space for every operation.

```csharp
var httpClient = new HttpClient();
var client = new ContentfulManagementClient(httpClient, "<content_management_api_key>", "<space_id>")
```

{: .note}
An `HttpClient` in .Net is special. It implements `IDisposable` but is generally not supposed to be disposed of for the lifetime of your application. This is because whenever you make a request with the `HttpClient` and immediately dispose of it, you leave the connection open in a `TIME_WAIT` state. It will remain in this state for **240** seconds by default. If you make a lot of requests in a short period you might end up exhausting the connection pool, which would result in a `SocketException`. To avoid this you should share a single instance of `HttpClient` for the entire application, and exposing the underlying `HttpClient` of the `ContentfulManagementClient` allows you to do this.

Once you have an `ContentfulManagementClient` you can start managing content. For example, to create a brand new space:

```csharp
var space = await client.CreateSpaceAsync("<space_name>", "<default_locale>", "<organization_id>");
Console.WriteLine(space.Name); // => <space_name>
```

If your user account belongs to a single organization, you can omit the `organization_id` parameter.

To delete a space, pass a space id to the `DeleteSpaceAsync` method:

```csharp
var space = await client.DeleteSpaceAsync("<space_id>");
```

To change the name of an existing space, use the `UpdateSpaceNameAsync` method.

```csharp
var space = await client.UpdateSpaceNameAsync("<space_id>", "<new_space_name>", "<space_version>", "<organization_id>");
```

Unless your account has more than one organization, you can omit the organization id, but the version parameter is always needed.

This is a common pattern to update operations in the Contentful management API. To update an entry, you need to pass the last known version to make sure that you do not overwrite a resource that has since been updated. This is called 'optimistic locking' and prevents unwanted data loss. If the version passed does not match the latest version in Contentful the update will be rejected and a `ContentfulException` thrown.

To retrieve the version of a resource, inspect the `SystemProperties.Version` property.

The following is an example of creating a space:

```csharp
var space = await client.GetSpaceAsync("<space_id>")
var version = space.SystemProperties.Version; // Nullable int
await client.UpdateSpaceNameAsync("<space_id>", "<new_space_name>", version.Value);
```

## Working with content types

Once you've familiarized yourself with creating and deleting spaces, the next step is to add content types to your space. A content type in Contentful is a blueprint for an entry, and contains up to 50 fields that you can define.

First create a new `ContentType` object, initialize it's system properties, give it an ID, name, and description:

```csharp
var contentType = new ContentType();
contentType.SystemProperties = new SystemProperties();
contentType.SystemProperties.Id = "<content_type_id>";
contentType.Name = "Product";
contentType.Description = "";
```

Create a `List` of field types, and add all the fields for your content model to it. The example below shows you how to recreate the 'Product' content type you find in our examples spaces, further explanation of the fields follows:

```csharp
contentType.Fields = new List<Field>()
{
    new Field()
    {
        Name = "Product name",
        Id = "productName",
        Type = "Text",
        Required = true,
        Localized = false,
        Disabled = false,
        Omitted = false,
    },
    new Field()
    {
        Name = "Slug",
        Id = "slug",
        Type = "Symbol",
        Required = false,
        Localized = true,
        Disabled = false,
        Omitted = false
    },
    new Field()
    {
        Name = "Description",
        Id = "productDescription",
        Type = "Text",
        Required = false,
        Localized = false,
        Disabled = true,
        Omitted = false
    },
    new Field()
    {
        Name = "Size/Type/Color",
        Id = "sizetypecolor",
        Type = "Symbol",
        Required = false,
        Localized = false,
        Disabled = false,
        Omitted = false
    },
    new Field()
    {
        Name = "Image",
        Id = "image",
        Type = "Asset",
        Required = false,
        Localized = false,
        Disabled = false,
        Omitted = false,
        LinkType = "Asset",  
        Validations = new List<IFieldValidator>() {
            new MimeTypeValidator(MimeTypeRestriction.Image, "My custom validation message")
        }                                    
    },
    new Field()
    {
        Name = "Tags",
        Id = "tags",
        Type = "Array",
        Required = false,
        Localized = false,
        Disabled = false,
        Omitted = false,
        Items = new Schema() {
            Type = "Symbol"
        },
    },
    new Field()
    {
        Name = "Categories",
        Id = "categories",
        Type = "Array",
        Required = false,
        Localized = false,
        Disabled = false,
        Omitted = false,
        Items = new Schema() {
          Type = "Link",
          LinkType = "Entry"           
        },
    },
    new Field()
    {
        Name = "Price",
        Id = "price",
        Type = "Number",
        Required = false,
        Localized = false,
        Disabled = false,
        Omitted = false
    },
    new Field()
    {
        Name = "Brand",
        Id = "brand",
        Type = "Link",
        Required = false,
        Localized = false,
        Disabled = false,
        Omitted = false,
        LinkType = "Entry"
    },
    new Field()
    {
        Name = "Quantity",
        Id = "quantity",
        Type = "Integer",
        Required = false,
        Localized = false,
        Disabled = false,
        Omitted = false
    },
    new Field()
    {
        Name = "SKU",
        Id = "sku",
        Type = "Symbol",
        Required = false,
        Localized = false,
        Disabled = false,
        Omitted = false
    },
    new Field()
    {
        Name = "Available at",
        Id = "website",
        Type = "Symbol",
        Required = false,
        Localized = false,
        Disabled = false,
        Omitted = false,
        Validations = new List<IFieldValidator>() {
          // REGEX
        }
    },
};
```

Define which field is the display field, and send the new content type declaration to the client.

```csharp
contentType.DisplayField = "productName";

await _client.CreateOrUpdateContentTypeAsync(contentType);
```

The fields have a lot of properties and can look daunting at first, especially if you add validations, so let's break the components down. Every field can consist of up to 10 properties.

```csharp
new Field()
{
    Name = "The name of the field", // The human readable name of the field e.g. "Top image" or "Main heading"
    Id = "field1", // The id for the field, must be between 2 and 60 characters long and only include alphanumerical characters, dashes, underscores or periods.
    Type = "Link", // The field type. This determines how the data is stored. E.g. "Date", "Text" or "Integer".
    Required = false, // Whether this field is mandatory for this content type.
    Localized = false, // Whether this field should be localized.
    Disabled = false, // Whether this field is disabled for editing.
    Omitted = false, // Whether this field should be omitted from the API response entirely
    LinkType = "Entry",  // Applicable if Type is "Link", whether this links to an Entry or an Asset   
    Items = new Schema() {  // Applicable if the Type is "Array" and specifies allowed item types for the array
        Type = "Link", // The type this array field should contain, e.g. "Symbol" or "Link"
        LinkType = "Entry" // Applicable if the item type is Link, specifies whether the array contains Entry or Asset
    },
    Validations = new List<IFieldValidator>() // See validations section below                
}
```

But at a minimum, you need to specify the name, id and type.

```csharp
new Field()
{
    Name = "Product name",
    Id = "productName",
    Type = "Text",
}
```

### Field validations

The most complex part of fields is handling validations. You can use different validators that all implement the `IFieldValidator` interface. Every validator has a `Message` property where you can specify a custom message to show if the validation fails.

#### LinkContentTypeValidator

The `LinkContentTypeValidator` validates that a given field contains entries of a particular content type. The constructor takes an optional message and any number of string ids or content types to validate against.

```csharp
new Field()
{
  Name = "Brand",
  Id = "brand",
  Type = "Link",
  Validations = new List<IFieldValidator>() {
      new LinkContentTypeValidator(message: "My custom validation message", "<content_type_id>", "<content_type_id>" ...)
  }
}
```

#### InValuesValidator

The `InValuesValidator` validates that a given field value is within a predefined set of values. The constructor takes an optional message and any number of strings to validate against.

```csharp
new Field()
{
  Name = "Tags",
  Id = "tags",
  Type = "Text",
  Validations = new List<IFieldValidator>() {
      new InValuesValidator(message: "This is not a valid tag", "<value1>", "<value2>" ...)
  }
}
```

#### MimeTypeValidator

The `MimeTypeValidator` validates that an asset is of a particular mime type group.

```csharp
new Field()
{
    Name = "Image",
    Id = "image",
    Type = "Text",
    Validations = new List<IFieldValidator>() {
        new MimeTypeValidator(MimeTypeRestriction.Image, "Not a valid image")
    }
}
```

Available restrictions are:

-   `MimeTypeRestriction.Attachment`
-   `MimeTypeRestriction.Plaintext`
-   `MimeTypeRestriction.Image`
-   `MimeTypeRestriction.Audio`
-   `MimeTypeRestriction.Video`
-   `MimeTypeRestriction.Richtext`
-   `MimeTypeRestriction.Presentation`
-   `MimeTypeRestriction.Spreadsheet`
-   `MimeTypeRestriction.PdfDocument`
-   `MimeTypeRestriction.Archive`
-   `MimeTypeRestriction.Code`
-   `MimeTypeRestriction.Markup`

#### SizeValidator

The `SizeValidator` validates that an array field contains a specific number of items.

```csharp
new Field()
{
    Name = "Tags",
    Id = "tags",
    Type = "Array",
    Validations = new List<IFieldValidator>() {
        new SizeValidator(min: 2, max: 7, message: "Sorry, you must add between 2 and 7 tags.")
    }
}
```

Both the min and the max value are nullable. You can create size validators that validate that an array contains at least a set number of items, but without an upper bound. Or contains a maximum of a set number of items but may also be empty.

```csharp
// This SizeValidator allows a maximum of 5 items, but as it has no minimum value it can contain 0 items.
new SizeValidator(min: null, max: 5, message: "Sorry, you may add a maxium of 5 tags.")

// This SizeValidator specifies that the field must contain at least 4 items, but there is no upper bound.
new SizeValidator(min: 4, max: null, message: "Sorry, you must add at least 4 tags.")
```

#### RangeValidator

The `RangeValidator` validates that a field is within a particular numeric range.

```csharp
new Field()
{
  Name = "Quantity",
  Id = "quantity",
  Type = "Number",
  Validations = new List<IFieldValidator>() {
      new RangeValidator(min: 10, max: 1000, message: "Quantities must be between 10 and 1000.")
  }
}
```

When used for text fields it validates that the entered value contains at least the minimum number of characters and at most the maximum number of characters. For numeric fields it validates that the value entered is within the specified range. Both the min and max value are nullable in the same way as for the `SizeValidator`.

#### RegexValidator

The `RegexValidator` validates that a field conforms to a specified regular expression.

```csharp
new Field()
  {
  Name = "Availabe at",
  Id = "website",
  Type = "Symbol",
  Validations = new List<IFieldValidator>() {
      new RegexValidator(expression: "\\b((?:[a-z][\\w-]+:(?:\\/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}\\/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))", flags: "i", message: "The value isn't a valid web address.")
  }
}
```

#### UniqueValidator

The `UniqueValidator` validates that the field values is unique among all entries.

```csharp
new Field()
{
  Name = "Name",
  Id = "productName",
  Type = "Text",
  Validations = new List<IFieldValidator>() {
      new UniqueValidator(message: "Sorry, product names must be unique.")
  }
}
```

### Activate a content type

Once you have created a content type you need to activate it before it's usable.

```csharp
var contentType = await client.ActivateContentTypeAsync("<content_type_id>", version: 7);
```

You can deactivate the content type in a similar fashion, but you don't need to specify a version as there is no risk of data loss.

```csharp
var contentType = await client.DeactivateContentTypeAsync("<content_type_id>");
```

Deleting a content type is similar, you must deactivate a content type before deleting it.

```csharp
var contentType = await client.DeleteContentTypeAsync("<content_type_id>");
```

There are three methods available to fetch content types.

```csharp
var contentTypes = await client.GetContentTypesAsync(); // Gets all content types of the space
var contentType = await client.GetContentTypeAsync("<content_type_id>"); // Gets a single content type
var activeContentTypes = await client.GetActivatedContentTypesAsync(); // Gets the latest activated version of all content types
```

## Editor interface

An editor interface represents information about how the user interface displays the fields of a content type.

Every content type has its own Editor interface, and you cannot explicitly create it. Instead, you retrieve and update it appropriately.

```csharp
var editorInterface = await client.GetEditorInterfaceAsync("<content_type_id>");
```

Once you have the editor interface, you can update it and change how certain fields are displayed.

```csharp
var editorInterface = await client.GetEditorInterfaceAsync("<content_type_id>");

editorInterface.Controls.First(f => f.FieldId == "productName").WidgetId = SystemWidgetIds.SingleLine;

var boolField = editorInterface.Controls.First(f => f.FieldId == "preorder")
boolField.WidgetId = SystemWidgetIds.Boolean;
boolField.Settings = new BooleanEditorInterfaceControlSettings()
{
  HelpText = "Is the product available?",
  TrueLabel = "Yes",
  FalseLabel = "No"
}
await client.UpdateEditorInterfaceAsync(editorInterface, "<content_type_id>", editorInterface.SystemProperties.Version.Value);
```

An Editor interface consists of a collection of 'controls'. These are of type `EditorInterfaceControl` which has three different properties.

```csharp
var editorInterfaceControl =  new EditorInterfaceControl()
{
  FieldId = "<field_id>",
  WidgetId = "<widget_id>",
  Settings = new EditorInterfaceControlSettings()
}
```

The `FieldId` is the id of the field that this `EditorInterfaceControl` controls the appearance of, and the `WidgetId` is the widget type you want the control to display as. There's a handy `SystemWidgetIds` class that contains all built in ids, for a full list refer to [the API documentation](/developers/docs/references/content-management-api/#/reference/editor-interface/get-the-editor-interface).

The `Settings` property contains settings for certain widget types. Normally it's of type `EditorInterfaceControlSettings` and has only a `HelpText` property which represents the help text you want to display in relation to your field control. There are three distinct subclasses of `EditorInterfaceControlSettings` for specific fields.

```csharp
var boolEditorInterfaceControlSettings = new BooleanEditorInterfaceControlSettings()
{
  HelpText = "Is the product available?",
  TrueLabel = "Yes",
  FalseLabel = "No"
};

var ratingEditorInterfaceControlSettings = new RatingEditorInterfaceControlSettings()
{
  HelpText = "Rate the product",
  NumberOfStars = 7, // The number of stars to display in the rating widget, default is 5
};

var datepickerEditorInterfaceControlSettings = new DatePickerEditorInterfaceControlSettings()
{
  HelpText = "Set the date of release",
  DateFormat = EditorInterfaceDateFormat.time, // The format of the date, can be time, timeZ or dateonly
  ClockFormat = "24" // The format of the clock, can be 12 or 24
}
```

## Working with entries

You fetch entries in a similar way to using the Content Delivery API (CDA), but with three key differences:

-   Every entry will always include all configured locales.
-   Calls will include unpublished entries.
-   The CMA does not cache calls as rigorously as the CDA.

For these reasons, it's better to use the CDA and the `ContentfulClient` [provided by the .NET SDK](#) if you're only fetching content. At times it can be convenient to use the CMA as well.

For example, to get all entries for a space you can pass a `QueryBuilder` to filter which entries to return.

```csharp
var entries = await client.GetEntriesCollectionAsync<Entry<dynamic>>();
```

Or to get a single entry.

```csharp
var entry = await _client.GetEntryAsync("<entry_id>");
```

{: .note} **Note**: This method is not generic but always returns an `Entry<dynamic>`, as opposed to the `GetEntry` method of the `ContentfulClient`.

To create (or update) an entry use the `CreateOrUpdateEntryAsync` method. Since you need to provide all the locales the simplest way to model fields is with dictionaries.

```csharp
var entry = new Entry<dynamic>();
entry.SystemProperties = new SystemProperties();
entry.SystemProperties.Id = "Accessories";

entry.Fields = new
{
    Title = new Dictionary<string, string>()
    {
        { "en-US", "Accessories" },
        { "sv-SE", "Tillbehör"}
    },
    Icon = new Dictionary<string, string>()
    {
        { "en-US", "Icon" }
    },
    Description = new Dictionary<string, int>()
    {
        { "en-US", "Small items to make you life or home complete." },
        { "sv-SE", "Små saker för att göra ditt liv eller hem komplett." }
    }
};

var newEntry = await _client.CreateOrUpdateEntryAsync(entry, contentTypeId: "<category_content_type_id>");
```

You can publish/unpublish, archive/unarchive and delete entries.

For example, to publish the specified version of an entry and make it publicly available through the CDA.

```csharp
client.PublishEntryAsync("<entry_id>", version);
```

Or to unpublish a specified version.

```csharp
client.UnpublishEntryAsync("<entry_id>", version);
```

To archive an entry. You can only archive an entry if it's not published.

```csharp
client.ArchiveEntryAsync("<entry_id>", version);
```

To unarchive an entry.

```csharp
client.UnarchiveEntryAsync("<entry_id>", version);
```

To permanently delete an entry.

```csharp
client.DeleteEntryAsync("<entry_id>", version);
```

## Working with assets

You fetch assets in a similar way to fetching entries. It includes all the locales for an asset, unpublished assets, and calls are not cached to the same level.

The `ContentfulManagementClient` returns `ManagementAsset`s as opposed to the `Asset`s returned from `ContentfulClient`. This is because every property is a `Dictionary` containing the value for each locale.

```csharp
var assets = await client.GetAssetsCollectionAsync();

var publishedAssets = await client.GetPublishedAssetsCollectionAsync();

var asset = await client.GetAssetAsync("<asset_id>");
var title = asset.Title["en-US"];
var swedishTitle = asset.Title["sv-SE"];
var englishAssetUrl = asset.Files["en-US"].Url;
```

To create an asset, initialize a `ManagementAsset` and pass it to the `CreateOrUpdateAssetAsync` method.

```csharp
var managementAsset = new ManagementAsset();

managementAsset.SystemProperties = new SystemProperties();
managementAsset.SystemProperties.Id = "<new_asset_id>";

managementAsset.Title = new Dictionary<string, string> {
    { "en-US", "New asset" },
    { "sv-SE", "Ny tillgång" }
};

managementAsset.Files = new Dictionary<string, File>
{
    { "en-US", new File() {
            ContentType = "image/png",
            FileName = "image.png",
            UploadUrl = "https://example.com/image.png"
        }
    },
    { "sv-SE", new File() {
            ContentType = "image/png",
            FileName = "image.png",
            UploadUrl = "https://example.com/image-SE.png"
        }
    }
};

await client.CreateOrUpdateAssetAsync(managementAsset);
```

After you have created an asset, you need to process it, which moves it to the Contentful AWS buckets and CDN servers.

{: .note} **Note**: You need to process each locale separately.

```csharp
await client.ProcessAssetAsync("<new_asset_id>", version, locale);
```

As with entries, you can publish/unpublish, archive/unarchive and delete assets.

To publish a particular version of the asset and make it publicly available through the CDA.

```csharp
await client.PublishAssetAsync("<new_asset_id>", version);
```

To unpublish a specified version.

```csharp
await client.UnpublishAssetAsync("<new_asset_id>", version);
```

To archive an entry. You can only archive an asset if it's not published.

```csharp
await client.ArchiveAssetAsync("<new_asset_id>", version);
```

To unarchive an asset.

```csharp
await client.UnarchiveAssetAsync("<new_asset_id>", version);
```

To permanently delete an asset.

```csharp
cawait lient.DeleteAssetAsync("<new_asset_id>", version);
```

## Working with locales

Locales allow you to define translatable fields for entries and assets. To fetch all configured locales for a space, use the `GetLocalesCollectionAsync` method.

```csharp
var locales = await client.GetLocalesCollectionAsync(); // Fetches all locales for a space.

var locale = await client.GetLocaleAsync("<locale_id>"); // Note that this parameter is not the locale code or name, but the actual id.
locale.Code; // => "en-GB"
locale.Name; // => "British English"
```

To create a locale you need to define some properties.

```csharp
var newLocale = new Local()
{
    Name = "Swenglish", // The name of the locale
    Code = "en-SV", // The code of the locale, can be an arbitrary string
    FallbackCode = "en-GB", // The code of the locale to fallback to if this locale is missing a translation for a given field
    Optional = true, // Whether this locale allows for empty required fields, this is important to allow a locale to fallback to another locale if missing
    ContentDeliveryApi = true, // Whether this locale should be enabled in the API response for the delivery api
    ContentManagementApi = true // Whether this locale should be visible in the management api
};

await client.CreateLocaleAsync(locale);
```

You can't delete a locale used as a fallback. You first need to delete or update any locale that has the locale you're trying to delete set as a fallback. When you delete a locale you delete **all** content associated with that locale. It's not possible to reverse this action and all content will be permanently deleted.

```csharp
await client.DeleteLocaleAsync("<locale_id>");
```
