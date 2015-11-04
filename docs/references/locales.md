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