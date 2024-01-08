require 'csv'

class CsvUpdater
  def self.update_csv(input_csv_path, output_csv_path)
    # Read the CSV file into an array of arrays
    data = CSV.read(input_csv_path)
    # Define the range of rows to update
    start_row = 1  # Start at row 2 (index 1)
    end_row = 178  # End at row 179 (index 178)
    # Update specified rows
    (start_row..end_row).each do |row|
      # Ensure the row exists
      data[row] ||= []
      # Update specific columns
      data[row][3]  = "Thnk"       # Column D
      data[row][8]  = "Title"      # Column I
      data[row][7]  = "FALSE"      # Column H
      data[row][16] = "shopify"    # Column Q
      data[row][18] = "deny"       # Column S
      data[row][19] = "manual"     # Column T
      data[row][22] = "TRUE"       # Column W
      data[row][23] = "TRUE"       # Column X
      data[row][28] = "FALSE"      # Column AC
      data[row][45] = "g"          # Column AT
      data[row][51] = "draft"      # Column AY
    end
    # Write the updated data back to a new CSV file
    CSV.open(output_csv_path, 'w') do |csv|
      data.each do |row|
        csv << row
      end
    end
  end
end
# Usage
input_csv_path = 'output.csv'  # Replace with your input CSV file path
output_csv_path = 'output1.csv'  # Replace with your output CSV file path
CsvUpdater.update_csv(input_csv_path, output_csv_path)

# IDEA
# use this current set up here to write the data all at once to the specified columns/lines
# have a separate file adjust this one as needed..? but how would the other one know...?
