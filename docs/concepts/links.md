---
page: :docsLinks
name: Links
title: Links
metainformation: 'Links are a powerful way to model relationships between content. You can use a URI query parameter with the Contentful search to retrieve an entire chain of related content to display in your application.'
slug: null
tags:
  - Basics
  - Content model
nextsteps:
  - text: Add images to your content
    link: /developers/docs/concepts/images/
---

Links are a powerful way to model relationships between content. You can use a URI query parameter with the Contentful search to retrieve an entire chain of related content to display in your application.

Entries can have link fields which point to other entries or assets, for example:

- A restaurant linking to its menu (singular relationship).
- A menu linking to its specific menu items (plural relationship).
- Each menu item linking to a photo (attachment).
- A restaurant linking to multiple photos (attachments).

A **single** HTTP request lets you retrieve the entire set of linked resources above, starting with the menu, in one request. Contentful's CDN can cache these requests to further speed up future requests. This is useful for mobile apps as it reduces the need for multiple concurrent connections, and the latency for results to return.

Links bring you other features:

- Relationships are clearly defined and validated by specific content type fields.
- Entry links can be validated by content type. E.g. Only allow Menu Items for `fields.menuItems`.
- Asset links can be validated by file type. E.g. Only allow Images for `fields.photo`.

{: .note}
**Note:** Because of the caching features describe above, this automated link resolution performed by the API is only available with the [Content Delivery API](/developers/docs/references/content-delivery-api/) and [Preview API](/developers/docs/references/content-preview-api/).

## Link level

By default, a response includes the first level of linked content. Use the `include` parameter to set the number of levels you want to return. The maximum number of inclusions is `10`.

Link resolution works regardless of how many results are there in `items`.

{: .note}
**Note:** Only links between entries, spaces and assets are resolved. Links between spaces and content types are not included in the response.

## JSON response

In the JSON response of a successful query, linked items are placed in the `includes` array, when not already fetched in the `items` array.

Take this query:

~~~bash
curl -v 'https://cdn.contentful.com/spaces/oc3u7dt7mty5/entries?access_token=6cabb22c95d52aa7752fe70ae9b3271a1fc2decf7ae7d99ccd7dceba718980e6&include=1'
~~~

This fetches the restaurant entry `Spaceburger` alongside its image links by using the `restaurantImages` linking field:

~~~json
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

The response retrieves the image with `id=23qqdlTciMGm6IYy224euu` as a link to an asset. Information about the `23qqdlTciMGm6IYy224euu` image is in the `includes` array:

~~~json
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

Before resolving links to items, Contentful matches the filter conditions of a query. This changes the response contained within the `items` array to reflect the search criteria of the querying URL.

Here's the response for a menu linked to its meals:

~~~json
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

As `AstroChicken` and `AstroCattle` all match the conditions of the query parameters and are linked to `Menu for Humans`, they are all fetched in the same `items` array. Since `AstroChicken` and `AstroCattle` are present in the response's `items`, they are not included in the `includes.Entry` array.

## Fetching resources linked to a specific entry

You might want retrieve all items linked to a particular target entry. Your query URL should filter entries based on their specific `content_type`, a `linking_field` to link items and a `entry_id` from the target entry.

For example, to retrieve all resources of content type `Menu` linked to the restaurant `Space Burger` by using the following query URL:

~~~bash
curl -v 'https://cdn.contentful.com/spaces/oc3u7dt7mty5/entries?access_token=6cabb22c95d52aa7752fe70ae9b3271a1fc2decf7ae7d99ccd7dceba718980e6&content_type=3HjHXUYR3yyosUqAGmi8wu&fields.restaurantField.sys.id=2UmoQ8Bo4g4S82WmGiQIQE'
~~~

Because these are all Menus linked to the `Space Burger` restaurant, `Menu for Humans`, `Menu for Romulans` and `Menu for Klingons` are all retrieved alongside their own links and the target entry:

~~~json
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

Linking an entry to another entry represents a relationship. The structure of linked items should be like this:

~~~json
{
  "fields": {
      "reference_field": {
          "en-US": {
              "sys": {
                  "type": "Link",
                  "linkType": "Entry",
                  "id": "<ID_of_Linked_Item>"
               }
           }
       },
      "title": {
        ...
       },
       ...
   }
}
~~~

Here's a restaurant linked to its menu:

~~~json
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

## Multiple links

It's possible to create circular links, for example a chain of entries to model a dialog in a video game or complex graphs.

Certain fields in every Resource's `sys` array are also links. These include the space they're in, their content type (in the case of entries) or users who created or modified them.

An entry can link to more than one entry or asset, here's how:

- Multiple link fields, e.g. for the restaurant example, fields for `fields.menu` and `fields.openingHours`. You could even limit the entries a link field can point to by specifying link content type validation on the field.
- An array of links field, e.g. `fields.menuItems` in the restaurant's menu, representing an ordered list of related items.

## Modeling attachments

Below is the example JSON structure of an entry with an asset attached:

~~~json
{
  "fields": {
    "title": {
      "en-US": "Hello, World!"
    },
    "reference_field": {
      "en-US": [
        {"sys": {
          "type": "Link",
          "linkType": "Asset",
          "id": "id1"
        }},
        {"sys": {
          "type": "Link",
          "linkType": "Asset",
          "id": "id2"
        }}
        ...
      ]
    }
  }
}
~~~

For example, here's a restaurant with related photos:

~~~json
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

As with entry links, you can have multiple fields linking to a single `fields.mainPhoto` or multiple `fields.photos` assets.

You can limit the type of asset a link field can link to by specifying an asset file type validation on the field.

## Link fields in content types

Adding links to an entry requires the entry's content type to have one or more link fields.

Here are some other examples, used in the context of a content type like this:

~~~json
{
  "sys": {"type": "ContentType", "id": "restaurant"},
  "fields": [
    ...
  ]
}
~~~

### Link field for entry

~~~json
{
  "id": "menu",
  "type": "Link",
  "linkType": "Entry"
}
~~~

### Link field for multiple entries

~~~json
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

~~~json
{
  "id": "mainPhoto",
  "type": "Link",
  "linkType": "Asset"
}
~~~

### Link field for multiple assets

~~~json
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

You can use link values in entries to specify actual links to other entries or assets. Before you can add these links you need to have added link fields to a content type.

Contentful represents link values as objects containing a `sys` property with the type and ID of the resource they're linking to:

{:.table}
Field |Type |Description
------------|------|------------------------
sys.type |String|Always "Link".
sys.linkType|String|Type of linked Resource.
sys.id |String|ID of linked Resource.

Here are some examples, used in the context of an entry like this:

~~~json
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

~~~json
{
  "sys": {
    "type": "Link",
    "linkType": "Entry",
    "id": "il-doges-nice-menu"
  }
}
~~~

### Links to multiple entries

~~~json
[
  {"sys": {"type": "Link", "linkType": "Entry", "id": "nice-burger"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "such-dessert"}},
  {"sys": {"type": "Link", "linkType": "Entry", "id": "WOW"}}
]
~~~

### Link to an asset

~~~json
{
  "sys": {
    "type": "Link",
    "linkType": "Asset",
    "id": "such-doge"
  }
}
~~~

### Links to multiple assets

~~~json
[
  {"sys": {"type": "Link", "linkType": "Asset", "id": "nice-food"}},
  {"sys": {"type": "Link", "linkType": "Asset", "id": "such-doge"}},
  {"sys": {"type": "Link", "linkType": "Asset", "id": "wow"}}
]
~~~
