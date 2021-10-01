require './lib/board'

describe KnightMovement do
  describe '#generate_moves' do
    let(:board) { Board.new }

    context 'when board is empty' do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end

      let(:figure) { Figure.new(:knight, :white) }
      let(:enemy_figure) { Figure.new(:pawn, :black) }
      let(:ally_figure) { Figure.new(:pawn, :white) }

      context 'when figure stay at 2,2' do
        subject(:generator) { described_class.new(figure, figure_coordinate, board) }

        let(:figure_coordinate) { Coordinate.new(2, 2) }

        before do
          board.replace_at!(figure_coordinate, figure)
        end

        it 'adds 8 moves' do
          expect(generator.generate_moves.length).to be 8
        end

        it 'adds move with coordinate 1,4 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(1, 4)
          end
        end

        it 'adds move with coordinate 3,4 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(3, 4)
          end
        end

        it 'adds move with coordinate 4,3 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(4, 3)
          end
        end

        it 'adds move with coordinate 4,1 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(4, 1)
          end
        end

        it 'adds move with coordinate 3,0 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(3, 0)
          end
        end

        it 'adds move with coordinate 1,0 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(1, 0)
          end
        end

        it 'adds move with coordinate 0,1 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(0, 1)
          end
        end

        it 'adds move with coordinate 0,3 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(0, 3)
          end
        end

        context 'and enemy figure stay at 1,4' do
          before do
            board.replace_at!(Coordinate.new(1, 4), enemy_figure)
          end

          it 'adds 8 moves' do
            expect(generator.generate_moves.length).to be 8
          end

          it 'adds move with coordinate 1,4 and kind :capture' do
            expect(generator.generate_moves).to be_any do |move|
              move.is_a?(Capture) &&
                move.point_end == Coordinate.new(1, 4)
            end
          end
        end

        context 'and ally figure stay at 1,4' do
          before do
            board.replace_at!(Coordinate.new(1, 4), ally_figure)
          end

          it 'adds 7 moves' do
            expect(generator.generate_moves.length).to be 7
          end

          it 'does not add move with coordinate 1,4' do
            expect(generator.generate_moves).not_to be_any do |move|
              move.point_end == Coordinate.new(1, 4)
            end
          end
        end
      end
    end
  end
end
