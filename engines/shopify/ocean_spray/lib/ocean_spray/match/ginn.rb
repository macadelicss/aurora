require 'csv'
require 'amatch'
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
      if closest_match != original_category
        puts "#{original_category} => #{closest_match}"
      end
    end
  end
  private
  def find_closest_match(category)
    matcher = Amatch::PairDistance.new(category)
    closest = @categories.min_by { |cat| matcher.match(cat) }
    closest || category
  end
end
csv_path = 'added_products.csv'  
category_path = 'categories.txt'  
ginn = Ginn.new(csv_path, category_path)
ginn.check_and_print_matches