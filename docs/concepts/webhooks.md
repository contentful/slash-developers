---
page: :docsWebhooks
---

Webhooks in Contentful can notify you or someone else when content (Assets, Entries or Content Types) has changed by calling a preconfigured HTTP endpoint. This can be used for notifications, static site generators or other forms of post-processing that is sourced from Contentful.

Whenever an event like that occurs, you can set up a webhook that would call the specified URI in order to somehow react. For instance, you can send a push notification or a message to a Slack channel every time an entry has been edited to keep up with the changes.

[See our documentation for all the details](/developers/docs/references/content-management-api/#/reference/webhooks/) and the screenshots below to better understand how it works.

**New webhook**<br>
*You can create multiple webhooks with different configurations each.*
![Creating new webhook](https://images.contentful.com/sxx7gi06ja5s/1Gn2WOuwG42K6A08gwY0Ai/300653f7e0d89081203a5c3f0f36c020/webhook__new_webhook.png)

**Webhook configuration**<br>
*When creating a webhook you can specify for which changes on your content (topics) you want your webhook called.*
![Select when the webhook should be triggered](https://images.contentful.com/sxx7gi06ja5s/488gvUzJoQ4GIKggqOQO4K/f360d313073264682822ff6fb2ceafc5/webhook__events.png)

**Webhook call overviews**<br>
*The call overviews consist of a list of the most recent webhook calls made, their status, possible errors, and the target URL.*
![See how your requests are doing](https://images.contentful.com/sxx7gi06ja5s/OJSwxatFAceAqOQgC42GO/f359e7105e8abaaea919fc6c45624622/webhook__activity_log.png)

**Webhook call details**<br>
*The call details provide detailed information about the outgoing request and the response, including headers, body and possible errors.*
![Investigate the details](https://images.contentful.com/sxx7gi06ja5s/5DArLijukoIwKi8Eo2IsCk/67e763564548233b4490a7348e0c9ed4/webhook__request_details__super_secret.png)

