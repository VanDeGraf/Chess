require './lib/possible_moves'
require './lib/board'
require './lib/figure'
require './lib/coordinate'
require './lib/move'

describe PossibleMoves do
  let(:board) { Board.new }
  let(:figure) { Figure.new(:pawn, :white) }

  describe '#pawn_moves' do
    context 'when board is empty' do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end
      context 'when white pawn stay on board alone at coordinate 1,1' do
        let(:figure) { Figure.new(:pawn, :white) }
        let(:figure_coordinate) { Coordinate.new(1, 1) }
        before do
          board.replace_at!(figure_coordinate, figure)
        end
        it 'should add 2 moves' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 2
        end
        it 'should add move with coordinate 1,2 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 2)
              end).to be_truthy
        end
        it 'should add move with coordinate 1,3 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 3)
              end).to be_truthy
        end
        context 'and enemy stay at 2,2' do
          before do
            board.replace_at!(Coordinate.new(2, 2), Figure.new(:pawn, :black))
          end
          it 'should add 3 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 3
          end
          it 'should add move with coordinate 2,2 and kind :capture' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.kind == :capture &&
                      move.options[:point_end] == Coordinate.new(2, 2)
                end).to be_truthy
          end
        end
        context 'and enemy stay at 1,3' do
          before do
            board.replace_at!(Coordinate.new(1, 3), Figure.new(:pawn, :black))
          end
          it 'should add 1 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 1
          end

          it 'should add move with coordinate 1,2 and kind :move' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.kind == :move &&
                      move.options[:point_end] == Coordinate.new(1, 2)
                end).to be_truthy
          end
        end
        context 'and enemy stay at 1,2' do
          before do
            board.replace_at!(Coordinate.new(1, 2), Figure.new(:pawn, :black))
          end
          it 'should add 0 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 0
          end
        end
      end
      context 'when black pawn stay on board alone at coordinate 1,6' do
        let(:figure) { Figure.new(:pawn, :black) }
        let(:figure_coordinate) { Coordinate.new(1, 6) }
        before do
          board.replace_at!(figure_coordinate, figure)
        end
        it 'should add 2 moves' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 2
        end
        it 'should add move with coordinate 1,5 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 5)
              end).to be_truthy
        end
        it 'should add move with coordinate 1,4 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 4)
              end).to be_truthy
        end
        context 'and enemy stay at 2,5' do
          before do
            board.replace_at!(Coordinate.new(2, 5), Figure.new(:pawn, :white))
          end
          it 'should add 3 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 3
          end
          it 'should add move with coordinate 2,5 and kind :capture' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.kind == :capture &&
                      move.options[:point_end] == Coordinate.new(2, 5)
                end).to be_truthy
          end
        end
        context 'and enemy stay at 1,4' do
          before do
            board.replace_at!(Coordinate.new(1, 4), Figure.new(:pawn, :white))
          end
          it 'should add 1 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 1
          end

          it 'should add move with coordinate 1,5 and kind :move' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.kind == :move &&
                      move.options[:point_end] == Coordinate.new(1, 5)
                end).to be_truthy
          end
        end
        context 'and enemy stay at 1,5' do
          before do
            board.replace_at!(Coordinate.new(1, 5), Figure.new(:pawn, :white))
          end
          it 'should add 0 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 0
          end
        end
      end
    end
  end
  describe '#knight_moves' do
    context 'when board is empty' do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end
      let(:figure) { Figure.new(:knight, :white) }
      let(:enemy_figure) { Figure.new(:pawn, :black) }
      let(:ally_figure) { Figure.new(:pawn, :white) }
      context 'when figure stay at 2,2' do
        let(:figure_coordinate) { Coordinate.new(2, 2) }
        before do
          board.replace_at!(figure_coordinate, figure)
        end
        it 'should add 8 moves' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 8
        end
        it 'should add move with coordinate 1,4 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 4)
              end).to be_truthy
        end
        it 'should add move with coordinate 3,4 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(3, 4)
              end).to be_truthy
        end
        it 'should add move with coordinate 4,3 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(4, 3)
              end).to be_truthy
        end
        it 'should add move with coordinate 4,1 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(4, 1)
              end).to be_truthy
        end
        it 'should add move with coordinate 3,0 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(3, 0)
              end).to be_truthy
        end
        it 'should add move with coordinate 1,0 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 0)
              end).to be_truthy
        end
        it 'should add move with coordinate 0,1 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(0, 1)
              end).to be_truthy
        end
        it 'should add move with coordinate 0,3 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(0, 3)
              end).to be_truthy
        end
        context 'and enemy figure stay at 1,4' do
          before do
            board.replace_at!(Coordinate.new(1, 4), enemy_figure)
          end
          it 'should add 8 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 8
          end
          it 'should add move with coordinate 1,4 and kind :capture' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.kind == :capture &&
                      move.options[:point_end] == Coordinate.new(1, 4)
                end).to be_truthy
          end
        end
        context 'and ally figure stay at 1,4' do
          before do
            board.replace_at!(Coordinate.new(1, 4), ally_figure)
          end
          it 'should add 7 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 7
          end
          it 'should not add move with coordinate 1,4' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.options[:point_end] == Coordinate.new(1, 4)
                end).to be_falsey
          end
        end
      end
    end
  end
  describe '#king_moves' do
    context 'when board is empty' do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end
      let(:figure) { Figure.new(:king, :white) }
      let(:enemy_figure) { Figure.new(:pawn, :black) }
      let(:ally_figure) { Figure.new(:pawn, :white) }
      context 'when figure stay at 1,1' do
        let(:figure_coordinate) { Coordinate.new(1, 1) }
        before do
          board.replace_at!(figure_coordinate, figure)
        end
        it 'should add 8 moves' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 8
        end
        it 'should add move with coordinate 1,2 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 2)
              end).to be_truthy
        end
        it 'should add move with coordinate 2,2 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(2, 2)
              end).to be_truthy
        end
        it 'should add move with coordinate 2,1 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(2, 1)
              end).to be_truthy
        end
        it 'should add move with coordinate 2,0 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(2, 0)
              end).to be_truthy
        end
        it 'should add move with coordinate 1,0 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 0)
              end).to be_truthy
        end
        it 'should add move with coordinate 0,0 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(0, 0)
              end).to be_truthy
        end
        it 'should add move with coordinate 0,1 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(0, 1)
              end).to be_truthy
        end
        it 'should add move with coordinate 0,2 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(0, 2)
              end).to be_truthy
        end
        context 'and enemy figure stay at 1,2' do
          before do
            board.replace_at!(Coordinate.new(1, 2), enemy_figure)
          end
          it 'should add 8 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board, false).moves.length).to be 8
          end
          it 'should add move with coordinate 1,2 and kind :capture' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.kind == :capture &&
                      move.options[:point_end] == Coordinate.new(1, 2)
                end).to be_truthy
          end
        end
        context 'and ally figure stay at 1,2' do
          before do
            board.replace_at!(Coordinate.new(1, 2), ally_figure)
          end
          it 'should add 7 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 7
          end
          it 'should not add move with coordinate 1,2' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.options[:point_end] == Coordinate.new(1, 2)
                end).to be_falsey
          end
        end
      end
    end
    # TODO: more edges
  end
  describe '#bishop_moves' do
    context 'when board is empty' do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end
      let(:figure) { Figure.new(:bishop, :white) }
      let(:enemy_figure) { Figure.new(:pawn, :black) }
      let(:ally_figure) { Figure.new(:pawn, :white) }
      context 'when figure stay at 2,2' do
        let(:figure_coordinate) { Coordinate.new(2, 2) }
        before do
          board.replace_at!(figure_coordinate, figure)
        end
        it 'should add 11 moves' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 11
        end
        it 'should add move with coordinate 1,1 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 1)
              end).to be_truthy
        end
        it 'should add move with coordinate 0,0 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(0, 0)
              end).to be_truthy
        end
        it 'should add move with coordinate 1,3 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 3)
              end).to be_truthy
        end
        it 'should add move with coordinate 0,4 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(0, 4)
              end).to be_truthy
        end
        it 'should add move with coordinate 3,3 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(3, 3)
              end).to be_truthy
        end
        it 'should add move with coordinate 7,7 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(7, 7)
              end).to be_truthy
        end
        context 'and enemy figure stay at 1,1' do
          before do
            board.replace_at!(Coordinate.new(1, 1), enemy_figure)
          end
          it 'should add 10 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 10
          end
          it 'should add move with coordinate 1,1 and kind :capture' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.kind == :capture &&
                      move.options[:point_end] == Coordinate.new(1, 1)
                end).to be_truthy
          end
          it 'should not add move with coordinate 0,0' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.options[:point_end] == Coordinate.new(0, 0)
                end).to be_falsey
          end
        end
        context 'and ally figure stay at 1,1' do
          before do
            board.replace_at!(Coordinate.new(1, 1), ally_figure)
          end
          it 'should add 9 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 9
          end
          it 'should not add move with coordinate 1,1' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.options[:point_end] == Coordinate.new(1, 1)
                end).to be_falsey
          end
          it 'should not add move with coordinate 0,0' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.options[:point_end] == Coordinate.new(0, 0)
                end).to be_falsey
          end
        end
      end
    end
  end
  describe '#rook_moves' do
    context 'when board is empty' do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end
      let(:figure) { Figure.new(:rook, :white) }
      let(:enemy_figure) { Figure.new(:pawn, :black) }
      let(:ally_figure) { Figure.new(:pawn, :white) }
      context 'when figure stay at 2,2' do
        let(:figure_coordinate) { Coordinate.new(2, 2) }
        before do
          board.replace_at!(figure_coordinate, figure)
        end
        it 'should add 14 moves' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 14
        end
        it 'should add move with coordinate 1,2 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(1, 2)
              end).to be_truthy
        end
        it 'should add move with coordinate 0,2 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(0, 2)
              end).to be_truthy
        end
        it 'should add move with coordinate 2,1 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(2, 1)
              end).to be_truthy
        end
        it 'should add move with coordinate 2,0 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(2, 0)
              end).to be_truthy
        end
        it 'should add move with coordinate 3,2 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(3, 2)
              end).to be_truthy
        end
        it 'should add move with coordinate 7,2 and kind :move' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves
              .any? do |move|
                move.kind == :move &&
                    move.options[:point_end] == Coordinate.new(7, 2)
              end).to be_truthy
        end
        context 'and enemy figure stay at 1,2' do
          before do
            board.replace_at!(Coordinate.new(1, 2), enemy_figure)
          end
          it 'should add 13 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 13
          end
          it 'should add move with coordinate 1,2 and kind :capture' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.kind == :capture &&
                      move.options[:point_end] == Coordinate.new(1, 2)
                end).to be_truthy
          end
          it 'should not add move with coordinate 0,2' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.options[:point_end] == Coordinate.new(0, 2)
                end).to be_falsey
          end
        end
        context 'and ally figure stay at 1,2' do
          before do
            board.replace_at!(Coordinate.new(1, 2), ally_figure)
          end
          it 'should add 12 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves.length).to be 12
          end
          it 'should not add move with coordinate 1,2' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.options[:point_end] == Coordinate.new(1, 2)
                end).to be_falsey
          end
          it 'should not add move with coordinate 0,2' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves
                .any? do |move|
                  move.options[:point_end] == Coordinate.new(0, 2)
                end).to be_falsey
          end
        end
      end
    end
  end
  describe '#queen_moves' do
    let(:pm) do
      PossibleMoves.new(Figure.new(:pawn, :white),
                        Coordinate.new(0, 0), board, false)
    end
    before do
      allow(pm).to receive(:bishop_moves).and_return([])
      allow(pm).to receive(:rook_moves).and_return([])
    end
    it 'should call bishop_moves once' do
      expect(pm).to receive(:bishop_moves).once
      pm.queen_moves
    end
    it 'should call rook_moves once' do
      expect(pm).to receive(:rook_moves).once
      pm.queen_moves
    end
    it 'should return array' do
      expect(pm.queen_moves).to be_a(Array)
    end
  end
  describe '#build_moves' do
    let(:pm) do
      PossibleMoves.new(Figure.new(:pawn, :white),
                        Coordinate.new(1, 1), board, false)
    end
    before do
      allow(pm).to receive(:pawn_moves).and_return([])
      allow(pm).to receive(:knight_moves).and_return([])
      allow(pm).to receive(:king_moves).and_return([])
      allow(pm).to receive(:rook_moves).and_return([])
      allow(pm).to receive(:bishop_moves).and_return([])
      allow(pm).to receive(:queen_moves).and_return([])
      allow(board).to receive(:move).and_return(board)
      allow(board).to receive(:shah?).and_return(false)
    end
    context 'when check_shah true' do
      context 'and has moves' do
        before do
          allow(pm).to receive(:pawn_moves).and_return([Move.new(:test, {})])
        end
        it 'should call board shah?' do
          expect(board).to receive(:shah?)
          pm.build_moves(true)
        end
      end
      context 'and has not moves' do
        it 'should not call board shah?' do
          expect(board).to_not receive(:shah?)
          pm.build_moves(true)
        end
      end
    end
    context 'when check_shah false' do
      context 'and has moves' do
        before do
          allow(pm).to receive(:pawn_moves).and_return([Move.new(:test, {})])
        end
        it 'should not call board shah?' do
          expect(board).to_not receive(:shah?)
          pm.build_moves(false)
        end
      end
      context 'and has not moves' do
        it 'should not call board shah?' do
          expect(board).to_not receive(:shah?)
          pm.build_moves(false)
        end
      end
    end
    context 'when figure type is :pawn' do
      before { pm.instance_variable_get(:@figure).instance_variable_set(:@figure, :pawn) }
      it 'should call #pawn_moves' do
        expect(pm).to receive(:pawn_moves)
        pm.build_moves(true)
      end
    end
    context 'when figure type is :knight' do
      before { pm.instance_variable_get(:@figure).instance_variable_set(:@figure, :knight) }
      it 'should call #pawn_moves' do
        expect(pm).to receive(:knight_moves)
        pm.build_moves(true)
      end
    end
    context 'when figure type is :king' do
      before { pm.instance_variable_get(:@figure).instance_variable_set(:@figure, :king) }
      it 'should call #pawn_moves' do
        expect(pm).to receive(:king_moves)
        pm.build_moves(true)
      end
    end
    context 'when figure type is :bishop' do
      before { pm.instance_variable_get(:@figure).instance_variable_set(:@figure, :bishop) }
      it 'should call #pawn_moves' do
        expect(pm).to receive(:bishop_moves)
        pm.build_moves(true)
      end
    end
    context 'when figure type is :rook' do
      before { pm.instance_variable_get(:@figure).instance_variable_set(:@figure, :rook) }
      it 'should call #pawn_moves' do
        expect(pm).to receive(:rook_moves)
        pm.build_moves(true)
      end
    end
    context 'when figure type is :queen' do
      before { pm.instance_variable_get(:@figure).instance_variable_set(:@figure, :queen) }
      it 'should call #pawn_moves' do
        expect(pm).to receive(:queen_moves)
        pm.build_moves(true)
      end
    end
  end
  describe '.castling' do
    context 'when board is default' do
      it 'should return empty array' do
        expect(PossibleMoves.castling(board, :white)).to eql([])
      end
    end
    # TODO: more edges
  end
end
