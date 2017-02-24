#!/usr/bin/env bash

npm install
HERCULE=node_modules/.bin/hercule

rm -dfr docs

echo "Processing Markdown"
for filename in $(find raw_docs -type f -name '*.md'); do

  echo $filename
  original_string=$filename
  string_to_replace_with=docs
  result_string="${original_string/raw_docs/$string_to_replace_with}"
  echo $result_string

  mkdir -p "$(dirname "$result_string")" && touch "$result_string"
  hercule $filename -o $result_string
  ./placeholder-replacements.sh $result_string
done

cp raw_docs/references/authentication.html.haml docs/references/authentication.html.haml

rm -dfr docs/_partials
