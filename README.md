# slash-developers

This repo contains the raw content for `www.contentful.com/developers/`

## Usage

1. There's a `Makefile` for dealing with the reference blueprints:

```bash
$ make clean    # remove generated files
$ make install  # install the necessary tools
$ make preview  # generates local HTML for blueprints, shows them in a browser
$ make publish  # publishes local content to Apiary
$ make test     # tests the blueprints
```

Where appropriate, tests are run before the task is performed. The test use
[dredd](https://github.com/apiaryio/dredd) to check the blueprint against the
actual APIs.

Note: to reduce manual duplication of content between the different blueprints, [hercule](https://github.com/jamesramsay/hercule) is used for including content from `_partials` into the blueprints - the `Makefile` tasks take care of generating a full blueprint into the `out` directory, so make sure you are editing the actual sources, not the generated files.

2. The rest of the documentation consists of Markdown files which will end up on the
Contentful website, via a Git submodule in the
[marketing repo](https://github.com/contentful/marketing-website).

3. To make the lists of SDKs and projects more maintainable, there's a script:

```bash
$ ./scripts/public_projects.rb
```

This will list all Contentful public GitHub repositories, which aren't referenced
from the documentation.

## Setting up the environment

- For running the tests, the environment variable `CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN` needs to be set to a valid CMA token which has access to the testing space "5smsq22uwt4m".
- For publishing to Apiary, the environment variable `APIARY_API_KEY` needs to be set (see [this](https://github.com/apiaryio/apiary-client#install) for more information).

## Tips on contributing

 - use branches & pull requests
 - All pull requests should be reviewed by somebody else before merging to master. Preferably they are reviewed by @eugenekudashev.
