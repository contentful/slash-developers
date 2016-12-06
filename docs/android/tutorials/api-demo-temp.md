# Your first API call with Java

You're a developer, you've discovered Contentful and you're interested in understanding what it is and how it works. This introduction will show you how to fetch content from Contentful in just 3 minutes

Contentful is an API-first Content management system (CMS) which helps developers get content in their apps with API calls, and offers editors a familiar-looking web app for creating and managing content.

This guide shows you how to make a call to one of the [Contentful APIs](/developers/docs/concepts/apis), explains how the response looks, and suggests next steps.

## Setup

Download the Java SDK library jar file:

~~~bash
wget 'http://search.maven.org/remotecontent?filepath=com/contentful/java/java-sdk/6.1.2/java-sdk-6.1.2-jar-with-dependencies.jar' -O contentful.jar
~~~

**VERSION?**

Create a _HelloContentful.java_ file and copy these lines into it:

~~~java
import com.contentful.java.cda.*;
import com.google.gson.*;

public class HelloContentful {
  public static void main(String[] argv) {
    CDAClient client = CDAClient.builder()
        .setSpace("developer_bookshelf")
        .setToken("0b7f6x59a0")
        .build();

    CDAEntry entry = client.fetch(CDAEntry.class).one("5PeGS2SoZGSa4GuiQsigQu");

    Gson gson = new GsonBuilder().setPrettyPrinting().create();
    System.out.println(gson.toJson(entry));

    System.exit(0);
  }
}
~~~

This API call will request an entry with the specified ID.

## Make the first request

Save the file and run it:

~~~bash
javac -cp contentful.jar HelloContentful.java
java -cp contentful.jar:. HelloContentful
~~~

The output should look something like:

~~~json
{
  "contentType": {
    "fields": […],
    "name": "Book",
    "displayField": "name",
    "description": "",
    "sys": {
      "type": "ContentType",
      "id": "book",
      "revision": 1.0,
      "createdAt": "2015-12-08T15:44:49.413Z",
      "updatedAt": "2015-12-08T15:44:49.413Z"
    }
  },
  "locale": "en-US",
  "defaultLocale": "en-US",
  "fields": {
    "author": {
      "en-US": "Larry Wall"
    },
    "name": {
      "en-US": "An introduction to regular expressions. Volume VI"
    },
    "description": {
      "en-US": "Now you have two problems."
    }
  },
  "rawFields": {…},
  "sys": {…}
}
~~~

## Custom content structures

Contentful is built on the principle of structured content, a set of key-value pairs is not a great interface to program against if the keys and data types are always changing.

The same way you can set up any [content structure](/developers/docs/concepts/data-model) in a MySQL database, you can set up a custom content structure in Contentful. There are no presets, templates, or similar, you can (and should) set everything up depending on the logic of your project.

You maintain this structure with _content types_, which define what data fields are present in a content entry. You might have noticed the `sys.contentType` property of the entry above:

~~~json
"contentType": {
  "fields": [ … ],
  "name": "Book",
  "displayField": "name",
  "description": "",
  "sys": {
    "type": "ContentType",
    "id": "book",
    "revision": 1.0,
    "createdAt": "2015-12-08T15:44:49.413Z",
    "updatedAt": "2015-12-08T15:44:49.413Z"
  }
}
~~~

This is a link to the content type which defines the structure of this entry. Being API-first, you can fetch this content type from the API and inspect it to understand what it contains. Change line 11 of _HelloContentful.java_ to:

~~~java
CDAContentType entry = client.fetch(CDAContentType.class).one("book");
~~~

Re-running the script should now produce the following output:

~~~json
{
  "fields": [
    {
      "name": "Name",
      "id": "name",
      "type": "Symbol",
      "disabled": false,
      "required": false,
      "localized": false
    },
    {
      "name": "Author",
      "id": "author",
      "type": "Symbol",
      "disabled": false,
      "required": false,
      "localized": false
    },
    {
      "name": "Description",
      "id": "description",
      "type": "Symbol",
      "disabled": false,
      "required": false,
      "localized": false
    }
  ],
  "name": "Book",
  "displayField": "name",
  "description": "",
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
    "revision": 1.0,
    "createdAt": "2015-12-08T15:44:49.413Z",
    "updatedAt": "2015-12-08T15:44:49.413Z"
  }
}
~~~

## Usable by all (??)

Contentful enables structuring content in any possible way, making it accessible both to developers through the API and for editors via the web interface. It's a perfect tool to use for any project that involves content that should be properly managed by editors, in a CMS, instead of developers having to deal with the hardcoded content.

## Explore further

We'd like to help you understand our product, so here are our suggested next steps:

- [Browse other Java tutorials](/developers/docs/java/)
- [Explore our four APIs](/developers/docs/concepts/apis)
- [Understand content modelling](/developers/docs/concepts/data-model)
