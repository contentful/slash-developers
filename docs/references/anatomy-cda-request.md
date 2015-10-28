---
page: :docsAnatomyCDARequest
---

# Overview

Contentful's Delivery API(CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

In every request, clients need to provide an access token, which is created per Space and used to delimit audiences and content classes. In a request, `access_token` may be provided as a query parameter `access_token=$token` or a HTTP header `Authorization: Bearer $token`.

In this article, we will focus on retrieving Entries, which are documents(e.g., Blog Posts, Events) contained within a Space(similar to a database) and based on a Content Type(describes fields of Entries). 

In each returned Entry, it will be fetched a `sys` property, which is an object containing system managed metadata. It retrieves essential information about a resource, such as `sys.type` and `sys.id`. 

Finally, retrieved Entries also have a `field` array, which is used to assign values to Content Type fields.


