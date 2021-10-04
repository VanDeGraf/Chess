require './lib/board'

describe PromotionMove do
  subject(:promotion_move) { described_class.new(figure1, point_start, point_end, figure2) }

  let(:figure1) { Figure.new(:bishop, :white) }
  let(:figure2) { Figure.new(:queen, :white) }
  let(:point_start) { Coordinate.new(0, 0) }
  let(:point_end) { Coordinate.new(2, 1) }

  describe '#to_s' do
    it 'returns right string' do
      expect(promotion_move.to_s).to eql('move bishop from a1 to c2, then promotion to queen')
    end
  end

  describe '#algebraic_notation' do
    it 'returns right string' do
      expect(promotion_move.algebraic_notation).to eql('c2=Q')
    end
  end
end
