# slash-developers

This repo contains (will contain) the raw content for `www.contentful.com/developers/`

## Structure

All source content lives in the `source/` directory.

 - source/index - Landing page that directs users to other parts of the documentation
 - source/reference/ - Reference docs for each API, to be written in [API Blueprint](https://apiblueprint.org) format.
  - [ ] Delivery API
  - [ ] Management API
  - [ ] Preview API
 - source/overview/ - Summary articles providing an introduction to key concepts of Contentfuls API
 - source/tutorials/ - Tutorial articles providing step-by-step instructions on acheiving certain outcomes via the Contentful API
 - source/libraries/ - Single page of content linking:
   - official and unofficial SDKs by programming language
   - other useful libraries such as contentful_rails
 - source/tools/ - Single page listing useful tools for working with API's, e.g. import/export tools, migration & sync, and so on

## Tips on contributing

Use our usual [git workflow](https://contentful.atlassian.net/wiki/display/ENG/Git+and+Github+workflow), essentially:

 - use branches & pull requests
 - all pull requests should be reviewed by somebody else before merging to master. Preferably they are reviewed by @eugenekudashev.
