require './lib/board'

describe Capture do
  let(:figure1) { Figure.new(:bishop, :white) }
  let(:figure2) { Figure.new(:pawn, :black) }
  let(:point_start) { Coordinate.new(0, 0) }
  let(:point_end) { Coordinate.new(2, 1) }
  subject(:capture_movement) { described_class.new(figure1, point_start, point_end, figure2) }
  describe '#to_s' do
    it 'should return right string' do
      expect(capture_movement.to_s).to eql("move #{figure1} from #{point_start} and capture #{figure2} at #{point_end}")
    end
  end
  describe '#special?' do
    it 'should not be' do
      expect(capture_movement.special?).to be_falsey
    end
  end
  describe '#algebraic_notation' do
    context 'when file=false and rank=false' do
      it 'should return right string' do
        expect(capture_movement.algebraic_notation(file: false, rank: false)).to eql('Bxc2')
      end
    end
    context 'when file=true and rank=false' do
      it 'should return right string' do
        expect(capture_movement.algebraic_notation(file: true, rank: false)).to eql('Baxc2')
      end
    end
    context 'when file=false and rank=true' do
      it 'should return right string' do
        expect(capture_movement.algebraic_notation(file: false, rank: true)).to eql('B1xc2')
      end
    end
    context 'when file=true and rank=true' do
      it 'should return right string' do
        expect(capture_movement.algebraic_notation(file: true, rank: true)).to eql('Ba1xc2')
      end
    end
  end
end
