---
page: :docsReferenceLocales
---

## Overview

Locales are a great advantage of Contentful's [premium plans](https://www.contentful.com/pricing/). They allow you to define multiple localizations of each piece of content and select a specific locale when querying the Content Delivery API.

Every space has its own set of locales, where each locale is uniquely identified by its ISO code (e.g., en-US or de-AT). There is always one default locale defined when a space is created, which is shown by default in the Contentful web app and used for Content Delivery API queries that do not request a specific locale. Note that as a default locale is specified in a space, it becomes permanent and cannot be changed afterwards.

## Working with locales

You can add a new locale to a space in the Contentful web app or by using the Content Management API.

To add a locale in the web app, go to **Settings** > **Locales** and click in **Add locale**:

{:.img}
![](https://images.contentful.com/3ts464by117l/5E8X56DtxCY0is2ocuyeso/2a7c7f3c028343b2e2f6cbcea2bf399a/mainlocale.png)

Choose a locale and its options:

{:.img}
![](locale-editor.png)

Alternatively, if you are writing scripts or applications, you can also use the [Content Management API](https://www.contentful.com/developers/docs/references/content-management-api/#/reference/locales) to add a locale to a space:

### URL request
~~~
POST https://api.contentful.com/spaces/31odstfovq9h/locales
~~~

### Header
~~~
Authorization: Bearer cecb9d540699226c5b62627ad4951d8c8292c35757bc703de45b255dfa46770e
Content-Type: application/vnd.contentful.management.v1+json
~~~

### Body of request
~~~ json
{
   "name":"German (Austria)",
   "code":"de-AT"
}
~~~

### JSON response
~~~ json
{
  "sys":{
    "type":"Locale",
    "id":"2Qd9RdEZa1WV5rPPOwiy5m",
    "version":0,
    "space":{
      "sys":{
        "type":"Link",
        "linkType":"Space",
        "id":"mo94git5zcq9"
      }
    },
    "createdBy":{
      "sys":{
        "type":"Link",
        "linkType":"User",
        "id":"77vJyNePDmNplztpJLgGkQ"
      }
    },
    "createdAt":"2015-10-30T14:56:46Z",
    "updatedBy":{
      "sys":{
        "type":"Link",
        "linkType":"User",
        "id":"77vJyNePDmNplztpJLgGkQ"
      }
    },
    "updatedAt":"2015-10-30T14:56:46Z"
  },
  "name":"German (Austria)",
  "code":"de-AT",
  "fallbackCode":null,
  "default":false,
  "contentManagementApi":true,
  "contentDeliveryApi":true,
  "optional":false
}
~~~

## Locales and fields

Fields are the main structure used by locales to separate content in different languages. After locales are added to a Space, you must define which fields of your various content types can be localized. Again this can be done with the web app or the Content Management API.

To enable localization on a field in the web app, check the corresponding option in the field settings:

{:.img}
![](https://images.contentful.com/3ts464by117l/2BmUtgSXxSs6qkmewiIgGQ/6b769bea8fd6195935d7e9378f1e79c3/enablelocalization.png)

It is also possible to use the [Content Management API](/developers/docs/references/content-management-api/#/reference/content-types/content-type) to update content types and localize fields.

In the following example, we will enable localization for the fields `title` and `body` of the content type `Essays` by setting their `localized` property to `true`:

### URL of request

~~~
PUT https://api.contentful.com/spaces/31odstfovq9h/content_types/219e7sHYGkOK6OgOgoC0mg
~~~

### Header of request

~~~
Authorization: Bearer cecb9d540699226c5b62627ad4951d8c8292c35757bc703de45b255dfa46770e
Content-Type: application/vnd.contentful.management.v1+json
X-Contentful-Version: 2
~~~

### Body of request

~~~ json
{
  "name": "Essay",
  "displayField": "name",
  "fields": [
    {
      "name": "body",
      "id": "body",
      "type": "Text",
      "localized": true,
      "validations": []
    },
    {
      "name": "title",
      "id": "name",
      "type": "Text",
      "localized": true,
      "validations": []
    }
  ]
}
~~~

As you can see in the following response, `body` and `title` fields have been localized:

~~~ json
{
  "name": "Essay",
  "displayField": "name",
  "fields": [
    {
      "name": "body",
      "id": "body",
      "type": "Text",
      "localized": true,
      "validations": []
    },
    {
      "name": "title",
      "id": "name",
      "type": "Text",
      "localized": true,
      "validations": []
    }
  ],
  "sys": {
    "id": "219e7sHYGkOK6OgOgoC0mg",
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
    "updatedAt": "2015-10-30T15:48:10.095Z",
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

Then, we must choose what translations will be used in each entry:

{:.img}
![](https://images.contentful.com/3ts464by117l/2OVtt4VWTYsiCCWmIIsCsE/808d49d8d84af41e5b642687c4d48d10/choosetranslations.png)

With that, entries will finally have different fields for each locale:

{:.img}
![](https://images.contentful.com/3ts464by117l/3lsbrrYk6kgGsem4EseEGO/b1778d50c8e869fa4fcb150c99ac63d6/geenfields.png)

## Locales and the Content Delivery API

### Retrieving entries without a specific locale

 If there is no specific locale in your URL request, you will receive the corresponding value from the default locale (`en-US` in our example):

#### URL of request

~~~
GET https://cdn.contentful.com/spaces/mo94git5zcq9/entries/tcptFqv6xwQy6QYOAgK0C?access_token=b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb
~~~

#### JSON response

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
    "id": "tcptFqv6xwQy6QYOAgK0C",
    "revision": 2,
    "createdAt": "2015-11-03T12:05:26.752Z",
    "updatedAt": "2015-11-11T13:06:13.855Z",
    "locale": "en-US"
  },
  "fields": {
    "title": "Welcome",
    "body": "this is a test"
  }
}
~~~

### Retrieving entries with a specific locale
If we want to retrieve fields from a specific locale (e.g `de-AT`), we should use the `locale=de-AT` parameter:

#### URL of request

~~~
GET https://cdn.contentful.com/spaces/mo94git5zcq9/entries/tcptFqv6xwQy6QYOAgK0C?access_token=b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb&locale=de-AT
~~~

#### JSON response

~~~json
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
    "id": "tcptFqv6xwQy6QYOAgK0C",
    "revision": 2,
    "createdAt": "2015-11-03T12:05:26.752Z",
    "updatedAt": "2015-11-11T13:06:13.855Z",
    "locale": "de-AT"
  },
  "fields": {
    "title": "Willkommen",
    "body": "das ist ein Test"
  }
}
~~~

### Retrieving entries with a wildcard locale
It is possible to retrieve all localized content of an entry by using the wildcard parameter `locale=*`:

#### URL of request

~~~
GET https://cdn.contentful.com/spaces/mo94git5zcq9/entries/tcptFqv6xwQy6QYOAgK0C?access_token=b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb&locale=*
~~~

#### JSON response

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
    "id": "tcptFqv6xwQy6QYOAgK0C",
    "revision": 2,
    "createdAt": "2015-11-03T12:05:26.752Z",
    "updatedAt": "2015-11-11T13:06:13.855Z"
  },
  "fields": {
    "title": {
      "en-US": "Welcome",
      "de-AT": "Willkommen"
    },
    "body": {
      "de-AT": "das ist ein Test",
      "en-US": "this is a test"
    }
  }
}
~~~

## Locales and the Sync API

The [synchronization API](https://www.contentful.com/developers/docs/concepts/sync/) always includes all localized content, using the same structure as the wildcard locale option above:

### URL of request

~~~
GET https://cdn.contentful.com/spaces/mo94git5zcq9/sync?initial=true&access_token=b933b531a7f37efbfc68838d24b416ddb3d53ea16377606045d3bfcdf705b0fb&locale=de-AT
~~~

### JSON response

~~~ json
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
          "id": "tcptFqv6xwQy6QYOAgK0C",
          "revision": 2,
          "createdAt": "2015-11-03T12:05:26.752Z",
          "updatedAt": "2015-11-11T13:06:13.855Z"
        },
        "fields": {
          "title": {
            "en-US": "Welcome",
            "de-AT": "Willkommen"
          },
          "body": {
            "de-AT": "das ist ein Test",
            "en-US": "this is a test"
          }
        }
      },
      ...
  ]
~~~
