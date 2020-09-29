require 'rspec'
require './position'

RSpec.describe Position do
  let(:mygrid) { 'FM18JS' }
  let(:othergrid) { 'DO20xv66' }
  let(:other) { described_class.new(othergrid) }
  subject { described_class.new(mygrid) }

  context '#distance_to' do
    it 'figures the distance to itself' do
      other = described_class.new(mygrid)
      expect(subject.distance_to(other)).to eq 0
    end

    context 'a distant square' do
      it 'figures the distance' do
        expect(subject.distance_to(other)).to eq 3159
      end

      it 'works with the reciprocal' do
        expect(other.distance_to(subject)).to eq 3159
      end
    end

  end

  context '#bearing_to' do

    context 'east-west' do
      let(:othergrid) { 'GM18js' }
      it 'figures out due east' do
        expect(subject.bearing_to(other)).to eq 84
      end

      it 'figures out reciprocal' do
        expect(other.bearing_to(subject)).to eq 276
      end
    end

    context 'north-south' do
      let(:othergrid) { 'FL18js' }
      it 'figures out due south' do
        expect(subject.bearing_to(other)).to eq 180
      end

      it 'figures out reciprocal' do
        expect(other.bearing_to(subject)).to eq 0
      end
    end

    context 'somewhere else' do
      it 'figures out the way there' do
        expect(subject.bearing_to(other)).to eq 307
      end

      it 'figures out reciprocal' do
        expect(other.bearing_to(subject)).to eq 101
      end
    end
  end
end
