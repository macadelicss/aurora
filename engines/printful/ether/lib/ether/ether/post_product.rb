# frozen_string_literal: true
#
require 'net/http'
require 'json'
require 'uri'
require 'dotenv'
# TODO: require_relative 'products.txt'
#       require_relative 'product_data'

Dotenv.load

module PostProduct
  class ProductPost
    def initialize              # (api_key)
      @api_key = ENV['API_KEY'] # api_key #
      @url = 'https://api.printful.com/sync/products'
    end
    def create_product(product_data)
      uri = URI(url)
      headers = {
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/json'
      }

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request_body = product_data.to_json
      response = http.request(request)

      if response.code == "200"
        puts "Product created"
        puts JSON.parse(response_body)
      else
        puts "Failed"
        puts response.body
      end
    end
  end
end

creator = PostProduct::ProductPost.new
creator.create_product(ProductSkeleton)
