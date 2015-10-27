---
page: :docsLinks
---

Links are a very powerful way to model relationships between
pieces of content. Contentful search is built to make linked data retrieval
as simple as adding an additional URI query parameter to retrieve an entire
chain of related content that you can display in your application.

Basically, *Resources* can have *Link* fields which point to other *Entries* or *Assets*, for example:

- A restaurant linking to its menu (singular relationship)
- A menu linking to its specific menu items (plural relationship)
- Each menu item linking to a photo (attachment)
- A restaurant linking to multiple photos (multiple attachments)

When using links you benefit from many great features:

- Relationships are clearly defined and validated by special Content Type Fields
- Entry Links can be validated by Content Type.
E.g.: Only allow Menu Items for `fields.menuItems`.
- Asset Links can be validated by File Type.
E.g.: Only allow Images for `fields.photo`.
- The CDA is highly optimized for Links:
A _single_ HTTP request let's you retrieve an entire web of linked Resources:
A restaurant with its menu, all menu items  and all of their attachments -
everything in the example above. A mobile app could immediately display
something, if not everything, after a single request.
This is very important for mobile apps where latency is a big issue:
Instead of doing hundreds of requests, do a single request which can also
be cached by Contentful's CDN to speed up future requests even more.

## Linked Entries

When you have related content (e.g. Entries with links to other Entries)
it's possible include both search results and related data in a single request.

Simply tell the search to include the targets of links in the response:
Set the `include` parameter to the number of levels you want to resolve.
The maximum number of inclusion is 10.

The search results will include the requested entries matching the query in items, along with the linked entries and assets they contain.

Link resolution works regardless of how many results are there in `items`. Some examples for this are:

- Get a list of blog posts in items with related authors, categories and other meta data in includes.
- Get a single restaurant in items along with its menu, menu items and photos (Assets) in includes.

### Querying Linked Entries

Querying linked items is as simple as adding a specific `include` parameter to retrieve a desired level of related content to be displayed in an application. 

In the JSON response of a successful query, when not already fetched in the `items` array, linked items are placed in the `includes` array. 

Let's take the example of restaurants pointing to their linked images.

Before anything, we need a successful query URL using the `include=1` parameter:

~~~ bash
curl -v https://cdn.contentful.com/spaces/oc3u7dt7mty5/entries?access_token=6cabb22c95d52aa7752fe70ae9b3271a1fc2decf7ae7d99ccd7dceba718980e6&include=1
~~~

The first part of a JSON response gets information about Entries and their Links. 

In the following example, the restaurant Entry `Spaceburger` is fetched alongside its Links to images by using the `restaurantImages` linking field:

~~~ json
  "items": [
    {
      "sys": {
        "type": "Entry",
        "id": "2UmoQ8Bo4g4S82WmGiQIQE",
        ...
      },
      "fields": {
        "name": "Spaceburger",
        "description": "The Jetson's love to come here!",
        "restaurantImages": [
          {
            "sys": {
              "type": "Link",
              "linkType": "Asset",
              "id": "23qqdlTciMGm6IYy224euu"
            }
          }
        ]
      }
    },
    
    ...
  ],
~~~

As seen in the above response, the linked image with `id=23qqdlTciMGm6IYy224euu` is only retrieved as a Link to an Asset. 

Instead, information about the `23qqdlTciMGm6IYy224euu` image is placed in the `includes` array:

~~~ json
  "includes": {
    "Asset": [
      {
        "sys": {
          "type": "Asset",
          "id": "23qqdlTciMGm6IYy224euu",
          ...
        },
        "fields": {
          "title": "The SpaceBurger Photo",
          "file": {
            "fileName": "spaceburger.jpg",
            "contentType": "image/jpeg",
            "details": {
              "image": {
                "width": 550,
                "height": 421
              },
              "size": 205683
            },
            "url": "//images.contentful.com/oc3u7dt7mty5/23qqdlTciMGm6IYy224euu/85514b430c28045a3b2930ebe15dfcce/spaceburger.jpg"
          }
        }
      },
      ...
    ]
  }
