---
page: :docsErrors
---

Whenever something goes wrong with an API request, the server produces an error. The error message contains an appropriate HTTP status code in the header and a JSON response in the body. The `sys` part of the JSON describes the error details.

The `sys.type` will always be *Error*, and the `sys.id` identifies the precise error that has occurred. The error messages sometimes include more details about the error.

## Error types

The API has a set of well-defined errors that it responds with if something didn't work out.

{:.table}
HTTP Status Code   |Error Code       |Description
-------------------|-----------------|--------------------------------------
`400 Bad Request`  |`BadRequestError`|The request was malformed or it is missing a required parameter.
`400 Invalid query`|`InvalidQueryError`|The request contained invalid or unknown query parameters.
`401 Unauthorized` |`AccessTokenInvalidError`|The authorization token was invalid.
`403 Access Denied`|`AccessDeniedError`|The user tried to access a resource that they do not have access to. This could include a missing role.
`404 Not Found`|`NotFoundError`|The requested resource or endpoint could not be found.
`409 Version Mismatch`|`VersionMismatchError`|This error happens when you're trying to update an existing asset, entry or content type, and you either didn't specify the current version of the object or specify an outdated version.
`422 Validation Error`|`ValidationFailedError`|The request payload was a valid JSON, but something was wrong with the data. Check the error details field – it should provide more specific information about the error.
`422 Unknown Field`|`ValidationFailedError`|The triggered query references an invalid field.
`422 Invalid Entry`| `InvalidEntryError`|The entered value is invalid.
`429 Rate Limit Exceeded Error`|`RateLimitExceededError`|The user sends too many requests per second.
`500 Server Error`|`ServerError`|Something went wrong on our end.
`502 Hibernated`|`AccessDeniedError`|The space has not been used for a long time and hence it has been hibernated, but it will reappear if the user begins using it again.
