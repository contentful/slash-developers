---
page: ':docsSelectOperator'
---

# temp

The `select` operator is a powerful query parameter you can use to selectively load the content you want to display in your app, instead of loading entire entries. Combined with other parameters, this gives you more flexibility in managing and querying your content models. It also helps you reduce network and memory impact as you can more precisely request the data you need.

This tutorial will show some of the ways you can use the operator, using the 'Product Catalogue' example you can load into any space for experimentation.

![Import Examples](import-example.png)

To use the `select` operator, append it to your call to retrieve entries, with a comma seperated list of fields you want, for example:

```
https://cdn.contentful.com/spaces/<space_id>/entries/?select=fields.productName&content_type=<content_type_id>
```

Instead of returning all fields, this will return the fields requested and metadata about the results.

```json
{
  "sys": {
    "type": "Array"
  },
  "total": 4,
  "skip": 0,
  "limit": 100,
  "items": [
    {
      "fields": {
        "productName": "Whisk Beater"
      }
    },
    {
      "fields": {
        "productName": "SoSo Wall Clock"
      }
    },
    {
      "fields": {
        "productName": "Hudson Wall Cup"
      }
    },
    {
      "fields": {
        "productName": "Playsam Streamliner Classic Car, Espresso"
      }
    }
  ]
}
```

Contentful already has fields that you can hide from the JSON output, but if you had fields you wanted to selectively hide and show depending on the platform, you had to retrieve them anyway and not display them, or maintain different content models for different purposes.

The `select` operator now allows you to use the same content types for different platforms and instead selectively load the relevant fields for each application use case.

Only fetching one of the objects contained within a request will exclude the other, and fetching the entire `sys` or `fields` object will return all it's sub-fields. For example to omit the `sys` object from a request:

```bash
/spaces/<space-id>/entries/?select=fields&content_type=<content_type_id>
```
