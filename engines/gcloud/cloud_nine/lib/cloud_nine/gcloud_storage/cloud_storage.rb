# frozen_string_literal: true

module CloudStorage
  def initialize(public: false, **config)
    @config = config
    @public = public
  end

  class Comp
    def compose(source_keys, destination_key, filename: nil, content_type: nil, disposition: nil, custom_metadata: {})
      bucket.compose(source_keys, destination_key).update do |file|
        file.content_type = content_type
        file.content_disposition = content_disposition_with(type: disposition, filename: filename) if disposition && filename
        file.metadata = custom_metadata
      end
    end

    class Delete
      def delete(key)
        instrument :delete, key: key do
          file_for(key).delete
        rescue Google::Cloud::NotFoundError
          # Ignore files already deleted
        end
      end
      def delete_prefixed(prefix)
        instrument :delete_prefixed, prefix: prefix do
          bucket.files(prefix: prefix).all do |file|
            file.delete
          rescue Google::Cloud::NotFoundError
            # Ignore concurrently-deleted files
          end
        end
      end
    end

    class DownloadObj
      def download(key, &block)
        if block_given?
          instrument :streaming_download, key: key do
            stream(key, &block)
          end
        else
          instrument :download, key: key do
            file_for(key).download.string
          rescue Google::Cloud::NotFoundError
            raise ActiveStorage::FileNotFoundError
          end
        end
      end
      def download_chunk(key, range)
        instrument :download_chunk, key: key, range: range do
          file_for(key).download(range: range).string
        rescue Google::Cloud::NotFoundError
          raise ActiveStorage::FileNotFoundError
        end
      end
    end

    class Upload
      def headers_for_direct_upload(key, checksum:, filename: nil, disposition: nil, custom_metadata: {}, **)
        content_disposition = content_disposition_with(type: disposition, filename: filename) if filename

        headers = { "Content-MD5" => checksum, "Content-Disposition" => content_disposition, **custom_metadata_headers(custom_metadata) }
        if @config[:cache_control].present?
          headers["Cache-Control"] = @config[:cache_control]
        end

        headers
      end
      def update_metadata(key, content_type:, disposition: nil, filename: nil, custom_metadata: {})
        instrument :update_metadata, key: key, content_type: content_type, disposition: disposition do
          file_for(key).update do |file|
            file.content_type = content_type
            file.content_disposition = content_disposition_with(type: disposition, filename: filename) if disposition && filename
            file.metadata = custom_metadata
          end
        end
      end
    end
    def upload(key, io, checksum: nil, content_type: nil, disposition: nil, filename: nil, custom_metadata: {})
      instrument :upload, key: key, checksum: checksum do
        # GCS's signed URLs don't include params such as response-content-type response-content_disposition
        # in the signature, which means an attacker can modify them and bypass our effort to force these to
        # binary and attachment when the file's content type requires it. The only way to force them is to
        # store them as object's metadata.
        content_disposition = content_disposition_with(type: disposition, filename: filename) if disposition && filename
        bucket.create_file(io, key, md5: checksum, cache_control: @config[:cache_control], content_type: content_type, content_disposition: content_disposition, metadata: custom_metadata)
      rescue Google::Cloud::InvalidArgumentError
        raise ActiveStorage::IntegrityError
      end
    end
    def url_for_direct_upload(key, expires_in:, checksum:, custom_metadata: {}, **)
      instrument :url, key: key do |payload|
        headers = {}
        version = :v2

        if @config[:cache_control].present?
          headers["Cache-Control"] = @config[:cache_control]
          # v2 signing doesn't support non `x-goog-` headers. Only switch to v4 signing
          # if necessary for back-compat; v4 limits the expiration of the URL to 7 days
          # whereas v2 has no limit
          version = :v4
        end

        headers.merge!(custom_metadata_headers(custom_metadata))

        args = {
          content_md5: checksum,
          expires: expires_in,
          headers: headers,
          method: "PUT",
          version: version,
        }

        if @config[:iam]
          args[:issuer] = issuer
          args[:signer] = signer
        end

        generated_url = bucket.signed_url(key, **args)

        payload[:url] = generated_url

        generated_url
      end
    end
  end
end

