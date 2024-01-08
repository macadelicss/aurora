
# Define a class for processing the file
class PercAlgo
  def initialize(filename)
    @filename = filename
    @patterns = [
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
      { name: :price,       pattern: /^\$\d+(\.\d{2})?$/, count: 0, lines: [] }
    ]
  end

  def process
    File.foreach(@filename).with_index(1) do |line, line_number|
      @patterns.each do |pattern|
        match_and_store_line(line, line_number, pattern)
      end
    end
    print_patterns
  end

  private

  def match_and_store_line(line, line_number, pattern_hash)
    if line.match?(pattern_hash[:pattern])
      pattern_hash[:count] += 1
      pattern_hash[:lines] << { number: line_number, text: line.strip }
    end
  end

  def print_patterns
    File.open('processed_output.txt', 'w') do |file|
      @patterns.each do |pattern_hash|
        file.puts "#{pattern_hash[:name]} Count = #{pattern_hash[:count]}"
        pattern_hash[:lines].each do |line_info|
          file.puts " Line #{line_info[:number]}: #{line_info[:text]}"
        end
        file.puts ""
      end
    end
  end
end

# Create an instance of TextProcessor and process the file
processor = PercAlgo.new('new_prods.txt')
processor.process
