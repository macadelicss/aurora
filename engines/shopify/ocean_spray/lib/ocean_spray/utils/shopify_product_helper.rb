# frozen_string_literal: true

require 'fileutils'

class ShopifyProductHelper
  def self.kmp_search(string, substring)
    return nil if string.nil? or substring.nil?

    # create failure function table
    pos = 2
    cnd = 0
    failure_table = [-1, 0]
    while pos < substring.length
      if substring[pos - 1] == substring[cnd]
        failure_table[pos] = cnd + 1
        pos += 1
        cnd += 1
      elsif cnd > 0
        cnd = failure_table[cnd]
      else
        failure_table[pos] = 0
        pos += 1
      end
    end

    m = i = 0
    while m + i < string.length
      if substring[i] == string[m + i]
        i += 1
        return m if i == substring.length
      else
        m = m + i - failure_table[i]
        i = failure_table[i] if i > 0
      end
    end
    return nil
  end

  def self.swipe_n_flee(source_file_path, target_directory, patterns)
    FileUtils.mkdir_p(target_directory) unless Dir.exist?(target_directory)
    pattern_files = {}
    File.open(source_file_path, 'r') do |file|
      file.each_line do |line|
        patterns.each do |pattern|
          if kmp_search(line, pattern) # Check if the pattern is present
            extracted_data = line # Example: using the whole line
            pattern_files[pattern] ||= File.open(File.join(target_directory, "#{pattern}.txt"), 'w')
            pattern_files[pattern].puts(extracted_data)
          end
        end
      end
    end
    pattern_files.values.each(&:close)
  end
end


# Example usage
patterns = %w[$ Category Items Details]
ShopifyProductHelper.swipe_n_flee('products.txt', 'extracted_data', patterns)
