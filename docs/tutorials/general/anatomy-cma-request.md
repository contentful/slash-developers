---
page: :docsAnatomyCMARequest
name: Anatomy of a CMA Request
title: Anatomy of a CMA Request
metainformation: 'This article is a comprehensive exposure to managing content via the Content Management API. In the end, you should be able to write custom applications and scripts using our API.'
slug: null
tags:
  - API
  - Request
  - Advanced
nextsteps: null
---
## Overview

In Contentful, content is defined as entries and assets (e.g images, videos and other media) and divided into spaces. Apps and websites depend on the structure of entries, so every entry must comply to a specific content type.

This article is a comprehensive exposure to managing content via the Content Management API. In the end, you should be able to write custom applications and scripts using our API.

In this example, we will create an online magazine, publish a blog post and add an image to it.

To do so, we will do the following:

+ Create a space named `Galactic magazine`;
+ Establish a content type named `Blog Posts` with fields `body`, `title`
+ Create and publish a blog post entry
+ Create, process and publish an asset (image)
+ Add a field `image` to the content type `Blog Posts`
+ Add this image to our blog post entry

## Structuring blog posts

### Creating a space

Spaces are containers for content types, entries and assets and other resources. API consumers retrieve data by getting entries and assets from one or more spaces. To create a space, a request should have the following structure:

#### URL

~~~
POST https://api.contentful.com/spaces
~~~

#### Header

~~~
Authorization: $token
Content-Type: application/vnd.contentful.management.v1+json
~~~

#### Body
In the body of our request we should specify a `name` and `defaultLocale` (defines the standard language):

~~~ json
{
  "name": "Galactic Magazine",
  "defaultLocale": "en"
}
~~~

We get a JSON response with a `sys` property, containing managed system properties, and additional space information like `name` and `locales`:

~~~ json
{
  "sys":{
    "type":"Space",
    "id":"31odstfovq9h",
    "version":1,
    "createdBy":{
      "sys":{
        "type":"Link",
        "linkType":"User",
        "id":"77vJyNePDmNplztpJLgGkQ"
      }
    },
    "createdAt":"2015-10-28T13:06:27Z",
    "updatedBy":{
      "sys":{
        "type":"Link",
        "linkType":"User",
        "id":"77vJyNePDmNplztpJLgGkQ"
      }
    },
    "updatedAt":"2015-10-28T13:06:28Z"
  },
  "name":"Galactic Magazine",
  "locales": [
    {
      "code": "en",
      "default": true,
      "name": "English"
    }
  ]
}
~~~

### Creating and activating a content type
Content types are mainly list of fields acting as a blueprint for entries.
In this example of an online magazine, we will create the content type `Blog Post`, which will yield the structure of our future entries:

#### URL

~~~
PUT https://api.contentful.com/spaces/31odstfovq9h/content_types/blog_post
~~~

#### Header

~~~
Authorization: Bearer $token
Content-Type: application/vnd.contentful.management.v1+json
~~~

#### Body

~~~ json
{
  "name": "Blog Post",
  "fields": [
    {
      "id": "title",
      "name": "Title",
      "type": "Text"
    },
    {
      "id": "body",
      "name": "Body",
      "type": "Text"
    }
  ]
}
~~~

As you can see in the following response, we've just created a content type named `Blog Posts` with fields `body` and `title`:

~~~ json
{
  "name": "Blog Post",
  "fields": [
    {
      "id": "title",
      "name": "Title",
      "type": "Text",
      "localized": false,
      "validations": []
    },
    {
      "id": "body",
      "name": "Body",
      "type": "Text",
      "localized": false,
      "validations": []
    }
  ],
  "sys": {
    "id": "blog_post",
    "type": "ContentType",
    "version": 1,
    "createdAt": "2015-10-28T13:27:53.057Z",
    "createdBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "31odstfovq9h"
      }
    },
    "updatedAt": "2015-10-28T13:27:53.057Z",
    "updatedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    }
  }
}
~~~

We will be using this schema to create our entry in the next section. Before we do that, we must activate our content type by using the following request:

#### URL

~~~
PUT https://api.contentful.com/spaces/31odstfovq9h/content_types/blog_post/published
~~~

#### Header

