require 'rubyXL'
# require 'write_xlsx'
# require 'write_xlsx/utility'

module Excel
  class ExcelValidator
    workbook = RubyXL::Parser.parse('book6.xlsx')

    # Use the first worksheet
    worksheet = workbook[0]
    def validate
      start_row = 1  # Start at row 2 (index 1)
      end_row = 134  # End at row 135 (index 134)

      # Append the specified values to the columns
      (start_row..end_row).each do |row|
        worksheet.add_cell(row, 3, "Thnk")        # column D
        worksheet.add_cell(row, 8, "Title")
        worksheet.add_cell(row, 7, "FALSE")       # Column H
        worksheet.add_cell(row, 16, "shopify")    # Column Q
        worksheet.add_cell(row, 18, "deny")       # Column S
        worksheet.add_cell(row, 19, "manual")     # Column T
        worksheet.add_cell(row, 22, "TRUE")       # Column W
        worksheet.add_cell(row, 23, "TRUE")       # Column X
        worksheet.add_cell(row, 28, "FALSE")      # Column AC
        worksheet.add_cell(row, 45, "g")          # Column AT
        worksheet.add_cell(row, 50, "draft")      # Column AY
      end
      # Save the workbook
      workbook.write('book6.xlsx')
    end
  end
end

=begin
require 'roo'
require 'write_xlsx'
require 'securerandom'
require 'rubyXL'

module ExcelTools
  class ExcelUpdater
    def initialize(file_path, start_row, end_row)
      @workbook = RubyXL::Parser.parse(file_path)
      @worksheet = @workbook[0]
      @start_row = start_row
      @end_row = end_row
    end

    def update_cells
      (@start_row..@end_row).each do |row|
        @worksheet.add_cell(row, 3, "Thnk")
        @worksheet.add_cell(row, 8, "Title")
        @worksheet.add_cell(row, 7, "FALSE")       # Column H
        @worksheet.add_cell(row, 16, "shopify")    # Column Q
        @worksheet.add_cell(row, 18, "deny")       # Column S
        @worksheet.add_cell(row, 19, "manual")     # Column T
        @worksheet.add_cell(row, 22, "TRUE")       # Column W
        @worksheet.add_cell(row, 23, "TRUE")       # Column X
        @worksheet.add_cell(row, 28, "FALSE")      # Column AC
        @worksheet.add_cell(row, 45, "g")          # Column AT
        @worksheet.add_cell(row, 51, "draft")      # Column AY
      end
      @workbook.write('output1.xlsx')
    end
  end

  class DataCopierAndSkuGenerator
    def initialize(source_file, target_file)
      @source_file = source_file
      @target_file = target_file
    end

    def copy_row_data
      source_workbook = Roo::Excelx.new(@source_file)
      source_sheet = source_workbook.sheet(0)

      target_workbook = WriteXLSX.new(@target_file)
      worksheet = target_workbook.add_worksheet

      headers = [
        "Handle", "Title", "Body (HTML)", "Vendor", "Product Category", "Type", "Tags",
        "Published", "Option1 Name", "Option1 Value", "Option2 Name", "Option2 Value",
        "Option3 Name", "Option3 Value", "Variant SKU", "Variant Grams",
        "Variant Inventory Tracker", "Variant Inventory Qty", "Variant Inventory Policy",
        "Variant Fulfillment Service", "Variant Price", "Variant Compare At Price",
        "Variant Requires Shipping", "Variant Taxable", "Variant Barcode", "Image Src",
        "Image Position", "Image Alt Text", "Gift Card", "SEO Title", "SEO Description",
        "Google Shopping / Google Product Category", "Google Shopping / Gender",
        "Google Shopping / Age Group", "Google Shopping / MPN",
        "Google Shopping / AdWords Grouping", "Google Shopping / AdWords Labels",
        "Google Shopping / Condition", "Google Shopping / Custom Product",
        "Google Shopping / Custom Label 0", "Google Shopping / Custom Label 1",
        "Google Shopping / Custom Label 2", "Google Shopping / Custom Label 3",
        "Google Shopping / Custom Label 4", "Variant Image", "Variant Weight Unit",
        "Variant Tax Code", "Cost per item", "Price / International",
        "Compare At Price / International", "Status"
      ]
      headers.each_with_index { |header, index| worksheet.write(0, index, header) }

      (1..source_sheet.last_row).each do |row_index|
        row = source_sheet.row(row_index)
        row.each_with_index { |cell, cell_index| worksheet.write(row_index, cell_index, cell) }
      end

      target_workbook.close
    end

    def generate_sku(title, category)
      part1 = title.to_s[0..2].upcase
      part2 = category.to_s[0..2].upcase
      return "" if part1.empty? && part2.empty?
      random_number = SecureRandom.random_number(1000).to_s.rjust(3, '0')
      "#{part1}#{part2}#{random_number}"
    end

    def process_sku_generation
      source_workbook = Roo::Excelx.new(@source_file)
      source_sheet = source_workbook.sheet(0)

      target_workbook = WriteXLSX.new(@target_file)
      worksheet = target_workbook.add_worksheet
      headers = ['Product Title', 'Product Category', 'SKU']
      headers.each_with_index { |header, index| worksheet.write(0, index, header) }

      (1..source_sheet.last_row).each do |row|
        title = source_sheet.cell(row, 1)    # Column 1 for 'Product Title'
        category = source_sheet.cell(row, 4) # Column 4 for 'Product Category'
        sku = generate_sku(title, category)

        worksheet.write(row, 0, title || "N/A")
        worksheet.write(row, 1, category || "N/A")
        worksheet.write(row, 2, sku)
      end

      target_workbook.close
    end
  end
