# slash-developers

[![Build Status](https://travis-ci.org/contentful/slash-developers.svg?branch=master)](https://travis-ci.org/contentful/slash-developers)

This repository contains the raw content for `www.contentful.com/developers/`

## Usage

1. There's a `Makefile` inside the `apiary` folder for dealing with the reference blueprints:

```bash
$ cd apiary/
$ make clean    # remove generated files
$ make install  # install the necessary tools
$ make preview  # generates local HTML for blueprints, shows them in a browser
$ make test     # tests the blueprints
```

Where appropriate, tests are run before the task is performed. The test use
[dredd](https://github.com/apiaryio/dredd) to check the blueprint against the
actual APIs. When changes are merged to `master`, they will be automatically published.

Note: to reduce manual duplication of content between the different blueprints, [hercule](https://github.com/jamesramsay/hercule) is used for including content from `_partials` into the blueprints - the `Makefile` tasks take care of generating a full blueprint into the `out` directory, so make sure you are editing the actual sources, not the generated files.

2. The rest of the documentation consists of Markdown files which will end up on the
Contentful website, via a Git submodule in the
[marketing repository](https://github.com/contentful/marketing-website).

3. To make the lists of SDKs and projects more maintainable, there's a script:

```bash
$ ./scripts/public_projects.rb
```

This will list all Contentful public GitHub repositories, which aren't referenced
from the documentation.

## Setting up the environment

- For running the tests, the environment variable `CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN` needs to be set to a [valid CMA token](https://www.contentful.com/developers/docs/references/authentication/#getting-an-oauth-token) which has access to the testing space "fp91oelsziea".
- For using the Apiary gem, the environment variable `APIARY_API_KEY` needs to be set (see [this](https://github.com/apiaryio/apiary-client#install) for more information).

## Tips on contributing

 - use branches & pull requests
 - All pull requests should be reviewed by somebody else before merging to master. Preferably they are reviewed by [@chrischinchilla](https://github.com/ChrisChinchilla).
 - To actually make your changes appear on staging/production, follow [this guide](https://github.com/contentful/marketing-website/blob/master/README.md#contribute-to-the-docs)
 - Changes to the API blueprints are automatically published once they are merged to `master`.

## Tests

The tests in this repository are using [dredd](https://github.com/apiaryio/dredd) to check that the examples defined in
the docs actually work against the API. Generally this works by taking the URL template and example body, replacing all variables with the
sample values and comparing the APIs response with the MSON defined for this request. Currently only GET requests are tested.

Note: The tests only affect the blueprint used for the documentation on Apiary. Files in the `docs/` directory are not tested in any way.

## Apiary customization
In order to understand how we include and theme the Apiary references, please see the [apiary_customization.md](https://github.com/contentful/marketing-website/blob/master/apiary_customization.md) file in the marketing website repository.
