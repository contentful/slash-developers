---
page: :docsUiExtensions
name: UI Extensions
title: UI Extensions
metainformation: 'The UI Extensions SDK allows you to customize and extend the functionality of the Contentful Web App entry editor.'
slug: null
tags:
  - Customization
nextsteps:
  - text: Integrate Contentful with other services via Webhooks
    link: /developers/docs/concepts/webhooks/
  - text: Tools and libraries to make your Contentful experience better
    link: /developers/docs/tools/extensions/
---

The [UI Extensions SDK](https://github.com/contentful/ui-extensions-sdk) allows you to customize and extend the functionality of the Contentful Web App's entry editor. The editor itself is a container for components that enable editors to manipulate the content stored in content fields. Extensions can be simple user interface controls, such as a dropdown, or more complex micro web applications such as our Markdown editor. Extensions are decoupled entities from field types, and you can reuse them, for example using a dropdown to edit number or text fields. Custom extensions that you create are rendered inside a secure iframe.

## Examples

We have created some example extensions to help you understand how to create your own.

### Basic rating dropdown

A dropdown component to change the value of a number field and make a Content Management API request.

[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/rating-dropdown)

{: .img}
![Basic rating dropdown extension screenshot](https://images.contentful.com/tz3n7fnw4ujc/45NRCrYg8gwKW08kug8M2W/3050ef93c62eff65642dc29d0cb8821d/BBD4DC36-163A-43A4-B13F-8AE5F6993434.png_dl_1)

### Rich text editor

This example integrates the Alloy rich text editor into text fields.

[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/alloy-editor)

{: .img}
![Rich text editor extension screenshot](https://images.contentful.com/tz3n7fnw4ujc/3Rzmmj2fuEgwg6kwQ8kSmg/4e9dc78ee1fc95df3bd6063c73fd9bc6/9CDF5788-57FC-444C-8199-04408341F0D7.png_dl_1)

### Chessboard

This extension displays a chessboard and stores the board position as a JSON object. You can drag pieces on the chessboard and the position data updates automatically. The extension also supports collaborative editing, so if two editors open the same entry, moves are synced between them.

[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/chessboard)

{: .img}
![Chessboard extension screenshot](https://images.contentful.com/tz3n7fnw4ujc/1cSM1cmGUKIIMqcAI8KE4u/c740287f67d682ffbbc014665500efe0/B58EE807-A598-478E-A509-C7203A0C35A2.gif_dl_1)

### Slug generator

This extension automatically generates its value from the title field of an entry. For example typing "Hello World" into the title field will set the extensions input field to "hello-world". It will also check the uniqueness of the slug across a customizable list of content types.

[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/slug)

{: .img}
![Slug generator extension screenshot](https://images.contentful.com/tz3n7fnw4ujc/3JUTcNxs7eSkIMKgKeCA62/2f0bcb05d409436c322fb425f8838c78/D0B28EA2-9E86-4A23-ACE0-EED81A758A6D.png_dl_1)

### Translator

This extension translates text from the default locale to other locales in a space using the Yandex translation API.

[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/translate)

{: .img}
![Translator extension screenshot](https://images.contentful.com/tz3n7fnw4ujc/4qrgjGbN7y0oMYSkS6cyko/ee50c251463c954ec875ee35775deefa/92CB0364-E3DA-4649-9D99-8458D7A6A6DD.png_dl_1)

### JSON editor

This extension formats and validates JSON based on the CodeMirror library. You can use it with fields of type "Object".

[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/json-editor)

{: .img}
![Translator extension](https://images.contentful.com/tz3n7fnw4ujc/47FwXETOc0E4u8U62sImq4/b409b273b03a1ed897c88d576ad5e6af/C020349F-ECC0-49D8-A22F-B143F4233F2C.png_dl_1)

### JSON form editor

This extension integrates the JSON editor library to display an edit form based on a predefined JSON schema. The form input gets stored as a JSON object.

[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/json-form-editor)

{: .img}
![Translator extension](https://images.contentful.com/tz3n7fnw4ujc/1M9qxfkvLqi4wI0GGASMwq/5da14e00202b17ae754aedcafe662c5a/E200B073-BC43-4B2E-A89B-6EC48D5AD722.png_dl_1)

### YouTube ID

This extension extracts the video id from a valid YouTube URL for a simple way to integrate with 3rd party media services.

[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/youtube-id)

{: .img}
![YouTube ID extension](https://images.contentful.com/tz3n7fnw4ujc/4M2yCNPQTK8wmiSGmmKIaI/36ec7f8fc7990fff1b521da1dcb359b0/ACC6E270-9904-45F6-94E2-FE0ECEAEADD1.png_dl_1)

### Wistia Videos

The extension loads videos from a project on [wistia](https://wistia.com/) into the Contentful Web Application. A video can be previewed, selected and then stored as part of your content.

[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/wistia)

{: .img}
![Wistia Video extension](https://images.contentful.com/tz3n7fnw4ujc/4Olj3gwXIAEMCqscKIq0yC/68f37a3b6a5daf2664e0b2b3aad6063e/D1F4EE3E-D811-4C4C-BBA5-C990E5B1DD85.gif_dl_1)
