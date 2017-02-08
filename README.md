# Contentful developer documentation

[![Build Status](https://travis-ci.org/contentful/slash-developers.svg?branch=master)](https://travis-ci.org/contentful/slash-developers)

This repository contains the raw content for _www.contentful.com/developers/_, but not API documentation.

## Writing documentation

To allow for the reuse of content and a centralized way to update placeholders in examples, make changes in the _raw_docs_ folder.

### Including other content

You can use [hercule](https://github.com/jamesramsay/hercule) to include (transclude) other partial markdown files and reduce repetition. Hercule is included in the _package.json_ file or you can install it manually. You can find the current partial files in the _raw_docs/\_partials_ folder and you include them with the following syntax:

```markdown
:[Getting started tutorial intro](../../_partials/getting-started-intro.md)
```

### Placeholders

Placeholders for variables in code examples are enclosed in angled brackets, for example:

```markdown
<space_id>
```

When you build the documentation these are replaced with the real values you can find in _placeholder-replacements.sh_ via the `sed` command. Feel free to add new variables you need.

### Tips on contributing

-   Use branches & pull requests.
-   All pull requests should be reviewed by somebody else before merging to master. Preferably they are reviewed by [@chrischinchilla](https://github.com/ChrisChinchilla).
-   To actually make your changes appear on staging/production, follow [this guide](https://github.com/contentful/marketing-website/blob/master/README.md#contribute-to-the-docs)

## Building documentation

You will need to generate the final documentation ready for deployment to the Contentful website via a Git submodule in the [marketing repository](https://github.com/contentful/marketing-website). Run the _generate-docs.sh_ file that will transclude the files in _raw_docs_ and replace all the placeholders, outputting the rendered documentation to a new _docs_ folder. At the moment, this folder needs to be committed to the repository.
