require_relative '../errors'

module Ralyxa
  module ResponseEntities
    class Card
      LINK_ACCOUNT_CARD_TYPE = "LinkAccount"
      SIMPLE_CARD_TYPE       = "Simple"
      STANDARD_CARD_TYPE     = "Standard"

      def initialize(options)
        @options = options
      end

      def self.as_hash(title, body, image_url = nil)
        new(title: title, body: body, image_url: image_url).to_h
      end

      def self.link_account
        new(link_account: true).to_h
      end

      def to_h
        Hash.new.tap do |card|
          set_type(card)
          set_title(card) if @options[:title]
          set_body(card)  if @options[:body]
          set_image(card) if @options[:image_url]
        end
      end

      private

      def set_type(card)
        return card[:type] = LINK_ACCOUNT_CARD_TYPE if link_account?
        card[:type]        = SIMPLE_CARD_TYPE       if simple?
        card[:type]        = STANDARD_CARD_TYPE     if standard?
      end

      def set_title(card)
        card[:title] = @options[:title]
      end

      def set_body(card)
        card[:content] = @options[:body] if simple?
        card[:text]    = @options[:body] if standard?
      end

      def set_image(card)
        raise UnsecureUrlError.new("Card images must be available at an SSL-enabled (HTTPS) endpoint. Your current image url is: #{ @options[:image_url] }") unless secure?
        card[:image] = Hash.new
        card[:image][:smallImageUrl] = @options[:image_url]
        card[:image][:largeImageUrl] = @options[:image_url]
      end

      def link_account?
        !!@options[:link_account]
      end

      def simple?
        !@options[:image_url]
      end

      def standard?
        !!@options[:image_url]
      end

      def secure?
        URI.parse(@options[:image_url]).scheme == "https"
      end
    end
  end
end