end


updater = ExcelTools::ExcelUpdater.new('path_to_input_file.xlsx', 1, 178)
updater.update_cells
# For copying data from one workbook to another
data_copier = ExcelTools::DataCopierAndSkuGenerator.new('source_file.xlsx', 'copied_file.xlsx')
data_copier.copy_row_data
# For generating SKUs and writing to a new workbook
sku_generator = ExcelTools::DataCopierAndSkuGenerator.new('source_file_for_sku.xlsx', 'output_with_skus.xlsx')
sku_generator.process_sku_generation







# Create a new Excel workbook
workbook = WriteXLSX.new('products.xlsx')
# Add a worksheet
worksheet = workbook.add_worksheet
# Define the headers
headers = [
  "Handle", "Title", "Body (HTML)", "Vendor", "Product Category", "Type", "Tags",
  "Published", "Option1 Name", "Option1 Value", "Option2 Name", "Option2 Value",
  "Option3 Name", "Option3 Value", "Variant SKU", "Variant Grams",
  "Variant Inventory Tracker", "Variant Inventory Qty", "Variant Inventory Policy",
  "Variant Fulfillment Service", "Variant Price", "Variant Compare At Price",
  "Variant Requires Shipping", "Variant Taxable", "Variant Barcode", "Image Src",
  "Image Position", "Image Alt Text", "Gift Card", "SEO Title", "SEO Description",
  "Google Shopping / Google Product Category", "Google Shopping / Gender",
  "Google Shopping / Age Group", "Google Shopping / MPN",
  "Google Shopping / AdWords Grouping", "Google Shopping / AdWords Labels",
  "Google Shopping / Condition", "Google Shopping / Custom Product",
  "Google Shopping / Custom Label 0", "Google Shopping / Custom Label 1",
  "Google Shopping / Custom Label 2", "Google Shopping / Custom Label 3",
  "Google Shopping / Custom Label 4", "Variant Image", "Variant Weight Unit",
  "Variant Tax Code", "Cost per item", "Price / International",
  "Compare At Price / International", "Status"
]
# Write the headers to the first row of the worksheet
headers.each_with_index do |header, index|
  worksheet.write(0, index, header)
end
# Close the workbook
workbook.close
source_workbook = Roo::Excelx.new('added_products.xlsx')
source_sheet = source_workbook.sheet(0)
# Prepare to write to a new Excel file
workbook = WriteXLSX.new('skus.xlsx')
worksheet = workbook.add_worksheet
# Headers for the new file
headers = ['Product Title', 'Product Category', 'SKU']
# Write headers
headers.each_with_index do |header, index|
  worksheet.write(0, index, header)
end
# Initialize a row index for the output file
output_row_index = 1
# Read each row from the source, generate SKU, and write to the new file
(1..source_sheet.last_row).each do |row|
  title = source_sheet.cell(row, 1) # Column 1 for 'Product Title'
  category = source_sheet.cell(row, 4) # Column 2 for 'Product Category'
  sku = generate_sku(title, category)
  # Write title, category, and SKU to the new file
  worksheet.write(output_row_index, 0, title || "N/A")
  worksheet.write(output_row_index, 1, category || "N/A")
  worksheet.write(output_row_index, 2, sku)
  # Increment the output row index
  output_row_index += 1
end
# Close the workbook
workbook.close
=end
