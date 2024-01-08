require 'csv'

# Function to change 'not stocked' to 1

module Refact
  def convert_not_stocked(row)
    # Columns M, N, O, P, Q correspond to indexes 12, 13, 14, 15, 16 respectively
    (12..16).each do |i|
      row[i] = '1' if row[i] == 'not stocked'
    end
  end

  # Reading the CSV file
  filename = 'test_inv.csv'
  modified_data = []

  CSV.foreach(filename, headers: true) do |row|
    convert_not_stocked(row)
    modified_data << row
  end

  # Writing the modified data to a new CSV file
  CSV.open('modified_test_inv.csv', 'w') do |csv|
    csv << modified_data.first.headers # Add headers
    modified_data.each { |row| csv << row }
  end
end

puts 'CSV file has been modified and saved as modified_test_inv.csv'
