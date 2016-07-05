---
page: :docsUiExtensions
---

UI extensions allows you to extend the Contentful web app's entry editor, so that you can build plugins that meet your specific content editing or content management needs. It operates on top of any of our current field types, and gives you the power to manipulate its data through an iframe where you can embed custom functionality, styling, integrations or workflows.

UI extensions is still in development and therefore it is not encouraged to use it to build business critical solutions as it is likely to change. The purpose of making it available early is to provide early access to upcoming features and make our roadmap more transparent to users, as well as to collect early feedback before releasing, and committing to support, a brand new API.<br>
[View on GitHub](https://github.com/contentful/ui-extensions-sdk)

There also a command line tool (CLI) to simplify the management tasks associated with custom extensions.<br>
[View on GitHub](https://github.com/contentful/contentful-extension-cli)

## Examples

### Basic rating dropdown
Basic extension that helps you get started with developing. Uses a dropdown to change the value of a number field and makes some CMA requests.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/rating-dropdown)

### Diff
This extension shows the difference between the current draft value of a field and its published value in a human friendly way.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/diff)

### Rich text editor
This example integrates the Alloy rich text editor to edit text fields.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/alloy-editor)

### Chessboard
This extension displays a chessboard and stores the board position as a JSON object. You can drag pieces on the chessboard and the position data will be updated automatically. The extension also supports collaborative editing. If two editors open the same entry moves will be synced between them.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/chessboard)

### Slug generator
This extension will automatically generate its values from an entries title field. For example typing “Hello World” into the title field will set this extension's input field to “hello-world”. It will also check the uniqueness of the slug across a customizable list of content types.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/slug)

### Translator
This extension translates text from the default locale to other locales in a space using the Yandex translation API.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/translate)

### JSON editor
This extension provides a JSON formatter and validator based on the CodeMirror library.<br>
It should be used with fields with the type “Object”.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/json-editor)

### JSON form editor
This extension integrates the JSON editor library to display an edit form based on a predefined JSON schema. Form input gets stored as a JSON object.<br>
[View on GitHub](https://github.com/contentful/extensions/tree/master/samples/json-form-editor)
