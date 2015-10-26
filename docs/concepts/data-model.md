---
page: :docsDataModel
---

Content in Contentful is organized into *spaces*, so that related resources for one project can be grouped together into one repository.

If you want to deliver the same content to several different platforms, then you should just use one space and create multiple API keys to deliver the content. However, if you have multiple projects, you should put the content into separate spaces. For example, you can have three different apps running on Contentful — it would make sense to set up a separate space for each.

Each space has its own content model and its own permissions for users.

Individual pieces of content are stored in either entries, which represent textual or structural information or assets, which handle binary files, like images, videos or documents. Each piece has a set of attributes, which we call fields. Assets have three fixed fields, name, description and the attached file, but the structure of entries in your space is defined in the content model.

The content model for a space consists of one or more content types. Each content type defines which fields an entry of that type is supposed to have. A field has a name, a data type and additional metadata, like validations. The data type defines what kind of content the field values store, e.g. a short text or an integer number. One notable data type is link, it enables the modelling of relationships between entries and assets. For example, you can have a category content type and link all blog posts belonging to that category to it, so that you can easily retrieve them. Each field in Contentful can also be localized into different locales, by providing a different value for each of them.
