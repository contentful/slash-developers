# Your first API call with Ruby

:[API demo intro](../../_partials/api-demo-intro.md)

## Setup

Install the Contentful gem with the following command:

~~~bash
gem install contentful
~~~

Create _hello-contentful.rb_ and copy these lines into it:

~~~ruby
require 'contentful'
require 'pp'

# This is the space ID. A space is like a project folder in Contentful terms
space_id = 'developer_bookshelf'

# This is the access token for this space. Normally you get both ID and the token in the Contentful web app
access_token = '0b7f6x59a0'

# This creates the Client for this Space/Access Token pair
client = Contentful::Client.new(
  space: space_id,
  access_token: access_token,
  dynamic_entries: :auto
)
~~~

## Make the first request

To request an entry with the specified ID, add this to the end of the file:

~~~ruby
entry_id = '5PeGS2SoZGSa4GuiQsigQu'
entry = client.entry(entry_id)

puts "#{entry.name} - by #{entry.author}"
puts "\t  #{entry.description}"
~~~

Save the file and run it:

~~~bash
ruby hello-contentful.rb
~~~

The output should look like this:

~~~bash
An introduction to regular expressions. Volume VI - by Larry Wall
  Now you have two problems.
~~~

In this example, all the fields are text fields, but you can have different types of fields, including Numbers, Booleans, Geolocation, JSON Objects, Files and Links to other Entries. Read [the guide on content modelling and field types](/developer/docs/concepts/data-model) for more details.

:[Custom content Structures](../../_partials/custom-content-structures.md)

You can check the content type of the entry in the previous example with:

~~~ruby
puts
puts entry.content_type
~~~

Which if you run, will output:

~~~bash
#<Contentful::Link: @sys={:type=>"Link", :linkType=>"ContentType", :id=>"book"}>
~~~

This is a link to the content type which defines the structure of this entry. Being API-first, you can fetch this content type from the API and inspect it to understand what it contains. Add the following to _hello-contentful.rb_:

~~~ruby
content_type = client.content_type(entry.content_type.id)

puts
puts "#{content_type.name} Fields:"
pp content_type.fields.map(&:properties)
~~~

Re-running the script should now produce the following output:

~~~bash
Book Fields:
[{:id=>"name",
  :name=>"Name",
  :type=>"Symbol",
  :linkType=>nil,
  :items=>nil,
  :required=>nil,
  :localized=>false},
 {:id=>"author",
  :name=>"Author",
  :type=>"Symbol",
  :linkType=>nil,
  :items=>nil,
  :required=>nil,
  :localized=>false},
 {:id=>"description",
  :name=>"Description",
  :type=>"Symbol",
  :linkType=>nil,
  :items=>nil,
  :required=>nil,
  :localized=>false}]
~~~

:[Explore Further](../../_partials/explore-further.md)


- [Browse other Ruby tutorials](/developers/docs/ruby/)
- [Explore our four APIs](/developers/docs/concepts/apis)
- [Understand content modelling](/developers/docs/concepts/data-model)
