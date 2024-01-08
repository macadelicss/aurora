require 'csv'
require 'rubyXL'

module Stepa
  class Title
    def initialize(input_file, csv_file, xlsx_file)
      @input_file = input_file
      @csv_file = csv_file
      @xlsx_file = xlsx_file
      @extracted_lines = extract_lines
    end
    def append_to_files
      append_to_csv
      append_to_xlsx
    end

    private

    # Extracts the first line following each "block_" marker
    def extract_lines
      all_lines = File.readlines(@input_file)
      extracted_lines = []
      next_line = false
      all_lines.each do |line|
        if next_line
          extracted_lines << line.strip
          next_line = false
        end
        next_line = true if line.strip.start_with?('block_')
      end
      extracted_lines
    end
    # Append lines to CSV, starting from the second column (Title)
    def append_to_csv
      CSV.open(@csv_file, 'a') do |csv|
        @extracted_lines.each { |line| csv << ['Handle', line] }
      end
    end
    # Append lines to XLSX, starting from the second column (Title)
    def append_to_xlsx
      workbook = RubyXL::Workbook.new
      worksheet = workbook[0]
      @extracted_lines.each_with_index do |line, index|
        worksheet.add_cell(index + 1, 1, line)  # B column (index 1), starting from row 2
      end
      workbook.write(@xlsx_file)
    end
  end
end

class HandleGenerator
  def self.generate(title)
    title.downcase.gsub(/\s+/, '_')
  end
end
