require './lib/board'

describe Move do
  let(:figure1) { Figure.new(:bishop, :white) }
  let(:point_start) { Coordinate.new(0, 0) }
  let(:point_end) { Coordinate.new(2, 1) }
  subject(:move) { described_class.new(figure1, point_start, point_end) }
  describe '#to_s' do
    it 'should return right string' do
      expect(move.to_s).to eql("move #{figure1} from #{point_start} to #{point_end}")
    end
  end
  describe '#special?' do
    it 'should not be' do
      expect(move.special?).to be_falsey
    end
  end
  describe '#algebraic_notation' do
    context 'when file=false and rank=false' do
      it 'should return right string' do
        expect(move.algebraic_notation(file: false, rank: false)).to eql('Bc2')
      end
    end
    context 'when file=true and rank=false' do
      it 'should return right string' do
        expect(move.algebraic_notation(file: true, rank: false)).to eql('Bac2')
      end
    end
    context 'when file=false and rank=true' do
      it 'should return right string' do
        expect(move.algebraic_notation(file: false, rank: true)).to eql('B1c2')
      end
    end
    context 'when file=true and rank=true' do
      it 'should return right string' do
        expect(move.algebraic_notation(file: true, rank: true)).to eql('Ba1c2')
      end
    end
  end
end
