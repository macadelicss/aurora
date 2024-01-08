module SpreadNScan
  class SpreadEm
    def lemme_see_them_cheeks

    end
    def search_patterns_in_file(file_path, patterns)
      # Searches for occurrences of specific patterns in a file and returns a hash
      # with the count of each pattern.
      #
      # @param file_path [String] Path to the file to be searched.
      # @param patterns [Array<String>] List of string patterns to search for.
      # @return [Hash] Hash with pattern as key and count as value.

      # Initialize a hash to store the count of each pattern
      pattern_counts = Hash[patterns.collect { |pattern| [pattern, 0] }]

      # Read the file and search for patterns
      begin
        File.open(file_path, 'r') do |file|
          file.each_line do |line|
            patterns.each do |pattern|
              pattern_counts[pattern] += 1 if line.match(/#{Regexp.escape(pattern)}/)
            end
          end
        end
      rescue Errno::ENOENT
        return "File not found."
      end

      pattern_counts
    end

    # Path to the 'products.txt' file (this needs to be updated if the file exists)
    products_file_path = 'products.txt'

    # Patterns to search for
    patterns_to_search = %w[% Items Category $]

    # Perform the search
    search_results = search_patterns_in_file(products_file_path, patterns_to_search)
    puts search_results

    # output
    # {"%"=>54, "Items"=>170, "Category"=>175, "$"=>190}

  end
end

require 'csv'
module Scanner
  class Scan
    def process_csv(input_file, output_file)
      data = CSV.read(input_file, headers: true)
      corrected_data = []
      data.each do |row|
        # Ensure product titles start with "%"
        row['Title'] = "%#{row['Title'].strip}" unless row['Title'].start_with?(':')
        # Check and correct missing or incomplete data
        if row['Description'].to_s.strip.empty?
          puts "Warning: Missing description for product #{row['Title']}"
        end
        if row['Items'].to_s.strip.empty?
          puts "Warning: Missing items/inventory for product #{row['Title']}"
        end
        if row['Details'].to_s.strip.empty?
          puts "Warning: Missing details for product #{row['Title']}"
        end
        corrected_data << row
      end
      # Write corrected data to new CSV file
      CSV.open(output_file, 'w') do |csv|
        csv << data.headers
        corrected_data.each { |row| csv << row }
      end
    end
  end
end
