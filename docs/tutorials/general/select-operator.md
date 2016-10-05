---
page: :docsSelectOperator
---

# temp

The `select` operator is a powerful query parameter you can use to selectively load the content you want to display in your app, instead of loading entire entries. Combined with other parameters, this gives you more flexibility in managing and querying your content models. It also helps you reduce network and memory impact as you can more precisely request the data you need.

This tutorial will show some of the ways you can use the operator, using the 'Product Catalogue' example you can load into any space for experimentation.

![Import Examples](import-example.png)

## Choosing fields

To use the `select` operator, append it to your call to retrieve entries, with a comma separated list of fields you want, for example:

```bash
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

## Including and excluding objects

Only fetching one of the objects contained within a request will exclude the other, and fetching the entire `sys` or `fields` object will return all it's sub-fields. For example to omit the `sys` object from a request:

```bash
https://cdn.contentful.com/spaces/<space-id>/entries/?select=fields&content_type=<content_type_id>
```

## Assets

You can use the operator with assets in your space in the same way. For example, to fetch the names of assets:

```bash
https://cdn.contentful.com/spaces/<space-id>/assets?select=fields.title
```

Will return:

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
      "fields": {
        "title": "City Street"
      }
    },
    {
      "fields": {
        "title": "Janine"
      }
    },
    {
      "fields": {
        "title": "Celebration"
      }
    },
    {
      "fields": {
        "title": "Golden Gate Bridge"
      }
    },
    {
      "fields": {
        "title": "The world on a digital screen"
      }
    },
    {
      "fields": {
        "title": "Air Baloon"
      }
    },
    {
      "fields": {
        "title": "The Flower"
      }
    }
  ]
}
```

## The preview API

The `select` operator also works with the preview API for your draft and unpublished content. For example:

```bash
https://preview.contentful.com/spaces/<space_id>/entries?access_token=<access_token>&content_type=<content_type_id>&select=fields.productName
```

Will return the same result structure as above.

## Work with the content you want

The `select` operator is one of the ways we plan to make working with the content you want easier. Our SDKs will support the feature soon, as with other APIs and endpoints.
