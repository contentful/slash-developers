---
page: :docsUsingJsCdaSdk
---

## Overview

Contentful's Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location by using our global CDN.

In a previously published article, we explained how requests and responses work by issuing HTTP requests directly to our API.

However, in order to makes things easier for our users, we publish SDKs for various languages which make the task easier.

This article goes into detail about how to get content using the [JavaScript CDA SDK](https://github.com/contentful/contentful.js).

To get started, for every request, clients [need to provide an access token](https://www.contentful.com/developers/docs/references/authentication/), which is created per Space and used to delimit audiences and content classes.

You can create an access token using [Contentful's Web Interface](http://app.contentful.com) or the [Content Management API](https://www.contentful.com/developers/docs/references/content-management-api/#/reference/api-keys/create-an-api-key)

In this article, we will focus on retrieving Entries, which are documents (e.g. Blog Posts, Events) contained within a Space (similar to a database) and based on a Content Type (describes fields of Entries).

In each returned Entry, it will be fetched a `sys` property, which is an object containing system managed metadata. It retrieves essential information about a resource, such as `sys.type` and `sys.id`.

Finally, retrieved Entries also have a `field` object, which is used to assign values to Content Type fields.

## Pre-requisites

In this tutorial, it is assumed you have understood the basic Contentful data model as described above and in the [Developer Center](https://www.contentful.com/developers/docs/concepts/data-model/).

## Setting up the client

First off, you need to get the SDK and use it in your project.

### In node.js

If you are running your code in node.js, all you have to do is install the npm package and require it in your code:

~~~bash
npm install contentful
~~~

~~~javascript
// main.js
var contentful = require('contentful')
~~~

### In a browser

If you are running your code in a web page, there are multiple ways you can get it ready to use.

The quickest and easiest way is to download the [pre built and minified](https://raw.github.com/contentful/contentful.js/master/dist/contentful.min.js) file from our repo.

Don't link to that url directly in your page as it is not a recommended practice by github and the file can be updated in the future, which would break your code.

Download it and use it locally.

Once you've done so, you can include it with a script tag:

~~~html
<script src="contentful.min.js"></script>
~~~

The recommended way would be to also managed your browser JavaScript code and dependencies with npm and use a build tool suck as browserify or webpack.

In that case, you'd need to first install the package:

~~~bash
npm install contentful
~~~

Then you can use it in your code

~~~javascript
// main.js
var contentful = require('contentful')
~~~

And finally build and use your file:

~~~bash
webpack main.js bundle.js
# or
browserify main.js -o bundle.js
~~~

~~~html
<script src="bundle.js"></script>
~~~

## Initializing the client

In order to be able to access your content, you need to create a client with the necessary credentials.

Having the API key you created before and the space ID, you can initialize your client:

~~~javascript
var client = contentful.createClient({
  space: 'mo94git5zcq9',
  accessToken: 'b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb'
})
~~~

See the README.md for [contentful.js](https://github.com/contentful/contentful.js) for more options.

## Requesting a single Entry

Once you have a client you can start getting content.

In order to retrieve a specific Entry, you need the entry ID for that Entry. If you're looking at an Entry you created in the user interface, it should be the string in the URL after `/entries/`. In this particular case we have an Entry read to be retrieved with the id `O1ZiKekjgiE0Uu84oKqaY`.

~~~javascript
client.entry('O1ZiKekjgiE0Uu84oKqaY')
.then(function (entry) {
  console.log(entry)
})
~~~

The object received by the Promise callback represents the Entry `O1ZiKekjgiE0Uu84oKqaY` and contains two objects: `sys`, describing system properties of the Entry, and `fields`, assigning specific values to fields (`title`,`body`,`image`) of its Content Type (`Blog Post`):

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

# The following object retrieves a list of fields that belongs to the retrieved Entry
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

You could access the content of a specific field in the following way:
~~~javascript
client.entry('O1ZiKekjgiE0Uu84oKqaY')
.then(function (entry) {
  console.log(entry.fields.title)
})
~~~


## Retrieving all Entries of a Space

Now we're going to retrieve all the entries in a space.


~~~javascript
client.entries()
.then(function (entries) {
  console.log(entries)
})
~~~

Some entries might have links to each other, so when you retrieve a list of entries, those links are automatically resolved so you don't have to go look for the linked entry separately.

By default, one level of linked entries or assets are resolved.

If you'd like to have additional levels of links resolved, or none at all, you can use the include parameter:

~~~javascript
client.entries({include: 0})
.then(function (entries) {
  console.log(entries)
})
~~~

Check the [Links Reference Page](https://www.contentful.com/developers/docs/concepts/links/) for more information on linked entries.

In the example below, one level of entries and assets are resolved.

The array will also contain the following special properties which are used for pagination purposes:

* `total` - total amount of available entries
* `skip` - entries that are skipped on the current response (offset)
* `limit` - number of entries retrieved after the skipped ones

### Response
~~~ json
[
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
      "relatedPosts": []
    }
  },
  {
    "fields": {
      "title": "Explore the Universe!",
      "body": "We live in an awesome universe and...",
      "image": {
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
      "id": "7NX8Kkd9ZYS6igQQMyuC2O",
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
      "relatedPosts": []
    }
  }
]
~~~

The entries method can also take additional parameters for filtering and querying. Check out the [JavaScript CDA SDK](https://github.com/contentful/contentful.js) page for more examples and the [Search Parameters API page](https://www.contentful.com/developers/docs/references/content-delivery-api/#/reference/search-parameters) for more information.

## Conclusion

In this article, we have shown you how to use the Contentful JavaScript SDK to perform some requests and handle their responses by performing the following actions:

1. Retrieve a single Entry
2. Retrieve all Entries of a Space
3. Retrieve all Entries and their linked resources
