---
page: :docsFieldTypes
---

#Overview

All data in Contentful has a field type, which is defined in the [creation of a content type](https://www.contentful.com/developers/docs/references/content-management-api/#/reference/content-types/create-a-content-type). 

Field types have a JSON Primitive (data type) and a name (describes how it is used in Contentful).

Here is the complete table of field types:


Name   |JSON Primitive|Description|Example
-------|--------------|-----------|------------
Symbol<sup>1</sup> |String        |Basic list of characters. Maximum length is 256.| "The title"
Text<sup>2</sup>   |String        |Same as Symbol, but filterable via Full-Text Search. Maximum length is 50,000.|" This is a post and ..."
Integer|Number        |Number type without decimals. Values from  -2^53 to 2^53. | 42
Number |Number        |Number type with decimals. | 3.14
Date<sup>3</sup>  |String        |Date/Time in ISO-8601 format. | 2015-11-06T09:45:27
Boolean|Boolean       |Flag, `true` or `false` | true
Link   |Object        |See [Links](https://www.contentful.com/developers/docs/concepts/links/) | -
Array  |Array         |List of values. Value type depends on `field.items.type`. |["name1", "name2", ...]
Object |Object        |Arbitrary Object. | `fields.file.details`

Observations:

1. **Symbol**: fields do not support the `match` operator for full-text searching within the field value

2. **Text**: fields do not support ordering or strict equality

3. **Date**: fields must be ISO8601 formatted, but do not require a time portion