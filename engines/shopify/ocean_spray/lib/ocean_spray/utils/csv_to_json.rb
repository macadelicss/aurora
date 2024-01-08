# frozen_string_literal: true

class CsvToJSON
  def self.convert(csv_file_path, json_file_path)
    array_of_hashes = CSV.read(csv_file_path, headers: true, header_converters: :symbol).map(&:to_hash)
    json_data = array_of_hashes.to_json
    File.open(json_file_path, 'w') do |file|
      file.write(json_data)
    end
  end
end

CsvToJSON.self.convert('products_export_1-2.csv', 'FINAL2.json')
