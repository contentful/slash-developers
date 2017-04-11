#!/usr/bin/env bash

rm -rf docs

echo "Processing Markdown"
for filename in $(find raw_docs -type f -name '*.md'); do
  echo $filename
  original_string=$filename
  string_to_replace_with=docs
  result_string="${original_string/raw_docs/$string_to_replace_with}"
  echo $result_string

  mkdir -p "$(dirname "$result_string")" && touch "$result_string"
  ./node_modules/.bin/hercule $filename -o $result_string
  ./placeholder-replacements.sh $result_string
done

cp -v raw_docs/references/authentication.html.haml docs/references/authentication.html.haml
cp -v raw_docs/android/tutorials/*.png docs/android/tutorials/
cp -v raw_docs/ios/tutorials/*.png docs/ios/tutorials/
cp -v raw_docs/javascript/tutorials/*.png docs/javascript/tutorials/

rm -rf docs/_partials
