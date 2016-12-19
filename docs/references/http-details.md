---
page: :docsHttpDetails
name: HTTP details
title: HTTP details
metainformation: 'The Content Delivery API and Preview API are fully available via SSL. You should request JSON data and assets through a secure transport.'
slug: null
tags:
 - Reference
 - Network
nextsteps:
 - text: Details of our error messages
   link: /developers/docs/references/errors/
---

## Security

The Content Delivery API and Preview API are fully available via SSL. You should request JSON data and assets through a secure transport.

Our client libraries enable SSL by default. Unless there is a reason to disable SSL you should leave it enabled to ensure maximum privacy for clients.

The Content Management API is only available via SSL, and you must make all requests using the _https_ protocol.

Using SSL ensures that the content and access tokens of a space remain secure and that potential eavesdroppers cannot intercept your data.

## Cross-origin resource sharing

[CORS (Cross-origin resource sharing)](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) allows JavaScript web apps to make HTTP requests to other domains. This is important for third party web apps using Contentful, as without CORS, a JavaScript app hosted on _example.com_ couldn't access our APIs because they're hosted on _contentful.com_ which is a different domain.

CORS is [supported by all modern browsers](http://caniuse.com/cors). Read more about using CORS in this [tutorial](https://www.html5rocks.com/en/tutorials/cors/).

To allow JavaScript applications running inside browsers to interact with our APIs, we set the following HTTP response headers:

- `Access-Control-Allow-Origin`: `*`, or all.
- `Access-Control-Allow-Headers`: A long list of common headers, if you want to know more, [read the reference below](#allow-headers).
- `Access-Control-Allow-Methods`: HTTP verbs. Typically the request type, plus `OPTIONS` and `HEAD`.
- `Access-Control-Max-Age`: This varies depending on endpoint, but is a high value to avoid preflight requests.

{: .note}
**Note:** Allowing all origins is safe because all requests must include an access token in the query string or as header. The token will never be sent implicitly by a cookie. You can only issue destructive requests against the HTTPS endpoint.

## ETag/If-None-Match

Our APIs support conditional `GET` requests via [ETag](https://en.wikipedia.org/wiki/HTTP_ETag) and `If-None-Match` headers.

Every API response (both single resources and searches) includes an `ETag` header. The `ETag` header changes depending on the content of the response. If a resource is updated or a search result changes, the ETag also changes.

To avoid unnecessary transfers you can set the `If-None-Match` header of an API request to the `ETag` previously received for the same API request.

If the content hasn't changed in the meantime the API will respond with a 304 Not Modified response. This makes a difference for large responses and especially binary files.

## GZip compression

All API endpoints support GZip compression to save bandwidth. Please take into account that enabling compression will put more load on your clients' processors.

## JSON format details

Contentful represents resources as [JSON](http://json.org), encoded in UTF-8. Contentful represents dates and times as [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)-encoded string, with system-generated dates represented as UTC.

### Allow headers reference <a id="allow-headers"></a>

Contentful sets the following headers:

`Accept`, `Accept-Language`, `Authorization`, `Cache-Control`, `Content-Length`, `Content-Range`, `Content-Type`, `DNT`, `Destination`, `Expires`, `If-Match`, `If-Modified-Since`, `If-None-Match`, `Keep-Alive`, `Last-Modified`, `Origin`, `Pragma`, `Range`, `User-Agent`, `X-Http-Method-Override`, `X-Mx-ReqToken`, `X-Requested-With`, `X-Contentful-Version`, `X-Contentful-Content-Type`, `X-Contentful-Organization`, `X-Contentful-Skip-Transformation`, `X-Contentful-User-Agent`
