Content Types are schemas that define the fields of Entries. Every Entry can
only contain values in the fields defined by it's Content Type, and the values
of those fields must match the data type defined in the Content Type.

Content Type properties:

Field       |Type        |Description
------------|------------|----------------------------------------------------------
sys         |Sys         |Common system properties.
name        |String      |Name of the Content Type.
description |String      |Description of the Content Type.
fields      |\[Field\]   |List of Fields.
displayField|String      |ID of main Field used for display.

Each Field in the Content Type describes a single allowed field value of an Entry:

Field      |Type          |Description
-----------|--------------|-------------------------------------------
id         |String        |The `id` of a field corresponds to a key in the `fields` property of entries with this Content Type. It must be unique among all fields in the content type.
name       |String        |The `name` of the field is the human readable label that will be used for this field in the Contentful web application.
type       |String        |The `type` of the field determines what data can be stored here, as well was what query operations you can perform with this field. See below for more details.
items      |Schema        | Defines a subschema for the elements of an array field. This is required when `type` is `"Array"`.
required   |Boolean       |Describes whether the Field is mandatory.
localized  |Boolean       |Describes whether the Field will support different values for different locales.
disabled   |Boolean       |Describes whether the Field is disabled. Disabled fields are hidden in the editing application.

All data in Contentful has a field type, which is defined in the [creation of a content type](https://www.contentful.com/developers/docs/references/content-management-api/#/reference/content-types/create-a-content-type). 

Each field type corresponds to a JSON type, though there are more field types than JSON types.


Name   |JSON Type|Description|Example
-------|--------------|-----------|------------
Symbol<sup>1</sup> |String        |Basic list of characters. Maximum length is 256.| `"The title"`
Text<sup>2</sup>   |String        |Same as Symbol, but filterable via Full-Text Search. Maximum length is 50,000.| `" This is a post and ..."`
Integer|Number        |Number type without decimals. Values from  -2^53 to 2^53. | `42`
Number |Number        |Number type with decimals. | `3.14`
Date<sup>3</sup>  |String        |Date/Time in ISO-8601 format. | `"2015-11-06T09:45:27"`
Boolean|Boolean       |Flag, `true` or `false` | true
Location|Object        |A geographic location specified in latitude and longitude. | `{"lat":"52.5018616","lon":"13.4112619"}`
Link   |Object        |A reference to an entry or asset. The type of the referenced item is defined by the `linkType` property. See [links](https: //www.contentful.com/developers/docs/concepts/links/) for more information| `{"sys": {"type": "Link", "linkType": "Entry", "id": "af35vcx8etbtwe8xv"}}`
Array  |Array         |List of values. See **Array fields** below for details on what types of values can be stored in an array. |`["name1", "name2", ...]`
Object |Object        |Arbitrary Object. | `{"somekey": ["arbitrary", "json"]}"`

1. **Symbol**: fields do not support the `match` operator for full-text searching within the field value

2. **Text**: fields do not support ordering or strict equality

3. **Date**: fields must be ISO8601 formatted, but do not require a time portion

#### Array fields

Contentful supports fields that contain multiple values with it's `Array` type. Currently an array can contain either symbols (strings up to 256 characters), **or** [links](/developers/docs/concepts/links/) to other entries or assets. The allowed values in the array are defined by the `items` property of the field definition.

A field that contains symbols is defined like this:

```
{
  "id": "tags",
  "type": "Array",
  "items": { "type": "Symbol" }
}
```

And a field containing an array of links to assets is defined like this:

```
{
  "id": "relatedImages",
  "type": "Array",
  "items": { "type": "Link", "linkType": "Asset" }
}
```
