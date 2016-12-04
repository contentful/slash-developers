# Your first API call with Node.js

You're a developer, you've discovered Contentful and you're interested in understanding what it is and how it works. This introduction will show you how to fetch content from Contentful in just 3 minutes

Contentful is an API-first Content management system (CMS) which helps developers get content in their apps with API calls, and offers editors a familiar-looking web app for creating and managing content.

This guide shows you how to make a call to one of the [Contentful APIs](/developers/docs/concepts/apis), explains how the response looks, and suggests next steps.

## Setup

Create a folder and inside it run:

~~~bash
npm install contentful
~~~

Create the file _hello-contentful.js_ and copy these lines into it:

~~~javascript
var contentful = require('contentful')
var util = require('util')
var client = contentful.createClient({
  // This is the space ID. A space is like a project folder in Contentful terms
  space: 'developer_bookshelf',
  // This is the access token for this space. Normally you get both ID and the token in the Contentful web app
  accessToken: '0b7f6x59a0'
})
~~~

## Make the first request

To request an entry with the specified ID, add this to the end of the file:

~~~javascript
...
// This API call will request an entry with the specified ID from the space defined at the top, using a space-specific access token.
client.getEntry('5PeGS2SoZGSa4GuiQsigQu')
.then(function (entry) {
  console.log(util.inspect(entry, {depth: null}))
})
~~~

Save the file and run it:

~~~bash
node hello-contentful.js
~~~

The output should look like this:

~~~json
{
  "sys": {
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "developer_bookshelf"
      }
    },
    "type": "Entry",
    "contentType": {
      "sys": {
        "type": "Link",
        "linkType": "ContentType",
        "id": "book"
      }
    },
    "id": "5PeGS2SoZGSa4GuiQsigQu",
    "revision": 1,
    "createdAt": "2015-12-08T15:45:54.394Z",
    "updatedAt": "2015-12-08T15:45:54.394Z",
    "locale": "en-US"
  },
  "fields": {
    "name": "An introduction to regular expressions. Volume VI",
    "author": "Larry Wall",
    "description": "Now you have two problems."
  }
}
~~~

## Custom content structures

Contentful is built on the principle of structured content, a set of key-value pairs is not a great interface to program against if the keys and data types are always changing.

The same way you can set up any [content structure](/developers/docs/concepts/data-model) in a MySQL database, you can set up a custom content structure in Contentful. There are no presets, templates, or similar, you can (and should) set everything up depending on the logic of your project.

You maintain this structure with _content types_, which define what data fields are present in a content entry. You might have noticed the `sys.contentType` property of the entry above:

~~~json
"contentType": {
  "sys": {
    "type": "Link",
    "linkType": "ContentType",
    "id": "book"
  }
}
~~~

This is a link to the content type which defines the structure of this entry. Being API-first, you can fetch this content type from the API and inspect it to understand what it contains. Change the request in _hello-contentful.js_ to:

~~~javascript
client.getContentType('book')
.then(function (contentType) {
  console.log(util.inspect(contentType, {depth: null}))
})
~~~

Re-running the script should now produce the following output:

~~~json
{
  "name": "Book",
  "fields": [
    {
      "name": "Name",
      "id": "name",
      "type": "Symbol",
      "localized": false
    },
    {
      "name": "Author",
      "id": "author",
      "type": "Symbol",
      "localized": false
    },
    {
      "name": "Description",
      "id": "description",
      "type": "Symbol",
      "localized": false
    }
  ],
  "description": "",
  "displayField": "name",
  "sys": {
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "developer_bookshelf"
      }
    },
    "type": "ContentType",
    "id": "book",
    "revision": 1,
    "createdAt": "2015-12-08T15:44:49.413Z",
    "updatedAt": "2015-12-08T15:44:49.413Z"
  }
}
~~~

## Usable by all (??)

Contentful enables structuring content in any possible way, making it accessible both to developers through the API and for editors via the web interface. It's a perfect tool to use for any project that involves content that should be properly managed by editors, in a CMS, instead of developers having to deal with the hardcoded content.

## Explore further

We'd like to help you understand our product, so here are our suggested next steps:

- [Browse other JavaScript tutorials](/developers/docs/javascript/)
- [Explore our four APIs](/developers/docs/concepts/apis)
- [Understand content modelling](/developers/docs/concepts/data-model)
