#!/usr/bin/env bash

rm -dfr docs

echo "Processing Markdown"
for filename in $(find _rawDocs -type f -name '*.md'); do

  echo $filename
  original_string=$filename
  string_to_replace_with=docs
  result_string="${original_string/_rawDocs/$string_to_replace_with}"
  echo $result_string

  mkdir -p "$(dirname "$result_string")" && touch "$result_string"
  hercule $filename -o $result_string
  sed -i -e 's/<space_id>/71rop70dkqaj/g' $result_string
  sed -i -e 's/<access_token>/297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971/g' $result_string
  sed -i -e 's/<entry_id>/5KsDBWseXY6QegucYAoacS/g' $result_string
done

rm -dfr docs/_partials
