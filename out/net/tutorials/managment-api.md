---
page: ':docsUsingNetCdmSdk'
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

The Content Management API (CMA) is a restful API for managing content in your Contentful spaces. This means you can create, update, delete and retrieve content using well known HTTP verbs.

To make development easier for our users, we publish SDKs for various languages which make the task easier. This article details how to use the [.Net SDK](https://github.com/contentful/contentful.net) to create, update and delete content.

# Pre-requisites

This tutorial assumes you understand the basic Contentful data model as described in the [developer center](/developers/docs/concepts/data-model/) and that you have already read and understand the [getting started tutorial for the .Net SDK](/developers/docs/net/tutorials/using-net-cda-sdk/).

Contentful.net is built on .net core and targets .Net Standard 1.4. The SDK is cross platform and runs on Linux, macOS and Windows.

# Your first request

To communicate with the CMA we use a very similar approach as when we call the CDA, but instead of a `ContentfulClient` we use a `ContentfulManagementClient` that, just like the CDA client, requires three parameters.

1.  An `HttpClient` that makes the HTTP requests to the CMA.
2.  An access token. This has to be a valid management token created using OAuth. To learn more about creating a management token please refer to the [documentation](/developers/docs/references/authentication/#the-management-api).
3.  A space id. This is the unique identifier of your space that you can find in the Contentful web app. This will be the default space for all operations in the SDK, but you can also specify a different space for every operation.

```csharp
var httpClient = new HttpClient();
var client = new ContentfulManagementClient(httpClient, "<content_management_api_key>", "71rop70dkqaj")
```

{: .note} An `HttpClient` in .Net is special. It implements `IDisposable` but is generally not supposed to be disposed for the lifetime of your application. This is because whenever you make a request with the `HttpClient` and immediately dispose it you leave the connection open in a `TIME_WAIT` state. It will remain in this state for **240** seconds by default. This means that if you make a lot of requests in a short period of time you might end up exhausting the connection pool, which would result in a `SocketException`. To avoid this you should share a single instance of `HttpClient` for the entire application, and exposing the underlying `HttpClient` of the `ContentfulManagementClient` allows you to do this.

Once you have an `ContentfulManagementClient` you can start managing content. For example, to create a brand new space:

```csharp
var space = await client.CreateSpaceAsync("<space_name>", "<default_locale>", "<organization_id>");
Console.WriteLine(space.Name); // => <space_name>
```

If your user account only belongs to a single organization the organization_id parameter can be omitted.

To delete a space, simply pass a space id to the `DeleteSpaceAsync` method:

```csharp
var space = await client.DeleteSpaceAsync("71rop70dkqaj");
```

To change the name of an existing space use the `UpdateSpaceNameAsync` method.

```csharp
var space = await client.UpdateSpaceNameAsync("71rop70dkqaj", "<new_space_name>", "<space_version>", "<organization_id>");
```

The organisation id can, again, normally be omitted unless your account has several different organizations. The version parameter however, can not.

This is a common pattern to update operations in the Contentful management API. To update an entry you need to pass the last known version to make sure that you do not overwrite a resource that has since been updated. This is known as optimistic locking and is to prevent unwanted data loss. If the version passed does not match the latest version in Contentful the update will be rejected and a `ContentfulException` will be thrown.

To retrieve the version of a resource we inspect the `SystemProperties.Version` property.

A simple example for a space could be:

```csharp
var space = await client.GetSpaceAsync("71rop70dkqaj")
var version = space.SystemProperties.Version; //Nullable int
await client.UpdateSpaceNameAsync("71rop70dkqaj", "<new_space_name>", version.Value);
```

# Working with content types

Once you've familiarized yourself with creating and deleting spaces the next step is to add some content types to your space. A content type in Contentful is a blue print for an Entry, it contains up to 50 fields that you can define.

First create a new `ContentType` object, initialize it's system properties, give it an ID, name, an description:

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

Finaly define which field is the main display field, and send the new content type declaration to the client.

```csharp
contentType.DisplayField = "productName";

await _client.CreateOrUpdateContentTypeAsync(contentType);
```

The fields have a lot of properties and can look daunting at first, especially if you add validations, so let's break the components down. Every field consists of up to 10 properties.

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

    In the simplest of cases you only need to specify the name, id and type.

    ```csharp
    new Field()
        {
            Name = "Some field",
            Id = "field1",
            Type = "Text",
        }
    ```

    ## Field validations

    The trickiest part of fields is handling validations. There are a number of different validators that all implement the `IFieldValidator` interface.

    Every validator has a `Message` property where you can specify a custom message to be shown if the validation fails.

    ### LinkContentTypeValidator

    The `LinkContentTypeValidator` validates that a given field only contains entries of a certain content type. The constructor takes an optional message and any number of string ids or content types to validate against.

    ```csharp
    new Field()
        {
            Name = "Some field",
            Id = "field1",
            Type = "Link",
            Validations = new List<IFieldValidator>() {
                new LinkContentTypeValidator(message: "My custom validation message", "<content_type_id>", "<content_type_id>" ...)
            }
        }
    ```

    ### InValuesValidator

    The `InValuesValidator` validates that a given fields value is within a predefined set of values. The constructor takes an optional message and any number of strings to validate against.

    ```csharp
    new Field()
        {
            Name = "Some field",
            Id = "field1",
            Type = "Text",
            Validations = new List<IFieldValidator>() {
                new InValuesValidator(message: "My custom validation message", "<value1>", "<value2>" ...)
            }
        }
    ```

    ### MimeTypeValidator

    The `MimeTypeValidator` validates that an asset is of a specific mime type group.

    ```csharp
    new Field()
        {
            Name = "Some field",
            Id = "field1",
            Type = "Text",
            Validations = new List<IFieldValidator>() {
                new MimeTypeValidator(MimeTypeRestriction.Image, "My custom validation message")
            }
        }
    ```

    Available restrictions are

    - MimeTypeRestriction.Attachment
    - MimeTypeRestriction.Plaintext
    - MimeTypeRestriction.Image
    - MimeTypeRestriction.Audio
    - MimeTypeRestriction.Video
    - MimeTypeRestriction.Richtext
    - MimeTypeRestriction.Presentation
    - MimeTypeRestriction.Spreadsheet
    - MimeTypeRestriction.PdfDocument
    - MimeTypeRestriction.Archive
    - MimeTypeRestriction.Code
    - MimeTypeRestriction.Markup

    ### SizeValidator

    The `SizeValidator` validates that an array field contains a specific number of items.

    ```csharp
    new Field()
        {
            Name = "Some field",
            Id = "field1",
            Type = "Array",
            Validations = new List<IFieldValidator>() {
                new SizeValidator(min: 2, max: 7, message: "My custom validation message")
            }
        }
    ```

    Both the min and the max value are nullable. This means you can easily create size validators that validates that an array contains at least a set number of items, but without an upper bound. Or contains a maximum of a set number of items but may also be empty.

    ```csharp
    //This SizeValidator allows a maximum of 5 items, but as it has no minimum value it can contain 0 items.
    new SizeValidator(min: null, max: 5, message: "My custom validation message")

    //This SizeValidator specifies that the field must contain at least 4 items, but there is no upper bound.
    new SizeValidator(min: 4, max: null, message: "My custom validation message")
    ```

    ### RangeValidator

    The `RangeValidator` validates that a field is within a certain numeric range.

    ```csharp
    new Field()
        {
            Name = "Some field",
            Id = "field1",
            Type = "Text",
            Validations = new List<IFieldValidator>() {
                new RangeValidator(min: 2, max: 7, message: "My custom validation message")
            }
        }
    ```

    When used for text fields it validates that the entered value contains at least the minimum number of characters and at most the maximum number of characters. For numeric fields it validates that the value entered is within the specified range. Both the min and max value are nullable in the exact same way as for the `SizeValidator`.

    ### RegexValidator

    The `RegexValidator` validates that a field conforms to a specified regular expression.

    ```csharp
    new Field()
        {
            Name = "Some field",
            Id = "field1",
            Type = "Text",
            Validations = new List<IFieldValidator>() {
                new RegexValidator(expression: "^such", flags: "im", message: "My custom validation message")
            }
        }
    ```

    ### UniqueValidator

    The `UniqueValidator` validates that the field values is unique among all entries.

    ```csharp
    new Field()
        {
            Name = "Some field",
            Id = "field1",
            Type = "Text",
            Validations = new List<IFieldValidator>() {
                new UniqueValidator(message: "My custom validation message")
            }
        }
    ```

    Once a content type has been created it needs to be activated before it is usable.

    ```csharp
    var contentType = await client.ActivateContentTypeAsync("<content_type_id>", version: 7);
    ```

    It can also be deactivated again in a similar fashion, but no version is necessary as we do not risk any data loss.

    ```csharp
    var contentType = await client.DeactivateContentTypeAsync("<content_type_id>");
    ```

    Deleting a content type is similarily straightforward. A content type must be deactivated before it can be deleted.

    ```csharp
    var contentType = await client.DeleteContentTypeAsync("<content_type_id>");
    ```

    There are three methods available to fetch content types.

    ```csharp
    var contentTypes = await client.GetContentTypesAsync(); //Gets all content types of the space
    var contentType = await client.GetContentTypeAsync("<content_type_id>"); //Gets a single content type
    var activeContentTypes = await client.GetActivatedContentTypesAsync(); //Gets the latest activated version of all content types
    ```

    ## Editor interface

    An editor interface represents information about how the fields of a content type is displayed in the user interface.

    Every content type has it's own Editor interface and it can not be excplicitly created. Instead it can be retrieved and updated as appropriate.

    ```csharp
    var editorInterface = await client.GetEditorInterfaceAsync("<content_type_id>");
    ```

    Once you have the editor interface you can update it and change how certain fields should be displayed.

    ```csharp
    var editorInterface = await client.GetEditorInterfaceAsync("<content_type_id>");

    editorInterface.Controls.First(f => f.FieldId == "field1").WidgetId = SystemWidgetIds.SingleLine;

    var boolField = editorInterface.Controls.First(f => f.FieldId == "field2")
    boolField.WidgetId = SystemWidgetIds.Boolean;
    boolField.Settings = new BooleanEditorInterfaceControlSettings()
                        {
                            HelpText = "Help me here!",
                            TrueLabel = "Truthy",
                            FalseLabel = "Falsy"
                        }
    await client.UpdateEditorInterfaceAsync(editorInterface, "<content_type_id>", editorInterface.SystemProperties.Version.Value);
    ```

    As you can tell an Editor interface consists of a collection of Controls. These are of type `EditorInterfaceControl` and has three different properties.

    ```csharp
    var editorInterfaceControl =  new EditorInterfaceControl()
                    {
                        FieldId = "<field_id>",
                        WidgetId = "<widget_id>",
                        Settings = new EditorInterfaceControlSettings()
                    }
    ```

    The `FieldId` is the id of the field that this `EditorInterfaceControl` controls the appearence of, the `WidgetId` is the type of widget you want the control to display as. There's a handy `SystemWidgetIds` class that contains all built in ids, for a full list refer to [the api documentation](/developers/docs/references/content-management-api/#/reference/editor-interface/get-the-editor-interface).

    There's also a `Settings` property that contains additional settings for certain type of widgets. Normally it is just of type `EditorInterfaceControlSettings` and has only a `HelpText` property which represents the helptext you want to display in relation to your field control. There are three distinct subclasses of `EditorInterfaceControlSettings` for specific fields.

    ```csharp
    var boolEditorInterfaceControlSettings = new BooleanEditorInterfaceControlSettings()
                    {
                        HelpText = "Help me here!",
                        TrueLabel = "Truthy", // The label to display next to the true option
                        FalseLabel = "Falsy" // The label to display next to the false option
                    };

    var ratingEditorInterfaceControlSettings = new RatingEditorInterfaceControlSettings()
                    {
                        HelpText = "Help me here!",
                        NumberOfStars = 7, // The number of stars to display in the rating widget, default is 5
                    };

    var datepickerEditorInterfaceControlSettings = new DatePickerEditorInterfaceControlSettings()
                    {
                        HelpText = "Help me here!",
                        DateFormat = EditorInterfaceDateFormat.time, // The format of the date, can be time, timeZ or dateonly
                        ClockFormat = "24" // The format of the clock, can be 12 or 24
                    }
    ```

    # Working with entries

    Fetching entries through the management API is very similar to using the delivery API, but with a few key differences.

    - Every entry will always include all configured locales.
    - You will get even unpublished entries through your calls.
    - Calls will not be cached as rigirously as with the delivery API.

    For this reason it's normally better to prefer the delivery API and `ContentfulClient` if you're only fetching content. However, at times it can be convenient to use the management API for this as well.

    ```csharp
    //Get all entries of a space, you can also pass a QueryBuilder to filter which entries to return.
    var entries = await client.GetEntriesCollectionAsync<Entry<dynamic>>();

    //Get a single entry
    var entry = await _client.GetEntryAsync("5KsDBWseXY6QegucYAoacS");
    //Note that this method is not generic but always returns an Entry<dynamic> as opposed to the GetEntry method of the ContentfulClient
    ```

    To create (or update) an entry use the `CreateOrUpdateEntryAsync` method. Since we need to provide all of the locales the simplest way to model our fields are trough dictionaries.

    ```csharp
    var entry = new Entry<dynamic>();
                entry.SystemProperties = new SystemProperties();
                entry.SystemProperties.Id = "new-thing";

                entry.Fields = new
                {
                    Field1 = new Dictionary<string, string>()
                    {
                        { "en-US", "First field" }
                    },
                    Field2 = new Dictionary<string, string>()
                    {
                        { "en-US", "English" },
                        { "sv-SE", "Svenska"}
                    },
                    Field3 = new Dictionary<string, int>()
                    {
                        { "en-US", 7 }
                    },
                    Field4 = new Dictionary<string, dynamic>()
                    {
                        { "en-US",
                            new {
                                Sys = new { Id = "<another_entry_id>", LinkType = "Entry", Type = "Entry" }
                            }
                        }
                    }
                };

                var newEntry = await _client.CreateOrUpdateEntryAsync(entry, contentTypeId: "<content_type_id>");
    ```

    You can also publish/unpublish, archive/unarchive and delete entries.

    ```csharp
    //This publishes the specified version of the entry and makes it publicly available through the delivery API
    client.PublishEntryAsync("5KsDBWseXY6QegucYAoacS", version);
    //Unpublishes a specified version again
    client.UnpublishEntryAsync("5KsDBWseXY6QegucYAoacS", version);

    //Archives an entry. An Entry can only be archived if it is not published
    client.ArchiveEntryAsync("5KsDBWseXY6QegucYAoacS", version);
    //Unarchives an entry again
    client.UnarchiveEntryAsync("5KsDBWseXY6QegucYAoacS", version);

    //Permanently deletes an entry
    client.DeleteEntryAsync("5KsDBWseXY6QegucYAoacS", version);
    ```

    # Working with assets

    Fetching assets is very similar to fetching entries. It also includes all the locales for an asset, you get even unpublished assets and the calls are not cached to the same degree. There's also another difference from fetching assets through the `ContentfulClient`, the `ContentfulManagementClient` returns `ManagementAsset` as opposed to `Asset`. The reason being that every property is a Dictionary containing the value for every locale.

    ```csharp
    var assets = await client.GetAssetsCollectionAsync();

    var publishedAssets = await client.GetPublishedAssetsCollectionAsync();

    var asset = await client.GetAssetAsync("wtrHxeu3zEoEce2MokCSi");
    var title = asset.Title["en-US"];
    var swedishTitle = asset.Title["sv-SE"];
    var englishAssetUrl = asset.Files["en-US"].Url;
    ```

    To create an asset simply create a `ManagementAsset` and pass it to the `CreateOrUpdateAssetAsync` method.

    ```csharp
    var managementAsset = new ManagementAsset();

    managementAsset.SystemProperties = new SystemProperties();
    managementAsset.SystemProperties.Id = "new-asset";

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

    After an asset has been created it also needs to be processed, which means it is moved to the contentful AWS buckets and CDN servers.

    ```csharp
    //Note that each locale needs to be processed separately.
    await client.ProcessAssetAsync("wtrHxeu3zEoEce2MokCSi", version, locale);
    ```

    As with entries, you can publish/unpublish, archive/unarchive and delete assets.

    ```csharp
    //This publishes the specified version of the asset and makes it publicly available through the delivery API
    await client.PublishAssetAsync("wtrHxeu3zEoEce2MokCSi", version);
    //Unpublishes a specified version again
    await client.UnpublishAssetAsync("wtrHxeu3zEoEce2MokCSi", version);

    //Archives an entry. An asset can only be archived if it is not published
    await client.ArchiveAssetAsync("wtrHxeu3zEoEce2MokCSi", version);
    //Unarchives an asset again
    await client.UnarchiveAssetAsync("wtrHxeu3zEoEce2MokCSi", version);

    //Permanently deletes an asset
    cawait lient.DeleteAssetAsync("wtrHxeu3zEoEce2MokCSi", version);
    ```

    # Working with locales

    Locales allow you to define translatable fields for entries and assets. To fetch all configured locales for a space use the `GetLocalesCollectionAsync` method.

    ```csharp
    var locales = await client.GetLocalesCollectionAsync(); //Fetches all locales for a space.

    var locale = await client.GetLocaleAsync("<locale_id>"); //Note that this parameter is not the locale code or name, but the actual id.
    locale.Code; // => "en-GB"
    locale.Name; // => "British English"
    ```

    To create a locale we need to define a number of properties.

    ```csharp
    var newLocale = new Local()
    {
        Name = "Swenglish", //The name of the locale
        Code = "en-SV", //The code of the locale, can be an arbitrary string
        FallbackCode = "en-GB", //The code of the locale to fallback to if this locale is missing a translation for a given field
        Optional = true, //Whether or not this locale allows for empty required fields, this is important to allow a locale to fallback to another locale if missing
        ContentDeliveryApi = true, //Whether or not this locale should be enabled in the API response for the delivery api
        ContentManagementApi = true //Whether or not this locale should be visible in the management api
    };

    await client.CreateLocaleAsync(locale);
    ```

    When deleting locales there are a few things to keep in mind. You can't delete a locale that is used as a fallback. You first need to delete or update any locale that has the locale you're trying to delete set as fallback. When you delete a locale you also delete **all** content associated with that locale. It is not possible to reverse this action and all content will be permanently deleted.

    ```csharp
    await client.DeleteLocaleAsync("<locale_id>");
    ```
````
