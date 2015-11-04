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