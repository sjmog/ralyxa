require_relative '../errors'

module Ralyxa
  module ResponseEntities
    class Card
      LINK_ACCOUNT_CARD_TYPE = 'LinkAccount'.freeze
      SIMPLE_CARD_TYPE       = 'Simple'.freeze
      STANDARD_CARD_TYPE     = 'Standard'.freeze

      def initialize(options)
        @options = options
      end

      def self.as_hash(title, body, small_image_url = nil, large_image_url = small_image_url)
        new(title: title, body: body, small_image_url: small_image_url, large_image_url: large_image_url).to_h
      end

      def self.link_account
        new(link_account: true).to_h
      end

      def to_h
        {}.tap do |card|
          add_type(card)
          add_title(card) if @options[:title]
          add_body(card)  if @options[:body]
          add_image(card) if standard?
        end
      end

      private

      def add_type(card)
        return card[:type] = LINK_ACCOUNT_CARD_TYPE if link_account?
        card[:type]        = SIMPLE_CARD_TYPE       if simple?
        card[:type]        = STANDARD_CARD_TYPE     if standard?
      end

      def add_title(card)
        card[:title] = @options[:title]
      end

      def add_body(card)
        card[:content] = @options[:body] if simple?
        card[:text]    = @options[:body] if standard?
      end

      def add_image(card)
        raise Ralyxa::UnsecureUrlError, "Card images must be available at an SSL-enabled (HTTPS) endpoint. Your current image urls are: (small: #{@options[:small_image_url]}, large: #{@options[:large_image_url]}" unless secure_images?
        card[:image] = {}

        small_image = @options[:small_image_url] || @options[:large_image_url]
        large_image = @options[:large_image_url] || @options[:small_image_url]

        card[:image][:smallImageUrl] = small_image if small_image
        card[:image][:largeImageUrl] = large_image if large_image
      end

      def link_account?
        !@options[:link_account].nil?
      end

      def simple?
        !@options[:small_image_url] && !@options[:large_image_url]
      end

      def standard?
        @options[:small_image_url] || @options[:large_image_url]
      end

      def secure_images?
        small_secure = secure_uri?(@options[:small_image_url])
        large_secure = secure_uri?(@options[:large_image_url])

        small_secure && large_secure
      end

      # Given a uri string, retutrn true if:
      #   * the scheme is https
      #   * or if we are not interested in the uri being secure
      #   * or if the value that has been passed is nil
      def secure_uri?(uri_string)
        return true if uri_string.nil?

        (URI.parse(uri_string).scheme == 'https' || !Ralyxa.require_secure_urls?)
      end
    end
  end
end
