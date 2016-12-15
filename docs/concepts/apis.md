---
page: :docsApis
name: API basics
title: Four content APIs
metainformation: 'Contentful is an API first content management system, offering four REST APIs for working with your content. Each of these APIs serve a different purpose, so which one to use depends on what you want to do.'
slug: null
tags:
  - API
  - Basics
nextsteps: null
---

Contentful is an API first content management system, offering four REST APIs for working with your content. Each of these APIs serve a different purpose, so which one to use depends on what you want to do:

- If you're retrieving content to display to users in an app or website, use the [Content Delivery API][cda-section].
- If you want to programmatically create or update content items, use the [Content Management API][cma-section].
- If you want to retrieve unpublished content to show in-context previews to content creators and editors, use the [Preview API][cpa-section]. This API behaves like the Content Delivery API, but includes content that has not yet been published.
- If you want to retrieve and apply transformations to images stored in Contentful, use the [Images API][images-section].

## Content Delivery API

The Content Delivery API (CDA), available at _<https://cdn.contentful.com>_, is a read-only API for delivering content from Contentful to apps, websites and other media. Content is delivered as JSON data, and images, videos and other media as files.

The API is available via a globally distributed content delivery network. The server closest to the user serves all content, both JSON and binary. This minimizes latency, which especially benefits mobile apps. Hosting content in multiple global data centers also greatly improves the availability of content.

For more details [read the reference guide for the Content Delivery API][1].

## Content Management API

The Content Management API (CMA), available at _<https://api.contentful.com>_, is a read-write API for managing content. Unlike the Content Delivery API, the management API requires you to authenticate as a Contentful user. You could us the CMA for several use cases, such as:

- Automatic imports from different CMSes like WordPress or Drupal.
- Integration with other backend systems, such as an e-commerce shop.
- Building custom editing experiences. We built the [Contentful web app](https://app.contentful.com) on top of this API.

{: .note}
**Note**: You can also use the Content Management API to retrieve content. But as it's used to manage content, it will retrieve **all** items (i.e. all localized and unpublished content).

For more details [read the reference documentation for the Content Management API][2].

## Preview API

The Preview API, available at _<https://preview.contentful.com>_, is a variant of the CDA for previewing your content before delivering it to your customers. You use the Preview API in combination with a "preview" deployment of your website (or a "preview" build of your mobile app) that allows content managers and authors to view their work in-context, as if it were published, using a "preview" access token as though it were delivered by the CDA.

For more details [read the reference documentation for the Preview API][3].

## Images API

The Images API, available at _<https://images.contentful.com>_, allows you to resize and crop images, change their background color and convert them to different formats. Using our API for these transformations lets you upload high-quality assets, deliver exactly what your app needs, and still get all the benefits of our caching CDN.

For more details [read the reference documentation for the Images API][4].

[1]: /developers/docs/references/content-delivery-api/
[2]: /developers/docs/references/content-management-api/
[3]: /developers/docs/references/content-preview-api/
[4]: /developers/docs/references/images-api/
[cda-section]: #content-delivery-api
[cma-section]: #content-management-api
[cpa-section]: #content-preview-api
[images-section]: #images-api
