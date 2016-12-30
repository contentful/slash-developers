#!/usr/bin/env bash

rm -dfr out
mkdir out

# cd apiary/
# make clean    # remove generated files
# make install  # install the necessary tools
# make preview
# # TODO: sed happens after preview
#
# cd ../

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

# Cleanup
# mv out/apiary/out out/apiary
# rm -dfr out/apiary/out
rm -dfr out/_partials
