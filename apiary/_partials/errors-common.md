Whenever something goes wrong with an API request, the server returns an error. An HTTP status code indicates the error type, with further details in the response body, which is a JSON resource.

Errors share the same common attributes as other API resources. They have a `sys` property, where `sys.type` is always `"Error"` and a `sys.id` that identifies the exact error code (see table below) that occurred. They always have a `message` property which will be a short description of what went wrong.

Errors resulting from bad input (such as `ValidationFailed` errors) contain a `details` property. This property is structured data that indicates more precisely what was wrong with the input.

### Shared error types

HTTP Status Code |Error Code       |Description
-------------------|-----------------|----------------------------------------------------------------------------------
`400`|`BadRequestError`|The request was malformed or missing a required parameter.
`400`|`InvalidQueryError`|The request contained invalid or unknown query parameters.
`401`|`AccessTokenInvalidError`|The authorization token was invalid.
`403`|`AccessDeniedError`|The user tried to access a resource that they do not have access to. This could include a missing role.
`404`|`NotFoundError`|The requested resource or endpoint could not be found.
`422`|`ValidationFailedError`|The triggered query references an invalid field.
`429`|`RateLimitExceededError`|The user sends too many requests per second.
`500`|`ServerError`|Something went wrong on our end.
`502`|`AccessDeniedError`|The space has not been used for a long time and has been hibernated, it will reappear if the user begins to use it again.
