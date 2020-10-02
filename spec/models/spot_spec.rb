require 'spec_helper'

RSpec.describe Spot do
  describe '#band' do
    it 'converts a 20M frequency to 20' do
      expect(described_class.new(frequency: 14075793).band).to eq 20
    end

    it 'converts a 40M frequency to 20' do
      expect(described_class.new(frequency: 7076331).band).to eq 40
    end
  end
end
