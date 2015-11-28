## Collection Resources and Pagination

Collections of resources are returned in a wrapper object that contains additional information useful for pagination over large result sets:

```json
{
  "sys": { "type": "Array" },
  "skip": 0,
  "limit": 100,
  "total": 1256,
  "items": [ /* 100 individual resources */ ]
}
```

In the above example, a client would get the next 100 resources by repeating their request with the `skip` query parameter set to `100`. Keep in mind that you should use the `order` parameter when paging through larger result sets, for example `order=sys.createdAt`.
