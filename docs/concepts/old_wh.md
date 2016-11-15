Webhooks in Contentful help by responding to events such as "an entry was edited", and "an asset has been published/unpublished".

Whenever an event like this occurs, you can set up a webhook that will call a specified URI to somehow react. For instance, you can send a notification to a Slack channel every time someone edits an entry to be notified of changes.

Webhooks greatly extend the integration possibilities provided by Contentful.

## Setup

Go to _Settings_ → _Webhooks_ from the navigation bar at the top. Click _Add webhook_, enter the credentials of the remote host and configure whatever else is necessary in your environment, and you're done.

{: .img}
![webhook  new webhook](https://images.contentful.com/sxx7gi06ja5s/1Gn2WOuwG42K6A08gwY0Ai/300653f7e0d89081203a5c3f0f36c020/webhook__new_webhook.png)

{: .img-caption}
Creating new webhook

{: .note}
**Note**: You can fine-tune the events which call a webhook.

{: .img}
![webhook  events](https://images.contentful.com/sxx7gi06ja5s/488gvUzJoQ4GIKggqOQO4K/f360d313073264682822ff6fb2ceafc5/webhook__events.png)

{: .img-caption}
Select when the webhook should be triggered

{: .note}
**Note**: The "Save" webhook is triggered when the entry (or an asset) has been saved with an API call, and "Autosave" is triggered when it's autosaved in the UI.*

For specific details on what's included in the HTTP request, please refer to the [API reference](https:https://www.contentful.com/developers/docs/references/content-management-api/#/reference/webhooks).

## Overview

You can find all the webhooks you've created in the main _Webhooks_ screen.

{: .img}
![webhook  list of webhooks](https://images.contentful.com/sxx7gi06ja5s/4yHjcApbaEKiSKAusSWMi6/d804e81f93cd39865c9722a3761eb979/webhook__list_of_webhooks.png)

{: .note}
**Note**:
There's a per-space limit of 20 webhooks.

## Activity log

To help you see how the webhooks are doing and make sure that they work as expected, Contentful shows the status of every webhook call in the activity log. _Click_ on a webhook, and the activity log will appear.

{: .img}
![webhook  activity log](https://images.contentful.com/sxx7gi06ja5s/OJSwxatFAceAqOQgC42GO/f359e7105e8abaaea919fc6c45624622/webhook__activity_log.png)

{: .img-caption}
See how your requests are doing

To see the request details (including the complete JSON) and the remote server response, click _View details_.

{: .img}
![webhook  request details  super secret](https://images.contentful.com/sxx7gi06ja5s/5DArLijukoIwKi8Eo2IsCk/67e763564548233b4490a7348e0c9ed4/webhook__request_details__super_secret.png)

{: .img-caption}
Investigate the details

## Further reading

Read our [API documentation](https:https://www.contentful.com/developers/docs/references/content-management-api/#/reference/webhooks) for specific implementation details.
