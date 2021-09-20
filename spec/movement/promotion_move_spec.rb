require './lib/board'

describe PromotionMove do
  let(:figure1) { Figure.new(:bishop, :white) }
  let(:figure2) { Figure.new(:queen, :white) }
  let(:point_start) { Coordinate.new(0, 0) }
  let(:point_end) { Coordinate.new(2, 1) }
  subject(:promotion_move) { described_class.new(figure1, point_start, point_end, figure2) }
  describe '#to_s' do
    it 'should return right string' do
      expect(promotion_move.to_s).to eql('move bishop from a1 to c2, then promotion to queen')
    end
  end
  describe '#special?' do
    it 'should be' do
      expect(promotion_move.special?).to be_truthy
    end
  end
  describe '#algebraic_notation' do
    it 'should return right string' do
      expect(promotion_move.algebraic_notation).to eql('c2=Q')
    end
  end
end
