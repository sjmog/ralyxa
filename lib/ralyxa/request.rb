require 'json'

module Ralyxa
  class Request
    INTENT_REQUEST_TYPE = "IntentRequest".freeze

    def initialize(original_request)
      @request = JSON.parse(original_request.body.read)
    end

    def intent_name
      return @request["request"]["type"] unless intent_request?
      @request["request"]["intent"]["name"]
    end

    def slot_value(slot_name)
      @request["request"]["intent"]["slots"][slot_name]["value"]
    end

    def new_session?
      @request["session"]["new"]
    end

    def session_attribute(attribute_name)
      @request["session"]["attributes"][attribute_name]
    end

    private

    def intent_request?
      @request["request"]["type"] == INTENT_REQUEST_TYPE
    end
  end
end