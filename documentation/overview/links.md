# Links

Links are a very powerful way to model relationships between
pieces of content. Contentful's search is built to make linked data retrieval
as simple as adding an additional URI query parameter to retrieve an entire
web of related content that you can display in your application.

Basically Resources can have Link fields which point to other Entries or
Assets.

When you have related content (e.g. Entries with links to other Entries)
it's possible include both search results and related data in a single request.

Simply tell the search to include the targets of links in the response:
Set the `include` parameter to the number of levels you want to resolve.
The maximum number of inclusion is 10.

The search result will include the requested Entry matching the query in items along with the linked Entries and Assets in includes.

Link resolution works regardless of how many results are there in `items`. Some examples for this are:

- Get a list of blog posts in items with related authors, categories and other meta data in includes.
- Get a single restaurant in items along with its menu, menu items and photos (Assets) in includes.

Important note: If an item is already present in the response's items, it will not be included in 
the `include.Entry` again!
