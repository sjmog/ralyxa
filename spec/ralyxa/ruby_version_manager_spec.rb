require "spec_helper"

RSpec.describe Ralyxa::RubyVersionManager do

    let(:response_builder)      { Ralyxa::ResponseBuilder }
    let(:request)               { double(:request) }
    let(:handler)               { Ralyxa::Handler.new(request) }

    describe '#manage_ruby_version_for' do
        it "handle separation of positional and keyword arguments based on current ruby version" do 
            expect(response_builder.ancestors).to include(described_class)
            expect(handler).to respond_to(:manage_ruby_version_for)
        end
    end
    
end