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
end
