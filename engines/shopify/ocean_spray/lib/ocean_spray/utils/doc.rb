require 'fileutils'

# Define the base directory and output file
base_directory = '/Users/macadelic/Projects/etherngin-main/etherngin/app' # Replace with the path to your base directory
output_file = 'app2.md'

puts "Starting to process files in #{base_directory}"

# Open the output file
File.open(output_file, 'w') do |file|
  # Recursively find all files in the base directory and its subdirectories
  Dir.glob("#{base_directory}/**/*").each do |file_path|
    # Skip if the entry is not a file
    next unless File.file?(file_path)

    puts "Adding file to document: #{file_path}"
    # Write the file path to the Markdown file
    file.puts "## #{file_path.sub(base_directory + '/', '')}\n\n"  # Relative path

    # Determine the language or format of the file
    language = case File.basename(file_path)
               when 'Gemfile', 'Rakefile', 'rails', 'rake', 'setup' then 'ruby'
               when 'Dockerfile' then 'docker'
               when /\.rb$/ then 'ruby'
               when /\.erb$/ then 'erb'
               when /\.js$/ then 'javascript'
               when /\.css$/ then 'css'
               when /\.html$/ then 'html'
               when /\.rake$/ then 'ruby'
               when /\.yml$/ then 'yaml'
               when /\.gemspec$/ then 'ruby'
               when /\.ru$/ then 'ruby'
               else ''
               end

    # Start the code block if a language is identified
    file.puts "```#{language}\n" unless language.empty?

    # Write the file content
    file_content = File.read(file_path)
    file.puts file_content

    # End the code block if a language is identified
    file.puts "\n```" unless language.empty?

    file.puts "\n---\n\n"
  end
end

puts "Finished processing. Document saved to #{output_file}"
