require './lib/coordinate'

describe Coordinate do
  describe '#to_s' do
    context 'when coordinate is 0,0' do
      it 'should return a1' do
        expect(Coordinate.new(0, 0).to_s).to eq('a1')
      end
    end
    context 'when coordinate is 1,1' do
      it 'should return b2' do
        expect(Coordinate.new(1, 1).to_s).to eq('b2')
      end
    end
    context 'when coordinate is 7,1' do
      it 'should return h2' do
        expect(Coordinate.new(7, 1).to_s).to eq('h2')
      end
    end
  end

  describe '#relative' do
    context 'when this coordinate 1,1 and x,y is 2,2' do
      it 'should return new instance' do
        point = Coordinate.new(1, 1)
        expect(point.relative(2, 2)).to_not be point
      end

      it 'should return with coordinate 3,3' do
        point = Coordinate.new(1, 1)
        expect(point.relative(2, 2).x).to be 3
        expect(point.relative(2, 2).y).to be 3
      end
    end
    context 'when this coordinate 5,5 and x,y is -1,-2' do
      it 'should return with coordinate 4,3' do
        point = Coordinate.new(5, 5)
        expect(point.relative(-1, -2).x).to be 4
        expect(point.relative(-1, -2).y).to be 3
      end
    end
  end
  describe '.from_s' do
    context 'when string is a1' do
      it 'should return new instance' do
        expect(Coordinate.from_s('a1')).to be_a(Coordinate)
      end
      it 'should return with coordinate 0,0' do
        coordinate = Coordinate.from_s('a1')
        expect(coordinate.x).to be 0
        expect(coordinate.y).to be 0
      end
    end
    context 'when string is h2' do
      it 'should return with coordinate 7,1' do
        coordinate = Coordinate.from_s('h2')
        expect(coordinate.x).to be 7
        expect(coordinate.y).to be 1
      end
    end
  end
end
