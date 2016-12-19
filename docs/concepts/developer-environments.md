---
page: :docsDevEnvironments
name: Developer environments
title: Developer environments
metainformation: tbc
slug: null
tags: null
nextsteps: null
---

# temp

Deploying changes to content and configuration between spaces is a common task that developers need to undertake in the lifetime of a project.

There are three types of changes to a Contentful space:

- **Content changes**: Updated content, new content and removed content.
- **Structural changes**: Updated content types and new content types.
- **Configuration changes**: Editor interfaces, roles and permissions, webhooks and UI extensions.

Each type of change has a method best suited to it and this guide will outline each one in detail.

If you want to follow along with the examples in this guide, then create a space with the 'product catalogue' example content.

## Deploying changes to content

Deploying content changes requires using 1 editorial space managed by users with editorial roles, the Content Delivery API (CDA) and Content Preview API (CPA).

This method suits cases when you want to test how content changes will look when published, or experiment with how content will look on different delivery platforms you are testing.

### Collaboration and workflow

Invite your collaborators to the editorial space, assigning them an appropriate role that doesn't allow them to publish content. In this screenshot, the invitee is an 'author', which means they can create content, but can't publish it.

![Invite user to the space](https://images.contentful.com/tz3n7fnw4ujc/1kP0hQCIsIA8s822Uks24s/0bbddb6188b25fce1c83e227ce0fd679/invite-user.png)

If that new user creates or edits an item of content, these changes will stay in a draft state until a user with the appropriate editorial role publishes them.

![New entry in a draft state](https://images.contentful.com/tz3n7fnw4ujc/p30nNB86D6AuQaaowO0S/d9ea86c4e5d1768ff31a4fec3a3334c6/entry-status.png)

For easy access you can use the _Draft_ views shortcut.

![Draft entry view shortcut](https://images.contentful.com/tz3n7fnw4ujc/2QeVlra1yEm6sq0wKA0W0o/270132e95e64245e0a8bd396090dff9a/draft-view.png?h=250&)

Users with roles with appropriate permissions can now approve the changes, publish the entry and make it available to the Content delivery API.

![Publish post](https://images.contentful.com/tz3n7fnw4ujc/4gCoyBkCHCEoKkAAQImG4k/b66fc5b398a69c7fe96ede6712645954/publish-post.png)

### Using the Content Preview API

The CPA works in a similar way to the CDA, but it returns the draft state of entries whenever available. So, this API call:

```bash
curl -X GET
  -H "Content-Type: application/vnd.contentful.management.v1+json"
  "https://preview.contentful.com/spaces/<space-id>/entries?access_token=<content-delivery-api-key>"
```

Will return the 9 total entries present in the default example space, plus the draft content.

### Reverting changes to entries with snapshots

Using Contenful's Snapshot feature, editors can revert entries to previous states and undo changes made by other contributors.

![Restore previous versions of content](https://images.contentful.com/tz3n7fnw4ujc/6bmP4wkKiWG20Csi6wSUI2/6072e5cae095cbd923b9e680315fca14/restore-version.png)

### Handling data inconsistencies and problems

Any inconsistencies that emerge between content changes, such as broken references between content types should be handled before deploying them.

**AN EXAMPLE?**

### Webhooks to supplement workflow

To enhance the editorial experience you can use webhooks to notify external systems, for example, when a contributor submits a draft entry, notify the editorial team via Slack to review it.

![Content changes workflow](https://images.contentful.com/tz3n7fnw4ujc/72ZuDPOEY8K4M4o0esM6wS/932f834d6a63189e549979d40fcb4795/entry-gets-published.png)

## Deploying changes to structure and configuration

This method suits cases where users and developers want to experiment with changes to content structure or configuration.

The Contentful import and export tools offer a great way to export (most) of the data and structure from one space and import it into another.

There are limitations to the tools:

1. The import tool can only import data into a new space.
2. The export tool doesn't export all data from a space, such as users and permissions, which means that manual changes may be required before or after the import.

### Export content from a space

[The Contentful export tool](https://github.com/contentful/contentful-export) is a command line tool that helps you export the contents of a space.

Start by exporting the content of the current space:

```bash
contentful-export
  --space-id <space-id>
  --management-token <content-management-token>
```

You can see the results of the export of the test space [here](https://assets.contentful.com/tz3n7fnw4ujc/1a7CT8ita6GS88cMQW8YgY/5f4a8df5f7ed0f702b4f040a788e2d7e/contentful-export-hlvk7oi1onur-1479732074757.json), it follows the typical return pattern of API calls.

### Commit to version control

As the space data is now a JSON text file, you can commit it to version control as a backup.

### Import exported content

Create a new space with the Contentful web app or the API and note it's ID. Now use [the Contentful import tool](https://github.com/contentful/contentful-import) to import the JSON file into your new space.

```bash
contentful-import \
  --space-id spaceID \
  --management-token managementToken \
  --content-file exported-file.json \
```

And now you should see the copied content in your new space.

![Content copied into new space](https://images.contentful.com/tz3n7fnw4ujc/1HeBLVqmqEmiIOgKa288gy/38199abd3ca84d7d6d01d9dd87f2cc20/copied-content.png?h=250&)

But as noted above, if you switch to the _Users and Roles_ section under _Settings_, you will see that none of this content has copied over.

### Maintaining consistency in your apps

The main issue with this approach is the constant switching of space IDs in your applications. Our recommended solutions for this are using a configuration or production space.

### Use a configuration space

You can use an independent space to maintain a list of your spaces and their current IDs, with all apps served content via this space. You can then query this space to get the ID you need without needing to change your apps each time. You could also use this space for storing other configuration options for build and deployment processes. Below are screenshots to give you an idea, but you will likely want to create content types and entries that suit your specific use case.

![Create configuration space](https://images.contentful.com/tz3n7fnw4ujc/3Y0fsl5tmEQOqama8mKUia/a5510cbb549307dacb24ed4319996eb2/create-configuration-space.png)

![Create configuration content type](https://images.contentful.com/tz3n7fnw4ujc/1l5FhnyauMUy8AwoKKEwGc/eeded44ef5e134ba4cd22dbddc2a443e/create-config-content-type.png)

![Configuration entries](https://images.contentful.com/tz3n7fnw4ujc/1fa3cyBeVwYcgKQGK8KQYu/96b3ca52c55cd5d096749c523792e6ef/create-config-content-entry.png)

### Make, test, and deploy changes

At this point you have the original space, a cloned space, and a configuration space. Update the configuration space to direct production apps to the cloned space. You can now make changes to the configuration and content types in the original production space, using the options outlined above to preview the changes. When complete, use the configuration space to switch QA apps to the original production space and test the new changes. If this is successful, then you can switch all apps back to the production space and delete the cloned space. If the process fails at any point, then you can use contentful-import to rollback the production space to it's original state.

![Structure changes workflow](https://images.contentful.com/tz3n7fnw4ujc/7q1j2mVZoA84u206oyGeQI/7cf137484d527df7e8a094ad4af14daa/config-space.png)
