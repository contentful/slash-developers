#!/usr/bin/env bash

rm -dfr out
mkdir out

echo "Processing Files"
for filename in $(find docs -type f \( -iname \*.md -o -iname \*.apib \) -not -path "*docs/_partials*" -not -path "*node_modules*"); do

  echo "Processing $filename"

  original_string=$filename
  result_string="out/${original_string}"

  echo "Creating $result_string"

  mkdir -p "$(dirname "$result_string")" && touch "$result_string"

  hercule $filename -o $result_string

  ./placeholder-replacements.sh $result_string
done
