module Ralyxa
  module ResponseEntities
    module Directives
      class AudioPlayer
        class Stop
          def to_h
            {}.tap do |audio_player|
              audio_player['type'] = 'AudioPlayer.Stop'
            end
          end

          def self.as_hash
            new.to_h
          end
        end
      end
    end
  end
end
