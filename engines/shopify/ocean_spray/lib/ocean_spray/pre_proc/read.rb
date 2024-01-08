require 'fileutils'

module Read
  class Skim
    def check_txt

    end
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

    def parse_and_ex_cat_desc(start_pattern, end_pattern, output_file)
      # Ensure the output directory exists, create if it doesn't
      FileUtils.mkdir_p(@output_dir) unless Dir.exist?(@output_dir)

      # Path for the output file
      output_path = File.join(@output_dir, output_file)

      # Open the output file for writing
      File.open(output_path, 'a') do |output|
        # Read the input file and process each line
        begin
          File.open(@input_file, 'r') do |file|
            copy_line = false
            file.each_line do |line|
              # Start copying after encountering the start pattern
              if line.include?(start_pattern)
                copy_line = true
                next  # Skip the line with the start pattern
              end

              # Reset copy_line when encountering the end pattern
              if line.include?(end_pattern) && copy_line
                copy_line = false
                next  # Skip the line with the end pattern
              end

              # Write to the output file if copy_line is true
              output.puts line if copy_line
            end
          end
        rescue Errno::ENOENT
          puts "Input file not found."
        end
      end
    end
  end
end

# Configuration for category descriptions
input_file_path = 'products.txt' # Update with actual path
output_directory = 'for_c'
output_file_name_desc = 'desc.txt'
start_pattern_category = 'Category'
end_pattern_dollar_sign = '$'

# Create an instance of ProductParser
parser = ProductParser.new(input_file_path, output_directory)

# Perform the operation for category descriptions
parser.parse_and_ex_cat_desc(start_pattern_category, end_pattern_dollar_sign, output_file_name_desc)