~~~
Authorization: Bearer $token
Content-Type: application/vnd.contentful.management.v1+json
X-Contentful-Version: 1
~~~

Whereas the response yields the same `fields` array, `sys` is updated with new information about versioning:

~~~ json
{
  "name": "Blog Post",
  "fields": [
    ...
  ],
  "sys": {
    "id": "blog_post",
    "type": "ContentType",

    ...

    "version": 2,
    "updatedAt": "2015-10-28T15:59:06.125Z",
    "updatedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "firstPublishedAt": "2015-10-28T15:59:06.125Z",
    "publishedCounter": 1,
    "publishedAt": "2015-10-28T15:59:06.125Z",
    "publishedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "publishedVersion": 1
  }
}
~~~

### Creating and publishing an entry
To create an entry, we must specify a `X-Contentful-Content-Type` in the header and specify [locales](/developers/docs/concepts/locales/) for its fields. In the following example, we will create a blog post entry:

#### URL

~~~
POST https://api.contentful.com/spaces/31odstfovq9h/entries/
~~~

#### Header

~~~
Authorization: Bearer $token
Content-Type: application/vnd.contentful.management.v1+json
X-Contentful-Content-Type: blog_post
~~~

#### Body

~~~ json
{
   "fields":{
      "title":{
         "en":"Explore the Universe!"
      },
      "body":{
         "en":"We live in an awesome universe and..."
      }
   }
}
~~~

Our request payload assigns a value to each content type field:

~~~ json
{
  "fields": {
    "title": {
      "en": "Explore the Universe!"
    },
    "body": {
      "en": "We live in an awesome universe and..."
    }
  },
  "sys": {
    "id": "63uGDCuGTmMUQu4OWmoKyC",
    "type": "Entry",
    "version": 1,
    "createdAt": "2015-10-28T16:21:35.725Z",
    "createdBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "31odstfovq9h"
      }
    },
    "contentType": {
      "sys": {
        "type": "Link",
        "linkType": "ContentType",
        "id": "blog_post"
      }
    },
    "updatedAt": "2015-10-28T16:21:35.725Z",
    "updatedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    }
  }
}
~~~

Our entry is still a draft, so it's not possible to to deliver its content.

To deliver content, we must publish our entry and indicate its version (`X-Contentful-Version`) in the header of a PUT request:

#### URL

~~~
PUT https://api.contentful.com/spaces/31odstfovq9h/entries/63uGDCuGTmMUQu4OWmoKyC/published/
~~~

#### Headers

~~~
Content-Type: application/vnd.contentful.management.v1+json
Authorization: $token
X-Contentful-Version: 1
~~~

Similar to activating a content type, publishing an entry retrieves a `sys` array with updated information about versioning:

~~~ json
{
  "fields": {
    "title": {
      "en": "Explore the Universe!"
    },
    "body": {
      "en": "We live in an awesome universe and..."
    }
  },
  "sys": {
    "id": "63uGDCuGTmMUQu4OWmoKyC",
    "type": "Entry",
    "createdAt": "2015-10-28T16:21:35.725Z",
    "createdBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "31odstfovq9h"
      }
    },
    "contentType": {
      "sys": {
        "type": "Link",
        "linkType": "ContentType",
        "id": "blog_post"
      }
    },
    "version": 2,
    "updatedAt": "2015-10-28T16:25:58.718Z",
    "updatedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "firstPublishedAt": "2015-10-28T16:25:58.718Z",
    "publishedCounter": 1,
    "publishedAt": "2015-10-28T16:25:58.718Z",
    "publishedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "publishedVersion": 1
  }
}
~~~

## Adding assets to blog posts

### Creating an asset
To create assets using the Content Management API, we must provide a publicly available upload URL.

