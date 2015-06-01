# Tools

## Import/Export

You can import data from other systems into Contentful using [contentful-importer.rb](https://github.com/contentful/contentful-importer.rb). The importer using a flexible input format for which you can write your own exporters, but we also provide exporters for:

- [Drupal](https://github.com/contentful/drupal-exporter.rb)
- [SQL databases](https://github.com/contentful/database-exporter.rb)
- [Wordpress](https://github.com/contentful/wordpress-exporter.rb)

## Static Site Generators

There are plugins for using Contentful with:

- [Metalsmith](https://github.com/contentful-labs/contentful-metalsmith)
- [Middleman](https://github.com/contentful-labs/contentful_middleman)

There's also an example for building a static site using [AWS Lambda](https://github.com/contentful-labs/contentful-aws-lambda-static).

## Platform Specific

### Android

- [IntelliJ/Android Studio plugin](https://github.com/contentful/cf-generator-intellij) to generate model classes from your Contentful content model.
- [Vault](https://github.com/contentful/vault), a library for making it easy to persist data retrieved from Contentful in SQLite.

### iOS

- [Concorde](https://github.com/contentful-labs/Concorde), a library for displaying progressive JPEG images on iOS.
- [ContentfulPersistence](https://github.com/contentful/contentful-persistence.objc), a library for making it easy to persist data retrieved from Contentful in Core Data.
- [Xcode plugin](https://github.com/contentful/ContentfulXcodePlugin), a plugin for automatically creating Core Data models from your Contentful content model.

## Unofficial

These third-party libraries are not official Contentful tools and may be outdated.

* Usemarkup - [PHP Symfony2 Bundle][28]
* Dothiv - [PHP Symfony ContentfulBundle][31]
* Mohamagdy - [Contentful-RSS][35]
* Jcreixell - [RSS Proxy for Contentful's Sync API][36]
* Zackiles - [Contentful Node Dashboard][37]
* Johnproctor - [Contentful demo using Knockout][38]
* Jurgen Van de Moere - [AngularJS integration][40]
* IDEO - [Ember Integration][41]


[28]: https://github.com/usemarkup/ContentfulBundle
[31]: https://github.com/dothiv/ContentfulBundle
[35]: https://github.com/mohamagdy/contentful-rss
[36]: https://github.com/jcreixell/contentful-sync-rss
[37]: https://github.com/zackiles/contentful-node-dashboard
[38]: https://github.com/johnproctor/ContentOut
[40]: https://github.com/jvandemo/angular-contentful
[41]: https://github.com/ideo/ember-contentful/
