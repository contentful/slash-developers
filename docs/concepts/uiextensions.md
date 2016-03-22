---
page: :docsUiExtensions
---

The custom widgets API allows you to extend the Contentful Web Application's entry editor, so that you can build plugins that meet your specific content editing or content management needs. It operates on top of any of our current field types, and gives you the power to manipulate its data through an iframe where you can embed custom functionality, styling, integrations or workflows.

The Widgets API is still in development and therefore it is not encouraged to use it to build business critical solutions as it is likely to change. The purpose of making it available early is to provide early access to upcoming features and make our roadmap more transparent to users, as well as to collect early feedback before releasing, and committing to support, a brand new API.<br>
[View on GitHub](https://github.com/contentful/widget-sdk)

There also a Command Line Tool (CLI) to simplify the management tasks associated with custom widgets.<br>
[View on GitHub](https://github.com/contentful/contentful-widget-cli)

## Examples

### Basic Rating Dropdown
Basic widget that helps you get started with developing. Uses a dropdown to change the value of a number field and makes some CMA requests.<br>
[View on GitHub](https://github.com/contentful/widget-sdk/tree/master/examples/rating-dropdown)

### Rich Text Editor
This example integrates the Alloy rich text editor to edit “Text” fields.<br>
[View on GitHub](https://github.com/contentful/widget-sdk/tree/master/examples/alloy-editor)

### Chessboard
This widget displays a chessboard and stores the board position as a JSON object. You can drag pieces on the chessboard and the position data will be updated automatically. The widget also supports collaborative editing. If two editors open the same entry moves will be synced between them.<br>
[View on GitHub](https://github.com/contentful/widget-sdk/tree/master/examples/chessboard)

### Slug Generator
This widget will automatically generate its values from an entries title field. For example typing “Hello World” into the title field will set the widgets input field to “hello-world”. It will also check the uniqueness of the slug across a customizable list of content types.<br>
[View on GitHub](https://github.com/contentful/widget-sdk/tree/master/examples/slug)

### Translator
This widget translates text from the default locale to other locales in a space using the Yandex translation API.<br>
[View on GitHub](https://github.com/contentful/widget-sdk/tree/master/examples/translate)

### JSON Editor
This widget provides a JSON formatter and validator based on the CodeMirror library.<br>
It should be used with fields with the type “Object”.<br>
[View on GitHub](https://github.com/contentful/widget-sdk/tree/master/examples/json-editor)

### JSON Form Editor
This widget integrates the JSON Editor library to display an edit form based on a predefined JSON Schema. Form input gets stored as a JSON object.<br>
[View on GitHub](https://github.com/contentful/widget-sdk/tree/master/examples/json-form-editor)
