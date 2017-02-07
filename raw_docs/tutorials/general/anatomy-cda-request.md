---
page: :docsAnatomyCDARequest
name: Anatomy of a CDA Request
title: Anatomy of a CDA Request
metainformation: 'This article goes into detail about how the requests and responses work using the CDA.'
slug: null
tags:
  - API
  - Request
  - Advanced
nextsteps: null
---

## Overview

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

This article goes into detail about how the requests and responses work using the CDA. If you want to keep it simple, you can use the SDKs we're offering for the most popular [programming languages](/developers/docs/#libraries). But if you want to know exactly how the API works, this page is for you.

To get started, for every request, clients [need to provide an access token](/developers/docs/references/authentication/), which is created per space and used to delimit audiences and content classes.

You can create an access token using the [Contentful web app](https://be.contentful.com/login) or the [Content Management API](/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key)

In a request, `access_token` may be provided as a query parameter `access_token=$token` or a HTTP header `Authorization: Bearer $token`. Still, header-based authorization is preferred in most cases.

In this article, we will focus on retrieving entries, which are documents (e.g. blog posts, events) contained within a space (similar to a database) and based on a content type (describes fields of entries).

In each returned entry, it will be fetched a `sys` property, which is an object containing system managed metadata. It retrieves essential information about a resource, such as `sys.type` and `sys.id`.

Finally, retrieved entries also have a `field` object, which is used to assign values to content type fields.

## Pre-requisites

In this tutorial, it is assumed you have understood the basic Contentful data model as described above and in the [developer center](/developers/docs/concepts/data-model/).

You should also be able to recognize the basic structure of JSON responses and requests of REST APIs.

## Requesting a single entry

In order to retrieve a specific entry, the request should include a `space_id`, `entry_id` and `access_token`. Note that you only need to provide `space_id` and the space itself does not have to be retrieved. In the following request, we will retrieve a blog post entry with `id=O1ZiKekjgiE0Uu84oKqaY` from the space `mo94git5zcq9`:

~~~ bash
# Request with access_token as a query parameter
curl -v https://cdn.contentful.com/spaces/mo94git5zcq9/entries/O1ZiKekjgiE0Uu84oKqaY?access_token=b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb

# Request with access_token as a header
curl -v https://cdn.contentful.com/spaces/mo94git5zcq9/entries/O1ZiKekjgiE0Uu84oKqaY -H 'Authorization: Bearer b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb'
~~~

In the response, the entry `O1ZiKekjgiE0Uu84oKqaY` is retrieved alongside two objects: `sys`, describing system properties of the entry, and `fields`, assigning specific values to fields (`title`,`body`,`image`) of its content type (`Blog Post`):

~~~ json
{

# The following object retrieves common system properties of the Entry
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

# The following object retrieves a list of fields that belongs to the retrieved entry
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

## Retrieving all entries of a space

Similar to our previous example, we need to provide a `space_id` and `access_token`. However, it is necessary to state whether our response should include items that are linked to our entries.

In that way, we need to specify the number of levels we want to resolve using the `include` parameter. In this first example, we will only retrieve entries, so we must set `include=0`:

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

# The following array retrieves the entire structure of each entry of our space
# Each retrieved entry follows the same structure (sys and fields objects)
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

Although these entries contain links to other resources, the content of the linked items is not included in the response, just an object that specifies the link target.

## Fetching linked resources

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

  # The following array will retrieve entries that only match the query parameters
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

# Because we have specified `include=1`, linked resources that haven't matched query parameters will be put inside the includes array, as seen below:
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

This a simple usage of links, for more advanced uses visit the [links reference page](/developers/docs/concepts/links/).

{:.note}
**Note:** When omitted, the `include` parameter takes the standard value of `1`

## Conclusion

In this article, we have exposed the structure of CDA requests and responses by showing you how to:

1. Retrieve a single entry
2. Retrieve all entries of a space
3. Retrieve all entries and their linked resources

In the first example, we've uncovered the general structure of requests and responses and what parameters should be used.

In the last two examples, we've seen the importance of the `include` parameter while retrieving entries with linked resources.

In the next article, we will expose features and details of the Content Management API.
