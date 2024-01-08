module Overwatch
  class Exfil
    def need_qrf

    end
  end
end

module FindPat
  class FindPatterns
    NO_OF_CHARS = 256
    def initialize(pat = '')
      @pat = pat
      @tf = compute_tf(@pat, @pat.length) unless @pat.empty?
    end
    def set_pattern(pat)
      @pat = pat
      @tf = compute_tf(@pat, @pat.length)
    end
    def search_in_text(txt)
      m = @pat.length
      n = txt.length
      state = 0
      results = []
      (0...n).each do |i|
        state = @tf[state][txt[i].ord]
        results << (i - m + 1) if state == m
      end
      results
    end

    private

    def get_next_state(m, state, x)
      if state < m && x == @pat[state].ord
        return state + 1
      end
      (1..state).reverse_each do |ns|
        if @pat[ns - 1].ord == x
          i = 0
          while i < ns - 1
            break if @pat[i] != @pat[state - ns + 1 + i]
            i += 1
          end
          return ns if i == ns - 1
        end
      end
      0
    end
    def compute_tf(pat, m)
      tf = Array.new(m + 1) { Array.new(NO_OF_CHARS, 0) }
      (0..m).each do |state|
        (0...NO_OF_CHARS).each do |x|
          z = get_next_state(m, state, x)
          tf[state][x] = z
        end
      end
      tf
    end
  end
end


require 'rubyXL'

class FindColumn
  def find_col(n)
    str = Array.new(50)
    i = 0
    while n > 0
      rem = n % 26
      if rem == 0
        str[i] = 'Z'
        i += 1
        n = (n / 26).to_i - 1
      else
        str[i] = (65 + rem - 1).chr
        i += 1
        n = (n / 26).to_i
      end
    end
    puts str[0, i].reverse.join
  end
  def perc_file(i_file, o_file)
    File.open(o_file, 'w') do |file|
      File.foreach(i_file) do |line|
        col_num = line.to_i
        excel_name = find_col(col_num)
        file.puts(excel_name)
      end
    end
  end
end

i_file = ''
o_file = ''
FindColumn.perc_file(i_file, o_file)

class ExcelColumnNameConverter
  def self.excel_name_to_column(name)
    column_number = 0
    name.each_char.with_index do |char, i|
      column_number *= 26
      column_number += (char.ord - 'A'.ord + 1)
    end
    column_number
  end
end

