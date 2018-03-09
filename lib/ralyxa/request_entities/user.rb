module Ralyxa
  module RequestEntities
    class User
      attr_reader :id, :access_token

      def initialize(id:, access_token: nil)
        @id = id
        @access_token = access_token
      end

      def self.build(request)
        user_hash = request.dig('session', 'user') || request.dig('context', 'System', 'user') || {}

        new(
          id: user_hash['userId'],
          access_token: user_hash['accessToken']
        )
      end

      def access_token_exists?
        !@access_token.nil?
      end
    end
  end
end
