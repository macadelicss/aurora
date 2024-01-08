# frozen_string_literal: true

module ConvPyt
  class Convert
    require 'csv'

    # Load the test_inv.csv file
    file_path = ''
    test_inv = CSV.read(file_path, headers: true)

    # Change all 'not stocked' entries to 1 in specified columns
    columns_to_update = ['Incoming', 'Unavailable', 'Committed', 'Available', 'On hand']
    test_inv.each do |row|
      columns_to_update.each do |col|
        row[col] = '1' if row[col] == 'not stocked'
      end
    end

    # Reading the contents of the products.txt file
    products_file_path = ''
    products_contents = File.readlines(products_file_path)

    # Function to extract inventory numbers and corresponding product names
    def extract_inventory_info(contents)
      inventory_info = {}
      contents.each_with_index do |line, i|
        next unless line.strip.start_with?('Items')

        inventory_number = line.split('-')[1].strip.split(' ')[0]
        product_name = contents[i - 1].strip
        inventory_info[product_name] = inventory_number
      end
      inventory_info
    end

    # Extracting inventory information
    inventory_info = extract_inventory_info(products_contents)

    # Function to find the best match for a title in the inventory info
    def find_best_match(title, inventory_info)
      simplified_title = title.downcase.gsub(/[-,|]/, ' ')
      best_match = nil
      best_score = 0
      inventory_info.each do |product_name, _|
        simplified_product_name = product_name.downcase.gsub(/[_-]/, ' ')
        match_score = simplified_title.split.count { |word| simplified_product_name.include?(word) }
        if match_score > best_score
          best_score = match_score
          best_match = product_name
        end
      end
      best_match
    end

    # Matching titles with inventory info and updating the inventory numbers
    test_inv.each do |row|
      best_match = find_best_match(row['Title'], inventory_info)
      next unless best_match

      inventory_number = inventory_info[best_match]
      columns_to_update.each do |col|
        row[col] = inventory_number
      end
    end

    # Saving the updated CSV file
    updated_file_path = '/mnt/data/updated_test_inv.csv'
    CSV.open(updated_file_path, 'wb') do |csv|
      csv << test_inv.headers
      test_inv.each { |row| csv << row }
    end

    # Revised function to process new_prods.txt and extract title, items, category, description, and price
    def process_new_prods_revised(contents)
      products_data = []
      product = {}
      description_lines = []
      price_pattern = /\$\d+\.?\d*/  # Pattern to match price

      contents.each do |line|
        line = line.strip

        if line.start_with?('Category:')
          product['Category'] = line.sub('Category:', '').strip
        elsif line.start_with?('Items')
          product['Items'] = line.split('-')[1].strip.split(' ')[0]
        elsif line && !line.start_with?('•', '$')
          unless description_lines.empty?
            full_description = description_lines.join(' ')
            product['Description'] = full_description
            price_match = full_description.match(price_pattern)
            product['Price'] = price_match ? price_match[0] : ''
            products_data << product
            product = {}
            description_lines = []
          end
          product['Title'] = line
        elsif line.start_with?('•') || line.start_with?('$')
          description_lines << line
        end
      end

      unless description_lines.empty?
        full_description = description_lines.join(' ')
        product['Description'] = full_description
        price_match = full_description.match(price_pattern)
        product['Price'] = price_match ? price_match[0] : ''
        products_data << product
      end

      products_data
    end

    # Assuming you have read new_prods_contents somewhere
    new_prods_data_revised = process_new_prods_revised(products_contents)

    # Load another CSV for structure
    products_export = CSV.read('', headers: true)

    # Create a new array of hashes for the new products
    new_products = []

    new_prods_data_revised.each do |product|
      new_row = {}
      products_export.headers.each { |col| new_row[col] = '' }
      new_row['Title'] = product['Title']
      new_row['Variant Inventory'] = product['Items']
      new_row['Product Category'] = product['Category']
      new_row['Body (HTML)'] = product['Description']
      new_row['Variant Price'] = product['Price']
      new_products << new_row
    end

    # Convert new_products to CSV format and save it
    # ... (Similar to how updated_file_path was handled)
    new_products_file_path = ''

    # Open a new CSV file for writing
    CSV.open(new_products_file_path, 'wb') do |csv|
      # Write the headers first
      csv << products_export.headers

      # Iterate over each product hash and write it to the CSV
      new_products.each do |product|
        csv << products_export.headers.map { |header| product[header] }
      end
    end
  end
end