~~~ 

However, the structure of a JSON response could have been different. Before resolving Links to items, Contentful matches the filter conditions of a query.

As a consequence, if our linked resource had matched the filter conditions of the query parameters, it would have been put inside the `items` array.

Lets take a look at the response of a menu pointing to its meals:

~~~ json 
"items": [
    {
      "sys": {
        "type": "Entry",
        "id": "4rJn9OJsBiAKmeoiiw40Ko",
      },
      "fields": {
        "name": "Menu for Humans",
        ...
        "stickiness": 999.3,
        "menuMeal": [
          {
            "sys": {
              "type": "Link",
              "linkType": "Entry",
              "id": "3HkMtbj6hqcMYEqWIOm6SQ"
            }
          },
          {
            "sys": {
              "type": "Link",
              "linkType": "Entry",
              "id": "3SVh6Ei9pCkkIkoE0ME4Ms"
            }
          }
        ]
      }
    },
    ...
    {
      "sys": {
        "type": "Entry",
        "id": "3HkMtbj6hqcMYEqWIOm6SQ",
        ...
      },
      "fields": {
        "weight": 203.1,
        "name": "AstroChicken ",
        "rating": 100,
        "description": "An entire chicken with Andromeda's sauce"
      }
    },
    {
      "sys": {
        "type": "Entry",
        "id": "3SVh6Ei9pCkkIkoE0ME4Ms",
        ...
      },
      "fields": {
        "weight": 23049950.9,
        "name": "AstroCattle",
        "rating": 30,
        "description": "Yummy Cows with fries and Ketchup"
      }
    },
    ...

]    
~~~

As you can see, although 'Menu for Humans' is linked to its meals, `AstroChicken` and `AstroCattle`, they are all fetched in the same `items` array. That happens because they all primarily match the conditions of our query parameters.

In the end, since `AstroChicken` and `AstroCattle` are already present in the response's `items`, it should not be included in the `includes.Entry` array again.

Note: When omitted, the `include` parameter takes the standard value of `1` 

### Fetching resources linked to a specific Entry

It might be useful to retrieve all items linked to a particular target Entry. To do so, a query URL should filter Entries based on their specific `content_type`, `linking_field` used to link such items and `entry_id` from our target Entry. 

For example, let's retrieve all resources of Content Type `Menu` linked to the restaurant `Space Burger` by using the following query URL:

~~~ bash
curl -v https://cdn.contentful.com/spaces/oc3u7dt7mty5/entries?access_token=6cabb22c95d52aa7752fe70ae9b3271a1fc2decf7ae7d99ccd7dceba718980e6&content_type=3HjHXUYR3yyosUqAGmi8wu&fields.restaurantField.sys.id=2UmoQ8Bo4g4S82WmGiQIQE
~~~

Because these are all Menus linked to the `Space Burger` restaurant , `Menu for Humans`, `Menu for Romulans` and `Menu for Klingons` are all retrieved alongside their own links and the target Entry:

~~~ json
  "items": [
    {
      "fields": {
        "restaurantField": {
            "sys": {
              "type": "Link",
              "linkType": "Entry",
              "id": "2UmoQ8Bo4g4S82WmGiQIQE"
            }
          },
        "name": "Menu for Humans",        
        "images": [
          ...
        ],
        "menuMeal": [
          ...
        ]
      },
      "sys": {
        "type": "Entry",
        "id": "4rJn9OJsBiAKmeoiiw40Ko",
      }      
    },    
    {
      "fields": {
        "restaurantField": {
          "sys": {
            "type": "Link",
            "linkType": "Entry",
            "id": "2UmoQ8Bo4g4S82WmGiQIQE"
          }
        },
        "name": "Menu for Romulans",
        "menuMeal": [
          ...
        ]
      },
      "sys": {
        "type": "Entry",
        "id": "2Mt2YctJQ4am8u2oI4kcsS",
        ...
      }     
    },
    {
      "fields": {    
        "restaurantField": {
          "sys": {
            "type": "Link",
            "linkType": "Entry",
            "id": "2UmoQ8Bo4g4S82WmGiQIQE"
          }
        },
        "name": "Menu for Klingons",
        "menuMeal": [
          {
            ...
            }
        ]
      },
      "sys": {
        "type": "Entry",
        "id": "2RnAOt0ssgQ6kIk0E4WAeq",
        ...
      }     
    },
    {
      "sys": {
        "type": "Entry",
        "id": "2UmoQ8Bo4g4S82WmGiQIQE",
        ...
      },
      "fields": {
        "name": "Spaceburger",
        "description": "The Jetson's love to come here!",
        "restaurantImages": [
          {
            "sys": {
              "type": "Link",
              "linkType": "Asset",
              "id": "23qqdlTciMGm6IYy224euu"
            }
          }
        ]
      }
    },
    ...
  ]    
