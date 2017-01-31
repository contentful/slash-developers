#!/bin/bash
result_string=$1

# Space ID
sed -i -e 's/<space_id>/71rop70dkqaj/g' $result_string

# Access token
if [[ $2 == "preview" ]]; then
  # Preview API
    sed -i -e 's/<access_token>/46cc338e0d4647e3b9f98c52615a2414d725b6ddffdbbb2f3bed26f73789dd53/g' $result_string
else
  # Delivery API
  sed -i -e 's/<access_token>/297e67b247c1a77c1a23bb33bf4c32b81500519edd767a8384a4b8f8803fb971/g' $result_string
fi

sed -i -e 's/<cma_token>/8b57f1a13508078dd67f18c8a9b785d9fc818f9bd5f8c8e24e5899b8ae16532d/g' $result_string

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

# Specific city content type
sed -i -e 's/<city_content_type_id>/city/g' $result_string

# SKU value
sed -i -e 's/<sku_value>/B00E82D7I8/g' $result_string

# Specific asset
sed -i -e 's/<asset_id>/wtrHxeu3zEoEce2MokCSi/g' $result_string
sed -i -e 's/<asset_name>/Playsam Streamliner/g' $result_string
sed -i -e 's/<asset_file>/Playsam Streamliner/g' $result_string

# Link field
sed -i -e 's/<link_field>/brand/g' $result_string

# Link field, multiple
sed -i -e 's/<link_field_multiple>/tags/g' $result_string

# Webhook
sed -i -e 's/<webhook_id>/0KzM2HxYr5O1pZ4SaUzK8h/g' $result_string

# Snapshot
sed -i -e 's/<snapshot_id>/4lFryO7nDNioplKMFBpyMB/g' $result_string

# Space membership ID
sed -i -e 's/<space_membership_id>/0xWanD4AZI2AR35wW9q51n/g' $result_string

# Role
sed -i -e 's/<role_id>/0xvkNW6WdQ8JkWlWZ8BC4x/g' $result_string

# Locale
sed -i -e 's/<locale>/en-US/g' $result_string
sed -i -e 's/<locale_id>/0xpIUSHPfJRzsAFFaub3hT/g' $result_string

# Sync token
sed -i -e 's/<sync_token>/w7Ese3kdwpMbMhhgw7QAUsKiw6bCi09CwpFYwpwywqVYw6DDh8OawrTDpWvCgMOhw6jCuAhxWX_CocOPwowhcsOzeEJSbcOvwrfDlCjDr8O1YzLDvi9FOTXCmsOqT8OFcHPDuFDCqyMMTsKNw7rDmsOqKcOnw7FCwpIfNMOcFMOxFnHCoCzDpAjCucOdwpwfw4YTK8Kpw6zCtDrChVQlNsO2ZybDnw/g' $result_string
