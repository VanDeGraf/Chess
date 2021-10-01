require './lib/board'

describe Castling do
  let(:short_castling) { described_class.new(nil, nil, nil, nil, nil, nil, true) }
  let(:long_castling) { described_class.new(nil, nil, nil, nil, nil, nil, false) }

  describe '#to_s' do
    it 'short_castling returns right string' do
      expect(short_castling.to_s).to eql('castling short')
    end

    it 'long_castling returns right string' do
      expect(long_castling.to_s).to eql('castling long')
    end
  end

  describe '#special?' do
    it 'is' do
      expect(short_castling).to be_special
    end
  end

  describe '#algebraic_notation' do
    it 'short_castling returns right string' do
      expect(short_castling.algebraic_notation).to eql('O-O')
    end

    it 'long_castling returns right string' do
      expect(long_castling.algebraic_notation).to eql('O-O-O')
    end
  end
end
