

class Compare
  def preprocess_file_content(file_path)
    content = File.read(file_path)
    case File.extname(file_path)
    when '.json'
      JSON.pretty_generate(JSON.parse(content))
    else
      content
    end.split(/\n/)
  end
  # Generate the diff and format it
  def pretty_diff(file_path1, file_path2)
    file1_content = preprocess_file_content(file_path1)
    file2_content = preprocess_file_content(file_path2)
    diffs = Diff::LCS.diff(file1_content, file2_content)
    pretty_output = ""
    file_length_difference = 0
    diffs.each_with_index do |piece, index|
      hunk = Diff::LCS::Hunk.new(file1_content, file2_content, piece, 3, 3)
      file_length_difference = hunk.file_length_difference
      pretty_output << "\n" if index != 0
      pretty_output << hunk.diff(:unified)
    end
    pretty_output
  end
  # Compare two directories
  def compare_directories(dir1, dir2, output_dir)
    # Create output directory if it doesn't exist
    FileUtils.mkdir_p(output_dir)
    # Get a list of all files in both directories
    dir1_files = Dir.glob(File.join(dir1, '**', '*')).select { |f| File.file?(f) }
    dir2_files = Dir.glob(File.join(dir2, '**', '*')).select { |f| File.file?(f) }
    # Normalize the file paths for comparison
    dir1_files.map! { |f| f.sub("#{dir1}/", '') }
    dir2_files.map! { |f| f.sub("#{dir2}/", '') }
    # All unique file names for comparison
    all_files = (dir1_files + dir2_files).uniq
    all_files.each do |file|
      file1 = File.join(dir1, file)
      file2 = File.join(dir2, file)
      if File.exist?(file1) && File.exist?(file2)
        # Both files exist, compare them
        diff_output = pretty_diff(file1, file2)
        unless diff_output.strip.empty?
          output_path = File.join(output_dir, file)
          FileUtils.mkdir_p(File.dirname(output_path))
          File.write(output_path, diff_output)
        end
      else
        # TODO
        # Handle the case where the file does not exist in one of the directories
        # For sake of time when building, this module does not output anything for these cases
        # could easily log these cases or handle them as needed
      end
    end
  end
  # Main execution
  #   if ARGV.length != 3
  #     puts "Usage: #{$0} directory_1 directory_2 output_directory"
  #     exit
  #   end
  #   dir1, dir2, output_dir = ARGV
  #   compare_directories(dir1, dir2, output_dir)
  #   puts "Comparisons complete. Check the output directory for differences."
end
