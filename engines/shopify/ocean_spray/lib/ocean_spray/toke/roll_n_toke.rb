# frozen_string_literal: true

module RollNToke
  class Tag
    def initialize(input_filename, output_filename)
      @input_filename = input_filename
      @output_filename = output_filename
    end
    def process_file
      lines = File.readlines(@input_filename)
      output_lines = process_lines(lines)
      File.write(@output_filename, output_lines.join("\n"))
      puts "Processed file saved as #{@output_filename}"
      @output_filename
    end

    private

    def process_lines(lines)
      lines.each_with_object([]) do |line, output_lines|
        stripped_line = line.strip
        next output_lines << line if stripped_line.empty?

        if special_line?(stripped_line)
          output_lines << "|#{stripped_line}|"
          @add_perc = stripped_line.include?("$")
        elsif @add_perc
          output_lines << "::#{line}"
          @add_perc = false
        else
          output_lines << line
        end
      end
    end
    def special_line?(line)
      %w[Item Details Category:].any? { |word| line.include?(word) } || line.include?("$")
    end
  end
  class Tokenize
    def initialize(input_filename, output_filename)
      @input_filename = input_filename
      @output_filename = output_filename
    end
    def toke_blocks
      lines = File.readlines(@input_filename)
      blocks = []
      current_block = []
      block_started = false
      lines.each do |line|
        if line.start_with?('::')
          if block_started
            blocks << current_block.join("\n")
            current_block = []
          end
          block_started = true
          current_block << line[2..].strip
        elsif block_started
          current_block << line.strip
        end
      end
      blocks << current_block.join("\n") if current_block.any?
      tokenized_blocks = {}
      blocks.each_with_index do |block, index|
        tokenized_blocks["block_#{index + 1}"] = block
      end
      write_to_file(tokenized_blocks)
    end

    private

    def write_to_file(tokenized_blocks)
      File.open(@output_filename, 'w') do |file|
        tokenized_blocks.each do |key, value|
          file.puts "#{key}:\n#{value}\n\n"
        end
      end
      puts "Tokenized blocks.. at #{@output_filename}"
    end
  end
end
