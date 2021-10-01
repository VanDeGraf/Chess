require './lib/board'

describe EnPassant do
  subject(:en_passant) { described_class.new(figure1, point_start, point_end, figure2, point_capture) }

  let(:figure1) { Figure.new(:pawn, :black) }
  let(:figure2) { Figure.new(:pawn, :white) }
  let(:point_start) { Coordinate.new(1, 3) }
  let(:point_end) { Coordinate.new(0, 2) }
  let(:point_capture) { Coordinate.new(0, 3) }

  describe '#to_s' do
    it 'returns right string' do
      expect(en_passant.to_s).to eql('en passant from b4 to a3')
    end
  end

  describe '#special?' do
    it 'is' do
      expect(en_passant).to be_special
    end
  end

  describe '#algebraic_notation' do
    it 'returns right string' do
      expect(en_passant.algebraic_notation).to eql('bxa3')
    end
  end
end
