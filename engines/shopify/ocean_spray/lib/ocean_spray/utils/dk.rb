# frozen_string_literal: true

class Dk
  # Read txt file -> find body -> put body of each product into an array
  # append array to csv file

  require 'csv'

  i_f = 'rev_prod.txt'
  o_f = 'tmplate_copy.csv'
  # function to process the input file (i_f) and extracts the body (b) for each category (cat_i)
  def extract(i_f)
    content = File.read(i_f, encoding: 'UTF-8') # , encoding: 'UTF-8'
    # split the content by "$" to separate each product block
    pb = content.split('$')
    b = [] # extract the body for each product ("Body (HTML)")
    pb[0...-1].each do |block| # Exclude the last split as it's after the last "$"
      lines = block.strip.split("/n")
      cat_i = lines.index { |line| line.include?('Category: ') }
      if cat_i
        b_t = lines[cat_i + 1..-1].join("\n").strip  # grab all lines after "Category: " line and before the price line
        b << b_t
      end
    end
    b
  end
  # extract the body text for each product
  bodies = extract(i_f)
  # Specify the row index you want to append the data to
  # For example, append to the third row (index 2, since it's zero-based)
  r_i_append = 2
  # Read the entire CSV into memory (not efficient for very large CSV files)
  csv_data = CSV.read(o_f)
  if r_i_append >= csv_data.size
    csv_data[r_i_append] = Array.new([bodies.size, csv_data.first.size].max, "")
  end
  bodies.each_with_index do |body, index|
    csv_data[r_i_append][index] = body
  end
  CSV.open(o_f, 'w') do |csv|
    csv_data.each do |row|
      csv << row
    end
  end
  puts "body has been appended to row #{r_i_append} in #{o_f}"
end
