module CSV
  class Check
    def check_em

    end
  end
end

=begin
# frozen_string_literal: true
require 'csv'
require 'diff-lcs'
require_relative 'category_list'
class Ginn
  def initialize(csv_path, category_path)
    @csv_path = csv_path
    @categories = CategoryList.load_categories(category_path)
  end
  def check_and_print_matches
    CSV.foreach(@csv_path, headers: true) do |row|
      original_category = row['Category']
      closest_match = find_closest_match(original_category)

    end
  end
end

=end
