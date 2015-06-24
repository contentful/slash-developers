## HTTP Details of the Contentful APIs

### Security

The Content Delivery API and Content Preview API are fully available via SSL:
Both JSON data and Assets should be requested through a secure transport.

Our client libraries enable SSL by default. Unless there is a reason to 
disable SSL you should leave it enabled to ensure maximum privacy for clients.

The Content Management API is only available via SSL,
all requests must be performed using the `https:` protocol.

Using SSL ensures that the entire content and access tokens of a Space remain secure
and can not be intercepted by potential eavesdroppers.

### Cross-origin resource sharing

[CORS (Cross-origin resource sharing)](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
allows JavaScript web apps to make HTTP requests to other domains.
This is very important for third party web apps using Contentful:
Without CORS, a JS app on https://example.com couldn't access the
Content Management or the Content Delivery API because they're on
contentful.com which is a different domain.
In short, without CORS it wouldn't be possible to easily access
Contentful's APIs from a third party web app.

To allow JavaScript applications running inside browsers to freely
interact with our APIs we're setting the following HTTP response headers:

- `Access-Control-Allow-Origin`: `*`
- `Access-Control-Allow-Headers`: A long list of common headers
- `Access-Control-Allow-Methods`: Common HTTP verbs
- `Access-Control-Max-Age`: Reasonably high to avoid preflight requests

This should allow web apps to do whatever the user has given them
permission for.

Note: Allowing all origins is safe because of the way the APIs are designed:

- All requests must include an access token in the query string or as
header for every request. They will never be sent implicitly by a cookie.
- Destructive requests can only be issued against the HTTPS endpoint.

CORS is [supported by all modern browsers](http://caniuse.com/cors).
Read how to use CORS in this [HTML5 rocks tutorial on CORS](http://www.html5rocks.com/en/tutorials/cors/).

### Encoding

JSON is encoded in UTF-8.

### ETag/If-None-Match

The API support conditional GET-requests via ETag & If-None-Match headers:

Every API response (both single resources and searches) includes an `ETag` header.
The `ETag` header changes depending on the content of the response:
If something is updated or a search result changes in some way the ETag also changes.
But if nothing changes the ETag also stays the same.

To avoid unnecessary transfers you can set the `If-None-Match` header of an
API request to a the `ETag` previously received for the same API request.

If the content hasn't changed in the meantime the API will respond with a
short 304 Not Modified response. This makes quite a difference for large responses
and especially binary files.

### GZip Compression

All API endpoints support GZip compression to save valuable bandwidth.
Please take into account that enabling compression will also put more load on your clients' processors.

## JSON Format Details

Resources are represented as [JSON](http://json.org).

### Date & Time Format

Dates and times are an important part of all content.
Let's look at an Entry:

~~~json

    {
      "sys": {
        "type": "Entry",
        "id": "nyancat",
        "createdAt": "2013-05-01T08:00:00Z",
        "updatedAt": "2013-05-02T13:00:00Z"
      }
    }

~~~

Here we can see a few dates and times in both the content and the [system properties](#system-properties):

- Nyan Cat's birthday is April 2nd 2011
- Nyan Cat's meal time is 13:00
- The nyancat entry has been created May 1st 2013 at 08:00
- The nyancat entry has been updated May 2nd 2013 at 13:00

In JSON date and time are always represented as [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601)-encoded string.

System-generated dates are represented as UTC.

<!-- TODO: Check which exact formats or parts of ISO 8601 we support. -->
