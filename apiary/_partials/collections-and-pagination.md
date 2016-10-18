## Collection resources and pagination

Contentful returns collections of resources in a wrapper object that contains additional information useful for paginating over large result sets:

```json
{
  "sys": { "type": "Array" },
  "skip": 0,
  "limit": 100,
  "total": 1256,
  "items": [ /* 100 individual resources */ ]
}
```

In the above example, a client would get the next 100 resources by repeating the same request, changing the `skip` query parameter to `100`. Use the `order` parameter, for example `order=sys.createdAt`, when paging through larger result sets to keep ordering predictable.
