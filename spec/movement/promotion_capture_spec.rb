require './lib/board'

describe PromotionCapture do
  subject(:capture_movement) { described_class.new(figure1, point_start, point_end, captured, promoted_to) }

  let(:figure1) { Figure.new(:bishop, :white) }
  let(:captured) { Figure.new(:pawn, :black) }
  let(:point_start) { Coordinate.new(0, 0) }
  let(:point_end) { Coordinate.new(2, 1) }
  let(:promoted_to) { Figure.new(:queen, :white) }

  describe '#to_s' do
    it 'returns right string' do
      expect(capture_movement.to_s).to eql('move bishop from a1 and capture pawn at c2, then promotion to queen')
    end
  end

  describe '#special?' do
    it 'is' do
      expect(capture_movement).to be_special
    end
  end

  describe '#algebraic_notation' do
    context 'when file=false and rank=false' do
      it 'returns right string' do
        expect(capture_movement.algebraic_notation(file: false, rank: false)).to eql('Bxc2=Q')
      end
    end

    context 'when file=true and rank=false' do
      it 'returns right string' do
        expect(capture_movement.algebraic_notation(file: true, rank: false)).to eql('Baxc2=Q')
      end
    end

    context 'when file=false and rank=true' do
      it 'returns right string' do
        expect(capture_movement.algebraic_notation(file: false, rank: true)).to eql('B1xc2=Q')
      end
    end

    context 'when file=true and rank=true' do
      it 'returns right string' do
        expect(capture_movement.algebraic_notation(file: true, rank: true)).to eql('Ba1xc2=Q')
      end
    end
  end

  describe '#from_capture' do
    subject(:capture) do
      Capture.new(Figure.new(:pawn, :white),
                  Coordinate.new(0, 0),
                  Coordinate.new(1, 0),
                  Figure.new(:pawn, :black))
    end

    let(:board) { Board.new }

    it 'return array of 4 new PromotionMove instances' do
      expect(described_class.from_capture(capture).length).to be 4
    end

    it 'return instances with same start figure' do
      expect(described_class.from_capture(capture)[0].figure).to be_equal(capture.figure)
    end

    it 'return instances with same point_start' do
      expect(described_class.from_capture(capture)[0].point_start).to be_equal(capture.point_start)
    end

    it 'return instances with same point_end' do
      expect(described_class.from_capture(capture)[0].point_end).to be_equal(capture.point_end)
    end

    it 'return instances with same captured figure' do
      expect(described_class.from_capture(capture)[0].captured).to be_equal(capture.captured)
    end

    it 'return instances with same color of new figure' do
      expect(described_class.from_capture(capture)[0].promoted_to.color).to be_equal(capture.figure.color)
    end
  end

  describe '#perform_movement' do
    subject(:promotion_capture) do
      described_class.new(Figure.new(:pawn, :white),
                          point_start, point_end,
                          Figure.new(:bishop, :black),
                          promoted_to)
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
      promotion_capture.perform_movement(board)
      expect(board).to have_received(:remove_at!).with(point_start)
    end

    it 'set new figure on new position' do
      promotion_capture.perform_movement(board)
      expect(board).to have_received(:replace_at!).with(point_end, promoted_to)
    end
  end
end
