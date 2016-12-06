# Your first API call with PHP

:[API demo intro](../../_partials/api-demo-intro.md)

## Setup

Make sure you have [composer](https://getcomposer.org) installed on your machine and then use it to install the Contentful Delivery API (CDA) SDK:

~~~bash
php composer.phar require contentful/contentful:@beta
~~~

Create _hello-contentful.php_ and copy these lines into it:

~~~php
<?php
require_once 'vendor/autoload.php';

// This is the space ID. A space is like a project folder in Contentful terms
$space='developer_bookshelf';

// This is the access token for this space. Normally you get both ID and the token in the Contentful web app
$token='0b7f6x59a0';

// This configures the SDK to access the Delivery API entry with the specified ID from the space defined at the top, using a space-specific access token.
$client = new \Contentful\Delivery\Client($token, $space);
~~~

## Make the first request

To request an entry with the specified ID, add this to the end of the file:

~~~php
<?php
// This retrieves the entry with the specified ID and JSON encodes it
echo json_encode($client->getEntry('5PeGS2SoZGSa4GuiQsigQu'), JSON_PRETTY_PRINT);
~~~

Save the file and run it:

~~~bash
php hello-contentful.php
~~~

The output should look like this:

~~~json
{
  "sys": {
    "id": "5PeGS2SoZGSa4GuiQsigQu",
    "type": "Entry",
    "space": {
      "sys": {
        "type": "Link",
        "linkType": "Space",
        "id": "developer_bookshelf"
      }
    },
    "contentType": {
      "sys": {
        "type": "Link",
        "linkType": "ContentType",
        "id": "book"
      }
    },
    "revision": 1,
    "createdAt": "2015-12-08T15:45:54.394Z",
    "updatedAt": "2015-12-08T15:45:54.394Z"
  },
  "fields": {
    "name": {
      "en-US": "An introduction to regular expressions. Volume VI"
    },
    "author": {
      "en-US": "Larry Wall"
    },
    "description": {
      "en-US": "Now you have two problems."
    }
  }
}
~~~

:[Custom content Structures](../../_partials/custom-content-structures.md)

You might have noticed the `sys.contentType` property of the entry above:

~~~json
"contentType": {
  "sys": {
    "type": "Link",
    "linkType": "ContentType",
    "id": "book"
  }
}
~~~

This is a link to the content type which defines the structure of this entry. Being API-first, you can fetch this content type from the API and inspect it to understand what it contains. Change the last line of _hello-contentful.php_ to:

~~~php
<?php
echo json_encode($client->getContentType('book'), JSON_PRETTY_PRINT);
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

:[Explore Further](../../_partials/explore-further.md)


- [Browse other PHP tutorials](/developers/docs/php/)
- [Explore our four APIs](/developers/docs/concepts/apis)
- [Understand content modelling](/developers/docs/concepts/data-model)
