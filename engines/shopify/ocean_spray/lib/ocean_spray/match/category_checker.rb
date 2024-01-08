# frozen_string_literal: true

require 'csv'
require 'difflib'
require_relative 'category_list'

class CategoryChecker

  def initialize(csv_path, category_path)
    @csv_path = csv_path
    @category_path = category_path
    CategoryList.load_categories(category_path)
  end
  def check_and_print_matches
    CSV.foreach(@csv_path, headers: true) do |row|
      original_category = row['Category']
      closest_match = find_closest_match(original_category)
      if closest_match != original_category
        puts "Original: #{original_category}, CLosest Match: #{closest_match}"
      end
    end
  end

  private

    def find_closest_match(category)
      closest = DiffLib.closest_match(category, @categories)
      closest ? closest.first : category
    end
end


# Usage:
require_relative 'category_checker'

csv_file_path = 'path_to.csv'
category_file_path = 'path_to.txt'
checker = CategoryChecker.new(csv_file_path, category_file_path)
checker.check_and_print_matches