These can be hosted on your own domain, be tunneled from `localhost` (using a tool like [ngrok](https://ngrok.com/)) or stored in a third-party website.

In our case, we will create an Asset using the URL of a publicly available [image](https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?ixlib=rb-0.3.5&q=80&fm=jpg&w=720&fit=max&s=a9690b19fc22338ee55f570832213937):

#### URL

~~~
POST https://api.contentful.com/spaces/31odstfovq9h/assets
~~~

#### Header

~~~
Authorization: Bearer $token
Content-Type: application/vnd.contentful.management.v1+json
~~~

#### Body

~~~ json
{
   "fields":{
      "title":{
         "en-US":"Universe"
      },
      "file":{
         "en-US":{
            "contentType":"image/jpeg",
            "fileName":"spaceship.jpeg",
            "upload":"https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?ixlib=rb-0.3.5&q=80&fm=jpg&w=720&fit=max&s=a9690b19fc22338ee55f570832213937"
         }
      }
   }
}
~~~

A JSON response is retrieved with `sys` and `fields`, which describes the title, name and URL of our image:

~~~ json
{
  "fields": {
    "title": {
      "en": "Universe"
    },
    "file": {
      "en": {
        "contentType": "image/jpeg",
        "fileName": "spaceship.jpeg",
        "upload": "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?ixlib=rb-0.3.5&q=80&fm=jpg&w=720&fit=max&s=a9690b19fc22338ee55f570832213937"
      }
    }
  },
  "sys": {
    "id": "11gmpOYKfa8KOO6sYwaaYI",
    "type": "Asset",
    "version": 1,
    "createdAt": "2015-10-28T16:47:09.157Z",
    "createdBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "31odstfovq9h"
      }
    },
    "updatedAt": "2015-10-28T16:47:09.157Z",
    "updatedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    }
  }
}
~~~

Now, we must tell Contentful to download and store the file from the URL we've just specified. In other words, we must process this asset:

#### URL

~~~
PUT https://api.contentful.com/spaces/31odstfovq9h/assets/11gmpOYKfa8KOO6sYwaaYI/files/en/process
~~~

#### Header

~~~
Authorization: Bearer $token
Content-Type: application/vnd.contentful.management.v1+json
X-Contentful-Version: 1
~~~

Note that while no response is given, processing is asynchronous, so we may have to wait a little longer until the asset is publishable.

When finished, a GET request should reveal the updated image URL:

~~~ json
{
  "fields": {
    "title": "Universe",
    "file": {
      "contentType": "image/jpeg",
      "fileName": "spaceship.jpeg",
      "details": {
        "image": {
          "width": 720,
          "height": 480
        },
        "size": 118891
      },
      "url": "//images.contentful.com/31odstfovq9h/11gmpOYKfa8KOO6sYwaaYI/c2758c034d7f92dc7d4912eac26f6932/spaceship.jpeg"
    }
  },
  "sys": {
    ...
  }
}
~~~

As you can see, the image has been stored and given a new URL (placed under the `images.contentful.com` domain).

Now, we are ready to publish our asset. Note that we must specify the correct `X-Contentful-Version` on our header:

#### URL

~~~
PUT https://api.contentful.com/spaces/31odstfovq9h/assets/11gmpOYKfa8KOO6sYwaaYI/published
~~~

#### Header

~~~
Authorization: Bearer $token
Content-Type: application/vnd.contentful.management.v1+json
X-Contentful-Version: 2
~~~

The response has the same `field` array, but `sys` has been updated with new versioning information:

~~~ json
{
  "fields": {
    ...
  },
  "sys": {
    "id": "11gmpOYKfa8KOO6sYwaaYI",
    "type": "Asset",
    "createdAt": "2015-10-28T16:47:09.157Z",
    "createdBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "31odstfovq9h"
      }
    },
    "version": 3,
    "updatedAt": "2015-10-28T17:35:34.257Z",
    "updatedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "firstPublishedAt": "2015-10-28T17:35:34.257Z",
    "publishedCounter": 1,
    "publishedAt": "2015-10-28T17:35:34.257Z",
    "publishedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "publishedVersion": 2
  }
}
~~~

Now, to add our asset to an entry, we must update our content type `Blog Posts` to include an `image` field:

#### URL

~~~
PUT https://api.contentful.com/spaces/31odstfovq9h/content_types/blog_post
~~~

#### Header

~~~
Authorization: Bearer $token
Content-Type: application/vnd.contentful.management.v1+json
X-Contentful-Version: 2
~~~

#### Body

~~~ json
{
  "name": "Blog Post",
  "fields": [
    {
      "id": "title",
      "name": "Title",
      "type": "Text"
    },
    {
      "id": "body",
      "name": "Body",
      "type": "Text"
    },
    {
      "id": "image",
      "name": "Image",
      "type": "Link",
      "linkType": "Asset"
    }
  ]
}
~~~

