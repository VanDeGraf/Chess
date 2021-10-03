require './lib/board'

describe QueenMovement do
  describe '#generate_moves' do
    let(:board) { Board.new }

    context 'when board is empty' do
      let(:figure) { Figure.new(:queen, :white) }
      let(:enemy_figure) { Figure.new(:pawn, :black) }
      let(:ally_figure) { Figure.new(:pawn, :white) }

      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end

      context 'when figure stay at 2,2' do
        subject(:generator) { described_class.new(figure, figure_coordinate, board) }

        let(:figure_coordinate) { Coordinate.new(2, 2) }

        before do
          board.replace_at!(figure_coordinate, figure)
        end

        it 'adds 25 moves' do
          expect(generator.generate_moves.length).to be 25
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

        it 'adds move with coordinate 1,2 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(1, 2)
          end
        end

        it 'adds move with coordinate 0,2 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(0, 2)
          end
        end

        it 'adds move with coordinate 2,1 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(2, 1)
          end
        end

        it 'adds move with coordinate 2,0 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(2, 0)
          end
        end

        it 'adds move with coordinate 3,2 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(3, 2)
          end
        end

        it 'adds move with coordinate 7,2 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(7, 2)
          end
        end

        context 'and enemy figure stay at 1,1' do
          before do
            board.replace_at!(Coordinate.new(1, 1), enemy_figure)
          end

          it 'adds 24 moves' do
            expect(generator.generate_moves.length).to be 24
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

          it 'adds 23 moves' do
            expect(generator.generate_moves.length).to be 23
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

        context 'and enemy figure stay at 1,2' do
          before do
            board.replace_at!(Coordinate.new(1, 2), enemy_figure)
          end

          it 'adds 24 moves' do
            expect(generator.generate_moves.length).to be 24
          end

          it 'adds move with coordinate 1,2 and kind :capture' do
            expect(generator.generate_moves).to be_any do |move|
              move.is_a?(Capture) &&
                move.point_end == Coordinate.new(1, 2)
            end
          end

          it 'does not add move with coordinate 0,2' do
            expect(generator.generate_moves).not_to be_any do |move|
              move.point_end == Coordinate.new(0, 2)
            end
          end
        end

        context 'and ally figure stay at 1,2' do
          before do
            board.replace_at!(Coordinate.new(1, 2), ally_figure)
          end

          it 'adds 23 moves' do
            expect(generator.generate_moves.length).to be 23
          end

          it 'does not add move with coordinate 1,2' do
            expect(generator.generate_moves).not_to be_any do |move|
              move.point_end == Coordinate.new(1, 2)
            end
          end

          it 'does not add move with coordinate 0,2' do
            expect(generator.generate_moves).not_to be_any do |move|
              move.point_end == Coordinate.new(0, 2)
            end
          end
        end
      end
    end
  end
end
