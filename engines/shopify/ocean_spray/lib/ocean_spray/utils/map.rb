# frozen_string_literal: true
require 'csv'
require 'rexml/document'
require 'rubyXL'

module Map
  # Function to clean and wrap the product details in HTML tags
  #   def wrap_product_details_in_html(product_details)
  #     product_details.gsub!('Details', '<p>Details</p>')
  #     product_details.gsub!(/(?<=<\/p>)(.+)/m, '<ul><li>\1</li></ul>')
  #     product_details
  #   end
  # Function to map and format the processed product data to the Shopify CSV template
  def map_to_shopify_template(processed_data_path, template_csv_path)
    # Load the processed data
    processed_data = CSV.read(processed_data_path, headers: true, encoding: 'ISO-8859-1')
    # Load the Shopify CSV template
    template = CSV.read(template_csv_path, headers: true)
    # Initialize a new array for mapped data
    mapped_data = []
    processed_data.each_with_index do |row, index|
      mapped_row = {}
      # Map the required fields
      mapped_row['Handle'] = index + 1  # Creating a unique handle for each product
      mapped_row['Title'] = row['Title'].to_s.gsub(/[^a-zA-Z0-9\s]/, '')  # Clean title
      mapped_row['Variant Inventory Qty'] = row['Items'][/\d+/].to_f  # Extract numbers
      mapped_row['Product Category'] = row['Category'].to_s.gsub(/[^a-zA-Z0-9\s]/, '')  # Clean category
      mapped_row['Variant Price'] = row['Price'].gsub(/[^\d.]/, '').to_f  # Clean price
      mapped_row['Body (HTML)'] = wrap_product_details_in_html(row['Product'])  # Assign cleaned HTML content
      # Fill in the rest of the columns with default values or blanks as per template
      template.headers.each do |header|
        mapped_row[header] = mapped_row.fetch(header, template[0][header])
      end
      mapped_data << mapped_row
    end
    mapped_data
  end
  # Specify the paths to the processed product data and the Shopify CSV template
  processed_data_path = '/mnt/data/processed_products_html_wrapped.csv'
  template_csv_path = '/mnt/data/csv-template.csv'
  # Map and format the data to the Shopify template
  shopify_csv_data = map_to_shopify_template(processed_data_path, template_csv_path)
  # Save the mapped data to a CSV file
  output_csv_file_path = '/mnt/data/mapped_products_for_shopify.csv'
  CSV.open(output_csv_file_path, 'w', encoding: 'ISO-8859-1') do |csv|
    csv << shopify_csv_data.first.keys # Adds the headers
    shopify_csv_data.each { |row| csv << row.values }
  end
  puts "Mapped data saved to #{output_csv_file_path}"
end
