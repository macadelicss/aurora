require 'csv'

module Slyther
  class Sli
    def process_csv(input_file, output_file)
      data = CSV.read(input_file, headers: true)
      corrected_data = []
      data.each do |row|
        row['Title'] = "%#{row['Title'].strip}" unless row['Title'].start_with?('%')
        puts "Warning: Missing description for product #{row['Title']}" if row['Description'].to_s.strip.empty?
        puts "Warning: Missing items/inventory for product #{row['Title']}" if row['Items'].to_s.strip.empty?
        puts "Warning: Missing details for product #{row['Title']}" if row['Details'].to_s.strip.empty?
        corrected_data << row
      end
      CSV.open(output_file, 'w') do |csv|
        csv << data.headers
        corrected_data.each { |row| csv << row }
      end
    end

    def process(input_file_path, output_csv_file)
      bodies = extract_body(input_file_path)
      CSV.open(output_csv_file, 'w', write_headers: true, headers: ['Body']) do |csv|
        bodies.each { |body| csv << [body] }
      end
      puts "Body texts have been written to #{output_csv_file}"
    end

    def body(input_file_path, output_file_path)
      descriptions = []
      file_contents = File.read(input_file_path)
      file_contents.scan(/\|Category\|:(.*?)\$\d+/m) do |match|
        description = match[0].strip.gsub("\n", ' ')
        descriptions << description
      end
      CSV.open(output_file_path, "wb") do |csv|
        descriptions.each { |description| csv << [description] }
      end
    end

    private

    def extract_body(input_file)
      content = File.read(input_file, encoding: 'UTF-8')
      product_blocks = content.split('$')
      body_texts = []
      product_blocks[0...-1].each do |block|
        lines = block.strip.split("\n")
        category_index = lines.index { |line| line.include?('Category:') }
        body_text = lines[category_index + 1..-1].join("\n").strip if category_index
        body_texts << body_text if body_text
      end
      body_texts
    end
  end
end


require_relative 'slyther'

sli = SlyEth::Sli.new

# Example usage of process_csv method
input_csv_file = 'path/to/input.csv'
output_csv_file = 'path/to/output.csv'
sli.process_csv(input_csv_file, output_csv_file)

# Example usage of process method
input_file_path = 'path/to/input.txt'
output_csv_file = 'path/to/output.csv'
sli.process(input_file_path, output_csv_file)

# Example usage of body method
input_file_path = 'path/to/input.txt'
output_file_path = 'path/to/output.csv'
sli.body(input_file_path, output_file_path)
