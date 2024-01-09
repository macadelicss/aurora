# frozen_string_literal: true

# frozen_string_literal: true
require 'fileutils'
module Rename


  # Renames image files in the specified directory
  # @param [String] dir_path the path to the directory containing the images
  def self.rename_images(dir_path)
    # Define the types of image files you want to rename
    image_extensions = %w[.jpg .jpeg .png .gif .bmp .tiff .webp]

    # Check if the directory exists
    unless Dir.exist?(dir_path)
      puts "Directory not found: #{dir_path}"
      return
    end

    # Iterate over each file in the directory
    Dir.foreach(dir_path) do |filename|
      next if File.directory?(filename) # Skip if it's a directory

      # Check if the file is an image
      if image_extensions.include?(File.extname(filename).downcase)
        new_name = filename.gsub(/\s+|[^a-zA-Z0-9.]/, '_') # Replace spaces and non-alphanumeric characters with underscores
        new_name = new_name.downcase # Optional: make the file name lowercase

        # Rename the file
        FileUtils.mv(File.join(dir_path, filename), File.join(dir_path, new_name))
        puts "Renamed #{filename} to #{new_name}"
      end
    end
  end
end

# Example usage
Rename.rename_images('/Users/macadelic/Downloads/REVISED_New_items')

