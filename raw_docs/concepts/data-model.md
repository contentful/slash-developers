---
page: :docsContentModel
name: Data Model
title: Contentful data model
metainformation: 'Contentful organizes content into spaces with content entries, media assets, and settings for localizing content into different languages.'
slug: null
tags:
 - Basics
 - Content model
nextsteps:
 - text: Model relationships between content with links
   link: /developers/docs/concepts/links/
 - text: Add images to your content
   link: /developers/docs/concepts/images/
---

Contentful organizes content into _spaces_, that allows you to group all the related resources for a project together, this includes content entries, media assets, and settings for localizing content into different languages.

Each space has a _content model_ that represents the _content types_ you create.

## Content type properties

All content types have four standard fields that contain basic information about the content type, its fields and meta data.

| Field        | Type     | Description                        |
| ------------ | -------- | ---------------------------------- |
| sys          | Sys      | Common system properties.          |
| name         | String   | Name of the content type.          |
| description  | String   | Description of the content type.   |
| fields       | \[Field] | List of fields.                    |
| displayField | String   | ID of main field used for display. |

## Fields

Each _content type_ consists of a set of up to **50** fields that you define, these fields can be one of the following, and correspond to a JSON type. There are differences between the fields you can create in the web app and the API.

| Name                       | JSON type | Description                                                                                                                                                                                          | Limits                                           | Example                    |
| -------------------------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ | -------------------------- |
| Text (Short)               | String    | A short text field for tiles and names.                                                                                                                                                              | Maximum length is 256.                           | `"The title"`              |
| Text (Long)<sup>1</sup>    | String    | A long text field for paragraphs of text. Filterable via full-text search.                                                                                                                           | Maximum length is 50,000.                        | `"This is a post and ..."` |
| Number (Integer)           | Number    | A whole number                                                                                                                                                                                       | Values from -2 <sup>53</sup> to 2 <sup>53</sup>. | `42`                       |
| Number (Decimal)           | Number    | A decimal number.                                                                                                                                                                                    | Values from -2 <sup>53</sup> to 2 <sup>53</sup>. | `3.14`                     |
| Date and time <sup>2</sup> | String    | A date and time in ISO 8601 format.                                                                                                                                                                  |                                                  | `"2015-11-06T09:45:27"`    |
| Location                   | Object    | Coordinate values for storing the latitude and longitude of a location.                                                                                                                              |                                                  | `52.520008,13.404954`      |
| Boolean                    | Boolean   | For values that have two states, e.g. `Yes` or `no`, `true` or `false`.                                                                                                                              |                                                  | `true`                     |
| Media                      | Object    | A link to an asset. The type of the referenced item is defined by the `linkType` property. Read our [links guide](https://www.contentful.com/developers/docs/concepts/links/) for more details.      |                                                  |                            |
| Reference                  | Object    | A link to another entry. The type of the referenced item is defined by the `linkType` property. Read our [links guide](https://www.contentful.com/developers/docs/concepts/links/) for more details. |                                                  |                            |
| Array                      | Array     | List of values. See [array fields](#array-fields) below.                                                                                                                                             | Limited by entry size.                           | `["name1", "name2", ...]`  |
| JSON Object                | Object    | For storing any other types of objects you have defined.                                                                                                                                             | Limited by entry size.                           | `{ "foo": "bar" }`         |

1.  **Text**: Fields do not support ordering or strict equality.
2.  **Date**: Fields must be ISO8601 formatted, but do not require a time portion.

{: .img}
![New fields dialogue showing field types you can select](https://images.contentful.com/tz3n7fnw4ujc/5T9aAqcOrKOmGgYSwGq22s/530cf1377a1a16709df46fa4b3f2b106/0F75057E-1696-4631-86A6-AAC78904098F.png_dl_1)

### Array fields

Fields can contain multiple values with the `Array` type. An array can contain symbols (strings up to 256 characters), **or** [links](https://www.contentful.com/docs/concepts/links/) to other entries or assets. The `items` property defines the allowed values in the array.

You define a field that contains symbols like this:

```json
{
  "id": "tags",
  "type": "Array",
  "items": { "type": "Symbol" }
}
```

You define a field that contains links to assets like this:

```json
{
  "id": "relatedImages",
  "type": "Array",
  "items": {
    "type": "Link",
    "linkType": "Asset"
  }
}
```

You define a field that contains links to items like this:

```json
"reference_field": {
  "en-US": [
    {
      "sys": {
        "type": "Link",
        "linkType": "Asset",
        "id": "id1"
    }},
    {
      "sys": {
        "type": "Link",
        "linkType": "Asset",
        "id": "id2"
    }}
    ...
  ]
}
```

Individual fields also contain metadata, such as validations and widget appearance.

Contentful stores individual items of content as _entries_, which represent textual or structural information based on the content type used. Items can also be _assets_, which are binary files, such as images, videos or documents. Assets have three fixed fields, the name, description and attached file.

You can see how Contentful represents your content model in JSON by clicking the _JSON preview_ tab next to the _fields_ tab.

If you want to hide fields from appearing in JSON output, you can disable it by clicking the three dots to the right of the field.

{: .img}
![Disable Field](https://images.contentful.com/tz3n7fnw4ujc/3OjFlMBvmEu86ig0Yeoi6m/f6df20bb8baca265f34176295c753187/ECFFF57E-2FB6-44D5-B677-F0B58B3F43B4.png_dl_1)

This is useful for content information that is important to writers and editors, but not for public consumption.

## Example - modeling a product catalogue

One of the template spaces in Contentful is for a product catalogue, it consists of:

-   **A Category**: What product type is it?
-   **A Brand**: Who made the product?
-   **A Product**: An item for sale that references a _category_ and a _brand_.

And the **Brand** content type consists of the following fields:

-   **Company Name**: A text field that represents the title of the entry, it's required, with the _Single line_ appearance setting.
-   **Logo**: A media field that references assets.
-   **Description**: Describes the brand, it's a longer text field with the Markdown editor enabled.
-   **Website, Twitter, Email**: Three text fields that hold the contact details for the brand. They have validation rules to ensure the correct contact information.
-   **Phone #**: Another text field, but one that allows a user to add a list of values.
