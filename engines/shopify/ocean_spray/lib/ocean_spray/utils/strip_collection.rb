require 'fileutils'

class StripCollection
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

# require_relative 'ProductParser'

# Configuration for "Items"