The response reveals the new `image` field:

~~~ json
{
  "name": "Blog Post",
  "fields": [
    {
      "id": "title",
      "name": "Title",
      "type": "Text"
    },
    {
      "id": "body",
      "name": "Body",
      "type": "Text"
    },
    {
      "id": "image",
      "name": "Image",
      "type": "Link",
      "linkType": "Asset"
    }
  ],
  "sys": {
    "id": "blog_post",
    "type": "ContentType",
    "createdAt": "2015-10-28T13:27:53.057Z",
    "createdBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "31odstfovq9h"
      }
    },
    "firstPublishedAt": "2015-10-28T15:59:06.125Z",
    "publishedCounter": 1,
    "publishedAt": "2015-10-28T15:59:06.125Z",
    "publishedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "publishedVersion": 1,
    "version": 3,
    "updatedAt": "2015-10-30T14:33:34.532Z",
    "updatedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    }
  }
}
~~~

Finally, we update our entry and include the asset using the new `field.image`:

#### URL

~~~
PUT https://api.contentful.com/spaces/31odstfovq9h/entries/63uGDCuGTmMUQu4OWmoKyC
~~~

#### Headers

~~~
Authorization: Bearer $token
Content-Type: application/vnd.contentful.management.v1+json
X-Contentful-Version: 2
~~~

#### Body

~~~ json
{
   "fields":{
      "title":{
         "en":"Explore the Universe!"
      },
      "body":{
         "en":"We live in an awesome universe and..."
      },
      "image":{
       "en": {
          "sys": {
            "type": "Link",
            "linkType": "Asset",
            "id": "11gmpOYKfa8KOO6sYwaaYI"
          }
        }
      }
   }
}
~~~

The response confirms the recently included asset:

~~~ json
{
  "fields": {
    "title": {
      "en": "Explore the Universe!"
    },
    "body": {
      "en": "We live in an awesome universe and..."
    },
    "image": {
      "en": {
        "sys": {
          "type": "Link",
          "linkType": "Asset",
          "id": "11gmpOYKfa8KOO6sYwaaYI"
        }
      }
    }
  },
  "sys": {
    ...
  }
}
~~~

Then, we must publish the entry:

#### URL

~~~
PUT https://api.contentful.com/spaces/31odstfovq9h/entries/63uGDCuGTmMUQu4OWmoKyC/published/
~~~

#### Headers

~~~
Authorization: Bearer $token
Content-Type: application/vnd.contentful.management.v1+json
X-Contentful-Version: 2
~~~

#### Response
~~~ json
{
  "fields": {
    "title": {
      "en": "Explore the Universe!"
    },
    "body": {
      "en": "We live in an awesome universe and..."
    },
    "image": {
      "en": {
        "sys": {
          "type": "Link",
          "linkType": "Asset",
          "id": "11gmpOYKfa8KOO6sYwaaYI"
        }
      }
    }
  },
  "sys": {
    "id": "63uGDCuGTmMUQu4OWmoKyC",
    "type": "Entry",
    "createdAt": "2015-10-28T16:21:35.725Z",
    "createdBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "31odstfovq9h"
      }
    },
    "contentType": {
      "sys": {
        "type": "Link",
        "linkType": "ContentType",
        "id": "blog_post"
      }
    },
    "firstPublishedAt": "2015-10-28T16:25:58.718Z",
    "publishedCounter": 2,
    "publishedAt": "2015-10-30T16:27:05.350Z",
    "publishedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    },
    "publishedVersion": 2,
    "version": 3,
    "updatedAt": "2015-10-30T16:27:05.350Z",
    "updatedBy": {
      "sys": {
        "type": "Link",
        "linkType": "User",
        "id": "77vJyNePDmNplztpJLgGkQ"
      }
    }
  }
}
~~~

## Conclusion

In this article we have covered how to:

1. Create spaces
2. Create and activate content types
3. Create and publish entries
4. Create, process and publish assets
5. Add assets to entries

Although we have exposed many details of the Content Management API, there are still many uncovered features in the [reference documentation](/developers/docs/references/content-management-api/#/reference). We also offer SDKs and tools for the most popular [programming languages](/developers/docs/#libraries).
