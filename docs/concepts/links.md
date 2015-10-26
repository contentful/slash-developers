---
page: :docsLinks
---

Links are a very powerful way to model relationships between
pieces of content. Contentful search is built to make linked data retrieval
as simple as adding an additional URI query parameter to retrieve an entire
chain of related content that you can display in your application.

Basically, *resources* can have *link* fields which point to other *entries* or *assets*.

When you have related content (e.g. Entries with links to other entries)
it's possible include both search results and related data in a single request.

Simply tell the search to include the targets of links in the response:
Set the `include` parameter to the number of levels you want to resolve.
The maximum number of inclusion is 10.

The search results will include the requested entries matching the query in items, along with the linked entries and assets they contain.

Link resolution works regardless of how many results are there in `items`. Some examples for this are:

- Get a list of blog posts in items with related authors, categories and other meta data in includes.
- Get a single restaurant in items along with its menu, menu items and photos (Assets) in includes.

Note: If an item is already present in the response's items, it will not be included in the `includes.Entry` array again!

Links represent relationships between resources, for example:

- A restaurant linking to its menu (singular relationship)
- A menu linking to its specific menu items (plural relationship)
- Each menu item linking to a photo (attachment)
- A restaurant linking to multiple photos (multiple attachments)

When using links you benefit from many great features:

- Relationships are clearly defined and validated by special content type fields
- Entry links can be validated by content type.
E.g.: Only allow Menu Items for `fields.menuItems`.
- Asset links can be validated by File Type.
E.g.: Only allow Images for `fields.photo`.
- The CDA is highly optimized for links:
A _single_ HTTP request let's you retrieve an entire web of linked resources:
A restaurant with its menu, all menu items  and all of their attachments -
everything in the example above. A mobile app could immediately display
something, if not everything, after a single request.
This is very important for mobile apps where latency is a big issue:
Instead of doing hundreds of requests, do a single request which can also
be cached by Contentful's CDN to speed up future requests even more.

## Modeling Relationships

Linking an entry to another entry represents a relationship.

For example, here's a restaurant pointing to its menu:

~~~ json
{
  "sys": {
    "type": "Entry",
    "id": "il-doges"
  },
  "fields": {
    "menu": {
      "en-US": {
        "sys": {
          "type": "Link",
          "linkType": "Entry",
          "id": "il-doges-nice-menu"
        }
      }
    }
  }
}
~~~

"il-doges" `fields.menu` links to "il-doges-nice-menu".

It's possible to create circular links:
You could model a circular chain of entries to model a dialog in a video game
or more complex graphs. There are many possibilities, it's up to you to decide!

Various fields in every resource's `sys` are also links: The space they're in,
their content type (in case of entries) or Users who created or modified them.

Of course, an entry can also link to more than one entry or asset:

- Have multiple link Fields, e.g. `fields.menu` and `fields.openingHours`
in the restaurant. These represent semantically different links because of the
name & type of the field they're stored in.
You can even limit the entries a link Field may point to by specifying a
Link content type Validation on the field.
- Have an Array of links field, e.g. `fields.menuItems` in the restaurant's
menu. This represents an (orderable) list of related items. Often you may want
to model nothing but an ordered list: In this case, simply create a
Content Type with a single field that links to entries.

## Modeling Attachments

Entries linking to assets represent attachments.

For example, here's a restaurant pointing to some photos:

~~~ json
{
  "sys": {
    "type": "Entry",
    "id": "il-doges"
  },
  "fields": {
    "mainPhoto": {"en-US":
      {"sys": {"type": "Link", "linkType": "Asset", "id": "such-doge"}
    },
    "photos": {"en-US": [
      {"sys": {"type": "Link", "linkType": "Asset", "id": "nice-food"}},
      {"sys": {"type": "Link", "linkType": "Asset", "id": "such-doge"}},
      {"sys": {"type": "Link", "linkType": "Asset", "id": "wow"}}
    ]}
  }
}
~~~


_il-doges' `fields.mainPhoto` links to such-doge, `fields.photos` link to more
photos, including the mainPhoto._

Just as with entry links you can have multiple fields linking to a
single (`fields.mainPhoto`) or multiple (`fields.photos`) assets.

You can limit the type of asset a link Field can link to by specifying an
Asset File Type Validation on the field.

## Link fields in content types

Adding links to an entry requires the entry's content type to have
one or more link Fields.

Let's look at some example field values.
Remember that these need to be used in context of a content type like this:

~~~ json
{
  "sys": {"type": "ContentType", "id": "restaurant"},
  "fields": [
    ...
  ]
}
~~~

### Link field for entry

~~~ json
{
  "id": "menu",
  "type": "Link",
  "linkType": "Entry"
}
~~~

### Link field for multiple entries

~~~ json
{
  "id": "menuItems",
  "type": "Array",
  "items": {
    "type": "Link",
    "linkType": "Entry"
  }
}
~~~

### Link field for asset

~~~ json
{
  "id": "mainPhoto",
  "type": "Link",
  "linkType": "Asset"
}
~~~

### Link field for multiple assets

~~~ json
{
  "id": "photos",
  "type": "Array",
  "items": {
    "type": "Link",
    "linkType": "Asset"
  }
}
~~~

## Link values in entries

Link values are used in entries to specify actual links to other
Entries or assets. Before you can add those links you need to have
added link Fields to a content type.

Link values are represented as objects containing a sys property with the
type and ID of the resource they're linking to:

{:.table}
Field       |Type  |Description
------------|------|------------------------
sys.type    |String|Always "Link".
sys.linkType|String|Type of linked resource.
sys.id      |String|ID of linked resource.

Let's look at some example link values.
Remember that these need to be used in context of an entry like this:

~~~ json
{
  "sys": {"type": "Entry", "id": "restaurant"},
  "fields": {
    "someField": {
      "en-US": ...
    }
  }
}
~~~

### Link to an entry

~~~ json
{
  "sys": {
    "type": "Link",
    "linkType": "Entry",
    "id": "il-doges-nice-menu"
  }
}
~~~

### Links to multiple entries

~~~ json
[
  {"sys": {"type": "Link", "linkType": "Entry", "id": "nice-burger"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "such-dessert"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "WOW"}}
]
~~~

### Link to an asset

~~~ json
{
  "sys": {
    "type": "Link",
    "linkType": "Asset",
    "id": "such-doge"
  }
}
~~~

### Links to multiple assets

~~~ json
[
  {"sys": {"type": "Link", "linkType": "Entry", "id": "nice-food"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "such-doge"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "wow"}}
]
~~~
