---
page: :docsAnatomyCDARequest
---

## Overview

Contentful's Delivery API(CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

In every request, clients need to provide an access token, which is created per Space and used to delimit audiences and content classes. In a request, `access_token` may be provided as a query parameter `access_token=$token` or a HTTP header `Authorization: Bearer $token`.

In this article, we will focus on retrieving Entries, which are documents(e.g., Blog Posts, Events) contained within a Space(similar to a database) and based on a Content Type(describes fields of Entries). 

In each returned Entry, it will be fetched a `sys` property, which is an object containing system managed metadata. It retrieves essential information about a resource, such as `sys.type` and `sys.id`. 

Finally, retrieved Entries also have a `field` array, which is used to assign values to Content Type fields.

## Requesting a single Entry

In order to retrieve a specific Entry, the request should include a `space_id`, `entry_id` and `access_token`. In the following request, we will retrieve a blog post Entry with `id=O1ZiKekjgiE0Uu84oKqaY` from the Space `mo94git5zcq9`:

~~~ bash
# Request with access_token as a query parameter
curl -v https://cdn.contentful.com/spaces/mo94git5zcq9/entries/O1ZiKekjgiE0Uu84oKqaY?access_token=b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb

# Request with access_token as a header
curl -v https://cdn.contentful.com/spaces/mo94git5zcq9/entries/O1ZiKekjgiE0Uu84oKqaY -H 'Authorization: Bearer b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb'
~~~

In the response, the Entry `O1ZiKekjgiE0Uu84oKqaY` is retrieved alongside two arrays: `sys`, describing system properties of the Entry, and `fields`, assigning specific values to fields(`title`,`body`,`image`) of its Content Type(`Blog Post`):

~~~ json
{
  "sys": {
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "mo94git5zcq9"
      }
    },
    "type": "Entry",
    "contentType": {
      "sys": {
        "type": "Link",
        "linkType": "ContentType",
        "id": "6tw1zeDm5aMEIikMaCAgGk"
      }
    },
    "id": "O1ZiKekjgiE0Uu84oKqaY",
    "revision": 1,
    "createdAt": "2015-10-26T14:36:22.226Z",
    "updatedAt": "2015-10-26T14:36:22.226Z",
    "locale": "en-US"
  },
  "fields": {
    "title": "The Oldest Galaxies in the Universe",
    "body": "The formation of this galaxy, and others like it, was a momentous event in cosmic evolution. This galaxy and its brethren helped to ...",
    "image": {
      "sys": {
        "type": "Link",
        "linkType": "Asset",
        "id": "1Idbf0HVsQeYIC0EmYgiuU"
      }
    },
    "relatedPosts": [
      {
        "sys": {
          "type": "Link",
          "linkType": "Entry",
          "id": "6NX8Kkd9ZYS6igQQMyuC2O"
        }
      }
    ]
  }
}
~~~




