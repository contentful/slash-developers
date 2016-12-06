# Your first API call with Java

:[API demo intro](../../_partials/api-demo-intro.md)

## Setup

Download the Java SDK library jar file:

~~~bash
wget 'http://search.maven.org/remotecontent?filepath=com/contentful/java/java-sdk/7.2.0/java-sdk-7.2.0-jar-with-dependencies.jar' -O contentful.jar
~~~

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

:[Custom content Structures](../../_partials/custom-content-structures.md)

You might have noticed the `sys.contentType` property of the entry above:

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

:[Explore Further](../../_partials/explore-further.md)

- [Browse other Java tutorials](/developers/docs/java/)
- [Explore our four APIs](/developers/docs/concepts/apis)
- [Understand content modelling](/developers/docs/concepts/data-model)
