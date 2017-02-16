#!/bin/bash

mdspell -r -n -a --en-us `git diff --name-only HEAD HEAD~5`

# wc -l Spelling-and-style-sheet/.spelling > Spelling-and-style-sheet/contentful.dic
# sort Spelling-and-style-sheet/.spelling | uniq >> Spelling-and-style-sheet/contentful.dic
# touch Spelling-and-style-sheet/contentful.aff
# sudo cp contentful.* /usr/share/hunspell/

# find . -iname '*.md' -type f -exec hunspell -d en_US,contentful -l {} \;
