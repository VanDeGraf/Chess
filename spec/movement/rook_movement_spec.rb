require './lib/board'

describe RookMovement do
  describe '#generate_moves' do
    let(:board) { Board.new }

    context 'when board is empty' do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end

      let(:figure) { Figure.new(:rook, :white) }
      let(:enemy_figure) { Figure.new(:pawn, :black) }
      let(:ally_figure) { Figure.new(:pawn, :white) }

      context 'when figure stay at 2,2' do
        subject(:generator) { described_class.new(figure, figure_coordinate, board) }

        let(:figure_coordinate) { Coordinate.new(2, 2) }

        before do
          board.replace_at!(figure_coordinate, figure)
        end

        it 'adds 14 moves' do
          expect(generator.generate_moves.length).to be 14
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

        context 'and enemy figure stay at 1,2' do
          before do
            board.replace_at!(Coordinate.new(1, 2), enemy_figure)
          end

          it 'adds 13 moves' do
            expect(generator.generate_moves.length).to be 13
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

          it 'adds 12 moves' do
            expect(generator.generate_moves.length).to be 12
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
