require './lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#shah?' do
    context 'when on board king and enemy queen near' do
      it 'should return true' do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at!(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at!(Coordinate.new(1, 1), Figure.new(:queen, :black))
        expect(board.shah?(:white)).to be_truthy
      end
    end
    context 'when on board king and enemy pawn near' do
      it 'should return false' do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at!(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at!(Coordinate.new(0, 1), Figure.new(:pawn, :black))
        expect(board.shah?(:white)).to be_falsey
      end
    end
    # TODO: more edges
  end
  describe '#mate?' do
    context 'when on board king and enemy queen near' do
      it 'should return false' do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at!(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at!(Coordinate.new(1, 1), Figure.new(:queen, :black))
        expect(board.mate?(:white)).to be_falsey
      end
    end
    context 'when on board king and 2 enemy queen near' do
      it 'should return true' do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at!(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at!(Coordinate.new(0, 1), Figure.new(:queen, :black))
        board.replace_at!(Coordinate.new(1, 0), Figure.new(:queen, :black))
        expect(board.mate?(:white)).to be_truthy
      end
    end
    # TODO: more edges
  end
  describe '#stalemate?' do
    # TODO
  end
  describe '#deadmate?' do
    # TODO
  end
  describe '#threefold_repetition?' do
    # TODO
  end
  describe '#fivefold_repetition?' do
    # TODO
  end
end
