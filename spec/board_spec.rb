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
      it 'return nil on too positive' do
        expect(board.remove_at!(Coordinate.new(8, 8))).to be_nil
      end

      it 'return nil on negative' do
        expect(board.remove_at!(Coordinate.new(-1, -1))).to be_nil
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
      it 'return nil on too positive' do
        expect(board.replace_at!(Coordinate.new(8, 8), figure)).to be_nil
      end

      it 'return nil on negative' do
        expect(board.replace_at!(Coordinate.new(-1, -1), figure)).to be_nil
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
      it 'return nil on too positive' do
        expect(board.at(Coordinate.new(8, 8))).to be_nil
      end

      it 'return nil on negative' do
        expect(board.at(Coordinate.new(-1, -1))).to be_nil
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
      it 'return false on too positive' do
        expect(board).not_to be_on_board(Coordinate.new(8, 8))
      end

      it 'return false on negative' do
        expect(board).not_to be_on_board(Coordinate.new(-1, -1))
      end
    end

    context 'when coordinate on board' do
      it 'return true' do
        expect(board.on_board?(Coordinate.new(1, 1))).to be true
      end
    end
  end

  describe '#there_empty?' do
    it 'returns true at coordinate 0,2' do
      expect(board).to be_there_empty(Coordinate.new(0, 2))
    end

    it 'returns false at coordinate 0,0' do
      expect(board).not_to be_there_empty(Coordinate.new(0, 0))
    end

    it 'returns false at coordinate 9,9' do
      expect(board).not_to be_there_empty(Coordinate.new(9, 9))
    end

    it 'returns false at coordinate -1,-1' do
      expect(board).not_to be_there_empty(Coordinate.new(-1, -1))
    end
  end

  describe '#there_ally?' do
    context 'when color is white' do
      let(:color) { :white }

      it 'returns false at coordinate 0,2' do
        expect(board).not_to be_there_ally(color, Coordinate.new(0, 2))
      end

      it 'returns true at coordinate 0,0' do
        expect(board).to be_there_ally(color, Coordinate.new(0, 0))
      end

      it 'returns false at coordinate 0,7' do
        expect(board).not_to be_there_ally(color, Coordinate.new(0, 7))
      end

      it 'returns false at coordinate 9,9' do
        expect(board).not_to be_there_ally(color, Coordinate.new(9, 9))
      end

      it 'returns false at coordinate -1,-1' do
        expect(board).not_to be_there_ally(color, Coordinate.new(-1, -1))
      end
    end
  end

  describe '#there_enemy?' do
    context 'when color is white' do
      let(:color) { :white }

      it 'returns false at coordinate 0,2' do
        expect(board).not_to be_there_enemy(color, Coordinate.new(0, 2))
      end

      it 'returns false at coordinate 0,0' do
        expect(board).not_to be_there_enemy(color, Coordinate.new(0, 0))
      end

      it 'returns true at coordinate 0,7' do
        expect(board).to be_there_enemy(color, Coordinate.new(0, 7))
      end

      it 'returns false at coordinate 9,9' do
        expect(board).not_to be_there_enemy(color, Coordinate.new(9, 9))
      end

      it 'returns false at coordinate -1,-1' do
        expect(board).not_to be_there_enemy(color, Coordinate.new(-1, -1))
      end
    end
  end

  describe '#move!' do
    context 'when action move is nil' do
      it 'does not update history' do
        expect { board.move!(nil) }.not_to change { board.history.length }
      end

      it 'does not update history last move' do
        expect { board.move!(nil) }.not_to change { board.history.last }
      end
    end

    context 'when action not nil' do
      let(:move) do
        Move.new(board.at(Coordinate.new(0, 1)), Coordinate.new(0, 1), Coordinate.new(0, 2))
      end

      it 'updates history' do
        expect { board.move!(move) }.to change { board.history.length }.by(1)
      end

      it 'updates history last move to inputted move' do
        expect { board.move!(move) }.to change { board.history.last }.to(move)
      end
    end
  end

  describe '#clone' do
    it 'does not return nil' do
      expect(board.clone).not_to be_nil
    end

    context "when board's fields history and eaten not empty" do
      before do
        figure = Figure.new(:test, :test)
        board.history.push(Move.new(figure, Coordinate.new(0, 0), Coordinate.new(0, 1)))
        board.eaten.push(figure)
      end

      it 'returns object of same class' do
        expect(board.clone).to be_a(described_class)
      end

      it 'returns new object' do
        expect(board.clone).not_to equal(board)
      end

      it 'returns class instance, that has new instance of history field' do
        expect(board.clone.history).not_to equal(board.history)
      end

      it 'returns class instance, that has history field with same content' do
        expect(board.clone.history).to eql(board.history)
      end

      it 'returns class instance, that has new instance of eaten field' do
        expect(board.clone.eaten).not_to equal(board.eaten)
      end

      it 'returns class instance, that has eaten field with same content' do
        expect(board.clone.eaten).to eql(board.eaten)
      end

      it 'returns class instance, that has new instance of board field' do
        expect(board.clone.instance_variable_get(:@board)).not_to equal(board.instance_variable_get(:@board))
      end

      it 'returns class instance, that has new instances of board nested arrays' do
        expect(board.clone.instance_variable_get(:@board)[0]).not_to equal(board.instance_variable_get(:@board)[0])
      end

      it 'returns class instance, that has board field with same content' do
        expect(board.clone.instance_variable_get(:@board)).to eql(board.instance_variable_get(:@board))
      end
    end
  end

  describe '#move' do
    context 'when action is nil' do
      let(:new_board) { instance_double(described_class) }

      before do
        allow(board).to receive(:clone).and_return(new_board)
        allow(new_board).to receive(:move!)
      end

      it 'calls move! once' do
        expect(new_board).to receive(:move!).once
        board.move(nil)
      end

      it 'calls clone once' do
        expect(board).to receive(:clone).once
        board.move(nil)
      end

      it 'returns board clone' do
        expect(board.move(nil)).not_to equal(board)
      end
    end
  end

  describe '#where_is?' do
    context 'when figure_type = nil and figure_color = nil' do
      let(:figure_type) { nil }
      let(:figure_color) { nil }

      it 'returns array with all 32 figures coordinates' do
        expect(board.where_is(figure_type, figure_color).length).to be 32
      end

      context 'when board is empty' do
        it 'returns empty array' do
          board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
          expect(board.where_is(figure_type, figure_color).length).to be_zero
        end
      end
    end

    context 'when figure_type = :king and figure_color = nil' do
      let(:figure_type) { :king }
      let(:figure_color) { nil }

      it 'returns array with both kings coordinates' do
        expect(board.where_is(figure_type, figure_color).length).to be 2
      end
    end

    context 'when figure_type = nil and figure_color = :white' do
      let(:figure_type) { nil }
      let(:figure_color) { :white }

      it 'returns array with all white figures coordinates' do
        expect(board.where_is(figure_type, figure_color).length).to be 16
      end
    end

    context 'when figure_type = :king and figure_color = :white' do
      let(:figure_type) { :king }
      let(:figure_color) { :white }

      it 'returns array with one white king coordinate' do
        expect(board.where_is(figure_type, figure_color).length).to be 1
      end
    end
  end

  describe '#possible_moves' do
    subject(:board) do
      b = described_class.new
      b.instance_variable_set(:@board, Array.new(8) { Array.new(8) })
      b.init_pawn_row(:white, 1)
      b.init_pawn_row(:black, 6)
      b
    end

    context 'color white' do
      let(:color) { :white }

      it 'call where_is once' do
        allow(board).to receive(:where_is).and_return([])
        board.possible_moves(color)
        expect(board).to have_received(:where_is).with(nil, color)
      end

      it 'call MovementGenerator.generate_from 8 times' do
        allow(MovementGenerator).to receive(:generate_from).and_return([])
        board.possible_moves(color)
        expect(MovementGenerator).to have_received(:generate_from).exactly(8).times
      end

      it 'call MovementGenerator.castling once' do
        allow(MovementGenerator).to receive(:castling).and_return([])
        board.possible_moves(color)
        expect(MovementGenerator).to have_received(:castling).once
      end
    end
  end
end
