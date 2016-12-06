# Your first API call with Swift

:[API demo intro](../../_partials/api-demo-intro.md)

## Setup

In this example you will be building a command line application using the Swift Package Manager, but you can integrate our SDKs into an iOS app using [CocoaPods](https://cocoapods.org/) or a binary framework.

Create a _Package.swift_ file and copy these lines into it:

~~~swift
import PackageDescription

_ = Package(
  name: "apidemo",
  dependencies: [
    .Package(url: "[https://github.com/contentful/contentful.swift"](https://github.com/contentful/contentful.swift");, majorVersion: 0),
  ]
)
~~~

Create a _Sources_ directory with a _main.swift_ file inside it containing the following lines:

~~~swift
import Cocoa
import Contentful

// This is the space ID. A space is like a project folder in Contentful terms
let SPACE = "developer_bookshelf"

// This is the access token for this space. Normally you get both ID and the token in the Contentful web app
let TOKEN = "0b7f6x59a0"
~~~

## Make the first request

To request an entry with the specified ID, add this to the end of _main.swift_:

~~~swift
let client = Client(spaceIdentifier: SPACE, accessToken: TOKEN)
client.fetchEntry("5PeGS2SoZGSa4GuiQsigQu").1
  .next  { print($0); exit(0) }
  .error { print($0); exit(0) }

dispatch_main()
~~~

Build the project by running:

~~~bash
swift build
~~~

And run it with the following commands:

~~~bash
./.build/debug/apidemo
~~~

The output should look like this:

~~~json
Entry(
  sys: [
    "locale": en-US,
    "updatedAt": 2015-12-08T15:45:54.394Z,
    "id": 5PeGS2SoZGSa4GuiQsigQu,
    "contentType": {
      sys =     {
        id = book;
        linkType = ContentType;
        type = Link;
      };
    },
    "revision": 1,
    "space": {
      sys =     {
        id = "developer_bookshelf";
        linkType = Space;
        type = Link;
      };
    },
    "createdAt": 2015-12-08T15:45:54.394Z,
    "type": Entry
  ],
  localizedFields: [
    "en-US": [
      "author": Larry Wall,
      "name": An introduction to regular expressions. Volume VI,
      "description": Now you have two problems.
    ]
  ],
  defaultLocale: "en-US",
  identifier: "5PeGS2SoZGSa4GuiQsigQu",
  type: "Entry",
  locale: "en-US"
)
~~~

:[Custom content Structures](../../_partials/custom-content-structures.md)

You might have noticed the `sys.contentType` property of the entry above:

~~~json
"contentType": {
  sys =     {
    id = book;
    linkType = ContentType;
    type = Link;
  };
}
~~~

This is a link to the content type which defines the structure of this entry. Being API-first, you can fetch this content type from the API and inspect it to understand what it contains. Change the request in _main.swift_ to:

~~~swift
client.fetchContentType("book").1
  .next  { print($0); exit(0) }
  .error { print($0); exit(0) }
~~~

Re-building and re-running the application again should now produce the following output:

~~~json
ContentType(
  sys: [
    "updatedAt": 2015-12-08T15:44:49.413Z,
    "revision": 1,
    "id": book,
    "space": {
      sys =     {
        id = "developer_bookshelf";
        linkType = Space;
        type = Link;
      };
    },
    "createdAt": 2015-12-08T15:44:49.413Z,
    "type": ContentType
  ],
  fields: [
    Contentful.Field(
      identifier: "name",
      name: "Name",
      disabled: false,
      localized: false,
      required: false,
      type: Contentful.FieldType.Symbol,
      itemType: Contentful.FieldType.None
    ),
    Contentful.Field(
      identifier: "author",
      name: "Author",
      disabled: false,
      localized: false,
      required: false,
      type: Contentful.FieldType.Symbol,
      itemType: Contentful.FieldType.None
    ),
    Contentful.Field(
      identifier: "description",
      name: "Description",
      disabled: false,
      localized: false,
      required: false,
      type: Contentful.FieldType.Symbol,
      itemType: Contentful.FieldType.None
    )
  ],
  identifier: "book",
  name: "Book",
  type: "ContentType"
)
~~~

:[Explore Further](../../_partials/explore-further.md)

- [Browse other iOS tutorials](/developers/docs/ios/)
- [Explore our four APIs](/developers/docs/concepts/apis)
- [Understand content modelling](/developers/docs/concepts/data-model)
