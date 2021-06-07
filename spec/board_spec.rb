require './lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#remove_at' do
    context 'when there is figure' do
      let(:x) { 0 }
      let(:y) { 0 }
      it 'cell set nil value' do
        expect { board.remove_at!(Coordinate.new(x, y)) }.to change {
          board.instance_variable_get(:@board)[y][x]
        }.to(nil)
      end

      it 'return figure from cell' do
        figure = board.instance_variable_get(:@board)[y][x]
        expect(board.remove_at!(Coordinate.new(x, y))).to be figure
      end
    end

    context 'when coordinate out of board' do
      it 'return nil' do
        expect(board.remove_at!(Coordinate.new(-1, -1))).to be_nil
        expect(board.remove_at!(Coordinate.new(8, 8))).to be_nil
      end
    end
  end
  describe '#replace_at' do
    let(:figure) { Figure.new(:pawn, :white) }
    context 'when there is figure' do
      let(:x) { 0 }
      let(:y) { 0 }
      it 'cell set figure as value' do
        removed_figure = board.instance_variable_get(:@board)[y][x]
        expect { board.replace_at!(Coordinate.new(x, y), figure) }.to change {
          board.instance_variable_get(:@board)[y][x]
        }.from(removed_figure).to(figure)
      end

      it 'return replaced figure' do
        removed_figure = board.instance_variable_get(:@board)[y][x]
        expect(board.replace_at!(Coordinate.new(x, y), figure)).to be removed_figure
      end
    end
    context 'when there is empty' do
      let(:x) { 0 }
      let(:y) { 2 }
      it 'cell set figure as value' do
        expect { board.replace_at!(Coordinate.new(x, y), figure) }.to change {
          board.instance_variable_get(:@board)[y][x]
        }.from(nil).to(figure)
      end

      it 'return nil' do
        expect(board.replace_at!(Coordinate.new(x, y), figure)).to be_nil
      end
    end

    context 'when coordinate out of board' do
      it 'return nil' do
        expect(board.replace_at!(Coordinate.new(-1, -1), figure)).to be_nil
        expect(board.replace_at!(Coordinate.new(8, 8), figure)).to be_nil
      end
    end
    context 'when input figure is nil' do
      it 'return nil' do
        expect(board.replace_at!(Coordinate.new(1, 1), nil)).to be_nil
      end
    end
  end
  describe '#at' do
    context 'when coordinate out of board' do
      it 'return nil' do
        expect(board.at(Coordinate.new(-1, -1))).to be_nil
        expect(board.at(Coordinate.new(8, 8))).to be_nil
      end
    end
    context 'when there is figure' do
      it 'return figure' do
        expect(board.at(Coordinate.new(0, 0))).to be_a Figure
      end
    end
    context 'when there is empty' do
      it 'return nil' do
        expect(board.at(Coordinate.new(0, 2))).to be_nil
      end
    end
  end
  describe '#on_board?' do
    context 'when coordinate out of board' do
      it 'return false' do
        expect(board.on_board?(Coordinate.new(-1, -1))).to be false
        expect(board.on_board?(Coordinate.new(8, 8))).to be false
      end
    end
    context 'when coordinate on board' do
      it 'return true' do
        expect(board.on_board?(Coordinate.new(1, 1))).to be true
      end
    end
  end
  describe '#there_empty?' do
    it 'should return true at coordinate 0,2' do
      expect(board.there_empty?(Coordinate.new(0, 2))).to be_truthy
    end
    it 'should return false at coordinate 0,0' do
      expect(board.there_empty?(Coordinate.new(0, 0))).to be_falsey
    end
    it 'should return false at coordinate 9,9' do
      expect(board.there_empty?(Coordinate.new(9, 9))).to be_falsey
    end
    it 'should return false at coordinate -1,-1' do
      expect(board.there_empty?(Coordinate.new(-1, -1))).to be_falsey
    end
  end
  describe '#there_ally?' do
    context 'when color is white' do
      let(:color) { :white }
      it 'should return false at coordinate 0,2' do
        expect(board.there_ally?(color, Coordinate.new(0, 2))).to be_falsey
      end
      it 'should return true at coordinate 0,0' do
        expect(board.there_ally?(color, Coordinate.new(0, 0))).to be_truthy
      end
      it 'should return false at coordinate 0,7' do
        expect(board.there_ally?(color, Coordinate.new(0, 7))).to be_falsey
      end
      it 'should return false at coordinate 9,9' do
        expect(board.there_ally?(color, Coordinate.new(9, 9))).to be_falsey
      end
      it 'should return false at coordinate -1,-1' do
        expect(board.there_ally?(color, Coordinate.new(-1, -1))).to be_falsey
      end
    end
  end
  describe '#there_enemy?' do
    context 'when color is white' do
      let(:color) { :white }
      it 'should return false at coordinate 0,2' do
        expect(board.there_enemy?(color, Coordinate.new(0, 2))).to be_falsey
      end
      it 'should return false at coordinate 0,0' do
        expect(board.there_enemy?(color, Coordinate.new(0, 0))).to be_falsey
      end
      it 'should return true at coordinate 0,7' do
        expect(board.there_enemy?(color, Coordinate.new(0, 7))).to be_truthy
      end
      it 'should return false at coordinate 9,9' do
        expect(board.there_enemy?(color, Coordinate.new(9, 9))).to be_falsey
      end
      it 'should return false at coordinate -1,-1' do
        expect(board.there_enemy?(color, Coordinate.new(-1, -1))).to be_falsey
      end
    end
  end
  describe '#move!' do
    context 'when action move is nil' do
      it 'should not update history' do
        expect { board.move!(nil) }.to_not change { board.history.length }
      end
      it 'should not update history last move' do
        expect { board.move!(nil) }.to_not change { board.history.last }
      end
    end
    context 'when action not nil' do
      let(:move) do
        Move.new(:move, {
                   figure: board.at(Coordinate.new(0, 1)),
                   point_start: Coordinate.new(0, 1),
                   point_end: Coordinate.new(0, 2)
                 })
      end
      it 'should update history' do
        expect { board.move!(move) }.to change { board.history.length }.by(1)
      end
      it 'should update history last move to inputted move' do
        expect { board.move!(move) }.to change { board.history.last }.to(move)
      end
    end
    context 'when action kind is move' do
      # TODO
    end
    context 'when action kind is capture' do
      # TODO
    end
    context 'when action kind is promotion_move' do
      # TODO
    end
    context 'when action kind is promotion_capture' do
      # TODO
    end
    context 'when action kind is en_passant' do
      # TODO
    end
    context 'when action kind is castling_short' do
      # TODO
    end
    context 'when action kind is castling_long' do
      # TODO
    end
  end
  describe '#clone' do
    it 'should not return nil' do
      expect(board.clone).to_not be_nil
    end
    context "when board's fields history and eaten not empty" do
      before do
        board.history.push(Move.new(:test, { test: 'test' }))
        board.eaten.push(Figure.new(:test, :test))
      end
      it 'should return new instance of same class' do
        expect(board.clone).to be_a(Board)
        expect(board.clone).to_not equal(board)
      end
      it 'should return class instance, that has new instance of history field' do
        expect(board.clone.history).to_not equal(board.history)
      end
      it 'should return class instance, that has history field with same content' do
        expect(board.clone.history).to eql(board.history)
      end
      it 'should return class instance, that has new instance of eaten field' do
        expect(board.clone.eaten).to_not equal(board.eaten)
      end
      it 'should return class instance, that has eaten field with same content' do
        expect(board.clone.eaten).to eql(board.eaten)
      end
      it 'should return class instance, that has new instance of board field, include nested arrays' do
        expect(board.clone.instance_variable_get(:@board)).to_not equal(board.instance_variable_get(:@board))
        expect(board.clone.instance_variable_get(:@board)[0]).to_not equal(board.instance_variable_get(:@board)[0])
      end
      it 'should return class instance, that has board field with same content' do
        expect(board.clone.instance_variable_get(:@board)).to eql(board.instance_variable_get(:@board))
      end
    end
  end
  describe '#move' do
    context 'when action is nil' do
      let(:new_board) { instance_double(Board) }
      before do
        allow(board).to receive(:clone).and_return(new_board)
        allow(new_board).to receive(:move!)
      end
      it 'should call move! once' do
        expect(new_board).to receive(:move!).once
        board.move(nil)
      end
      it 'should call clone once' do
        expect(board).to receive(:clone).once
        board.move(nil)
      end
      it 'should return board clone' do
        expect(board.move(nil)).to_not equal(board)
      end
    end
  end
  describe '#where_is?' do
    context 'when figure_type = nil and figure_color = nil' do
      let(:figure_type) { nil }
      let(:figure_color) { nil }
      it 'should return array with all 32 figures coordinates' do
        expect(board.where_is(figure_type, figure_color).length).to be 32
      end
      context 'when board is empty' do
        it 'should return empty array' do
          board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
          expect(board.where_is(figure_type, figure_color).length).to be_zero
        end
      end
    end
    context 'when figure_type = :king and figure_color = nil' do
      let(:figure_type) { :king }
      let(:figure_color) { nil }
      it 'should return array with both kings coordinates' do
        expect(board.where_is(figure_type, figure_color).length).to be 2
      end
    end
    context 'when figure_type = nil and figure_color = :white' do
      let(:figure_type) { nil }
      let(:figure_color) { :white }
      it 'should return array with all white figures coordinates' do
        expect(board.where_is(figure_type, figure_color).length).to be 16
      end
    end
    context 'when figure_type = :king and figure_color = :white' do
      let(:figure_type) { :king }
      let(:figure_color) { :white }
      it 'should return array with one white king coordinate' do
        expect(board.where_is(figure_type, figure_color).length).to be 1
      end
    end
  end
end
