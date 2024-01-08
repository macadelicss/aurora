class Ecounter
  # count the number of times a word occurs in the file & where it occurs
  # word_data = count_words('example.txt')
  def count_words(file_path)
    word_counts = Hash.new { |hash, key| hash[key] = { count: 0, lines: [] } }
    File.foreach(file_path).with_index(1) do |line, line_number|
      line.split.each do |word|
        word = word.downcase.gsub(/[^a-z0-9]/i, '')  # Normalize the word
        word_counts[word][:count] += 1
        word_counts[word][:lines] << line_number
      end
    end
    word_counts
  end
end
word_data = count_words('products.txt')
