require './lib/board'

describe Movement do
  describe '#==' do
    context 'classes not equal' do
      it 'return false' do
        expect(Move.new(nil, nil, nil) ==
                 Capture.new(nil, nil, nil, nil)).to be_falsey
      end
    end

    context 'classes equal' do
      context 'has different values' do
        it 'return false' do
          expect(Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 0), Coordinate.new(1, 0)) ==
                   Move.new(Figure.new(:pawn, :black), Coordinate.new(0, 0), Coordinate.new(1, 0)))
            .to be_falsey
        end
      end

      context 'has all same values' do
        it 'return true' do
          expect(Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 0), Coordinate.new(1, 0)) ==
                   Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 0), Coordinate.new(1, 0)))
            .to be_truthy
        end
      end
    end
  end
end
