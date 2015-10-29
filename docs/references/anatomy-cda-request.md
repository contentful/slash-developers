---
page: :docsAnatomyCDARequest
---

## Overview

Contentful's Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

This article goes into detail about the how requests and responses work using the CDA. Our official [SDKs](/developers/docs/code/libraries/) should free you from all of these details, but if you want to know exactly how the API works, this page is for you.

To get started, for every request, clients need to provide an access token, which is created per Space and used to delimit audiences and content classes. In a request, `access_token` may be provided as a query parameter `access_token=$token` or a HTTP header `Authorization: Bearer $token`.

In this article, we will focus on retrieving Entries, which are documents (e.g. Blog Posts, Events) contained within a Space (similar to a database) and based on a Content Type (describes fields of Entries). 

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

In the response, the Entry `O1ZiKekjgiE0Uu84oKqaY` is retrieved alongside two arrays: `sys`, describing system properties of the Entry, and `fields`, assigning specific values to fields (`title`,`body`,`image`) of its Content Type (`Blog Post`):

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

## Retrieving all Entries of a Space

Similar to our previous example, we need to provide a `space_id` and `access_token`. However, it is necessary to state whether our response should include items that are linked to our Entries. 

In that way, we need to specify the number of levels we want to resolve using the `include` parameter. In this first example, we will only retrieve Entries, so we must set `include=0`: 

~~~ bash
# Request with access_token as a query parameter
curl -v https://cdn.contentful.com/spaces/mo94git5zcq9/entries?access_token=b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb&include=0

# Request with access_token as a header
curl -v https://cdn.contentful.com/spaces/mo94git5zcq9/entries?include=0 -H 'Authorization: Bearer b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb'
~~~

### Response
~~~ json
{
  "sys": {
    "type": "Array"
  },
  "total": 3,
  "skip": 0,
  "limit": 100,
  "items": [
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
    },
    {
      "fields": {
        "title": "Explore the Universe!",
        "body": "We live in an awesome universe and...",
        "image": {
          "sys": {
            "type": "Link",
            "linkType": "Asset",
            "id": "1ruXfeZDqckgOEUKMYsEqQ"
          }
        }
      },
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
        "id": "6NX8Kkd9ZYS6igQQMyuC2O",
        "revision": 1,
        "createdAt": "2015-10-26T14:34:57.606Z",
        "updatedAt": "2015-10-26T14:34:57.606Z",
        "locale": "en-US"
      }
    },
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
        "id": "5v10yZCONUS044UUgiqaO4",
        "revision": 1,
        "createdAt": "2015-10-26T15:43:21.233Z",
        "updatedAt": "2015-10-26T15:43:21.233Z",
        "locale": "en-US"
      },
      "fields": {
        "title": "Comfortably alone in the Universe",
        "body": "Given that the Universe is 13.7 billion years old this other life-form is unlikely to be a mere few hundred years ahead or behind. There is a good ...",
        "image": {
          "sys": {
            "type": "Link",
            "linkType": "Asset",
            "id": "5hzXG3eLtKqOM4CAisuCS6"
          }
        },
        "relatedPosts": [
          {
            "sys": {
              "type": "Link",
              "linkType": "Entry",
              "id": "O1ZiKekjgiE0Uu84oKqaY"
            }
          }
        ]
      }
    }
  ]
}
~~~

As you can see, the response is limited to the array `items` which include the Entries `O1ZiKekjgiE0Uu84oKqaY`, `5v10yZCONUS044UUgiqaO4` and `6NX8Kkd9ZYS6igQQMyuC2O`.

Although these Entries contain Links to other resources, the content of the linked items is not included in the response, just an object that specifies the link target.

## Fetching Linked Resources

Similar to our previous queries, we need to specify our `space_id` and `access_token`. However, as we need to fetch linked resources, we're going to set `include=1`, resolving `1` level of included resources:

~~~ bash
# Response with access_token as a query parameter
curl -v https://cdn.contentful.com/spaces/mo94git5zcq9/entries?access_token=b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb&include=1

# Response with access_token as a header
curl -v https://cdn.contentful.com/spaces/mo94git5zcq9/entries?include=1 -H 'Authorization: Bearer b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb'
~~~

Similar to our previous example, the array `items` will retrieve results matching our query: 

