---
page: :docsErrors
name: Errors
title: Errors
metainformation: 'When something goes wrong with an API request, our server generates an error. The error message contains an appropriate HTTP status code in the header and a JSON response in the body.'
slug: null
tags:
 - Reference
 - Errors
nextsteps:
  - text: Details of our HTTP transport
    link: /developers/docs/references/http-details/
---

When something goes wrong with an API request, our server generates an error. The error message contains an appropriate HTTP status code in the header and a JSON response in the body.

Errors share the same common attributes as other API resources. They have a `sys` property, where `sys.type` is always `"Error"` and a `sys.id` that identifies the exact error code (see table below) that occurred. They always have a `message` property which will be a short description of what went wrong.

Errors resulting from bad input (such as `ValidationFailed` errors) contain a `details` property. This property is structured data that indicates more precisely what was wrong with the input.

## Error types

{:.table}
HTTP status code |Error code |Description
-------------------|-----------------|--------------------------------------
`400 Bad Request` |`BadRequestError`|The request was malformed or missing a required parameter.
`400 Invalid query`|`InvalidQueryError`|The request contained invalid or unknown query parameters.
`401 Unauthorized` |`AccessTokenInvalidError`|The authorization token was invalid.
`403 Access Denied`|`AccessDeniedError`|The user tried to access a resource they do not have access to. This could include a missing role.
`404 Not Found`|`NotFoundError`|The requested resource or endpoint could not be found.
`409 Version Mismatch`|`VersionMismatchError`|This error occurs when you're trying to update an existing asset, entry or content type, and you didn't specify the current version of the object or specify an outdated version.
`422 Validation Error`|`ValidationFailedError`|The request payload was valid JSON, but something was wrong with the data. The error details should provide more specific information about the error.
`422 Unknown Field`|`ValidationFailedError`|The triggered query references an invalid field.
`422 Invalid Entry`| `InvalidEntryError`|The entered value is invalid.
`429 Rate Limit Exceeded Error`|`RateLimitExceededError`|The user sent too many requests per second.
`500 Server Error`|`ServerError`|Something went wrong on the Contentful servers.
`502 Hibernated`|`AccessDeniedError`|The space has not been used for a long time and was hibernated. It will become active again if the user begins using it.
