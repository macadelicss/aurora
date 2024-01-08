require 'securerandom'
require 'digest'
require 'json'
require 'csv'

module SkuGin
  class SKUGenerator
    def gin_sku(product_name, category, id)
      name_fragment = sanitize_string(product_name)
      category_fragment = sanitize_string(category)
      "#{category_fragment[0,3]}-#{name_fragment[0,3]}-#{id}".upcase
    end
    def sanitize_string(str)
      # Remove non-alphanumeric characters and downcase the string
      str.gsub(/[^0-9a-z ]/i, '').split.join
    end
  end
  class ProductSKUGenerator
    def initialize(input_file_path, output_file_path)
      @input_file_path = input_file_path
      @output_file_path = output_file_path
    end
    def process_products
      products = parse_text_file(@input_file_path)
      products.each { |product| product['sku'] = generate_sku(product['name'], product['category']) }
      write_to_json_file(products, @output_file_path)
    end

    private

      def generate_sku(product_name, category)
        simplified_product_name = product_name.gsub(/\W+/, '').upcase[0...3]
        simplified_category = category.gsub(/\W+/, '').upcase[0...3]
        unique_id = SecureRandom.uuid[0...4].upcase
        "#{simplified_category}#{simplified_product_name}#{unique_id}"
      end
      def parse_text_file(file_path)
        products = []
        File.foreach(file_path) do |line|
          data = line.split(',').map(&:strip)
          # Adjust these indices according to your file's structure
          product_name = data[1]  # Assuming 'Title' is the second element
          category = data[5]      # Assuming 'Type' (category) is the sixth element
          products << {"name" => product_name, "category" => category} if product_name && category
        end
        products
      end
      def write_to_json_file(products, file_path)
        File.open(file_path, 'w') do |json_file|
          json_file.write(JSON.pretty_generate(products))
        end
      end
  end
  class SKUExtractor
    def initialize(json_file_path, output_file_path)
      @json_file_path = json_file_path
      @output_file_path = output_file_path
    end
    def extract_skus
      products = read_json_file(@json_file_path)
      skus = products.map { |product| product['sku'] }
      write_to_text_file(skus, @output_file_path)
    end

    private

      def read_json_file(file_path)
        content = File.read(file_path)
        JSON.parse(content)
      rescue JSON::ParserError => e
        puts "There was an error parsing the JSON file: #{e.message}"
        []
      end
      def write_to_text_file(skus, file_path)
        File.open(file_path, 'w') do |file|
          skus.each { |sku| file.puts(sku) }
        end
      end
  end
  class SkuGin
    def self.generate_sku(column1)
      part1 = column1.split.last[0, 3].upcase rescue 'XXX'
      random_number = SecureRandom.random_number(1000).to_s.rjust(3, '0')
      "#{part1}#{random_number}"
    end
    def self.process_csv(filename)
      line_number = 0
      CSV.foreach(filename, headers: true, encoding: 'bom|utf-8:utf-8:invalid:replace') do |row|
        line_number += 1
        if row[0].to_s.strip.empty?
          puts "Skipping line #{line_number} due to missing data. Column 1: '#{row[0]}'"
          next
        end
        sku = generate_sku(row[0])
        puts "SKU for row #{line_number}: #{sku}"
      end
    rescue StandardError => e
      puts "An error occurred on line #{line_number}: #{e.message}"
    end
  end
  class SkuGin2
    def generate_sku(product_name, category)
      lcase_name = product_name.gsub(/\W+/, '').upcase[0..2]
      lcase = category.gsub(/\W+/, '').upcase[0..2]
      uu_id = SecureRandom.uuid[0..3].upcase
      "#{lcase}#{lcase_name}#{uu_id}"
    end
    def parse_file(file_path)
      products = []
      content = File.read(file_path)
      products_data = content.split("\n\n\n")
      products_data.each do |product_data|
        lines = product_data.split("\n")
        name_line = lines[0].split('_')
        product_name = name_line.length > 1 ? name_line[1] : name_line[0]
        category = nil
        lines.each do |line|
          category = line.split(":")[1].strip if line.starts_with?("Category")
        end
        products << {"name" => product_name, "category" => category} if product_name && category
        products
      end
    end
  end
end

# generate_sku = SkuGin::SKUGenerator.gin_sku
