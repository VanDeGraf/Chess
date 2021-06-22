require './lib/board'

context 'Queen possible moves' do
  let(:board) { Board.new }
  context 'when board is empty' do
    let(:figure) { Figure.new(:queen, :white) }
    let(:enemy_figure) { Figure.new(:pawn, :black) }
    let(:ally_figure) { Figure.new(:pawn, :white) }
    before do
      board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
    end
    context 'when figure stay at 2,2' do
      let(:figure_coordinate) { Coordinate.new(2, 2) }
      before do
        board.replace_at!(figure_coordinate, figure)
      end
      it 'should add 25 moves' do
        expect(MovementGenerator.generate_from(figure_coordinate, board).length).to be 25
      end
      it 'should add move with coordinate 1,1 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(1, 1)
               end).to be_truthy
      end
      it 'should add move with coordinate 0,0 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(0, 0)
               end).to be_truthy
      end
      it 'should add move with coordinate 1,3 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(1, 3)
               end).to be_truthy
      end
      it 'should add move with coordinate 0,4 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(0, 4)
               end).to be_truthy
      end
      it 'should add move with coordinate 3,3 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(3, 3)
               end).to be_truthy
      end
      it 'should add move with coordinate 7,7 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(7, 7)
               end).to be_truthy
      end
      it 'should add move with coordinate 1,2 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(1, 2)
               end).to be_truthy
      end
      it 'should add move with coordinate 0,2 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(0, 2)
               end).to be_truthy
      end
      it 'should add move with coordinate 2,1 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(2, 1)
               end).to be_truthy
      end
      it 'should add move with coordinate 2,0 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(2, 0)
               end).to be_truthy
      end
      it 'should add move with coordinate 3,2 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(3, 2)
               end).to be_truthy
      end
      it 'should add move with coordinate 7,2 and kind :move' do
        expect(MovementGenerator.generate_from(figure_coordinate, board)
                                .any? do |move|
                 move.kind == :move &&
                   move.options[:point_end] == Coordinate.new(7, 2)
               end).to be_truthy
      end
      context 'and enemy figure stay at 1,1' do
        before do
          board.replace_at!(Coordinate.new(1, 1), enemy_figure)
        end
        it 'should add 24 moves' do
          expect(MovementGenerator.generate_from(figure_coordinate, board).length).to be 24
        end
        it 'should add move with coordinate 1,1 and kind :capture' do
          expect(MovementGenerator.generate_from(figure_coordinate, board)
                                  .any? do |move|
                   move.kind == :capture &&
                     move.options[:point_end] == Coordinate.new(1, 1)
                 end).to be_truthy
        end
        it 'should not add move with coordinate 0,0' do
          expect(MovementGenerator.generate_from(figure_coordinate, board)
                                  .any? do |move|
                   move.options[:point_end] == Coordinate.new(0, 0)
                 end).to be_falsey
        end
      end
      context 'and ally figure stay at 1,1' do
        before do
          board.replace_at!(Coordinate.new(1, 1), ally_figure)
        end
        it 'should add 23 moves' do
          expect(MovementGenerator.generate_from(figure_coordinate, board).length).to be 23
        end
        it 'should not add move with coordinate 1,1' do
          expect(MovementGenerator.generate_from(figure_coordinate, board)
                                  .any? do |move|
                   move.options[:point_end] == Coordinate.new(1, 1)
                 end).to be_falsey
        end
        it 'should not add move with coordinate 0,0' do
          expect(MovementGenerator.generate_from(figure_coordinate, board)
                                  .any? do |move|
                   move.options[:point_end] == Coordinate.new(0, 0)
                 end).to be_falsey
        end
      end
      context 'and enemy figure stay at 1,2' do
        before do
          board.replace_at!(Coordinate.new(1, 2), enemy_figure)
        end
        it 'should add 24 moves' do
          expect(MovementGenerator.generate_from(figure_coordinate, board).length).to be 24
        end
        it 'should add move with coordinate 1,2 and kind :capture' do
          expect(MovementGenerator.generate_from(figure_coordinate, board)
                                  .any? do |move|
                   move.kind == :capture &&
                     move.options[:point_end] == Coordinate.new(1, 2)
                 end).to be_truthy
        end
        it 'should not add move with coordinate 0,2' do
          expect(MovementGenerator.generate_from(figure_coordinate, board)
                                  .any? do |move|
                   move.options[:point_end] == Coordinate.new(0, 2)
                 end).to be_falsey
        end
      end
      context 'and ally figure stay at 1,2' do
        before do
          board.replace_at!(Coordinate.new(1, 2), ally_figure)
        end
        it 'should add 23 moves' do
          expect(MovementGenerator.generate_from(figure_coordinate, board).length).to be 23
        end
        it 'should not add move with coordinate 1,2' do
          expect(MovementGenerator.generate_from(figure_coordinate, board)
                                  .any? do |move|
                   move.options[:point_end] == Coordinate.new(1, 2)
                 end).to be_falsey
        end
        it 'should not add move with coordinate 0,2' do
          expect(MovementGenerator.generate_from(figure_coordinate, board)
                                  .any? do |move|
                   move.options[:point_end] == Coordinate.new(0, 2)
                 end).to be_falsey
        end
      end
    end
  end
end
