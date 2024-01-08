# frozen_string_literal: true
require 'json'

module Thotiana
  class RunIt
    def initialize (json_file)
      @json_file = json_file
    end

    def parse(keys)
      file_content = File.read(@json_file)
      parsed_data = JSON.parse(file_content)
      puts "#{parsed_data}"
      puts "#{keys}"
      keys.map { |key| [key, parsed_data[key]] }.to_h
    rescue JSON::ParserError => e
      puts "nope..."
      {}
    end
    def double_back(output_file, parsed_data)
      File.open(output_file, 'w') do |file|
        file.write(JSON.pretty_generate(parsed_data))
      end
    end
  end
end


input_file = 'PRINTFUL_IMAGES.json'
parser = Thotiana::RunIt.new(input_file)
keys_to_extract = ["img_url"]  # "key1" => "handle", "key2" => "image_src"
parsed_data = parser.parse(keys_to_extract)

output_file = 'OUTPUT.json'
parser.double_back(output_file, parsed_data)

