module StripNewlines
  class FileCleaner
    def initialize(input_file, output_file = nil)
      @input_file = input_file
      @output_file = output_file || input_file  # Write to the same file if no output file is specified
    end

    def remove_newlines
      content = File.read(@input_file).gsub(/\r?\n/, '')  # Replace newlines with nothing
      File.write(@output_file, content)
    end
  end
end
input_file = 'products.txt'  # Replace with your file path
output_file = 'stripped_prod.txt'  # Optional: specify a different file for output

file_cleaner = StripNewlines::FileCleaner.new(input_file, output_file)
file_cleaner.remove_newlines
