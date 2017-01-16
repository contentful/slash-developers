---
page: :docsRubyAutomatedRebuild
name: Automated rebuild and deploy with CircleCI and Webhooks
title: Automated rebuild and deploy with CircleCI and Webhooks
metainformation: 'This guide will show you how you can automate this process using Webhooks and CircleCI.'
slug: null
tags:
  - SDKs
  - Ruby
  - Workflow
nextsteps: null
---

If you're running our [Jekyll](https://github.com/contentful/jekyll-contentful-data-import) or [Middleman](https://github.com/contentful/contentful_middleman) integrations,
you might be wondering how to automate your site building and publishing process.

Here we'll discuss how you can automate this process using [Contentful Webhooks](/developers/docs/concepts/webhooks/)
and CircleCI API.

> Everything we'll discuss here is for the case of using a public [GitHub](https://github.com) repository,
> using [CircleCI.com](https://circleci.com) and deploying on [GitHub Pages](https://pages.github.com/).
> This setup can be replicated on a private repository with CircleCI.com integration
> enabled. Just make sure to change the URLs in the examples appropriately.

## Requirements

* A Contentful Space and API Key
* Your Jekyll or Middleman application with Contentful hosted on GitHub
* CircleCI integration enabled on your repository
* GitHub Pages repository for deploying your site

We'll assume that you know how to set up your Jekyll or Middleman projects.
If not, you can check the basic example applications here:

* [Middleman Examples](https://github.com/contentful/contentful_middleman_examples)
* [Jekyll Examples](https://github.com/contentful/contentful_jekyll_examples)

## Setup your Contentful webhooks to trigger Circle builds

* Generate your CircleCI Token [here](https://circleci.com/docs/api/#getting-started).
* On the Contentful webhook admin page, create a webhook with (replacing the upper-cased values):

~~~
Name: CircleCI
URL: https://circleci.com/api/v1/project/YOUR_COMPANY/YOUR_PROJECT/tree/YOUR_BRANCH?circle-token=YOUR_CIRCLECI_TOKEN
On: Entry -> publish, unpublish
~~~

## Create automated build script

Here the setups differ a bit, but the structure is pretty similar.

Create a file called `automated_build.sh` and include the following:

* Middleman:

~~~bash
# Copy static site
CWD=`pwd`

# Clone Pages repository
cd /tmp
git clone YOUR_PAGES_REPO build

# cd build && git checkout -b YOUR_BRANCH origin/YOUR_BRANCH # If not using master

# Trigger Middleman rebuild
cd $CWD
bundle exec middleman contentful --rebuild

# Push newly built repository
cp -r $CWD/build/* /tmp/build

cd /tmp/build

git config --global user.email "YOUR_EMAIL@example.com"
git config --global user.name "YOUR NAME"

git add .
git commit -m "Automated Rebuild"
git push -f origin YOUR_PAGES_BRANCH
~~~

* Jekyll:

~~~bash
# Copy static site
CWD=`pwd`

# Clone Pages repository
cd /tmp
git clone YOUR_PAGES_REPO build
# cd build && git checkout -b YOUR_BRANCH origin/YOUR_BRANCH # If not using master

# Trigger Jekyll rebuild
cd $CWD
bundle exec jekyll contentful
bundle exec jekyll build

# Push newly built repository
cp -r $CWD/_build/* /tmp/build # or $CWD/_site

cd /tmp/build

git config --global user.email "YOUR_EMAIL@example.com"
git config --global user.name "YOUR NAME"

git add .
git commit -m "Automated Rebuild"
git push -f origin YOUR_PAGES_BRANCH
~~~

> Make sure your CircleCI machine has access to your Pages repository.
> This requires adding SSH Keys to the CircleCI machine and configuring them on GitHub.

## Setup Circle build steps

Now we have everything we need to create our automated builds, only thing missing
is to add a build step in Circle to run our build.

In `circle.yml`, add the following:

~~~yml
machine:
  ruby:
    version: 2.3.1
dependencies:
  pre:
    - gem install bundler
checkout:
  post:
    - bundle install
    - bash automated_build.sh
~~~

## We're done! Automation!

You can now start testing your automatically rebuilt site. With this setup, any change
pushed on your repository or any publish/unpublish action on Contentful will trigger
an automated rebuild of your site.
