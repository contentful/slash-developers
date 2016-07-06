---
page: :docsUiExtensions
---

The UI Extensions SDK allows you to customize and extend the functionality of [Contentful](https://www.contentful.com)
Web Application's entry editor. The editor itself is a container for many components that enable editors to manipulate the content stored in content fields. Extensions can be simple user interface controls, such as a dropdown, or more complex micro web applications such as our Markdown editor. They are decoupled entities from field types, and can be reused (for example using a dropdown to edit number or text fields).

Previously, the Contentful Web Application only offered our core platform components to manipulate fields' content. Now, with the UI Extensions SDK it is possible to personalize this Web App based on your needs.
Core components and custom extensions are both built on top of the same API, leading them to follow the same approach. The main difference resides in the fact that custom extensions are rendered inside a secure iframe.<br>
[View on GitHub](https://github.com/contentful/ui-extensions-sdk)

## Examples

### Basic rating dropdown
Basic extension that helps you get started with developing. Uses a dropdown to change the value of a number field and makes some CMA requests.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/rating-dropdown)

{: .img}
![Basic rating dropdown](basic-rating-dropdown.png)

### Rich text editor
This example integrates the Alloy rich text editor to edit text fields.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/alloy-editor)

{: .img}
![Rich text editor](rich-text-editor.png)

### Chessboard
This extension displays a chessboard and stores the board position as a JSON object. You can drag pieces on the chessboard and the position data will be updated automatically. The extension also supports collaborative editing. If two editors open the same entry moves will be synced between them.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/chessboard)

{: .img}
![Chessboard](chessboard.gif)

### Slug generator
This extension will automatically generate its values from an entries title field. For example typing “Hello World” into the title field will set the extensions input field to “hello-world”. It will also check the uniqueness of the slug across a customizable list of content types.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/slug)

{: .img}
![Slug generator](slug-generator.png)

### Translator
This extension translates text from the default locale to other locales in a space using the Yandex translation API.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/translate)

{: .img}
![Translator](translator.png)

### JSON editor
This extension provides a JSON formatter and validator based on the CodeMirror library.<br>
It should be used with fields with the type “Object”.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/json-editor)

{: .img}
![Translator](json-editor.png)

### JSON form editor
This extension integrates the JSON editor library to display an edit form based on a predefined JSON schema. Form input gets stored as a JSON object.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/json-form-editor)

{: .img}
![Translator](json-form-editor.png)

### YouTube ID

This example extracts the video id from a valid YouTube URI. Useful as a simple way to integrate with 3rd party media services.<br>
[View on GitHub](https://github.com/contentful/extension-sdk/tree/master/examples/youtube-id)

{: .img}
![YouTube ID](youtube-id.png)

### Wistia Videos

The example extension loads videos from a project on wistia into the Contentful Web Application. A video can be easily previewed, selected and then stored as part of your content. In this example extension we store the video embed URL in Contentful so the video can be embedded easily.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/wistia)

{: .img}
![Wistia Videos](wistia-videos.gif)
