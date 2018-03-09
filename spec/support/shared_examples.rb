shared_examples 'a configuration option' do |option|
  it "allows #{option} to be configured" do
    configuration  = described_class.new
    boolean_method = "#{option.to_s}?".to_sym
    setter_method  = "#{option.to_s}=".to_sym

    expect(configuration.send(boolean_method)).to eq(true)

    configuration.send(setter_method, false)
    expect(configuration.send(boolean_method)).to eq(false)

    configuration.send(setter_method, 'foo')
    expect(configuration.send(boolean_method)).to eq('foo')
  end
end