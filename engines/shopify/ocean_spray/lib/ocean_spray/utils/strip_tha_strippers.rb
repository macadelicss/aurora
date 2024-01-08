module Stripped
    class StripThaStrippers
      # Define the patterns to be stripped, only using names and regex patterns.
      PATTERNS = {
        underscore: /_/,
        pipe: /\|/,
        starts_with: /\A%/,
        bullet: /•/,
        dash: /-/,
        mult: /[()?!]/,
        colon: /:/,
        items: /\bItems\b/,
        category: /^Category:/,
        details: /^Details$/,
        #numbered: /^\d+::/,
        #price: /^\$\d+(\.\d{2})?$/
      }
  
      def self.strip(text)
        # Iterate over each pattern and strip occurrences.
        PATTERNS.each_value do |pattern|
          text.gsub!(pattern, '')
        end
        text
      end
    end
  end
  
  # Define pairs of input and output files
  files_to_process = [
    { input: 'strip_new/Collection.txt', output: 'strip_new/Collection1.txt' },
    { input: 'strip_new/Items.txt', output: 'strip_new/Items1.txt' },
    { input: 'strip_new/prices.txt', output: 'strip_new/prices1.txt' }
  ]
  
  files_to_process.each do |file_pair|
    input_path = file_pair[:input]
    output_path = file_pair[:output]
  
    if File.exist?(input_path)
      text = File.read(input_path)
      stripped_text = Stripped::StripThaStrippers.strip(text)
      File.write(output_path, stripped_text)
      puts "Processed #{input_path} and wrote to #{output_path}"
    else
      puts "File not found: #{input_path}"
    end
  end
  