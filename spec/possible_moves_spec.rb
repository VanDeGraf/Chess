require './lib/possible_moves'
require './lib/board'
require './lib/figure'
require './lib/coordinate'

describe PossibleMoves do
  let(:board) { Board.new }
  let(:figure) { Figure.new(:pawn, :white) }
  describe '#match?' do
    context 'when color = nil, beat = nil, beats = nil and moves length > 0' do
      it 'should return true' do
        possible_moves = PossibleMoves.new(figure, Coordinate.new(0, 0), board)
        possible_moves.instance_variable_set(:@moves_coordinates, [1, 2])
        expect(possible_moves.match?).to be_truthy
      end
    end
    context 'when color = nil, beat = nil, beats = nil and moves length == 0' do
      it 'should return true' do
        possible_moves = PossibleMoves.new(Figure.new(:pawn, :white), Coordinate.new(0, 0), board)
        possible_moves.instance_variable_set(:@moves_coordinates, [])
        expect(possible_moves.match?).to be_falsey
      end
    end
  end
  describe "#can_move?" do
    context 'when @start_coordinate not same as point_start' do
      it 'should return false' do
        possible_moves = PossibleMoves.new(figure, Coordinate.new(1, 1), board)
        expect(possible_moves.can_move?(Coordinate.new(2, 2), Coordinate.new(3, 3))).to be_falsey
      end
    end
    context 'when point_end not contains in @moves_coordinates' do
      it 'should return false' do
        possible_moves = PossibleMoves.new(figure, Coordinate.new(1, 1), board)
        expect(possible_moves.can_move?(Coordinate.new(1, 1), Coordinate.new(2, 2))).to be_falsey
      end
    end
    context 'when point_end contains in @moves_coordinates' do
      it 'should return true' do
        possible_moves = PossibleMoves.new(figure, Coordinate.new(1, 1), board)
        expect(possible_moves.can_move?(Coordinate.new(1, 1), Coordinate.new(1, 2))).to be_truthy
      end
    end
  end
  describe '#build_moves' do
    before do
      board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
    end
    context "when figure is white pawn" do
      let(:figure) { Figure.new(:pawn, :white) }
      context 'when figure stay at 1,1' do
        let(:figure_coordinate) { Coordinate.new(1, 1) }
        before do
          board.replace_at(figure_coordinate, figure)
        end
        it 'should add 2 moves' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 2
        end

        it 'should add move with coordinate 1,2' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.
              any? { |point| point.x == 1 && point.y == 2 }).to be_truthy
        end
        it 'should add move with coordinate 1,3' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.
              any? { |point| point.x == 1 && point.y == 3 }).to be_truthy
        end
        context 'and enemy stay at 2,2' do
          before do
            board.replace_at(Coordinate.new(2, 2), Figure.new(:pawn, :black))
          end
          it 'should add 3 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 3
          end
          it 'should add move with coordinate 2,2' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.
                any? { |point| point.x == 2 && point.y == 2 }).to be_truthy
          end
        end
        context 'and enemy stay at 1,3' do
          before do
            board.replace_at(Coordinate.new(1, 3), Figure.new(:pawn, :black))
          end
          it 'should add 1 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 1
          end

          it 'should add move with coordinate 1,2' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.
                any? { |point| point.x == 1 && point.y == 2 }).to be_truthy
          end
        end
        context 'and enemy stay at 1,2' do
          before do
            board.replace_at(Coordinate.new(1, 2), Figure.new(:pawn, :black))
          end
          it 'should add 0 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 0
          end
        end
      end
    end
    context "when figure is black pawn" do
      let(:figure) { Figure.new(:pawn, :black) }
      context 'when figure stay at 1,6' do
        let(:figure_coordinate) { Coordinate.new(1, 6) }
        before do
          board.replace_at(figure_coordinate, figure)
        end
        it 'should add 2 moves' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 2
        end

        it 'should add move with coordinate 1,5' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.
              any? { |point| point.x == 1 && point.y == 5 }).to be_truthy
        end
        it 'should add move with coordinate 1,4' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.
              any? { |point| point.x == 1 && point.y == 4 }).to be_truthy
        end
        context 'and enemy stay at 2,5' do
          before do
            board.replace_at(Coordinate.new(2, 5), Figure.new(:pawn, :white))
          end
          it 'should add 3 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 3
          end
          it 'should add move with coordinate 2,5' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.
                any? { |point| point.x == 2 && point.y == 5 }).to be_truthy
          end
        end
        context 'and enemy stay at 1,4' do
          before do
            board.replace_at(Coordinate.new(1, 4), Figure.new(:pawn, :black))
          end
          it 'should add 1 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 1
          end

          it 'should add move with coordinate 1,5' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.
                any? { |point| point.x == 1 && point.y == 5 }).to be_truthy
          end
        end
        context 'and enemy stay at 1,5' do
          before do
            board.replace_at(Coordinate.new(1, 5), Figure.new(:pawn, :black))
          end
          it 'should add 0 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 0
          end
        end
      end
    end
    context "when figure is knight" do
      let(:figure) { Figure.new(:knight, :white) }
      let(:enemy_figure) { Figure.new(:pawn, :black) }
      let(:ally_figure) { Figure.new(:pawn, :white) }
      context 'when figure stay at 2,2' do
        let(:figure_coordinate) { Coordinate.new(2, 2) }
        before do
          board.replace_at(figure_coordinate, figure)
        end
        it 'should add 8 moves' do
          expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 8
        end
        it 'should add move with coordinate 1,4' do
          expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
              any? { |point| point.x == 1 && point.y == 4 }).to be_truthy
        end
        it 'should add move with coordinate 3,4' do
          expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
              any? { |point| point.x == 3 && point.y == 4 }).to be_truthy
        end
        it 'should add move with coordinate 4,3' do
          expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
              any? { |point| point.x == 4 && point.y == 3 }).to be_truthy
        end
        it 'should add move with coordinate 4,1' do
          expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
              any? { |point| point.x == 4 && point.y == 1 }).to be_truthy
        end
        it 'should add move with coordinate 3,0' do
          expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
              any? { |point| point.x == 3 && point.y == 0 }).to be_truthy
        end
        it 'should add move with coordinate 1,0' do
          expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
              any? { |point| point.x == 1 && point.y == 0 }).to be_truthy
        end
        it 'should add move with coordinate 0,1' do
          expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
              any? { |point| point.x == 0 && point.y == 1 }).to be_truthy
        end
        it 'should add move with coordinate 0,3' do
          expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
              any? { |point| point.x == 0 && point.y == 3 }).to be_truthy
        end
        context 'and enemy figure stay at 1,4' do
          before do
            board.replace_at(Coordinate.new(1, 4), enemy_figure)
          end
          it 'should add 8 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 8
          end
          it 'should add move with coordinate 1,4' do
            expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
                any? { |point| point.x == 1 && point.y == 4 }).to be_truthy
          end
        end
        context 'and ally figure stay at 1,4' do
          before do
            board.replace_at(Coordinate.new(1, 4), ally_figure)
          end
          it 'should add 7 moves' do
            expect(PossibleMoves.new(figure, figure_coordinate, board).moves_coordinates.length).to be 7
          end
          it 'should not add move with coordinate 1,4' do
            expect(PossibleMoves.new(figure,figure_coordinate,board).moves_coordinates.
                any? { |point| point.x == 1 && point.y == 4 }).to be_falsey
          end
        end
      end
    end
  end
end