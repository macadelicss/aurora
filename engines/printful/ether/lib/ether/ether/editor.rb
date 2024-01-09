require 'fileutils'
require 'thread'

module Editor
    class Magic
        def work_it
            source_dir = 'source'
            resized_dir = 'resized'
            final_dir = 'final'
            background_image = 'resized_bg.jpg'
            # Ensure target directories exist
            FileUtils.mkdir_p(resized_dir) unless Dir.exist?(resized_dir)
            FileUtils.mkdir_p(final_dir) unless Dir.exist?(final_dir)
            # Get all image files from the source directory
            image_files = Dir.glob(File.join(source_dir, '*')).select { |f| File.file?(f) }
            # Define the number of concurrent threads
            thread_count = 8
            # Create a queue
            work_queue = Queue.new
            image_files.each { |file| work_queue.push(file) }
            def process_image(file, resized_dir, background_image, final_dir)
                resized_file = File.join(resized_dir, File.basename(file))
                final_file = File.join(final_dir, File.basename(file))
                # system("convert \"#{background_image}\" -resize 2000x2000 \"#{})
                # Resize and remove background
                system("convert \"#{file}\" -resize 1700x1700 \"#{resized_file}\"")
                system("magick \"#{resized_file}\" -alpha on \"#{resized_file}\"")
                # Composite with background
                system("composite -gravity center -colorspace sRGB \"#{resized_file}\" \"#{background_image}\" \"#{final_file}\"")
            end
            # Start threads
            workers = thread_count.times.map do
                Thread.new do
                    while !work_queue.empty? && ((file = work_queue.pop(true)) rescue nil)
                        process_image(file, resized_dir, background_image, final_dir)
                    end
                end
            end
            # Wait for all threads to finish
            workers.each(&:join)
            puts 'Processing complete.'
        end
    end
end
# Create an instance of the Magic class
image_processor = EditImages::Magic.new

# Call the work_it method to start processing images
image_processor.work_it
# module Editor
#     class Edit
#
#     end
# end
