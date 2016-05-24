## Collection resources and pagination

Collections of resources are returned in a wrapper object that contains additional information useful for pagination over large result sets:

```
{
  "sys": { "type": "Array" },
  "skip": 0,
  "limit": 100,
  "total": 1256,
  "items": [ /* 100 individual resources */ ]
}
```

In the above example, a client would get the next 100 resources by repeating the same request with the `skip` query parameter changed to `100`. The `order` parameter, for example `order=sys.createdAt`,
should be used when paging through larger result sets to keep ordering predictable.
