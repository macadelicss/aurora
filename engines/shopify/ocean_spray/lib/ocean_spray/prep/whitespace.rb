# frozen_string_literal: true

module Whitespace

  class PPrint
    def pprint_whole_md
      # Open 'README' file for reading and 'output_white.txt' for writing
      File.open('READMETWO') do |read_file|
        File.open('output_white', 'w') do |write_file|
          read_file.chunk { |line|
            /\A\s*\z/ !~ line || nil
          }.each { |_, lines|
            write_file.puts lines
            write_file.puts "\n---\n\n" # Adds a separator and an extra newline after each chunk
          }
        end
      end
    end
  end


end

# PPrint usage
Whitespace::PPrint.new
