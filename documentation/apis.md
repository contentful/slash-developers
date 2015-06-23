---
page: :apis
---

Contentful offers three [REST](http://en.wikipedia.org/wiki/Representational_State_Transfer) APIs for working with your content:

- The Content Delivery API (CDA), available via <https://cdn.contentful.com> is a read-only API for delivering content from Contentful to apps, websites and other media. Content is delivered as JSON data; images, videos and other media is delivered as files.

The API is a globally distributed CDN (Content Delivery Network) for content: all content, both JSON and binary, is served from the server closest to where a user is requesting content from. This minimizes latency, which especially benefits mobile apps. Hosting content in multiple datacenters around the world also greatly improves the availability of content.

You can find the reference documentation for the CDA [on Apiary][1].

- The Content Preview API (CPA), available via <https://preview.contentful.com> is a variant of the CDA for previewing your content before you deliver it to your customers. In addition to the published content served by the CDA, it will also deliver drafts.

- The Content Management API (CMA), available via <https://api.contentful.com> is a read-write API for managing your content. It covers several use cases, like automatic imports from previously used systems, like Wordpress, integration into existing workflows or building completely custom editing experiences tailored to your needs.

You can find the reference documentation for the CMA [on Apiary][2].

[1]: http://docs.contentfulcda.apiary.io/
[2]: http://docs.contentfulcma.apiary.io/
