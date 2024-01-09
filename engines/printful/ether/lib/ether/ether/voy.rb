module Voy
    class Voyeur

    end
end


module MiniMagick
    extend ActiveSupport::Concern
    included do
        require "image_processing/mini_magick"
    end
    module ClassMethods
        def convert(format)
            process :convert => format
        end
        def resize_to_limit(width, height)
            process :resize_to_limit => [width, height]
        end
        def resize_to_fit(width, height)
            process :resize_to_fit => [width, height]
        end
        def resize_to_fill(width, height, gravity='Center')
            process :resize_to_fill => [width, height, gravity]
        end
        def resize_and_pad(width, height, background='transparent', gravity='Center')
            process :resize_and_pad => [width, height, background, gravity]
        end
    end

    class MiniM
        def try
            image = MiniMagick::Image.new('')
            image.path
            image.resize "5000x5000"
            image.format "png"
            image.write "output.png"
        end

        def try_again
            img_dir = ''
            Dir.glob("#{img_dir}/*").each do |img_path|
                image = MiniMagick::Image.open(img_path)
                image.combine_options do |c|
                    c.alpha 'remove'
                    c.background 'white'
                end
                image.write(img_path)
            end
            puts "Bg Removal completed"
        end

        def convert(format, page=nil, &block)
            minimagick!(block) do |builder|
                builder = builder.convert(format)
                builder = builder.loader(page: page) if page
                builder
            end
        end

        def resize_and_pad(width, height, background=:transparent, gravity='Center', combine_options:{} &block)
            width, height = resolve_dimensions(width, height)
            minimagick!(block) do |builder|
                builder.resize_and_pad(width, height, background:background, gravity:gravity).apply(combine_options)
            end
        end
    end
end

