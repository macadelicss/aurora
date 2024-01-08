# frozen_string_literal: true
require 'csv'
require 'rubyXL'

module InvHeaders
  class InitCsv
    attr_reader :output_file

    def initialize(output_file)
      @output_file = output_file
    end

    def write_headers_to_csv
      CSV.open(@output_file, 'w') do |csv|
        csv << self.class.headers
      end
    end

    def write_headers_to_xlsx
      workbook = RubyXL::Workbook.new
      worksheet = workbook[0]
      self.class.headers.each_with_index do |header, index|
        worksheet.add_cell(0, index, header)
      end
      workbook.write(@output_file)
    end

    def self.headers
      [
        'Handle',
        'Title',
        'Option1 Name',
        'Option1 Value',
        'Option2 Name',
        'Option2 Value',
        'Option3 Name',
        'Option3 Value',
        'SKU',
        'Hs Code',
        'COO',
        'Location',
        'Incoming',
        'Unavailable',
        'Committed',
        'Available',
        'On hand'
      ]
    end
  end
end


output_csv_file = "template_inv.csv"
output_xlsx_file = "template_inv.xlsx"
csv_template = InitCsv.new(output_csv_file)
csv_template.write_headers_to_csv
xlsx_data_handler = InitCsv.new(output_xlsx_file)
xlsx_data_handler.write_headers_to_xlsx


