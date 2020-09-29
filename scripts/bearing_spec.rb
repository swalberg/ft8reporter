require 'rspec'
require './psreporter'

RSpec.describe 'bearing', '#bearing' do
  it 'figures out due south' do
    b = bearing(60, 5, 30, 5)
    expect(b).to eq 180
  end
end
