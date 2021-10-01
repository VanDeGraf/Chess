require './lib/board'

describe BishopMovement do
  describe '#generate_moves' do
    let(:board) { Board.new }

    context 'when board is empty' do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end

      let(:figure) { Figure.new(:bishop, :white) }
      let(:enemy_figure) { Figure.new(:pawn, :black) }
      let(:ally_figure) { Figure.new(:pawn, :white) }

      context 'when figure stay at 2,2' do
        subject(:generator) { described_class.new(figure, figure_coordinate, board) }

        let(:figure_coordinate) { Coordinate.new(2, 2) }

        before do
          board.replace_at!(figure_coordinate, figure)
        end

        it 'adds 11 moves' do
          expect(generator.generate_moves.length).to be 11
        end

        it 'adds move with coordinate 1,1 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(1, 1)
          end
        end

        it 'adds move with coordinate 0,0 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(0, 0)
          end
        end

        it 'adds move with coordinate 1,3 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(1, 3)
          end
        end

        it 'adds move with coordinate 0,4 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(0, 4)
          end
        end

        it 'adds move with coordinate 3,3 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(3, 3)
          end
        end

        it 'adds move with coordinate 7,7 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(7, 7)
          end
        end

        context 'and enemy figure stay at 1,1' do
          before do
            board.replace_at!(Coordinate.new(1, 1), enemy_figure)
          end

          it 'adds 10 moves' do
            expect(generator.generate_moves.length).to be 10
          end

          it 'adds move with coordinate 1,1 and kind :capture' do
            expect(generator.generate_moves).to be_any do |move|
              move.is_a?(Capture) &&
                move.point_end == Coordinate.new(1, 1)
            end
          end

          it 'does not add move with coordinate 0,0' do
            expect(generator.generate_moves).not_to be_any do |move|
              move.point_end == Coordinate.new(0, 0)
            end
          end
        end

        context 'and ally figure stay at 1,1' do
          before do
            board.replace_at!(Coordinate.new(1, 1), ally_figure)
          end

          it 'adds 9 moves' do
            expect(generator.generate_moves.length).to be 9
          end

          it 'does not add move with coordinate 1,1' do
            expect(generator.generate_moves).not_to be_any do |move|
              move.point_end == Coordinate.new(1, 1)
            end
          end

          it 'does not add move with coordinate 0,0' do
            expect(generator.generate_moves).not_to be_any do |move|
              move.point_end == Coordinate.new(0, 0)
            end
          end
        end
      end
    end
  end
end
