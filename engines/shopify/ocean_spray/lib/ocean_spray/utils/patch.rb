module Patch
  class Medic
    attr_accessor :column, :row, :not_stocked

    def initialize(input_filename, output_filename, column, row, not_stocked)
      @input_filename = input_filename
      @output_filename = output_filename
      @column = column
      @row = row
      @not_stocked = not_stocked
    end

    File.open(input_filename, 'a') do |column|
      column.puts("#{@column},#{@row},#{@not_stocked}")
    end
  end
end