~~~ json
  "sys": {
    "type": "Array"
  },
  "total": 3,
  "skip": 0,
  "limit": 100,
  "items": [
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
    },
    {
      "fields": {
        "title": "Explore the Universe!",
        "body": "We live in an awesome universe and...",
        "image": {
          "sys": {
            "type": "Link",
            "linkType": "Asset",
            "id": "1ruXfeZDqckgOEUKMYsEqQ"
          }
        }
      },
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
        "id": "6NX8Kkd9ZYS6igQQMyuC2O",
        "revision": 1,
        "createdAt": "2015-10-26T14:34:57.606Z",
        "updatedAt": "2015-10-26T14:34:57.606Z",
        "locale": "en-US"
      }
    },
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
        "id": "5v10yZCONUS044UUgiqaO4",
        "revision": 1,
        "createdAt": "2015-10-26T15:43:21.233Z",
        "updatedAt": "2015-10-26T15:43:21.233Z",
        "locale": "en-US"
      },
      "fields": {
        "title": "Comfortably alone in the Universe",
        "body": "Given that the Universe is 13.7 billion years old this other life-form is unlikely to be a mere few hundred years ahead or behind. There is a good ...",
        "image": {
          "sys": {
            "type": "Link",
            "linkType": "Asset",
            "id": "5hzXG3eLtKqOM4CAisuCS6"
          }
        },
        "relatedPosts": [
          {
            "sys": {
              "type": "Link",
              "linkType": "Entry",
              "id": "O1ZiKekjgiE0Uu84oKqaY"
            }
          }
        ]
      }
    }
  ],
~~~

However, we have specified `include=1`, so linked resources that still haven't matched our query parameters will be put inside the `includes` array, as seen below:

~~~ json

"includes": {
    "Asset": [
      {
        "fields": {
          "file": {
            "fileName": "space.jpg",
            "contentType": "image/jpeg",
            "details": {
              "image": {
                "width": 640,
                "height": 436
              },
              "size": 31934
            },
            "url": "//images.contentful.com/mo94git5zcq9/1Idbf0HVsQeYIC0EmYgiuU/9bc136bcb082d8c1d845c3ecd1684a75/space.jpg"
          },
          "title": "space9"
        },
        "sys": {
          "space": {
            "sys": {
              "type": "Link",
              "linkType": "Space",
              "id": "mo94git5zcq9"
            }
          },
          "type": "Asset",
          "id": "1Idbf0HVsQeYIC0EmYgiuU",
          "revision": 2,
          "createdAt": "2015-10-26T14:32:25.146Z",
          "updatedAt": "2015-10-26T14:34:13.333Z",
          "locale": "en-US"
        }
      },
      {
        "fields": {
          "file": {
            "fileName": "space.jpg",
            "contentType": "image/jpeg",
            "details": {
              "image": {
                "width": 1920,
                "height": 1080
              },
              "size": 585159
            },
            "url": "//images.contentful.com/mo94git5zcq9/5hzXG3eLtKqOM4CAisuCS6/56963118d9d83d0dc0b44639d116561f/space.jpg"
          },
          "title": "space5"
        },
        "sys": {
          "space": {
            "sys": {
              "type": "Link",
              "linkType": "Space",
              "id": "mo94git5zcq9"
            }
          },
          "type": "Asset",
          "id": "5hzXG3eLtKqOM4CAisuCS6",
          "revision": 2,
          "createdAt": "2015-10-26T14:32:44.137Z",
          "updatedAt": "2015-10-26T14:33:40.925Z",
          "locale": "en-US"
        }
      },
      {
        "fields": {
          "file": {
            "fileName": "space.jpg",
            "contentType": "image/jpeg",
            "details": {
              "image": {
                "width": 640,
                "height": 267
              },
              "size": 54850
            },
            "url": "//images.contentful.com/mo94git5zcq9/1ruXfeZDqckgOEUKMYsEqQ/5c570c823460809eec2b7fb643fe3cfa/space.jpg"
          },
          "title": "space10"
        },
        "sys": {
          "space": {
            "sys": {
              "type": "Link",
              "linkType": "Space",
              "id": "mo94git5zcq9"
            }
          },
          "type": "Asset",
          "id": "1ruXfeZDqckgOEUKMYsEqQ",
          "revision": 2,
          "createdAt": "2015-10-26T14:32:16.763Z",
          "updatedAt": "2015-10-26T14:34:22.323Z",
          "locale": "en-US"
        }
      }
    ]
  }
~~~

Note: When omitted, the `include` parameter takes the standard value of `1`

## Conclusion

In this article, we have exposed the structure of CDA requests and responses by showing you how to:

1. Retrieve a single Entry
2. Retrieve all Entries of a Space
3. Retrieve all Entries and their linked resources 

In the first example, we've uncoved the general structure of requests and responses and what parameters should be used.

In the last two examples, we've seen the importance of the `include` parameter while retrieving Entries with linked resources. 

In the next article, we will expose features and details of Contentful's Management API (CMA).






