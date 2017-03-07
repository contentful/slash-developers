# Contentful developer documentation

[![Build Status](https://travis-ci.org/contentful/slash-developers.svg?branch=master)](https://travis-ci.org/contentful/slash-developers)

This repository contains the raw content for <https://www.contentful.com/developers/>, but not API documentation.

## Contributing

- __Do not__ modify manually files in the `docs/` directory.
- __Do__ modify files in the `raw_dows/` directory.
- Before opening a PR, run `./generate-docs.sh`. It'll prepare files in the `/docs` directory as described below.
- Changes in both `raw_docs/` (manually introduced) and `docs/` (automatically generated) need to be committed to the repository.
- After opening a PR, ping developers and ask for a review.

## Documentation generation

Currently the `./generate-docs.sh` script does two things:

### Including other content

You can use [hercule](https://github.com/jamesramsay/hercule) to include (transclude) other partial markdown files and reduce repetition. You can find the current partial files in the `raw_docs/_partials` folder and you include them with the following syntax:

```
:[Getting started tutorial intro](../../_partials/getting-started-intro.md)
```

### Placeholders

Placeholders for variables in code examples are enclosed in angled brackets, for example:

```
<space_id>
```

When you build the documentation these are replaced with the real values you can find in `placeholder-replacements.sh` via the `sed` command. Feel free to add new variables you need.
