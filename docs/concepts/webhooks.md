---
page: ':docsWebhooks'
---

# tbc

Webhooks in Contentful can notify you, someone, or something else when content (assets, entries or content types) have changed by calling a pre-configured HTTP endpoint.

Whenever a matching event occurs, you can set up a webhook that would call the specified URI to react. For example, every time a user edits an entry, send a push notification or message to a Slack channel.

[Read the webhooks section of our Content Management API guide](/developers/docs/references/content-management-api/#/reference/webhooks/) to find out more details.

## Create a new webhook

You can create webhooks with different configurations.

{: .img} ![Creating new webhook](https://images.contentful.com/sxx7gi06ja5s/1Gn2WOuwG42K6A08gwY0Ai/300653f7e0d89081203a5c3f0f36c020/webhook__new_webhook.png)

## Webhook configuration

When creating a webhook you can specify for which changes to your entries you want your webhook called.

{: .img} ![Select when the webhook should be triggered](https://images.contentful.com/sxx7gi06ja5s/488gvUzJoQ4GIKggqOQO4K/f360d313073264682822ff6fb2ceafc5/webhook__events.png)

## Webhook call overview

The call overview consist of a list of the most recent webhook calls made, their status, possible errors, and the target URL.

{: .img} ![See how your requests are doing](https://images.contentful.com/sxx7gi06ja5s/OJSwxatFAceAqOQgC42GO/f359e7105e8abaaea919fc6c45624622/webhook__activity_log.png)

## Webhook call details

The call details provide detailed information about the outgoing request and the response, including headers, body and possible errors.

{: .img} ![Investigate the details](https://images.contentful.com/sxx7gi06ja5s/5DArLijukoIwKi8Eo2IsCk/67e763564548233b4490a7348e0c9ed4/webhook__request_details__super_secret.png)
