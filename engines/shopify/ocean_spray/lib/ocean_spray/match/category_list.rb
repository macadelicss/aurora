
module CategoryList
    def self.load_categories(file_path)
      categories = []
      File.open(file_path, 'r').each_line do |line|
        categories << line.strip  # Add the category to the array, removing any trailing newline
      end
      categories
    end
  end
  