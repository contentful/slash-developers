---
page: :docsWebhookRolesSnapshots
name: Managing webhooks, snapshots and roles with Contentful and .NET
title: Managing webhooks, snapshots and roles with Contentful and .NET
metainformation: This article details how to create and manage webhooks, snapshots and roles using the .NET SDK.
slug: null
tags:
  - SDKs
  - .NET
nextsteps:
  - text: Explore the .NET SDK GitHub repository
    link: https://github.com/contentful/contentful.net
---

The Content Management API (CMA) is a restful API for managing content in your Contentful spaces. You can use it to create, update, delete and retrieve content using well-known HTTP verbs.

To make development easier for our users, we publish SDKs for various languages which make the task easier. This article details how to use the [.Net SDK](https://github.com/contentful/contentful.net) to create, update and delete webhooks, snapshots and roles.

## Pre-requisites

This tutorial assumes you understand the basic Contentful data model as described in the [developer center](/developers/docs/concepts/data-model/) and that you have
already read and understand the [getting started tutorial for the .Net SDK](/developers/docs/net/tutorials/using-net-cda-sdk/) and the [using the management API with Contentful and .Net SDK](/developers/docs/net/tutorials/management-api/) article.

Contentful.net is built on .net core and targets .Net Standard 1.4. The SDK is cross-platform and runs on Linux, macOS and Windows.

## Working with webhooks

To learn more about what webhooks refer to [the webhooks concepts article](/developers/docs/concepts/webhooks/).

To create a webhook for a space use the `CreateWebHookAsync` method.

```csharp
var webHook = new WebHook();
webHook.Name = "New product"; // The name of the webhook
webHook.Url = "https://www.example.com/"; // The url to call when the specified event occurrs
webHook.HttpBasicPassword = "Pass"; // Optional basic auth password
webHook.HttpBasicUsername = "User"; // Optional basic auth username
webHook.Headers = new List<KeyValuePair<string, string>>(); // You can pass custom headers with every call
webHook.Headers.Add(new KeyValuePair<string, string>("custom", "header")); // Add a header by the name of "custom" with a value of "header"
webHook.Topics = new List<string>() // Topics are the events that trigger this webhook.
{
    "Entry.*"
};

await client.CreateWebHookAsync(webHook);
```

The topics available are described in more detail in [the webhooks concepts article](/developers/docs/concepts/webhooks/), but the summary is that you specify a `Type` and an `Action`. `Type` can be any of `Entry`, `Asset` or `ContentType` and `Action` can be any of `create`, `save`, `auto_save`, `archive`, `unarchive`, `publish`, `unpublish` or `delete`. `_` is a wildcard and `_.\*` is valid
and would mean to call this webhook for all actions across all types.

Once you have created a webhook you can fetch them from the SDK using the `GetWebHooksCollectionAsync` and `GetWebHookAsync` methods.

```csharp
var allWebhooks = await client.GetWebHooksCollectionAsync();

var webhook = await client.GetWebHookAsync("<webhook_id>");
```

To retrieve more information about a specific webhook call use the `GetWebHookCallDetailsCollectionAsync` to retrieve a list of calls made to the webhook or the `GetWebHookCallDetailsAsync` to get details of a specific call.

```csharp
var calldetails = await client.GetWebHookCallDetailsCollectionAsync("<webhook_id>");

var calldetail = await client.GetWebHookCallDetailsAsync("<call_details_id>", "webhook_id");
```

A method is available that gives a more general overview of the total number of webhook calls for a specific webhook and whether they returned a success code.

```csharp
var webhookHealth = await client.GetWebHookHealthAsync("<webhook_id>");

var total = webhookHealth.TotalCalls; // 27
var healthy = webhookHealth.TotalHealthy; // 23
```

To delete a webhook you are no longer using.

```csharp
await client.DeleteWebHookAsync("<webhook_id>");
```

## Roles and memberships

The .NET SDK allows for the creation of custom roles. It's complex to understand the permissions and policies system, but the examples below should give you a good overview. For more detailed information, refer to [the management API documentation](/developers/docs/references/content-management-api/#/reference/roles/get-webhook-health).

### Creating a role

Start by creating a new `Role` and adding the permissions and policies you need.

```csharp
var role = new Role();
role.Name = "Name of the role";
role.Description = "Describe the role";
role.Permissions = new ContentfulPermissions(); // Add permissions to the role
role.Permissions.ContentDelivery = new List<string>() { "read" }; // What permissions should the role have to the ContentDelivery API
role.Permissions.ContentModel = new List<string>() { "read" }; // What permissions should the role have to the content model, i.e. creating content types and fields
role.Permissions.Settings = new List<string>() { "manage" }; // What permissions should the role have to other type of settings

role.Policies = new List<Policy>(); // Add more granular policies to the role.
role.Policies.Add(new Policy() // Every policy consists of a number of actions and constraints.
{
    Effect = "allow",
    Actions = new List<string>()
    {
        "read",
        "create",
        "update"
    },
    Constraint = new AndConstraint()
    {
        new EqualsConstraint()
        {
            Property = "sys.type",
            ValueToEqual = "Entry"
        }
    }
});
```

This example above would give the role permissions to read entries, assets and content types, but not edit, create or delete them. It would also give permissions to manage settings for the space. The policies give this role-specific access to read, create and update entries.

### Policies explained

The policies can look daunting and the framework behind them is complex. However they do make it possible to create granular and flexible authorization rules.

The first property is the `Effect` which is how this policy is to be treated, will it `allow` or `deny` access.

`Actions` represents what actions this policy allows or denies. This is a list of strings but only a certain set of values are acceptable. These are `read`, `create`, `update`, `delete`, `publish`, `unpublish`, `archive`, `unarchive` or `all`.

`Constraint` is a `IConstraint`, which is explained in more detail below.

### Constraints explained

Constraints represent which resources a specific policy applies to. There are five different kinds of constraints.

`AndConstraint` and `OrConstraint` are lists of other `IConstraint`. The `OrConstraint` ensures that at least one of the contained constraints is true and the `AndConstraint` requires all contained constraints to be true.

The `NotConstraint` contains another `IConstraint` and inverts the value of that constraint.

The `EqualsConstraint` contains a `Property` which is a field on the content type or asset and a `ValueToEqual` which contains the value that this field must equal for this constraint to evaluate to be fulfilled.

The `PathConstraint` contains a `Fields` property that gives a path that must exist on the content type. An example is `"fields.heading"` which would only match content types that have the `heading` field present.

Putting them all together looks something like the following.

```csharp
var constraint = new AndConstraint() // AndConstraint is a list of other IConstraints, ensuring all other contained constraints are met
{
    new EqualsConstraint() // This equals constraint constraints this policy to only affect resources with a sys.type of Entry
    {
        Property = "sys.type",
        ValueToEqual = "Entry"
    },
    new PathConstraint(){ //This path constraint constraints this policy to only affect the name field of the resource
        Fields = "fields.name.%"
    }
}
```

Once you've created a `Role` and added the appropriate permissions and policies, you can call the `CreateRoleAsync` method.

```csharp
var createdRole = await client.CreateRoleAsync(role);
```

You can update, delete and fetch roles with the appropriate methods.

```csharp
var role = await client.GetRoleAsync("<role_id>");

var allRoles = await client.GetAllRolesAsync();

var updatedRole = await client.UpdateRoleAsync(role);

await client.DeleteRoleAsync("<role_id>");
```

## Working with snapshots

A snapshot of an entry is automatically created each time an entry is published and is the state of every field of the entry at that given time. You can use the snapshots of an entry to keep a full version history of the entry content. For more information read [the snapshots documentation](/developers/docs/references/content-management-api/#/reference/roles/role/get-a-snapshot).

To get all snapshots for an entry use the `GetAllSnapshotsForEntryAsync`. To get a specific snapshot use the `SingleSnapshot` method.

```csharp
var singleSnapshot = await client.SingleSnapshot("<snapshot_id>", "<entry_id>");

var allSnapshots = await client.GetAllSnapshotsForEntryAsync("<entry_id>");
```

## Working with space memberships

A space membership represents the membership type a user has in a space and you can assign additional roles to a user, flag a user as admin or remove a user from a space.

To get all memberships of a space call the `GetSpaceMembershipsAsync` method. To get a single membership call `GetSpaceMembershipAsync` method.

```csharp
var singleMembership = await client.GetSpaceMembershipAsync("<membership_id>");

var roles = singleMembership.Roles; // A List<string> of all role ids this membership has
var userId = singleMembership.User.SystemProperties.Id; // The id of the user tied to this membership
var isAdmin = singleMembership.Admin; // Whether this membership is the administrator of the space

var allMemberships = await client.GetSpaceMembershipsAsync();
```

To update an existing membership use the `UpdateSpaceMembershipAsync` method.

```csharp
var singleMembership = await client.GetSpaceMembershipAsync("<membership_id>");
singleMembership.Admin = false; // This membership will no longer be administrator of the space

await client.UpdateSpaceMembershipAsync(singleMembership);
```

To create a new membership use the `CreateSpaceMembershipAsync` method.

```csharp
var newMembership = new SpaceMembership();

newMembership.Roles = new List<string>() {
    "<role_id>"
};

newMembership.Admin = true;

newMembership.User = new User() { // The user must already exist. It cannot be automatically created through the membership.
    SystemProperties = new SystemProperties() {
        Id = "<user_id>",
        LinkType = "User",
        Type = "Link"
    }
};

await client.CreateSpaceMembershipAsync(newMembership);
```

To delete a membership use the `DeleteSpaceMembershipAsync` method.

{. :note}
**Note**: It's possible to delete every single membership of a space, leaving no administrator available. You
can fix this by inviting a new user through the Contentful web app organization settings.

```csharp
await client.DeleteSpaceMembershipAsync("<membership_id>");
```

## Working with API keys

The Contentful .NET SDK allows you to get all API keys for the Content Delivery API ((not the management API) for a space. It also allows you to create new API keys.

```csharp
var allApiKeys = await client.GetAllApiKeysAsync();

var accessToken = allApiKeys.First().AccessToken;

var newKey = await client.CreateApiKeyAsync("Name of key", "Description of key");

var newAccessToken = newKey.AccessToken;
```
