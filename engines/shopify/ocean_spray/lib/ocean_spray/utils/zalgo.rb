
class Zalgo
  def self.calculate_z_array(s)
    n = s.length
    z = Array.new(n, 0)
    l, r, k = 0, 0, 0
    (1...n).each do |i|
      if i > r
        l, r = i, i
        while r < n && s[r - l] == s[r]
          r += 1
        end
        z[i] = r - l
        r -= 1
      else
        k = i - l
        if z[k] < r - i + 1
          z[i] = z[k]
        else
          l = i
          while r < n && s[r - l] == s[r]
            r += 1
          end
          z[i] = r - l
          r -= 1
        end
      end
    end
    z
  end
  def self.z_algorithm_search(text, pattern)
    concatenated = pattern + "$" + text
    z = calculate_z_array(concatenated)
    results = []
    z.each_with_index do |value, i|
      results << i - pattern.length - 1 if value == pattern.length
    end
    results
  end
  # Define the pattern you are searching for
  pattern = "Category:"
  # Read the document
  text = File.read('new_prods.txt')
  # Run the Z-Algorithm
  matches = z_algorithm_search(text, pattern)
  # Open a file to write the results
  File.open('zoutput.txt', 'w') do |file|
    lines = text.split("\n")
    matches.each do |match|
      line_number = lines[0...match].join("\n").count("\n") + 1
      file.puts "Match found at line #{line_number}: #{lines[line_number - 1]}"
    end
  end
end

=begin
# main.rb
# require_relative 'zalgo' # Make sure 'zalgo.rb' is in the same directory

# Use the Zalgo class to perform operations
pattern = "$"
text = File.read('new_prods.txt')

matches = Zalgo.z_algorithm_search(text, pattern)

File.open('zoutput.txt', 'w') do |file|
  lines = text.split("\n")
  matches.each do |match|
    line_number = lines[0...match].join("\n").count("\n") + 1
    file.puts "Match found at line #{line_number}: #{lines[line_number - 1]}"
  end
end
=end
