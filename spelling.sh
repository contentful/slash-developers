#!/bin/bash

wc -l Spelling-and-style-sheet/.hunspell_en_US_contentful > Spelling-and-style-sheet/contentful.dic
sort Spelling-and-style-sheet/.hunspell_en_US_contentful | uniq >> Spelling-and-style-sheet/contentful.dic
touch Spelling-and-style-sheet/contentful.aff
sudo cp contentful.* /usr/share/hunspell/

find . -iname '*.md' -type f -exec hunspell -d en_US,contentful -l {} \;
