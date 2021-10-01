require './lib/coordinate'

describe Coordinate do
  describe '#to_s' do
    context 'when coordinate is 0,0' do
      it 'returns a1' do
        expect(described_class.new(0, 0).to_s).to eq('a1')
      end
    end

    context 'when coordinate is 1,1' do
      it 'returns b2' do
        expect(described_class.new(1, 1).to_s).to eq('b2')
      end
    end

    context 'when coordinate is 7,1' do
      it 'returns h2' do
        expect(described_class.new(7, 1).to_s).to eq('h2')
      end
    end
  end

  describe '#relative' do
    context 'when this coordinate 1,1 and x,y is 2,2' do
      subject(:point) { described_class.new(1, 1) }

      it 'returns new instance' do
        expect(point.relative(2, 2)).not_to be point
      end

      it 'return x coordinate 3' do
        expect(point.relative(2, 2).x).to be 3
      end

      it 'return y coordinate 3' do
        expect(point.relative(2, 2).y).to be 3
      end
    end

    context 'when this coordinate 5,5 and x,y is -1,-2' do
      subject(:point) { described_class.new(5, 5) }

      it 'return x coordinate 4' do
        expect(point.relative(-1, -2).x).to be 4
      end

      it 'return y coordinate 3' do
        expect(point.relative(-1, -2).y).to be 3
      end
    end
  end

  describe '.from_s' do
    context 'when string is a1' do
      subject(:coordinate) { described_class.from_s('a1') }

      it 'returns new instance' do
        expect(coordinate).to be_a(described_class)
      end

      it 'returns x coordinate 0' do
        expect(coordinate.x).to be 0
      end

      it 'returns y coordinate 0' do
        expect(coordinate.y).to be 0
      end
    end

    context 'when string is h2' do
      subject(:coordinate) { described_class.from_s('h2') }

      it 'returns x coordinate 7' do
        expect(coordinate.x).to be 7
      end

      it 'returns y coordinate 1' do
        expect(coordinate.y).to be 1
      end
    end
  end
end
