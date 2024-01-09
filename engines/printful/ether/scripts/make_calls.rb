# frozen_string_literal: true
require 'json'

module MakeCalls
  class InfoCalls
    def initialize(json_files, output_files)
      @json_files = json_files
      @output_files = output_files
    end
    def extract_products
      all_product_ids = []
      File.open(@output_file, 'w') do |file|
        @json_files.each do |file_path|
          begin
            file_content = File.read(file_path)
            json_data = JSON.parse(file_content)
            products = json_data['data']
            products.each do |product|
              file.puts "Name: #{product['name']}, ID: #{product['id']}"
              all_product_ids << product['id']
            end
          rescue JSON::ParseError =>  e
            puts "Failed to parse JSON from stream #{file_path}: #{e.message}"
          rescue => e
            puts "Error processing file #{file_path}: #{e.message}"
          end
        end
      end
      puts "Extraction complete... Data written to #{@output_file}."
      all_product_ids
    end
    # ....... [ rest of methods ] ..........
    def process_ids_and_write_to_json(product_ids, i1)
      # code here
    end

    def run
      product_ids = extract_products
      process_ids_and_write_to_json(product_ids, 'EXPANDED_PRINTFUL_ITEMS.json')
    end
  end
end

# Usage
json_files = ['.json']
output_file = '.txt'
info_calls_instance = MakeCalls::InfoCalls.new(json_files, output_file)
info_calls_instance.run
