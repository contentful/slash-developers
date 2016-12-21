---
page: :docsWebhooks
name: Webhooks
title: Webhooks
metainformation: 'Webhooks extend the integration possibilities by notifying you, another person or system when content (assets, entries or content types) have changed by calling a pre-configured HTTP endpoint.'
slug: null
tags:
  - Customization
  - Workflow
nextsteps:
  - docsToolsExtensions
nextsteps:
  - text: Integrate Contentful with other services via Webhooks
    link: /developers/docs/concepts/webhooks/
  - text: Tools and libraries to make your Contentful experience better
    link: /developers/docs/tools/extensions/
---

Webhooks extend the integration possibilities by notifying you, another person or system when content (assets, entries or content types) have changed by calling a pre-configured HTTP endpoint.

Whenever a matching event occurs, a webhook calls a specified URI to react. For example, every time a user edits an entry, sending a push notification or message to a Slack channel.

## Create and configure a webhook

### With the web app

In the top navigation bar, open _Settings_ → _Webhooks_. Click _Add webhook_, configure the remote host, and click _Save_.

{: .img}
![Creating a new webhook](https://images.contentful.com/sxx7gi06ja5s/1Gn2WOuwG42K6A08gwY0Ai/300653f7e0d89081203a5c3f0f36c020/webhook__new_webhook.png)

{: .img-caption}
Creating a new webhook

You can configure the events that trigger a webhook at the bottom of the screen.

{: .img}
![Configure triggering events](https://images.contentful.com/sxx7gi06ja5s/488gvUzJoQ4GIKggqOQO4K/f360d313073264682822ff6fb2ceafc5/webhook__events.png)

{: .img-caption}
Select what events trigger the webhook

{: .note}
**Note**: The "Save" webhook is triggered when the entry (or an asset) has been saved with an API call, and "Autosave" is triggered when it's autosaved in the UI.

### With the API

Create a webhook by sending the settings for the webhook in a body with your API call, for example, the following:

~~~bash
curl -X POST "https://api.contentful.com/spaces/<SPACE_ID>/webhook_definitions"
  -d '{"url": "<URL>", "name": "foo", "topics": ["*.*"]}'
  -H 'Authorization: Bearer <API_KEY>'
  -H 'Content-Type: application/vnd.contentful.management.v1+json'
~~~

Will create a new webhook in the specified space with a `url`, `name`, and `topics` which match the configuration options mentioned above.

`topics` takes the form of comma separated `Type` and `Action` pairs, with `*` covering all actions, including any future actions Contentful introduces. For example, `ContentType.create` would trigger when someone creates a new content type, and `ContentType.*` would trigger for any of the five current actions.

[Find more details on creating a webhook with the API in our reference docs](/developers/docs/references/content-management-api/#/reference/search-parameters/create-a-webhook).

## List webhooks in a space

### With the web app

The _Webhooks_ overview screen shows a list of the most recent webhook calls made, their status, possible errors, and the target URL.

{: .img}
![Overview of webhooks](https://images.contentful.com/sxx7gi06ja5s/4yHjcApbaEKiSKAusSWMi6/d804e81f93cd39865c9722a3761eb979/webhook__list_of_webhooks.png)

### With the API

To list all webhooks in a space, use the following endpoint:

~~~bash
curl -X GET "https://api.contentful.com/spaces/<SPACE_ID>/webhook_definitions"
-H "Authorization: Bearer <API_KEY>"
-H "Content-Type: application/vnd.contentful.management.v1+json"
~~~

[Find more details on listing the webhooks in a space with the API in our reference docs](/developers/docs/references/content-management-api/#/reference/webhooks/webhooks-collection/get-all-webhooks-of-a-space).

## Activity log of a call

### With the web app

Click the _View details_ link of any webhook in the overview screen to get a detailed activity log, including the JSON and remote server response.

{: .img}
![Activity log for webhooks](https://images.contentful.com/sxx7gi06ja5s/OJSwxatFAceAqOQgC42GO/f359e7105e8abaaea919fc6c45624622/webhook__activity_log.png)

{: .img}
![Detailed activity log of a webhook](https://images.contentful.com/sxx7gi06ja5s/5DArLijukoIwKi8Eo2IsCk/67e763564548233b4490a7348e0c9ed4/webhook__request_details__super_secret.png)

### With the API

The following endpoint will return the status of recent calls made by a webhook and any errors.

~~~bash
curl -X GET "https://api.contentful.com/spaces/<SPACE_ID>/webhooks/<WEBHOOK_ID>/calls"
-H "Authorization: Bearer <API_KEY>"
-H "Content-Type: application/vnd.contentful.management.v1+json"
~~~

[Find more details on getting the activity log of a webhook with the API in our reference docs](/developers/docs/references/content-management-api/#/reference/webhook-calls).

## Next steps

For more details on using webhooks with our API including deleting and updating, [read our API guide](/developers/docs/references/content-management-api/#/reference/webhooks).
