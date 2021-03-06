require './lib/board'

describe BoardState do
  let(:board) { Board.new }

  describe '#shah?' do
    context 'when on board king and enemy queen near' do
      it 'returns true' do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at!(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at!(Coordinate.new(1, 1), Figure.new(:queen, :black))
        expect(board.state).to be_shah(:white)
      end
    end

    context 'when on board king and enemy pawn near' do
      it 'returns false' do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at!(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at!(Coordinate.new(0, 1), Figure.new(:pawn, :black))
        expect(board.state).not_to be_shah(:white)
      end
    end
    # TODO: more edges
  end

  describe '#mate?' do
    context 'when on board king and enemy queen near' do
      it 'returns false' do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at!(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at!(Coordinate.new(1, 1), Figure.new(:queen, :black))
        expect(board.state).not_to be_mate(:white)
      end
    end

    context 'when on board king and 2 enemy queen near' do
      it 'returns true' do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at!(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at!(Coordinate.new(0, 1), Figure.new(:queen, :black))
        board.replace_at!(Coordinate.new(1, 0), Figure.new(:queen, :black))
        expect(board.state).to be_mate(:white)
      end
    end
    # TODO: more edges
  end

  describe '#stalemate?' do
    let(:color) { :white }

    it 'calculate possible_moves' do
      allow(board).to receive(:possible_moves).and_return([])
      board.state.stalemate?(color)
      expect(board).to have_received(:possible_moves).at_least(:once)
    end

    context 'possible_moves exist' do
      before do
        allow(board).to receive(:possible_moves).and_return([nil,nil])
      end

      it 'return false' do
        expect(board.state).not_to be_stalemate(color)
      end
    end

    context 'possible_moves not exist' do
      before do
        allow(board).to receive(:possible_moves).and_return([])
      end

      context 'on shah' do
        it 'return false' do
          allow(board.state).to receive(:shah?).and_return(true)
          expect(board.state).not_to be_stalemate(color)
        end
      end

      context 'not on shah' do
        it 'return true' do
          allow(board.state).to receive(:shah?).and_return(false)
          expect(board.state).to be_stalemate(color)
        end
      end
    end
  end

  describe '#draw?' do
    let(:color) { :white }

    before do
      allow(board.state).to receive(:stalemate?).and_return(false)
      allow(board.state).to receive(:deadmate?).and_return(false)
      allow(board.state).to receive(:n_move?).and_return(false)
      allow(board.repetition_log).to receive(:n_fold_repetition?).and_return(false)
    end

    it 'check stalemate' do
      board.state.draw?(color)
      expect(board.state).to have_received(:stalemate?).once
    end

    it 'check deadmate' do
      board.state.draw?(color)
      expect(board.state).to have_received(:deadmate?).once
    end

    it 'check n_move' do
      board.state.draw?(color)
      expect(board.state).to have_received(:n_move?).once
    end

    it 'check n_fold_repetition?' do
      board.state.draw?(color)
      expect(board.repetition_log).to have_received(:n_fold_repetition?).once
    end

    context 'all checks false' do
      it 'return false' do
        expect(board.state).not_to be_draw(color)
      end
    end
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

      it 'returns true' do
        expect(board.state).to be_deadmate
      end

      context 'and white knight' do
        it 'returns true' do
          board.replace_at!(Coordinate.new(1, 0), Figure.new(:knight, :white))
          expect(board.state).to be_deadmate
        end
      end

      context 'and white bishop' do
        before do
          board.replace_at!(Coordinate.new(1, 0), Figure.new(:bishop, :white))
        end

        it 'returns true' do
          expect(board.state).to be_deadmate
        end

        context 'and black bishop on same diagonal' do
          it 'returns true' do
            board.replace_at!(Coordinate.new(2, 1), Figure.new(:bishop, :black))
            expect(board.state).to be_deadmate
          end
        end

        context 'and black bishop on different diagonal' do
          it 'returns false' do
            board.replace_at!(Coordinate.new(1, 1), Figure.new(:bishop, :black))
            expect(board.state).not_to be_deadmate
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
        expect(board.state).to be_deadmate
      end
    end
  end

  describe '#n_move?' do
    context 'when n is 5' do
      context 'when history length < 5' do
        it 'returns false' do
          expect(board.state).not_to be_n_move(5)
        end
      end

      context 'when last history has capture' do
        it 'returns false' do
          history = Array.new(5, Move.new(Figure.new(:king, :white), nil, nil))
          history << Capture.new(Figure.new(:pawn, :white), nil, nil, nil)
          board.instance_variable_set(:@history, history)
          expect(board.state).not_to be_n_move(5)
        end
      end

      context 'when last history has pawn move' do
        it 'returns false' do
          history = Array.new(5, Move.new(Figure.new(:king, :white), nil, nil))
          history << Move.new(Figure.new(:pawn, :white), nil, nil)
          board.instance_variable_set(:@history, history)
          expect(board.state).not_to be_n_move(5)
        end
      end

      context 'when last history has not pawn move or capture' do
        it 'returns true' do
          history = Array.new(5, Move.new(Figure.new(:king, :white), nil, nil))
          board.instance_variable_set(:@history, history)
          expect(board.state).to be_n_move(5)
        end
      end
    end
  end
end
