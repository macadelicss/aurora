
# frozen_string_literal: true
require 'csv'
module GimmeTheLoot
  class StripPrices
    require 'fileutils'

    def initialize(input_file, output_dir)
      @input_file = input_file
      @output_dir = output_dir
    end

    def parse_and_extract(pattern, output_file)
      # Ensure the output directory exists, create if it doesn't
      FileUtils.mkdir_p(@output_dir) unless Dir.exist?(@output_dir)

      # Path for the output file
      output_path = File.join(@output_dir, output_file)

      # Open the output file for writing
      File.open(output_path, 'a') do |output|
        # Read the input file and process each line
        begin
          File.open(@input_file, 'r') do |file|
            file.each_line do |line|
              # If the line contains the pattern, write it to the output file
              output.puts line if line.include?(pattern)
            end
          end
        rescue Errno::ENOENT
          puts "Input file not found."
        end
      end
    end
  end

  class Extract
    i_f = ''
    o_f = ''
    # Define the path to your input text file and output CSV fil
    input_file_path = '$.txt'  # Replace with your input file path
    output_csv_file = 'output.csv'  # Replace with your output CSV file path
    # This function processes the input file and extracts the body for each category
    def self.extract_body(input_file)
      content = File.read(input_file, encoding: 'UTF-8')
      # Split the content by "$" to separate each product block
      product_blocks = content.split('$')
      # Extract the body for each product block
      body_texts = []
      product_blocks[0...-1].each do |block|  # Exclude the last split as it's after the last "$"
        lines = block.strip.split("\n")
        category_index = lines.index { |line| line.include?('Category:') }
        if category_index
          # Grab all lines after "Category:" line and before the price line (which starts with "$")
          body_text = lines[category_index + 1..-1].join("\n").strip
          body_texts << body_text
        end
      end
      body_texts
    end
    # Extract the body text for each product
    bodies = extract_body(input_file_path)
    # Append the body texts to the CSV file under the "Body" header
    CSV.open(output_csv_file, 'w', write_headers: true, headers: ['Body']) do |csv|
      bodies.each do |body|
        csv << [body]  # Write each body text as a new row under the "Body" header
      end
    end
    puts "Body texts have been written to #{output_csv_file}"
   def extract_body(i_f)
      content = File.read(i_f, encoding: 'UTF-8') # , encoding: 'UTF-8'
      # split the content by "$" to separate each product block
      pb = content.split('$')
      b = [] # extract the body for each product ("Body (HTML)")
      pb[0...-1].each do |block| # Exclude the last split as it's after the last "$"
        lines = block.strip.split("/n")
        cat_i = lines.index { |line| line.include?('Category: ') }
        if cat_i
          b_t = lines[cat_i + 1..-1].join("\n").strip  # grab all lines after "Category: " line and before the price line
          b << b_t
        end
      end
      b
    end
    # extract the body text for each product
    bodies = extract(i_f)
    # Specify the row index you want to append the data to
    # For example, append to the third row (index 2, since it's zero-based)
    r_i_append = 2
    # Read the entire CSV into memory (not efficient for very large CSV files)
    csv_data = CSV.read(o_f)
    if r_i_append >= csv_data.size
      csv_data[r_i_append] = Array.new([bodies.size, csv_data.first.size].max, "")
    end
    bodies.each_with_index do |body, index|
      csv_data[r_i_append][index] = body
    end
    CSV.open(o_f, 'w') do |csv|
      csv_data.each do |row|
        csv << row
      end
    end
  end
end
input_file_path = '$.txt'  # Replace with the actual path to your input file
GimmeTheLoot::StripPrices.new(input_file_path, 'output').parse_and_extract('Category:', 'output.csv')
bodies = StripPrices::Extract.extract(input_file_path)

