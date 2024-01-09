# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'uri'


module DownloadImages
  class Download
    def self.download_from_file(file_path)
      Dir.mkdir('ruby_download') unless Dir.exist?('ruby_download')

      File.foreach(file_path) do |url|
        url.strip!
        next if url.empty?
        download_images_from_url(url)
      end
    end

    private

    def self.download_images_from_url(url)
      begin
        doc = Nokogiri::HTML(URI.open(url))
        doc.css('img').each do |img|
          img_url = URI.join(url, img['src']).to_s
          File.open("ruby_download/#{File.basename(img_url)}", 'wb') do |f|
            f.write URI.open(img_url).read
          end
        end
      rescue => e
        puts "Error processing #{url}: #{e.message}"
      end
    end
  end
end


file_path = '.txt'  # Make sure this is the correct path to your text file
DownloadImages::Download.download_from_file(file_path)

