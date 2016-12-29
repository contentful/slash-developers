#!/usr/bin/env bash

rm -dfr out
mkdir out

cd apiary/
make clean    # remove generated files
make install  # install the necessary tools
make preview
# TODO: sed happens after preview

cd ../

echo "Processing Files"
for filename in $(find docs apiary/out -type f \( -iname \*.md -o -iname \*.apib \) -not -path "*docs/_partials*" -not -path "*node_modules*"); do

  echo "Processing $filename"

  original_string=$filename
  result_string="out/${original_string/./''}"

  echo "Creating $result_string"

  mkdir -p "$(dirname "$result_string")" && touch "$result_string"

  hercule $filename -o $result_string

  # Space ID
  sed -i -e 's/<space_id>/71rop70dkqaj/g' $result_string

  # Access token
  sed -i -e 's/<access_token>/297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971/g' $result_string

  # Specific entry ID
  sed -i -e 's/<entry_id>/5KsDBWseXY6QegucYAoacS/g' $result_string

  # Specific entry ID two
  sed -i -e 's/<entry_id_two>/3DVqIYj4dOwwcKu6sgqOgg/g' $result_string

  # Specific brand content type
  sed -i -e 's/<brand_content_type_id>/sFzTZbSuM8coEwygeUYes/g' $result_string

  # SKU value
  sed -i -e 's/<website_value>/B00E82D7I8/g' $result_string

  # Specific product content type
  sed -i -e 's/<product_content_type_id>/2PqfXUJwE8qSYKuM0U6w8M/g' $result_string

  # SKU value
  sed -i -e 's/<sku_value>/B00E82D7I8/g' $result_string

  # Specific asset
  sed -i -e 's/<asset_id>/wtrHxeu3zEoEce2MokCSi/g' $result_string
  sed -i -e 's/<asset_name>/Playsam Streamliner/g' $result_string

  # Link field
  sed -i -e 's/<link_field>/brand/g' $result_string

  # Link field, multiple
  sed -i -e 's/<link_field_multiple>/tags/g' $result_string

  # Webhook
  sed -i -e 's/<webhook_id>/newproduct/g' $result_string
done

rm -dfr out/_partials
