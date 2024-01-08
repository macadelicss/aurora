# frozen_string_literal: true

module KMP
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

  # Allows kmp_search to be called as an instance method in classes that include the Search module.
  #
  #   class String; include Algorithms::Search; end
  #   "ABC ABCDAB ABCDABCDABDE".kmp_search("ABCDABD") #=> 15
  def kmp_search(substring)
    KMP::kmp_search(self, substring)
  end
end
