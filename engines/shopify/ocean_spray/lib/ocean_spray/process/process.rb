# frozen_string_literal: true

module Process
  class Grind
    def grinder
      File.open(filename, 'r') do |file|
        file.each_line do |line|
          stripped_line = line.strip #strip!
          puts "Preprocessing line #{stripped_line}" unless stripped_line.empty?
        end
      end
    end
    def process(filename)
      patterns = [
        { name: :underscore,  pattern: /_/,                 count: 0, lines: [] },
        { name: :pipe,        pattern: /\|/,                count: 0, lines: [] },
        { name: :starts_with, pattern: /\A%/,               count: 0, lines: [] },
        { name: :bullet,      pattern: /•/,                 count: 0, lines: [] },
        { name: :dash,        pattern: /-/,                 count: 0, lines: [] },
        { name: :mult,        pattern: /[()?!]/,            count: 0, lines: [] },
        { name: :colon,       pattern: /:/,                 count: 0, lines: [] },
        { name: :db_colon,    pattern: /::/,                count: 0, lines: [] },
        { name: :items,       pattern: /\bItems\b/,         count: 0, lines: [] },
        { name: :category,    pattern: /^Category:/,        count: 0, lines: [] },
        { name: :details,     pattern: /^Details$/,         count: 0, lines: [] },
        { name: :numbered,    pattern: /^\d+::/,            count: 0, lines: [] },
        { name: :price,       pattern: /^\$\d+(\.\d{2})?$/, count: 0, lines: [] },
      ]
      File.foreach(filename).with_index(1) do |line, line_number|
        patterns.each do |pattern_hash|
          match_and_store_line(line, line_number, pattern_hash)
        end
      end
      print_patterns(patterns)
    end
    def match_and_store_line(line, line_number, pattern_hash)
      if line.match?(pattern_hash[:pattern])
        pattern_hash[:count] += 1
        pattern_hash[:lines] << { number: line_number, text: line.strip }
      end
    end
    private
    def print_patterns(patterns, output_file="processed.txt")
      File.open(output_file, 'w') do |file|
        patterns.each do |pattern_hash|
          file.puts "#{pattern_hash[:name]} Count = #{pattern_hash[:count]}"
          pattern_hash[:lines].each do |line_info|
            file.puts " Line #{line_info[:number]}: #{line_info[:text]}"
          end
          file.puts ""
        end
      end
    end
  end
end
# Create an instance of the Grind class from the Process module
grinder = Process::Grind.new

# Call the process method with the filename
filename = "output.txt" # Replace with your actual file name
grinder.process(filename)
