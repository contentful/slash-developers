---
page: :docsSchedulingPosts
---

#Overview

In this article, we will expose how to manage the publishing time of content. 

We use the example of a fictitious online magazine named `Andromeda` with `Articles` Content Type.  

The editors of this magazine want to manage content by specifying a publishing and unpublishing date and time for their Entries. 

Here is what we're going to do:

1. Create a basic Middleman app that retrieves Entries from Contentful's API;

2. Add scheduling fields to `Articles` Content Type

3. Add time functionality to the application

4. Filter Entries based on their scheduled Date and Time and order them by chronological order


## Structure of the App

For this example, we will use a simple Middleman app to retrieve Entries in a single-page application. The [following structure](https://github.com/contentful-labs/scheduling_app/commit/88017afc8e27b4689ff0636fccb8ae5b786b5639) is primarily used as a template for the magazine: 

~~~ bash
├── Gemfile
├── Gemfile.lock
├── README.md
├── config.rb
└── source
    ├── images
    │   ├── background.png
    │   └── middleman.png
    ├── index.html.erb
    ├── javascripts
    │   └── all.js
    ├── layouts
    │   └── layout.erb
    └── stylesheets
        └── all.css
~~~

## Connecting to the API

To retrieve Entries, we must connect the Middleman app to the Content Delivery API by adding the [following code](https://github.com/contentful-labs/scheduling_app/commit/cdd6ae913b13ce95274ed96db84160fa65b05048), holding our Contentful information, to `config.rb`:

~~~ ruby
activate :contentful do |f|
  f.access_token = "b99a46242f4a6e49263f30844bbb28649460e5b89088b97b3c79e14e6da12a8f"
  f.space = {magazine: "50gfvusg5ukj"}
  f.content_types = {article: "TE5C4G3m2AOwWcCoM6Cqc"}
  f.cda_query = {content_type: "TE5C4G3m2AOwWcCoM6Cqc" }
end
~~~ 

## Time Fields and Variables

With that, In Contentful's Web Interface, we must add the fields `startDateTime` and `endDateTime` to the Content Type `Articles`:

![alt text](https://images.contentful.com/3ts464by117l/3UqDYxf6YUquiUEiESG0os/7551bdcc9f59a9804847e7039e521940/Screen_Shot_2015-11-06_at_1.49.31_PM.png)

![alt text](https://images.contentful.com/3ts464by117l/2O6cTuFFlYCiICyUic0CyC/71805eeed16bbe01444fc85a37e996b8/Screen_Shot_2015-11-06_at_1.49.51_PM.png)

Then, in `config.rb`, [we must define](https://github.com/contentful-labs/scheduling_app/commit/6bb6ad5a39149ed6cc9a772606072dabeee9f08c) a `timenow` ruby variable to filter scheduled Entries:

~~~ ruby
@timenow = Time.now - 900
@timenow = @timenow.strftime("%FT%T")
@timenow = @timenow.to_s
~~~

Note that it is good practice to round `timenow` to the nearest ~900 seconds (15 minutes). While using `endDateTime[gt]` or `startDateTime[lte]`, it ensures the query paramaters will remain stable over time.

## Querying parameters

With that in mind, [we filter](https://github.com/contentful-labs/scheduling_app/commit/ec1238823f893c81ba8724ec237560eecdbef538) Entries with `endDateTime` greater than `timenow` and `startDateTime` less than `timenow`:

~~~ ruby
f.cda_query = {content_type: "TE5C4G3m2AOwWcCoM6Cqc",'fields.endDateTime[gt]' => @timenow, 'fields.startDateTime[lte]' => @timenow}
~~~

Then, we order these matched Entries [by creation date](https://github.com/contentful-labs/scheduling_app/commit/d7fcab40cefcb1cc1f243dd3f50385c9b7e8c271):

~~~ ruby
f.cda_query = {content_type: "TE5C4G3m2AOwWcCoM6Cqc",'fields.endDateTime[gt]' => @timenow, 'fields.startDateTime[lte]' => @timenow, 'order' => 'sys.createdAt' }
~~~

## Retrieving Entries in the application
 We must [add some code to index.html.erb](https://github.com/contentful-labs/scheduling_app/commit/cc2243b34195808b7e5e5dedbd64ec9ea7adc284) to retrieve Entries:

~~~ erb
<div class="container">
  <% data.magazine.article.each do |id, article| %>
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title"><%= article["title"] %></h3>
      </div>
      <div class="panel-body">
        <%= article["body"] %>
      </div>
    </div>
  <% end %>
</div>        
~~~

Use `middleman contentful` to import Entries and `middleman server` to start the application. Finally, our scheduled Entries are retrieved in chronological order:

![alt text](https://images.contentful.com/3ts464by117l/3bjFu5vA9a2miKSSu0aQa4/e1734ed22507357a575587b98c40d334/Screen_Shot_2015-11-10_at_1.56.39_PM.png)

## Using Contentful Views

Using views enables you to store a list of Entries filtered by a certain content type or query parameters. In this example, we will create a saved view that shows articles ordered by their `createdAt` date, so that the editor is able to see what's coming up next.

Using the Contentful's Web Interface, in the search bar, we will select the content type `Article` and the query parameter `order=createdAt`. Then, click on `+` followed by `Save current view as..` :

![alt text](https://images.contentful.com/3ts464by117l/71yu3so7CMakEECiGMq4kS/be3a736aa9720f7de45fe43ce088cf39/view1.png)

Our view has been saved and we can now see Entries ordered by their creation date:

![alt text](https://images.contentful.com/3ts464by117l/728f1yqv0AEaesAGYgsKGe/a7b96b7d16c909db137a31fbc3203141/view2.png)

## Conclusion

In this article we have:

+ Explored the usage of a simple Middleman app and its integrations with Contentful's APIs

+ Created time fields and variables whereby you can filter Entries

+ Crafted querying parameters used to manage scheduled posts

+ Built a Middleman View used to retrieve filtered Entries

Note this is a simple application consistently using the `middleman contentful` command to import newly added Entries. 

For a more detailed and comprehensive approach, visit our [documentation](https://www.contentful.com/developers/docs/references/content-delivery-api/#/reference), [SDKs](https://www.contentful.com/developers/docs/code/libraries/) and various [tools](https://www.contentful.com/developers/docs/code/tools/).

