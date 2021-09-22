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
    before do
      board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
    end
    context 'when on board white king, black king' do
      before do
        board.replace_at!(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at!(Coordinate.new(0, 7), Figure.new(:king, :black))
      end
      it 'should return true' do
        expect(board.deadmate?).to be_truthy
      end
      context 'and white knight' do
        it 'should return true' do
          board.replace_at!(Coordinate.new(1, 0), Figure.new(:knight, :white))
          expect(board.deadmate?).to be_truthy
        end
      end
      context 'and white bishop' do
        before do
          board.replace_at!(Coordinate.new(1, 0), Figure.new(:bishop, :white))
        end
        it 'should return true' do
          expect(board.deadmate?).to be_truthy
        end
        context 'and black bishop on same diagonal' do
          it 'should return true' do
            board.replace_at!(Coordinate.new(2, 1), Figure.new(:bishop, :black))
            expect(board.deadmate?).to be_truthy
          end
        end
        context 'and black bishop on different diagonal' do
          it 'should return false' do
            board.replace_at!(Coordinate.new(1, 1), Figure.new(:bishop, :black))
            expect(board.deadmate?).to be_falsey
          end
        end
      end
    end
    context 'when example deadmate with kings, bishops, and pawns on board' do
      xit 'should return true' do
        board.instance_variable_set(:@board, [
                                      Array.new(8, nil),
                                      Array.new(8, nil),
                                      [nil, Figure.new(:pawn, :white), nil, Figure.new(:bishop, :white),
                                       Figure.new(:king, :white), nil, nil, nil],
                                      [Figure.new(:pawn, :white), Figure.new(:pawn, :black), Figure.new(:pawn, :white), nil,
                                       Figure.new(:pawn, :white), nil, Figure.new(:pawn, :white), nil],
                                      [Figure.new(:pawn, :black), nil, Figure.new(:pawn, :black), nil, Figure.new(:pawn, :black), nil,
                                       Figure.new(:pawn, :black), Figure.new(:pawn, :white)],
                                      [nil, nil, nil, nil, nil, nil, nil, Figure.new(:pawn, :black)],
                                      [nil, nil, Figure.new(:bishop, :black), nil, Figure.new(:king, :black), nil, nil,
                                       nil],
                                      Array.new(8, nil)
                                    ])
        expect(board.deadmate?).to be_truthy
      end
    end
  end
  describe '#n_fold_repetition?' do
    # TODO
  end
  describe '#n_move?' do
    context 'when n is 5' do
      context 'when history length < 5' do
        it 'should return false' do
          expect(board.n_move?(5)).to be_falsey
        end
      end
      context 'when last history has capture' do
        it 'should return false' do
          history = Array.new(5, Move.new(Figure.new(:king, :white),nil, nil))
          history << Capture.new(Figure.new(:pawn, :white),nil,nil,nil)
          board.instance_variable_set(:@history, history)
          expect(board.n_move?(5)).to be_falsey
        end
      end
      context 'when last history has pawn move' do
        it 'should return false' do
          history = Array.new(5, Move.new(Figure.new(:king, :white),nil, nil))
          history << Move.new(Figure.new(:pawn, :white), nil,nil)
          board.instance_variable_set(:@history, history)
          expect(board.n_move?(5)).to be_falsey
        end
      end
      context 'when last history has not pawn move or capture' do
        it 'should return true' do
          history = Array.new(5, Move.new(Figure.new(:king, :white),nil, nil))
          board.instance_variable_set(:@history, history)
          expect(board.n_move?(5)).to be_truthy
        end
      end
    end
  end
end
