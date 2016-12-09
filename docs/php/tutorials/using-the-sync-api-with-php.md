---
page: :docsSyncApiWithPhp
name: Using the Sync API with PHP
title: Using the Sync API with PHP
metainformation: 'The sync API allows you to keep a local copy of all content of a space up-to-date via delta updates. This tutorial will walk you how to use the Sync API with the Contentful PHP SDK.'
slug: null
tags:
  - SDKs
  - PHP
nextsteps: null
---

The [sync](/developers/docs/concepts/sync/) API allows you to keep a local copy of all content of a space up-to-date via
delta updates. This tutorial will walk you how to use the Sync API with the Contentful PHP SDK.

{: .note}
The Contentful PHP SDK is currently in beta and the API may change before a stable release.

## Getting started

After you've [installed the SDK](/developers/docs/php/tutorials/getting-started-with-contentful-and-php/#installation)
you need to set up the client and get an instance of the synchronization manager. For this tutorial we'll be using an example space.

~~~ php
<?php
$client = new \Contentful\Delivery\Client('b4c0n73n7fu1', 'cfexampleapi');
$syncManager = $client->getSynchronizationManager();
~~~

Now we're able to start the initial synchronization.

~~~ php
<?php
$result = $syncManager->startSync();
$items = $result->getItems();
~~~

As this is the initial sync `$items` will contain the entries and assets of your space. Storing these objects to the
filesystem or a database will be left to you. To make it somewhat easier, all objects can be serialized to JSON and
later revived:

~~~ php
<?php
$json = json_encode($items[0]);
$object = $client->reviveJson($json);
~~~

If you have a space that's bigger than the example space, the sync might involve
more records that can't be handled with one API call. To get absolutely everything you have to check `$result->isDone()`:

~~~ php
<?php
$result = $syncManager->startSync();

while (!$result->isDone()) {
    $result = $syncManager->continueSync($result);
}
~~~

### Continuing the sync

To be able to get new changes later, you need to save the last token after the initial synchronization is complete. Using
this token you can then resume the synchronization at the last state you've saved.

~~~ php
<?php

$token = $result->getToken();

// Whenever you want to sync again

$result = $syncManager->continueSync($token);
~~~

When continuing the sync you might encounter instances of the classes `DeletedEntry` and `DeletedEntry`. These give you
access to some metadata, most importantly the ID, to delete the resources from your local storage.

## Conclusion

With this information you should be able to implement a solution syncing your content to local storage. If you run into
any trouble please open an issue.

You can find the Contentful PHP SDK on [GitHub][1].

[1]: https://github.com/contentful/contentful.php
