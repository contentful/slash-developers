---
page: :docsApis
---

Contentful is an API-first CMS, offering four REST APIs for working with your content. Each of these APIs serve a different purpose, so which one to use depends on what you want to do:

- If you're retrieving content to display to users in an app or website, you want to use the [Content Delivery API][cda-section].
- If you want to programmatically create or update content items, you want to use the [Content Management API][cma-section].
- If you want to retrieve unpublished content to show in-context previews to content creators and editors, you want to use the [Preview API][cpa-section]. This API behaves exactly like the Content Delivery API, but includes content that has not yet been published.
- Finally, when retrieving images stored in Contentful, they will come from `images.contentful.com`. You can apply various transforms to images by appending query parameters to the URL, so we refer to this as our [Images API][images-section].

## Content Delivery API

The Content Delivery API (CDA), available at `https://cdn.contentful.com`, is a read-only API for delivering content from Contentful to apps, websites and other media. Content is delivered as JSON data; images, videos and other media are delivered as files.

The API is available via a globally distributed content delivery network: all content, both JSON and binary, is served from the server closest to where a user is requesting content from. This minimizes latency, which especially benefits mobile apps. Hosting content in multiple data centers around the world also greatly improves the availability of content.

[Read the reference documentation for the Content Delivery API][1]

## Content Management API

The Content Management API (CMA), available at `https://api.contentful.com`, is a read-write API for managing your content. Unlike the Content Delivery API, the management API requires you to authenticate as a Contentful user. It covers several use cases, such as:

 - Automatic imports from different CMSes like WordPress or Drupal
 - Integration with other backend systems, such as an e-commerce shop
 - Building custom editing experiences. In fact, the [Contentful web app](https://app.contentful.com) is built on top of this API.

Note: The Content Management API can also be used to retrieve content. However, it is used to only manage content, so the entirety of items will be retrieved (i.e. all localized and unpublished content).

[Read the reference documentation for the Content Management API][2]

## Preview API

The Preview API, available at `https://preview.contentful.com`, is a variant of the CDA for previewing your content before you deliver it to your customers. You use the Preview API in combination with a "preview" deployment of your website (or a "preview" build of your mobile app) that allows content managers and authors to view their work in-context, as though it had been published. This API uses a "preview" access token to allow you to view unpublished content as though it were being delivered by the CDA.

[Read the reference documentation for the Preview API][3]

## Images API

With the Images API `https://images.contentful.com` you can resize and crop images, change their background color and convert them to different formats – PNG→JPG, for instance. Using our backend for these transformations lets you upload high-quality assets, deliver exactly what your app needs, and still get all the benefits of our caching CDN.

[Read the reference documentation for the Images API][4]

[cda-section]: #content-delivery-api
[cma-section]: #content-management-api
[cpa-section]: #content-preview-api
[images-section]: #images-api
[1]: /developers/docs/references/content-delivery-api/
[2]: /developers/docs/references/content-management-api/
[3]: /developers/docs/references/content-preview-api/
[4]: /developers/docs/references/images-api/
