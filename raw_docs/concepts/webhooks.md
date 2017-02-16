---
page: :docsWebhooks
name: Webhooks
title: Webhooks
metainformation: 'Webhooks extend integration possibilities by notifying you when assets, entries or content types have changed.'
slug: null
tags:
  - Customization
  - Workflow
nextsteps:
  - docsToolsExtensions
nextsteps:
  - text: Tools and libraries to make your Contentful experience better
    link: /developers/docs/tools/extensions/
  - text: Webhooks API guide
    link: /developers/docs/references/content-management-api/#/reference/webhooks  
---

Webhooks extend integration possibilities by notifying you, another person or system when resources have changed by calling a pre-configured HTTP endpoint.


### When webhooks are called

Webhooks are called as the result of an action against assets, entries or content types. Whenever a matching event occurs, a webhook calls a specified URI to react. For example, every time a user edits an entry, send a push notification or message to a Slack channel.

The following table summarizes the actions that Contentful offers for every resource type:

type/action| Create | Save | Auto save | Archive | Unarchive | Publish | Unpublish | Delete
-----------|--------|------|-----------|---------|-----------|---------|-----------|---------
Content type | Yes   | Yes  | No        | No      | No        | Yes     | Yes       | Yes
Entry      | Yes    | Yes  | Yes       | Yes     | Yes       | Yes     | Yes       | Yes
Asset      | Yes    | Yes  | Yes       | Yes     | Yes       | Yes     | Yes       | Yes

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



### With the API

Create a webhook by sending the settings for the webhook in a body with your API call, for example, the following:

~~~bash
curl -X POST "https://api.contentful.com/spaces/<SPACE_ID>/webhook_definitions"
  -d '{"url": "<URL>", "name": "foo", "topics": ["*.*"]}'
  -H 'Authorization: Bearer <API_KEY>'
  -H 'Content-Type: application/vnd.contentful.management.v1+json'
~~~

Will create a new webhook in the specified space with a `url`, `name`, and `topics` which match the configuration options mentioned above.

### Topics

When creating a webhook you have to explicitly specify for which changes on your content (topics) you want your webhook called.

For example, your webhook could be called when:

- Any content (of any type) is published.
- Assets are deleted.

These filters have to be translated into a list of `[Type].[Action]` pairs, `[*.publish, Asset.delete, Entry.*]`, and included in the payload that defines the webhook.

`*` is a wildcard character that can be used in place of any action or type. The combination `*.*` is also valid and means that your webhook is subscribed to all actions across all types.

{: .note}
**Note**: Using `*` allows your webhook to be called for future actions or types that didn't exist when the webhook was created or updated.
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

## Auto save

The Contentful web app automatically saves documents you are working on after every change you make. Contentful keeps track of documents active in the web app and uses that information to call webhooks you have configured. Contentful considers documents edited in the last 20 seconds as active.

This means that, if you are editing an entry in the web app for one minute, and you have a webhook configured to be called for `auto_save` actions, that webhook will be called 3 times.
