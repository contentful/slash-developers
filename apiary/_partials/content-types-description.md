Content types are a schema that define the fields of content entries. Every entry can only contain values in the fields defined by its content type, and the values of those fields must match the data type defined in the content type. There's a limit of **50** fields per content type.

Content type properties:

Field       |Type        |Description
------------|------------|----------------------------------------------------------
sys         |Sys         |Common system properties.
name        |String      |Name of the content type.
description |String      |Description of the content type.
fields      |\[Field\]   |List of fields.
displayField|String      |ID of main field used for display.

Each field in the content type describes a single allowed field value of an entry:

Field      |Type          |Description
-----------|--------------|-------------------------------------------
id         |String        |The `id` of a field corresponds to a key in the `fields` property of entries with this content type. It must be unique among all fields in the content type.
name       |String        |The `name` of the field is the human readable label used for this field in the Contentful web app.
type       |String        |The `type` of the field determines what data you can store here, as well was what query operations you can perform with this field. See below for more details.
items      |Schema        | Defines a subschema for the elements of an array field. Required when `type` is `"Array"`.
required   |Boolean       |Describes whether the field is mandatory.
localized  |Boolean       |Describes whether the field will support different values for different locales.
disabled   |Boolean       |Describes whether the field is disabled. Disabled fields are hidden in the Contentful web app.
omitted    |Boolean       |If set to `true` fully omits this field in the Content Delivery API and Preview API responses. The Content Management API is not affected by this.

All data in Contentful has a field type, defined in the [creation of a content type](https://www.contentful.com/developers/docs/references/content-management-api/#/reference/content-types/create-a-content-type).

Each field type corresponds to a JSON type, though there are more field types than JSON types.


Name   |JSON Type|Description|Example
-------|--------------|-----------|------------
Symbol |String        |Basic list of characters. Maximum length is 256.| `"The title"`
Text<sup>1</sup>   |String        |Same as symbol, but filterable via full-text search. Maximum length is 50,000.| `" This is a post and ..."`
Integer|Number        |Number type without decimals. Values from  -2<sup>53</sup> to 2<sup>53</sup>. | `42`
Number |Number        |Number type with decimals. | `3.14`
Date<sup>2</sup>  |String        |Date/time in ISO 8601 format. | `"2015-11-06T09:45:27"`
Boolean|Boolean       |Flag, `true` or `false` | true
Location|Object        |A geographic location specified in latitude and longitude. | `{"lat":"52.5018616","lon":"13.4112619"}`
Link   |Object        |A reference to an entry or asset. The type of the referenced item is defined by the `linkType` property. See [links](https://www.contentful.com/developers/docs/concepts/links/) for more information| `{"sys": {"type": "Link", "linkType": "Entry", "id": "af35vcx8etbtwe8xv"}}`
Array  |Array         |List of values. See **array fields** below for details on what types of values can be stored in an array. |`["name1", "name2", ...]`
Object |Object        |Arbitrary Object. | `{"somekey": ["arbitrary", "json"]}"`

1. **Text**: fields do not support ordering or strict equality

2. **Date**: fields must be ISO8601 formatted, but do not require a time portion

#### Array fields

Contentful supports fields that contain multiple values with its `Array` type. An array can contain symbols (strings up to 256 characters), **or** [links](/developers/docs/concepts/links/) to other entries or assets. The allowed values in the array are defined by the `items` property of the field definition. The maximum allowed number of items in an array is 1000.

Contentful defines a field that contains symbols like this:

```json
{
  "id": "tags",
  "type": "Array",
  "items": { "type": "Symbol" }
}
```

Contentful defines a field that contains an array of links like this:

```json
{
  "id": "relatedImages",
  "type": "Array",
  "items": { "type": "Link", "linkType": "Asset" }
}
```

A reference field represents linked items like the following:

```json
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
