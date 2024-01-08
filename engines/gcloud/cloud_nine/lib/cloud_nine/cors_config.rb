# frozen_string_literal: true
require "google/cloud/storage"
module CORSConfig
  class Config
    def cors_configuration(bucket_name:
                             # the id of you gcs bucket
                             # bucket_name = "your-unique-bucket-name"
                             # require 'google/cloud/storage'
                             #
                             storage = Google::Cloud::Storage.new)
      bucket = storage.bucket bucket_name
      bucket.cors do |c|
        c.add_rule ["*"],
                   %w[PUT POST],
                   headers: %w[Content-Type x-goog-resumable],
                   max_age: 3600
      end
      puts "Set CORS policies for bucket #{bucket_name}"
    end

    def get_bucket_metadata(bucket_name:
                              # The ID of your GCS bucket
                              # bucket_name = "your-unique-bucket-name"

                              storage = Google::Cloud::Storage.new)
      bucket = storage.bucket bucket_name

      puts "ID:                       #{bucket.id}"
      puts "Name:                     #{bucket.name}"
      puts "Storage Class:            #{bucket.storage_class}"
      puts "Location:                 #{bucket.location}"
      puts "Location Type:            #{bucket.location_type}"
      puts "Cors:                     #{bucket.cors}"
      puts "Default Event Based Hold: #{bucket.default_event_based_hold?}"
      puts "Default KMS Key Name:     #{bucket.default_kms_key}"
      puts "Logging Bucket:           #{bucket.logging_bucket}"
      puts "Logging Prefix:            #{bucket.logging_prefix}"
      puts "Metageneration:           #{bucket.metageneration}"
      puts "Retention Effective Time: #{bucket.retention_effective_at}"
      puts "Retention Period:         #{bucket.retention_period}"
      puts "Retention Policy Locked:  #{bucket.retention_policy_locked?}"
      puts "Requester Pays:           #{bucket.requester_pays}"
      puts "Self Link:                #{bucket.api_url}"
      puts "Time Created:             #{bucket.created_at}"
      puts "Versioning Enabled:       #{bucket.versioning?}"
      puts "Index Page:               #{bucket.website_main}"
      puts "Not Found Page:           #{bucket.website_404}"
      puts "Labels:"
      bucket.labels.each do |key, value|
        puts " - #{key} = #{value}"
      end
      puts "Lifecycle Rules:"
      bucket.lifecycle.each do |rule|
        puts "#{rule.action} - #{rule.storage_class} - #{rule.age} - #{rule.matches_storage_class}"
      end
    end

  end
end
