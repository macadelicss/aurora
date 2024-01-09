# frozen_string_literal: true

require 'mini_magick'
require 'mini_magick/image'

class ImageEditor
  def initialize(main_image_path, background_image_path)
    @main_image = MiniMagick::Image.open(main_image_path)
    @background_image = MiniMagick::Image.open(background_image_path)
  end
  def change_background(output_path)
    @main_image.resize "#{@background_image[:width]}x#{@background_image[:height]}"
    result = @background_image.composite(@main_image) do |composite|
      composite.compose 'Over'
      composite.geometry '+0+0'
    end
    result.write(output_path)
  end
end