~~~

## Modeling Relationships

Linking an Entry to another Entry represents a relationship.

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
You could model a circular chain of Entries to model a dialog in a video game
or more complex graphs. There are many possibilities, it's up to you to decide!

Various fields in every Resource's `sys` are also Links: The Space they're in,
their Content Type (in case of Entries) or Users who created or modified them.

Of course, an Entry can also link to more than one Entry or Asset:

- Have multiple Link Fields, e.g. `fields.menu` and `fields.openingHours`
in the restaurant. These represent semantically different Links because of the
name & type of the Field they're stored in.
You can even limit the Entries a Link Field may point to by specifying a
Link Content Type Validation on the Field.
- Have an Array of Links Field, e.g. `fields.menuItems` in the restaurant's
menu. This represents an (orderable) list of related items. Often you may want
to model nothing but an ordered list: In this case, simply create a
Content Type with a single Field that links to Entries.

## Modeling Attachments

Entries linking to Assets represent attachments.

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

Just as with Entry links you can have multiple Fields linking to a
single (`fields.mainPhoto`) or multiple (`fields.photos`) Assets.

You can limit the type of Asset a Link Field can link to by specifying an
Asset File Type Validation on the Field.

## Link Fields in Content Types

Adding Links to an Entry requires the Entry's Content Type to have
one or more Link Fields.

Let's look at some example Field values.
Remember that these need to be used in context of a Content Type like this:

~~~ json
{
  "sys": {"type": "ContentType", "id": "restaurant"},
  "fields": [
    ...
  ]
}
~~~

### Link Field for Entry

~~~ json
{
  "id": "menu",
  "type": "Link",
  "linkType": "Entry"
}
~~~

### Link Field for multiple Entries

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

### Link Field for Asset

~~~ json
{
  "id": "mainPhoto",
  "type": "Link",
  "linkType": "Asset"
}
~~~

### Link Field for multiple Assets

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

## Link values in Entries

Link values are used in Entries to specify actual Links to other
Entries or Assets. Before you can add those links you need to have
added Link Fields to a Content Type.

Link values are represented as objects containing a sys property with the
type and ID of the resource they're linking to:

{:.table}
Field       |Type  |Description
------------|------|------------------------
sys.type    |String|Always "Link".
sys.linkType|String|Type of linked Resource.
sys.id      |String|ID of linked Resource.

Let's look at some example Link values.
Remember that these need to be used in context of an Entry like this:

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

### Link to an Entry

~~~ json
{
  "sys": {
    "type": "Link",
    "linkType": "Entry",
    "id": "il-doges-nice-menu"
  }
}
~~~

### Links to multiple Entries

~~~ json
[
  {"sys": {"type": "Link", "linkType": "Entry", "id": "nice-burger"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "such-dessert"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "WOW"}}
]
~~~

### Link to an Asset

~~~ json
{
  "sys": {
    "type": "Link",
    "linkType": "Asset",
    "id": "such-doge"
  }
}
~~~

### Links to multiple Assets

~~~ json
[
  {"sys": {"type": "Link", "linkType": "Entry", "id": "nice-food"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "such-doge"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "wow"}}
]
~~~
