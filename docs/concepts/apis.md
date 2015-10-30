---
page: :docsApis
---

Contentful offers four [REST](https://en.wikipedia.org/wiki/Representational_State_Transfer) APIs for manipulating the content.

## Content Delivery API

The Content Delivery API (CDA), available via `https://cdn.contentful.com` is a read-only API for delivering content from Contentful to apps, websites and other media. Content is delivered as JSON data; images, videos and other media is delivered as files.

The API is available via a globally distributed Content Delivery Network: all content, both JSON and binary, is served from the server closest to where a user is requesting content from. This minimizes latency, which especially benefits mobile apps. Hosting content in multiple datacenters around the world also greatly improves the availability of content.

[Read the reference documentation for the Content Delivery API][1]

## Content Management API

The Content Management API (CMA), available via `https://api.contentful.com` is a read-write API for managing your content. It covers several use cases, like automatic imports from previously used systems, like Wordpress, integration into existing workflows or building completely custom editing experiences tailored to your needs.

[Read the reference documentation for the Content Management API][2]

## Content Preview API

The Content Preview API (CPA), available via `https://preview.contentful.com` is a variant of the CDA for previewing your content before you deliver it to your customers. In addition to the published content served by the CDA, it will also deliver drafts.

[Read the reference documentation for the Content Preview API][3]

## Images API

With the Images API `https://images.contentful.com` you can resize and crop images, change their background color and convert them to different formats – PNG→JPG, for instance. We believe that it's better to let the backend do this job, instead of having to deal with image transformation on the client.

[Read the reference documentation for the Images API][4]

[1]: /developers/docs/references/content-delivery-api/
[2]: /developers/docs/references/content-management-api/
[3]: /developers/docs/references/content-preview-api/
[4]: /developers/docs/references/images-api/
