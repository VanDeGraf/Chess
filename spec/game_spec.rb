require './lib/chess'

describe Game do
  let(:board) { Board.new }
  let(:player1) { Player.new('Bob', :white) }
  let(:player2) { Player.new('Anna', :black) }
  subject(:game) { Game.new([], board) }
  describe '#game_end?' do
    context 'when board in mate state and current player == 0' do
      before do
        allow(board).to receive(:mate?).and_return(true)
        allow(board).to receive(:draw?).and_return(false)
        game.instance_variable_set(:@players, [player1, player2])
      end
      it 'should return true' do
        expect(game.game_end?).to be_truthy
      end
      it 'should set winner to opposite player' do
        expect { game.game_end? }.to change { game.instance_variable_get(:@winner) }.to(player2)
      end
    end
    context 'when board in draw state' do
      before do
        allow(board).to receive(:mate?).and_return(false)
        allow(board).to receive(:draw?).and_return(true)
        game.instance_variable_set(:@players, [player1, player2])
        game.instance_variable_set(:@winner, player1)
      end
      it 'should return true' do
        expect(game.game_end?).to be_truthy
      end
      it 'should set winner to nil' do
        expect { game.game_end? }.to change { game.instance_variable_get(:@winner) }.to(nil)
      end
    end
    context 'when board not in draw or mate state' do
      before do
        allow(board).to receive(:mate?).and_return(false)
        allow(board).to receive(:draw?).and_return(false)
        game.instance_variable_set(:@players, [player1, player2])
      end
      it 'should return false' do
        expect(game.game_end?).to be_falsey
      end
      it 'should not change winner' do
        expect { game.game_end? }.to_not change { game.instance_variable_get(:@winner) }.from(nil)
      end
    end
  end
end
