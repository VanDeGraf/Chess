require './lib/board'

describe Castling do
  let(:short_castling) { described_class.new(nil,nil,nil,nil,nil,nil,true) }
  let(:long_castling) { described_class.new(nil,nil,nil,nil,nil,nil,false) }
  describe '#to_s' do
    it 'should return right string' do
      expect(short_castling.to_s).to eql('castling short')
      expect(long_castling.to_s).to eql('castling long')
    end
  end
  describe '#special?' do
    it 'should be' do
      expect(short_castling.special?).to be_truthy
    end
  end
  describe '#algebraic_notation' do
    it 'should return right string' do
      expect(short_castling.algebraic_notation).to eql('O-O')
      expect(long_castling.algebraic_notation).to eql('O-O-O')
    end
  end
end
