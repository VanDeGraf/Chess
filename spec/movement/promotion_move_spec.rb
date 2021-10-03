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

  describe '#special?' do
    it 'is' do
      expect(promotion_move).to be_special
    end
  end

  describe '#algebraic_notation' do
    it 'returns right string' do
      expect(promotion_move.algebraic_notation).to eql('c2=Q')
    end
  end

  describe '#perform_movement' do
    subject(:promotion_move) do
      described_class.new(Figure.new(:pawn, :white),
                          point_start, point_end, promoted_to)
    end

    let(:promoted_to) { Figure.new(:queen, :white) }
    let(:point_start) { Coordinate.new(0, 0) }
    let(:point_end) { Coordinate.new(1, 0) }

    let(:board) { Board.new }

    before do
      allow(board).to receive(:remove_at!)
      allow(board).to receive(:replace_at!)
    end

    it 'remove old figure from old position' do
      promotion_move.perform_movement(board)
      expect(board).to have_received(:remove_at!).with(point_start)
    end

    it 'set new figure on new position' do
      promotion_move.perform_movement(board)
      expect(board).to have_received(:replace_at!).with(point_end, promoted_to)
    end
  end

  describe '#from_move' do
    subject(:move) do
      Move.new(Figure.new(:pawn, :white),
               Coordinate.new(0, 0),
               Coordinate.new(1, 0))
    end

    let(:board) { Board.new }

    it 'return array of 4 new PromotionMove instances' do
      expect(described_class.from_move(move).length).to be 4
    end

    it 'return instances with same start figure' do
      expect(described_class.from_move(move)[0].figure).to be_equal(move.figure)
    end

    it 'return instances with same point_start' do
      expect(described_class.from_move(move)[0].point_start).to be_equal(move.point_start)
    end

    it 'return instances with same point_end' do
      expect(described_class.from_move(move)[0].point_end).to be_equal(move.point_end)
    end

    it 'return instances with same color of new figure' do
      expect(described_class.from_move(move)[0].promoted_to.color).to be_equal(move.figure.color)
    end
  end
end
