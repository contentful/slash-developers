---
page: :docsEditorInterfaces
name: Editor interfaces
title: blah
metainformation: tbc
slug: null
tags:
 - Basics
 - Content model
nextsteps:
 - text: Model relationships between content with links
   link: /developers/docs/concepts/links/
 - text: Add images to your content
   link: /developers/docs/concepts/images/
---

An editor interface represents the look and feel of content type fields in the web app. They are tightly coupled to a content type and define which widget is rendered for the content type's fields.

For example, the following content type describes a typical blog post data structure. It has a title, a body, and a category that can be either "General", "iOS" or "Android".

```json
{
  "fields": [
    { "id": "title", "name": "Title", "type": "Symbol" },
    { "id": "body", "name": "Body", "type": "Text" },
    {
      "id": "category", "name": "Category", "type": "Symbol",
      "validations": [{ "in": ["General", "iOS", "Android"] }]
    }
  ]
}
```

An editor interface could, for example, define that the `title` field should be rendered as an input field (the widget id is `singleLine`). It could then define that the `body` should be a normal text area (the widget id is `multipleLine`), and that the `category` should be rendered as a dropdown field (the widget id is `dropdown`).

The editor interface would look like this:

```json
{
  "controls": [
    { "fieldId": "title", "widgetId": "singleLine" },
    { "fieldId": "body", "widgetId": "multipleLine" },
    { "fieldId": "category", "widgetId": "dropdown" }
  ]
}
```

There are sets of applicable widgets per content type field type:

| Widget ID               | Applicable field types        | Description                                                                                                         |
| ----------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| assetLinkEditor         | Asset                         | Search, attach, and preview an asset.                                                                               |
| assetLinksEditor        | Asset (array)                 | Search, attach, reorder, and preview multiple assets.                                                               |
| assetGalleryEditor      | Asset (array)                 | Search, attach, reorder, and preview multiple assets in a gallery layout                                            |
| boolean                 | Boolean                       | Radio buttons with customizable labels.                                                                             |
| datePicker              | Date                          | Select date, time, and timezon.                                                                                     |
| entryLinkEditor         | Entry                         | Search and attach another entry.                                                                                    |
| entryLinksEditor        | Entry (array)                 | Search and attach multiple entries.                                                                                 |
| entryCardEditor         | Entry                         | Search, attach, and preview another entry.                                                                          |
| entryCardsEditor        | Entry (array)                 | Search, attach and preview multiple entries.                                                                       |
| numberEditor            | Integer, Number               | A simple input for numbers.                                                                                         |
| rating                  | Integer, Number               | Uses stars to select a number.                                                                                      |
| locationEditor          | Location                      | A map to select or find coordinates from an address.                                                                |
| objectEditor            | Object                        | A code editor for JSON                                                                                              |
| urlEditor               | Symbol                        | A text input that also shows a preview of the given URL.                                                            |
| slugEditor              | Symbol                        | Automatically generates a slug and validates its uniqueness across entries.                                         |
| ooyalaEditor            | Symbol                        | Search and select a video hosted by [Ooyala][]                                                                      |
| kalturaEditor           | Symbol                        | Search and select a video hosted by [Kaltura][]                                                                     |
| kalturaMultiVideoEditor | Symbol (array)                | Search and select multiple videos hosted by [Kaltura][]                                                             |
| listInput               | Symbol (array)                | Text input that splits values on `,` and stores them as an array.                                                   |
| checkbox                | Symbol (array)                | A group of checkboxes. One for each value from the `in` validation on the content type field                        |
| tagEditor               | Symbol (array)                | A text input to add a string to the list. Shows the items as tags and allows to remove them.                        |
| multipleLine            | Text                          | A simple `<textarea>` input                                                                                         |
| markdown                | Text                          | A full-fledged [markdown editor][]                                                                                  |
| singleLine              | Text, Symbol                  | A simple text input field                                                                                           |
| dropdown                | Text, Symbol, Integer, Number | A `<input type="select">` element. It uses the values from an `in` validation on the content type field as options. |
| radio                   | Text, Symbol, Integer, Number | A group of radio buttons. One for each value from the `in` validation on the content type field                     |

[kaltura]: https://www.contentful.com/ecosystem/kaltura/

[ooyala]: https://www.contentful.com/ecosystem/ooyala/

[markdown editor]: https://www.contentful.com/r/knowledgebase/markdown/

## Settings

You can pass custom settings to a control that change the behavior or presentation of a widget.

The entry for a field of type `Boolean`, for example, would look like this.

```json
{
  "fieldId": "isFeatured",
  "widgetId": "boolean",
  "settings": {
    "helpText": "Feature the post on homepage?",
    "trueLabel": "yes",
    "falseLabel": "no",
  }
}
```

If present, the `settings` object of a control must be an object. All widgets accept the `helpText` setting and use it to render extra information with the widget. Other settings are widget specific.

<table>
<thead>
  <tr>
    <th>Widget ID</th>
    <th>Property Name</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td rowspan="2">boolean</td>
    <td><code>trueLabel</code></td>
    <td>Shows this text next to the radio button that sets this value to `true`. Defaults to “Yes”.</td>
  </tr>
  <tr>
    <td><code>falseLabel</code></td>
    <td>Shows this text next to the radio button that sets this value to `false`. Defaults to “No”.</td>
  </tr>
  <tr>
    <td>rating</td>
    <td><code>stars</code></td>
    <td>Number of stars to select from. Defaults to 5.</td>
  </tr>
  <tr>
    <td rowspan="2">datePicker</td>
    <td><code>format</code></td>
    <td>One of “dateonly”, “time”, “timeZ” (default). Specifies whether to show the clock and/or timezone inputs.</td>
  </tr>
  <tr>
    <td><code>ampm</code></td>
    <td>Specifies which type of clock to use. Must be one of the stringss “12” or “24” (default).</td>
  </tr>
</tbody>
</table>
