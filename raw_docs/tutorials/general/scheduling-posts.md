---
page: :docsSchedulingPosts
name: Scheduling Posts
title: Scheduling Posts
metainformation: 'This guide will show you how to manage the publishing time of content.'
slug: null
tags:
  - Customization
  - Workflow
nextsteps: null
---

## Overview

In this article, we will expose how to manage the publishing time of content.

We use the example of a fictitious online magazine named `Andromeda` with `Articles` content type. The editors of this magazine want to manage content by specifying a publishing and unpublishing date and time for their entries.

Here is what we're going to do:

1. Create a basic Middleman app that retrieves entries from the Content Delivery API;
2. Add scheduling fields to `Articles` content type
3. Add time functionality to the application
4. Filter entries based on their scheduled date and time and order them by chronological order


## Structure of the app

For this example, we will use a simple Middleman app to retrieve entries in a single-page application. The [following structure](https://github.com/contentful-labs/scheduling_app/commit/88017afc8e27b4689ff0636fccb8ae5b786b5639) is primarily used as a template for the magazine:

~~~
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

To retrieve entries, we must connect the Middleman app to the Content Delivery API by adding the [following code](https://github.com/contentful-labs/scheduling_app/commit/cdd6ae913b13ce95274ed96db84160fa65b05048), holding our Contentful information, to `config.rb`:

~~~ ruby
activate :contentful do |f|
  f.access_token = "b99a46242f4a6e49263f30844bbb28649460e5b89088b97b3c79e14e6da12a8f"
  f.space = {magazine: "50gfvusg5ukj"}
  f.content_types = {article: "TE5C4G3m2AOwWcCoM6Cqc"}
  f.cda_query = {content_type: "TE5C4G3m2AOwWcCoM6Cqc" }
end
~~~

## Display entries in the application

We next [add some code to index.html.erb](https://github.com/contentful-labs/scheduling_app/commit/cc2243b34195808b7e5e5dedbd64ec9ea7adc284) to display articles:

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

Use `middleman contentful` to import entries and `middleman server` to start the application.

## Scheduling visibility with time fields and query parameters

We now have a simple static site being with all the content managed in Contentful. However, our editors want to schedule articles to be published in the future. To solve this, we can simply add some date fields to our `Articles` content type and use them to filter the entries included in our site.

### Add the date fields

First, in the Contentful web app , we must add the fields `startDateTime` and `endDateTime` to the content type `Articles`:

{:.img}
![](https://images.contentful.com/3ts464by117l/3UqDYxf6YUquiUEiESG0os/7551bdcc9f59a9804847e7039e521940/Screen_Shot_2015-11-06_at_1.49.31_PM.png)

{:.img}
![](https://images.contentful.com/3ts464by117l/2O6cTuFFlYCiICyUic0CyC/71805eeed16bbe01444fc85a37e996b8/Screen_Shot_2015-11-06_at_1.49.51_PM.png)

Then, in `config.rb`, [we define](https://github.com/contentful-labs/scheduling_app/commit/6bb6ad5a39149ed6cc9a772606072dabeee9f08c) a `timenow` variable to filter scheduled entries:

~~~ ruby
@timenow = Time.now
@timenow = @timenow - (@timenow % 300)
@timenow = @timenow.strftime("%FT%T")
@timenow = @timenow.to_s
~~~

Note that second line, which causes `@timenow` to move in increments of 5 minutes like `"2015-12-24T10:00:00"`, `"2015-12-24T10:05:00"`, `"2015-12-25T10:10:00"` and so on. It is a good practice to always truncate timestamps based on the current time to an acceptable latency to keep your requests cache-friendly.

### Add filter parameters to the entries query

With that in mind, [we filter](https://github.com/contentful-labs/scheduling_app/commit/ec1238823f893c81ba8724ec237560eecdbef538) entries with `endDateTime` greater than `timenow` and `startDateTime` less than `timenow`:

~~~ ruby
f.cda_query = {content_type: "TE5C4G3m2AOwWcCoM6Cqc",'fields.endDateTime[gt]' => @timenow, 'fields.startDateTime[lte]' => @timenow}
~~~

Then, we order these matched entries [by creation date](https://github.com/contentful-labs/scheduling_app/commit/d7fcab40cefcb1cc1f243dd3f50385c9b7e8c271):

~~~ ruby
f.cda_query = {content_type: "TE5C4G3m2AOwWcCoM6Cqc",'fields.endDateTime[gt]' => @timenow, 'fields.startDateTime[lte]' => @timenow, 'order' => '-fields.startDateTime' }
~~~

### Refresh the content

Now if you re-run `middleman contentful` and `middleman server` you will see your entries sorted by their startDateTime:

{:.img}
![](https://images.contentful.com/3ts464by117l/3bjFu5vA9a2miKSSu0aQa4/e1734ed22507357a575587b98c40d334/Screen_Shot_2015-11-10_at_1.56.39_PM.png)

## Using Contentful views

Now that the site is only showing items that are supposed to be published, we can do one more thing to make lives easier for our editors. Saved views enable you to share a specific set of filter, columns, and ordering in the Contentful web app with other members of the space. In this example, we will create a view that shows articles ordered by their `fields.startDateTime` date, so that our editors can easily see what's coming up next.

Using the Contentful web app, in the search bar, we will select the content type `Article`, click in the three lines icon above *Status* and then add the "Start Date Time" column to the table:

{:.img}
![](https://images.contentful.com/3ts464by117l/3EJFlPxIaQEmmeKGQK4akG/fb351f69300f148e5fd77ab4a74823a0/view1.png)

Finally click the `+` sign, select `Save current view as..` and name the view "Incoming Articles":

{:.img}
![](https://images.contentful.com/3ts464by117l/2wP0e3DwOUo0YIE2EEAcO8/cdc0f1d83e8a58d28139dd7ee98e110c/view2.png)

Now that our view has been saved any member of the space can use it to see the schedule for upcoming articles:

{:.img}
![](https://images.contentful.com/3ts464by117l/45BI6XvSfe0IyIUq8qosGi/a0751ee0493a988e367c9664db3c3b69/view3.png)

## Conclusion

In this article we have:

- Explored the usage of a simple Middleman app and its integrations with the Content Delivery API
- Created time fields and variables whereby you can filter entries
- Crafted querying parameters used to manage scheduled posts
- Built a Middleman View used to retrieve filtered entries

### Related resources

- For more advanced examples of using `contentful_middleman` check out [`contentful_middleman_examples`][cf-mm-examples] on GitHub.
- To learn more about the different kinds of filtering & querying supported by our API, check out [the reference documentation][filtering-reference].
- Finally, you can find more static site generator integrations on our [tools][tools] page.

[cf-mm-examples]: https://github.com/contentful/contentful_middleman_examples
[filtering-reference]: /developers/docs/references/content-delivery-api/#/reference/search-parameters
[tools]: /developers/docs/tools/staticsitegenerators/
