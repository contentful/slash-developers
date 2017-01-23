---
page: :docsGettingStarted
name: Getting Started with Contentful
title: Getting Started with Contentful
metainformation: tb
slug: null
tags: null
nextsteps: null
---

## What you can do with Contentful and what problems it solves for you



## An introduction to Contentful concepts

Contentful's Content Delivery API (CDA) is a read-only API for retrieving content from Contentful. All content, both JSON and binary, is fetched from the server closest to an user's location using our global delivery network.

## How to get the SDK

Contentful has SDKs for various languages that exposes API endpoints to you appropriate to your language and make developing applications easier.

Contentful maintains SDKs for the following languages, click the appropriate tab to learn how to get hold of it:

-   Curl (default selected)
-   PHP
-   Ruby
-   Objective-C
-   Swift
-   Android
-   Java
-   JavaScript
-   .Net
-   Python

## How to create a client to get the space and inferred content model

Creating a client to communicate with the CDA requires two parameters.

First is an ID of the space you want to connect to, which you can find in the web app, either in the URL of the space or under the _Settings_ tab.

![Space ID in the web app](https://images.contentful.com/tz3n7fnw4ujc/8CYfuWpkXYCQqgKGsgSIk/45445657bc516548e27bb10d41912f07/Space_ID.png)

You also need a valid API key for accessing that space, which you can find under the _APIs_ tab.

![Space ID in the web app](https://images.contentful.com/tz3n7fnw4ujc/1a1WEezqJQkYWGwU6uWm6o/b05e831c9e75ef67875355a0477f8c77/api-keys.png)

Creating a client will connect to the space, and make the content model available to your application.


## How to get all entries from the space

Now you have a connection to the space you can fetch content from it. Start by fetching all the entries.

## How to filter entries

Contentful offers a variety of ways to filter and order the entries you fetch from a space, including by content type, field values, and metadata.

### By content type

The example space contains three content types, a product, a brand, and categories. Here's how to filter entries to just brands.

### By a property

All entries have field values that match the fields defined in the content model. You can filter and sort entries based on values of these fields. Here's how to find all products that cost more than 50.
