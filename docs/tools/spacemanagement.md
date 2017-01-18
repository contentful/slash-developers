---
page: :docsToolsSpaceManagement
name: Space management
title: Space management tools
metainformation: 'These tools will help you import and manage entries in your spaces.'
slug: null
tags:
 - Tools
 - Extending
nextsteps: null
---

These tools will help you import and manage entries in your spaces.

## Import and Export Tools

The export tool allows you to export all content, including content types, assets and webhooks; the import tool enables all the content to be imported into a new space. These tools replace the space sync tool.

Import Tool - [View on GitHub](https://github.com/contentful/contentful-import)
Export Tool - [View on GitHub](https://github.com/contentful/contentful-export)

## Data import / Bootstrap

You can import data from other systems into Contentful using our [contentful-importer.rb](https://github.com/contentful/contentful-importer.rb) gem.

The importer uses a flexible input format that you can write your own exporters for, we provide exporters for:

- [Drupal](https://github.com/contentful/drupal-exporter.rb)
- [SQL databases](https://github.com/contentful/database-exporter.rb)
- [WordPress](https://github.com/contentful/wordpress-exporter.rb)

[Read this tutorial](/developers/docs/tutorials/general/import-and-export/) to learn how to export content from the systems listed above and import it into your Contentful spaces.

## Contentful link cleaner

If you delete an entry linked to another entry, then you will have loose references to non-existent entries. This tool cleans up these links.

[View on GitHub](https://github.com/contentful/contentful-link-cleaner)

## Contentful bootstrap

This Ruby gem gets you started using Contentful with one command, creating the spaces, entries and more with one command. [Read this tutorial](/developers/docs/ruby/tutorials/using-contentful-bootstrap-for-keeping-up-with-your-spaces/) for more details.

[View on GitHub](https://github.com/contentful/contentful-bootstrap.rb)
