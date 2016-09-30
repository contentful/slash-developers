---
page: ':docsSelectOperator'
---

# temp

The `select` operator is a powerful Query parameter you can use to selectively load the content you want to display in your app, instead of loading entire entries. This reduces network and memory impact as you can request exactly the data you need.

Create a new space using the 'Product Catalogue' example and wait for the default content to import.

![Import Examples](import-example.png)

To use the `select` operator, append it to your call to retrieve entries, with a comma seperated list of fields you want, for example:

```
https://cdn.contentful.com/spaces/<space_id>/entries/?select=sys.id,fields.productName&content_type=<content_type_id>
```

Instead of returning all fields, this will just return the fields requested.

```

```

## Android

Clone the Contentful Android product cataligue app to your local machine and configure the _Const.java_ file to match your space, API key and content types.
