# frozen_string_literal: true

module ProductSkeleton
  class SkeletonProducts
    # product_data.rb
    PRODUCT_DATA = {
      "sync_product" => {
        "name" => "Custom T-Shirt",
        "thumbnail" => "http://example.com/path/to/thumbnail.jpg"
      },
      "sync_variants" => [
        {
          "retail_price" => "25.00",
          "variant_id" => 1118,  # Example ID
          #  "sku" => "TSHAPP345",
          "files" => [
            {
              "type" => "default",
              "url" => "http://example.com/path/to/printfile.jpg"
            }
          ],
          "options" => [
            {
              "id" => "embroidery",
              "value" => "flat"
            }
          ]
        }
      ]
    }

  end
end

