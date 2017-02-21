## NodeJS

```javascript
var contentful = require('contentful')
var client = contentful.createClient({
  space: '<space_id>',
  accessToken: '<access_token>'
})
```

## JavaScript

Run the following command in your terminal:

```javascript

```

## Ruby

```ruby
client = Contentful::Client.new(
  access_token: '<access_token>',
  space: '<space_id>'
)
```

## Python

```python
entries = client.entries()
```

## .Net

```csharp
var httpClient = new HttpClient();
var options = new ContentfulOptions()
{
    DeliveryApiKey = "<access_token>",
    SpaceId = "<space_id>"
}
var client = new ContentfulClient(httpClient, options);
```

## PHP

```php
$client = new \Contentful\Delivery\Client('<access_token>', '<space_id>');
```

## Objective-C

```objective-c
CDAClient* client = [[CDAClient alloc] initWithSpaceKey:@"<space_id>" accessToken:@"<access_token>"];
```

## Swift

```swift
let client = Client(spaceIdentifier: "<space_id>", accessToken: "<access_token>")
```

## Java

```java
CDAArray array = client.fetch(CDAEntry.class).all();
```

## Android

```java
CDAClient client = CDAClient.builder()
    .setSpace("<space_id>")
    .setToken("<access_token>")
    .build();
```
