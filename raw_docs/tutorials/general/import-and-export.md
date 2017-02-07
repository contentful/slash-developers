---
page: :docsImportExport
name: Importing and Exporting Content
title:  Importing and Exporting Content
metainformation: 'This tutorial shows you how to import and export content from your spaces.'
slug: null
tags:
  - Workflow
nextsteps: null
---


## Overview

Before joining Contentful, most of our customers have struggled with other CMS systems like WordPress or Drupal. In that way, we've built tools to assist in migrating existing content from a different CMS to Contentful. By the end of this tutorial, you will be able to seamlessly shift to Contentful and enjoy all its benefits, spending as little time as possible dealing with issues.

This will be the structure of this post:

- [Extracting content](#extracting-content)
  - [Extracting content from a relational database](#extracting-content-from-a-relational-database)
  - [Extracting content from WordPress](#extracting-content-from-wordpress)
  - [Extracting content from Drupal](#extracting-content-from-drupal)
- [Importing content](#importing-content)


## Extracting content

### Extracting content from a relational database

It is possible to migrate content from a relational database to Contentful. To do that, we must install the `database-exporter` executable:

~~~ bash
gem install database-exporter
~~~

Then, we must create a content model using the [Contentful web app](https://be.contentful.com/login). With that, we download the content model and save it in a `content_model.json` file:

~~~ bash
 curl -X GET \
      -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
      'https://api.contentful.com/spaces/SPACE_ID/content_types' > contentful_model.json
~~~

We can now create a `setting.yml` file specifying the required parameters:

~~~ yml
# PATH to all data, this will create a folder in your current working directory
data_dir: PATH_TO_ALL_DATA

# Connecting to the database (available adapters: postgres, mysql2, sqlite)
adapter: postgres
host: localhost
database: database_name
user: username
password: username

# Extract data from models:
mapped:
  tables:
  - :table_name_1
  - :table_name_2
  - :table_name_3
  - :table_name_4

## MAPPING ##
mapping_dir: example_data/mapping.json
contentful_structure_dir: example_data/contentful_structure.json

## CONVERT
content_model_json: example_data/contentful_model.json
converted_model_dir: example_data/contentful_structure.json
~~~

Now, we must transform the `contentful_model.json` file into the `contentful_structure.json` file using:

~~~ bash
  database-exporter --config-file settings.yml --convert-content-model-to-json
~~~

As we have specified in `settings.yml`, the newly transformed file will be saved in the specified `converted_model_dir` path.

Using `contentful_structure.json`, we can now create content types JSON files:

~~~ bash
 database-exporter --config-file settings.yml --create-content-model-from-json
~~~

After inputting the required parameters to connect to the database, we must specify what tables will be retrieved:

~~~ bash
database-exporter --config-file settings.yml --list-tables
~~~

A file named `table_names.json` will be created listing the names of tables contained in the database:

~~~ json
[
    "schema_migrations",
    "likes",
    "comments",
    "photos",
    "bio",
    "users",
  ]
~~~

With this information, we create the `mapping.json` file, mapping the structure of the database.

Let's take the example structure for `user` table:

~~~ json
  "Users": {
    "content_type": "User",
    "type": "entry",
    "fields": {
    },
    "links": {
    }
  }
~~~

Finally, we extract the structure for each table to a JSON file:

~~~ bash
database-exporter --config-file settings.yml --extract-to-json
~~~

The `data_dir` path will be used along with subdirectories to store data from each table. The sub-directories name depends on the `content_type` parameter used in the `mapping.json` file.

### Extracting content from WordPress

It is also possible to extract the following content from a WordPress blog:

+ Blog with posts
+ Categories, tags and items from custom taxonomies
+ Attachments

First, we have to install the `wordpress-exporter` executable:

~~~ bash
  gem install wordpress-exporter
~~~

Then, we must extract the blog content from the WordPress blog and save it as a XML file:

{: .img}
![](https://images.contentful.com/3ts464by117l/5EaEMxdtOokGO8O0ScaQqE/0c3c687fbaf36fb22eb33c7fd97ea913/wordpress_export.png)

With that, we create a `settings.yml` file which specifies `wordpress_xml_path`, which describes the path of the saved XML file, and `data_dir`, the path where the WordPress data will be stored:

~~~ yml
# Path to data extracted
data_dir: PATH_TO_ALL_DATA

# Exported XML file from WordPress
wordpress_xml_path: PATH_TO_XML/file.xml

# Convert Contentful model to Contentful import structure
content_model_json: data/contentful_model.json
converted_model_dir: data/contentful_structure.json

# Contentful credentials
access_token: $token
organization_id : $org_id
~~~

Now, we run the following command and extract the content:

~~~ bash
wordpress-exporter --config-file settings.yml --extract-to-json
~~~

As data is exported, we can convert it to markup:

~~~ bash
wordpress-exporter --config-file settings.yml --convert-markup
~~~

With that, we create a Contentful model from the JSON file:

~~~ bash
wordpress-exporter --config-file settings.yml --create-contentful-model-from-json
~~~

Finally, we are able to import this model, as will be shown later.

### Extracting content from Drupal

Contentful's team created a gem to extract vocabularies, tags, users and content types (blog, article, page, custom content types) from a Drupal database dump file.

#### Installation
Use the following command to install the `drupal-exporter` executable:

~~~ bash
gem install drupal-exporter
~~~

#### Process
Before we can configure and run our scripts, we must create and configure certain files:

#### Required Parameters

We must create a YAML file specifying our required parameters(e.g. `settings.yml`):

~~~ yml
# PATH TO ALL DATA
data_dir: PATH_TO_ALL_DATA

# CONNECTING TO A DATABASE
adapter: mysql2
host: localhost
database: drupal_database_name
user: username
password: secret_password

# DRUPAL SETTINGS
drupal_content_types_json: drupal_settings/drupal_content_types.json
drupal_boolean_columns: drupal_settings/boolean_columns.yml
drupal_base_url: http://example_hostname.com

# CONVERT CONTENTFUL MODEL TO CONTENTFUL IMPORT STRUCTURE
content_model_json: PATH_TO_CONTENTFUL_MODEL_JSON_FILE/contentful_model.json
converted_model_dir: PATH_WHERE_CONVERTED_CONTENT_MODEL_WILL_BE_SAVED/contentful_structure.json

contentful_structure_dir: PATH_TO_CONTENTFUL_STRUCTURE_JSON_FILE/contentful_structure.json
~~~

#### Content type files
1. Create a content type using the Contentful web app
2. Download the content type and store it in a `contentful_model.json`( it will be used to subsequently transform `settings.yml` into JSON):

~~~ bash
 curl -X GET \
         -H 'Authorization: Bearer ACCESS_TOKEN' \
         'https://api.contentful.com/spaces/SPACE_ID/content_types' > contentful_model.json
~~~


Use `contentful_model.json` to transform it into `contentful_structure.json` using:

~~~ bash
drupal-exporter --config-file settings.yml --convert-content-model-to-json
~~~

Generate content type files:

~~~ bash
   drupal-exporter --config-file settings.yml  --create-contentful-model-from-json
~~~

#### Mapping File

Create the mapping file `drupal_content_types.json`. This file maps structure of your database:


~~~ json
    machine_name_of_content_type : {
        contentful_api_field_1 : column_machine_name_1,
        contentful_api_field_2: column_machine_name_2,
        contentful_api_field_3 : column_machine_name_3
    }
~~~
You can find a sample mapping file in the [drupal_settings/drupal_content_types.json](https://github.com/contentful/drupal-exporter.rb/blob/master/drupal_settings/drupal_content_types.json) directory.

#### Boolean values (optional)

To map the value of `0`,`1` to `false`, `true`, you have to specify the column names in the yaml file (eg. boolean_columns.yml) and specify the path to this file in the `settings.yml` file, parameter `drupal_boolean_columns`.

Example:

~~~ yml
- field_if_content_type
- field_boolean
~~~

#### Running the script

Finally, we extract the content from the database and generate the JSON files for the import:

~~~ bash
drupal-exporter --config-file settings.yml --extract-to-json
~~~

## Importing content

After you've extracted data by using the above methods, you must install the `contentful-importer` executable:

~~~ bash
gem install contentful-importer
~~~

Before anything, we must create a content model using the [Contentful web app](https://be.contentful.com/login). Then, you download the content model and save it in a `content_model.json` file:

~~~ bash
 curl -X GET \
      -H 'Authorization: Bearer ACCESS_TOKEN' \
      'https://api.contentful.com/spaces/SPACE_ID/content_types' > content_model.json
~~~


Then, we must create a `settings.yml` file with your credentials:

~~~ yml
#PATH to all data
data_dir: DEFINE_BEFORE_EXPORTING_DATA

#JSON describing your content model
content_model_json: PATH_TO_CONTENT_MODEL_JSON_FILE

#Contentful credentials
access_token: ACCESS_TOKEN
organization_id: ORGANIZATION_ID
space_id: DEFINE_AFTER_CREATING_SPACE
default_locale: DEFINE_LOCALE_CODE
~~~

With that, we can use the `contentful-importer` command to manage how content models, entries and assets will be imported:

~~~ bash
# Import content model
contentful-importer --configuration=settings.yml import-content-model

# Import only entries
contentful-importer --configuration=settings.yml import-entries

# Import only assets
contentful-importer --configuration=settings.yml import-assets
~~~

After the content is imported, it is necessary to publish them. We can also do that by using the `contentful-importer` command:

~~~ bash
# Publish everything that has been imported:
contentful-importer --configuration=settings.yml publish

# Publish all entries:
contentful-importer --configuration=settings.yml publish-entries

# Publish all assets:
contentful-importer --configuration=settings.yml publish-assets
~~~
