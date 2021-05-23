require "./lib/coordinate.rb"
require "./lib/figure.rb"
require "./lib/possible_moves.rb"
require "./lib/board.rb"

describe Board do
  subject(:board) { described_class.new }

  describe "#remove_at" do
    context "when there is figure" do
      let(:x) { 0 }
      let(:y) { 0 }
      it "cell set nil value" do
        expect { board.remove_at(Coordinate.new(x, y)) }.to change {
          board.instance_variable_get(:@board)[y][x]
        }.to(nil)
      end

      it "return figure from cell" do
        figure = board.instance_variable_get(:@board)[y][x]
        expect(board.remove_at(Coordinate.new(x, y))).to be figure
      end
    end

    context "when coordinate out of board" do
      it "return nil" do
        expect(board.remove_at(Coordinate.new(-1, -1))).to be_nil
        expect(board.remove_at(Coordinate.new(8, 8))).to be_nil
      end
    end
  end

  describe "#replace_at" do
    let(:figure) { Figure.new(:pawn, :white) }
    context "when there is figure" do
      let(:x) { 0 }
      let(:y) { 0 }
      it "cell set figure as value" do
        removed_figure = board.instance_variable_get(:@board)[y][x]
        expect { board.replace_at(Coordinate.new(x, y), figure) }.to change {
          board.instance_variable_get(:@board)[y][x]
        }.from(removed_figure).to(figure)
      end

      it "return replaced figure" do
        removed_figure = board.instance_variable_get(:@board)[y][x]
        expect(board.replace_at(Coordinate.new(x, y), figure)).to be removed_figure
      end
    end
    context "when there is empty" do
      let(:x) { 0 }
      let(:y) { 2 }
      it "cell set figure as value" do
        expect { board.replace_at(Coordinate.new(x, y), figure) }.to change {
          board.instance_variable_get(:@board)[y][x]
        }.from(nil).to(figure)
      end

      it "return nil" do
        expect(board.replace_at(Coordinate.new(x, y), figure)).to be_nil
      end
    end

    context "when coordinate out of board" do
      it "return nil" do
        expect(board.replace_at(Coordinate.new(-1, -1), figure)).to be_nil
        expect(board.replace_at(Coordinate.new(8, 8), figure)).to be_nil
      end
    end
    context "when input figure is nil" do
      it "return nil" do
        expect(board.replace_at(Coordinate.new(1, 1), nil)).to be_nil
      end
    end
  end

  describe "#at" do
    context "when coordinate out of board" do
      it "return nil" do
        expect(board.at(Coordinate.new(-1, -1))).to be_nil
        expect(board.at(Coordinate.new(8, 8))).to be_nil
      end
    end
    context "when there is figure" do
      it "return figure" do
        expect(board.at(Coordinate.new(0, 0))).to be_a Figure
      end
    end
    context "when there is empty" do
      it "return nil" do
        expect(board.at(Coordinate.new(0, 2))).to be_nil
      end
    end
  end

  describe "#on_board?" do
    context "when coordinate out of board" do
      it "return false" do
        expect(board.on_board?(Coordinate.new(-1, -1))).to be false
        expect(board.on_board?(Coordinate.new(8, 8))).to be false
      end
    end
    context "when coordinate on board" do
      it "return true" do
        expect(board.on_board?(Coordinate.new(1, 1))).to be true
      end
    end
  end

  describe "#move" do
    context "when coordinate out of board" do
      it "return nil" do
        expect(board.move(Coordinate.new(-1, -1), Coordinate.new(1, 1))).to be_nil
        expect(board.move(Coordinate.new(1, 1), Coordinate.new(-1, -1))).to be_nil
        expect(board.move(Coordinate.new(8, 8), Coordinate.new(1, 1))).to be_nil
        expect(board.move(Coordinate.new(1, 1), Coordinate.new(8, 8))).to be_nil
      end
    end
  end

  describe "#shah?" do
    context "when on board king and enemy queen near" do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at(Coordinate.new(1, 1), Figure.new(:queen, :black))
      end
      it 'should return true' do
        expect(board.shah?(:white)).to be_truthy
      end
    end
    context "when on board king and enemy pawn near" do
      before do
        board.instance_variable_set(:@board, Array.new(8) { Array.new(8, nil) })
        board.replace_at(Coordinate.new(0, 0), Figure.new(:king, :white))
        board.replace_at(Coordinate.new(0, 1), Figure.new(:pawn, :black))
      end
      it 'should return false' do
        expect(board.shah?(:white)).to be_falsey
      end
    end
  end

  describe "#can_move_at?" do
    #TODO
  end

  describe "#generate_possible_moves_by_color" do
    #TODO
  end
end
