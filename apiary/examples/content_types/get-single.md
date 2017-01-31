```java
CDAArray array = client.fetch(CDAContentType.class)
  .one('<content_type_id>');
```

```objc
[self.client fetchContentTypeWithIdentifier:@"<content_type_id>" success:^(CDAResponse* response, CDAContentType* contentType) {}];
```

```swift
self.client.fetchContentType(identifier: "<content_type_id>") { (result: Result<ContentType>) in
    // Handle result
}
```

```javascript
client.getContentType('<content_type_id>')
  .then(contentType => console.log(contentType))
```

```php
$contentType = $this->client->getContentType('<content_type_id');
```

```ruby
contentType = client.contentType(<content_type_id>)
```

```python
content_type = client.content_type('<content_type_id>')
```

```csharp
var contentType = await _client.GetContentTypeAsync("<content_type_id>");
```
