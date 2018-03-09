module Ralyxa
  module ResponseEntities
    module Directives
      module Audio
        class AudioItem
          def initialize(stream)
            @stream = stream
          end

          def to_h
            {}.tap do |audio_item|
              audio_item['stream'] = @stream.to_h
            end
          end

          def self.as_hash(stream)
            new(stream).to_h
          end
        end
      end
    end
  end
end
