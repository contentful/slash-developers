---
page: :docsReferenceLocales
---

## Overview

You can use locales to manage and deliver content in multiple languages.

All locales are stored in Spaces and defined by ISO locale codes(e.g., en-US and de-AT). Every Space has a default locale, which is used to retrieve results of unlocalized queries:

~~~json
{
  "sys": {
    "type": "Space",
    "id": "mo94git5zcq9"
  },
  "name": "Galactical Hack",
  "locales": [
    {
      "code": "en-US",
      "default": true,
      "name": "U.S. English"
    },
    {
      "code": "de-AT",
      "default": false,
      "name": "German"
    },
  ]
}
~~~

After locales are added to a Space, you must define what fields of a Content Type should be localized.  

In the following example, fields `title` and `body` have different content for `en-US` and `de-AT`:

~~~ json
{
  "fields": {
    "title": {
      "en-US": "Hello, World!",
      "de-AT": "Hallo, Welt!"
    },
    "body": {
      "en-US": "Bacon is healthy!",
      "de-AT": "Bacon ist gesund!"
    }
  }
}
~~~

## Locale and Spaces
Locales are a great advantage of [Contentful Premium Plans](https://www.contentful.com/pricing/). It is possible to have multiple locales in a Space and deliver content around the globe. 

To add a Locale to a Space you should the following:

In Contentful's Web Interface, go to **Settings** > **Locales**.

![alt text](https://images.contentful.com/3ts464by117l/5E8X56DtxCY0is2ocuyeso/2a7c7f3c028343b2e2f6cbcea2bf399a/mainlocale.png)

Click in **Add Locale** and choose an option:

![alt text](https://images.contentful.com/3ts464by117l/633NaPM11uo0qcsEWaW8IU/4cb24f447ddda520f5f24896de3f4e6d/newlocale.png)

Alternatively, if you are writing scripts or applications, you can also use the [Content Management API](https://www.contentful.com/developers/docs/references/content-management-api/#/reference/locales) to add a locale to a Space:

### URL request
`POST https://api.contentful.com/spaces/31odstfovq9h/locales`

### Header
+ `Authorization: Bearer cecb9d540699226c5b62627ad4951d8c8292c35757bc703de45b255dfa46770e`
+ `Content-Type: application/vnd.contentful.management.v1+json`

### Body of request
~~~ json
{  
   "name":"German (Austria),
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
  "internal_code":"de-AT",
  "code":"de-AT",
  "fallback_code":null,
  "default":false,
  "contentManagementApi":true,
  "contentDeliveryApi":true
}
~~~

## Locales and Fields

Fields are the main structure used by locales to separate content in different languages. In that way, it is necessary to enable localization for each field of a Content Type.

To do so, when adding or updating a field, make sure to select **Enable localization of this field**:

![alt text](https://images.contentful.com/3ts464by117l/2BmUtgSXxSs6qkmewiIgGQ/6b769bea8fd6195935d7e9378f1e79c3/enablelocalization.png)

Alternatively, it is also possible to use the [Content Management API](https://www.contentful.com/developers/docs/references/content-management-api/#/reference/content-types/content-type) to update Content Types and localize fields.

In the following example, we will enable localization for the fields `title` and `body` of the Content Type `Essays`:

### URL of Request
`PUT https://api.contentful.com/spaces/31odstfovq9h/content_types/219e7sHYGkOK6OgOgoC0mg`

### Header of Request
+ `Authorization: Bearer cecb9d540699226c5b62627ad4951d8c8292c35757bc703de45b255dfa46770e`
+ `Content-Type: application/vnd.contentful.management.v1+json`
+ `X-Contentful-Version: 2`

### Body of Request

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

Then, we must choose what translations will be used in each Entry:

![alt text](https://images.contentful.com/3ts464by117l/2OVtt4VWTYsiCCWmIIsCsE/808d49d8d84af41e5b642687c4d48d10/choosetranslations.png)

With that, Entries will finally have different fields for each locale:

![alt text](https://images.contentful.com/3ts464by117l/3lsbrrYk6kgGsem4EseEGO/b1778d50c8e869fa4fcb150c99ac63d6/geenfields.png)