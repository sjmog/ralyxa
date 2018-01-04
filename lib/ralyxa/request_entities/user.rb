module Ralyxa
  module RequestEntities
    class User
      attr_reader :id, :access_token

      def initialize(id:, access_token: nil)
        @id = id
        @access_token = access_token
      end

      def self.build(request)
        new(
          id: request.dig('session', 'user', 'userId'),
          access_token: request.dig('session', 'user', 'accessToken')
        )
      end

      def access_token_exists?
        !@access_token.nil?
      end
    end
  end
end
