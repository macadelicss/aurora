require 'csv'
require_relative 'process'

module MiniScan
  class Mini
    def scan(input_file, output_file)
      data = CSV.read(input_file, headers: true)
      corrected_data = []
      data.each do |row|
        # Ensure product titles start with "%"
        row['Title'] = "%#{row['Title'].strip}" unless row['Title'].start_with?('%')
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
    input_file = 'output.csv'
    output_file = 'corrected_output_file.csv'
    scan(input_file, output_file)
    puts "Processing completed. Corrected data written to #{output_file}."
  end
end

