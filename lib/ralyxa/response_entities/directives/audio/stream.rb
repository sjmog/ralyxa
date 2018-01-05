module Ralyxa
  module ResponseEntities
    module Directives
      module Audio
        class Stream
          def initialize(url, token, offset_in_milliseconds = 0, expected_previous_token = nil)
            raise Ralyxa::UnsecureUrlError, "Audio streams must be served from at an SSL-enabled (HTTPS) endpoint. Your current stream url is: #{url}" unless secure?(url)

            @url                     = url
            @token                   = token
            @offset_in_milliseconds  = offset_in_milliseconds
            @expected_previous_token = expected_previous_token
          end

          def to_h
            {}.tap do |stream|
              stream['url']                   = @url
              stream['token']                 = @token
              stream['offsetInMilliseconds']  = @offset_in_milliseconds
              stream['expectedPreviousToken'] = @expected_previous_token if @expected_previous_token
            end
          end

          def self.as_hash(url, token, offset_in_milliseconds = 0, expected_previous_token = nil)
            new(url, token, offset_in_milliseconds, expected_previous_token).to_h
          end

          private

          def secure?(url)
            URI.parse(url).scheme == 'https' || !Ralyxa.require_secure_urls?
          end
        end
      end
    end
  end
end
