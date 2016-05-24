---
page: :docsFieldTypes
---

## Overview

All data in Contentful has a field type, which is defined in the [creation of a content type](https://www.contentful.com/developers/docs/references/content-management-api/#/reference/content-types/create-a-content-type).

Each field type corresponds to a JSON type, though there are more field types than JSON types.

{:.table}
Name   |JSON type|Description|Example
-------|--------------|-----------|------------
Symbol |String        |Basic list of characters. Maximum length is 256.| "The title"
Text<sup>1</sup>   |String        |Same as Symbol, but filterable via full-text search. Maximum length is 50,000.|" This is a post and ..."
Integer|Number        |Number type without decimals. Values from  -2^53 to 2^53. | 42
Number |Number        |Number type with decimals. | 3.14
Date<sup>2</sup>  |String        |Date/time in ISO 8601 format. | 2015-11-06T09:45:27
Boolean|Boolean       |Flag, `true` or `false` | true
Link   |Object        |A reference to an entry or asset. The type of the referenced item is defined by the `linkType` property. See [links](https://www.contentful.com/developers/docs/concepts/links/) for more information| -
Array  |Array         |List of values. See [array fields](#array-fields) below. |["name1", "name2", ...]
Object |Object        |Arbitrary object. | `fields.file.details`

1. **Text**: fields do not support ordering or strict equality

2. **Date**: fields must be ISO8601 formatted, but do not require a time portion

## Array fields

Contentful supports fields that contain multiple values with it's `Array` type. Currently an array can contain either symbols (strings up to 256 characters), **or** [links](/developers/docs/concepts/links/) to other entries or assets. The allowed values in the array are defined by the `items` property of the field definition.

A field that contains symbols is defined like this:

~~~json
{
  "id": "tags",
  "type": "Array",
  "items": { "type": "Symbol" }
}
~~~

A field containing an array of links to assets is defined like this:

~~~json
{
  "id": "relatedImages",
  "type": "Array",
  "items": {
    "type": "Link",
    "linkType": "Asset"
  }
}
~~~

A reference field takes linked items as the following:

```
"reference_field": {
      "en-US": [
        {"sys": {
          "type": "Link",
          "linkType": "Asset",
          "id": "id1"
        }},
        {"sys": {
          "type": "Link",
          "linkType": "Asset",
          "id": "id2"
        }}...
      ]
    }
```
