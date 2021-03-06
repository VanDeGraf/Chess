require './lib/board'

describe PawnMovement do
  describe '#generate_moves' do
    let(:board) { Board.new }

    context 'when board is empty' do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
      end

      context 'when white pawn stay on board at coordinate 1,1' do
        subject(:generator) { described_class.new(figure, figure_coordinate, board) }

        let(:figure) { Figure.new(:pawn, :white) }
        let(:figure_coordinate) { Coordinate.new(1, 1) }

        before do
          board.replace_at!(figure_coordinate, figure)
        end

        it 'adds 2 moves' do
          expect(generator.generate_moves.length).to be 2
        end

        it 'adds move with coordinate 1,2 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(1, 2)
          end
        end

        it 'adds move with coordinate 1,3 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(1, 3)
          end
        end

        context 'and enemy stay at 2,2' do
          before do
            board.replace_at!(Coordinate.new(2, 2), Figure.new(:pawn, :black))
          end

          it 'adds 3 moves' do
            expect(generator.generate_moves.length).to be 3
          end

          it 'adds move with coordinate 2,2 and kind :capture' do
            expect(generator.generate_moves).to be_any do |move|
              move.is_a?(Capture) &&
                move.point_end == Coordinate.new(2, 2)
            end
          end
        end

        context 'and enemy stay at 1,3' do
          before do
            board.replace_at!(Coordinate.new(1, 3), Figure.new(:pawn, :black))
          end

          it 'adds 1 moves' do
            expect(generator.generate_moves.length).to be 1
          end

          it 'adds move with coordinate 1,2 and kind :move' do
            expect(generator.generate_moves).to be_any do |move|
              move.is_a?(Move) &&
                move.point_end == Coordinate.new(1, 2)
            end
          end
        end

        context 'and enemy stay at 1,2' do
          before do
            board.replace_at!(Coordinate.new(1, 2), Figure.new(:pawn, :black))
          end

          it 'adds 0 moves' do
            expect(generator.generate_moves.length).to be 0
          end
        end
      end

      context 'when black pawn stay on board alone at coordinate 1,6' do
        subject(:generator) { described_class.new(figure, figure_coordinate, board) }

        let(:figure) { Figure.new(:pawn, :black) }
        let(:figure_coordinate) { Coordinate.new(1, 6) }

        before do
          board.replace_at!(figure_coordinate, figure)
        end

        it 'adds 2 moves' do
          expect(generator.generate_moves.length).to be 2
        end

        it 'adds move with coordinate 1,5 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(1, 5)
          end
        end

        it 'adds move with coordinate 1,4 and kind :move' do
          expect(generator.generate_moves).to be_any do |move|
            move.is_a?(Move) &&
              move.point_end == Coordinate.new(1, 4)
          end
        end

        context 'and enemy stay at 2,5' do
          before do
            board.replace_at!(Coordinate.new(2, 5), Figure.new(:pawn, :white))
          end

          it 'adds 3 moves' do
            expect(generator.generate_moves.length).to be 3
          end

          it 'adds move with coordinate 2,5 and kind :capture' do
            expect(generator.generate_moves).to be_any do |move|
              move.is_a?(Capture) &&
                move.point_end == Coordinate.new(2, 5)
            end
          end
        end

        context 'and enemy stay at 1,4' do
          before do
            board.replace_at!(Coordinate.new(1, 4), Figure.new(:pawn, :white))
          end

          it 'adds 1 moves' do
            expect(generator.generate_moves.length).to be 1
          end

          it 'adds move with coordinate 1,5 and kind :move' do
            expect(generator.generate_moves).to be_any do |move|
              move.is_a?(Move) &&
                move.point_end == Coordinate.new(1, 5)
            end
          end
        end

        context 'and enemy stay at 1,5' do
          before do
            board.replace_at!(Coordinate.new(1, 5), Figure.new(:pawn, :white))
          end

          it 'adds 0 moves' do
            expect(generator.generate_moves.length).to be 0
          end
        end
      end
      # TODO: en_passant, promotion
    end
  end
end
