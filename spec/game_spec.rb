require './lib/chess'

describe Game do
  subject(:game) { described_class.new([], board) }

  let(:board) { Board.new }
  let(:player1) { Player.new('Bob', :white) }
  let(:player2) { Player.new('Anna', :black) }

  describe '#game_end?' do
    context 'when board in mate state and current player == 0' do
      before do
        allow(board.state).to receive(:mate?).and_return(true)
        allow(board.state).to receive(:draw?).and_return(false)
        game.instance_variable_set(:@players, [player1, player2])
      end

      it 'returns true' do
        expect(game).to be_game_end
      end

      it 'sets winner to opposite player' do
        expect { game.game_end? }.to change { game.instance_variable_get(:@winner) }.to(player2)
      end
    end

    context 'when board in draw state' do
      before do
        allow(board.state).to receive(:mate?).and_return(false)
        allow(board.state).to receive(:draw?).and_return(true)
        game.instance_variable_set(:@players, [player1, player2])
        game.instance_variable_set(:@winner, player1)
      end

      it 'returns true' do
        expect(game).to be_game_end
      end

      it 'sets winner to nil' do
        expect { game.game_end? }.to change { game.instance_variable_get(:@winner) }.to(nil)
      end
    end

    context 'when board not in draw or mate state' do
      before do
        allow(board.state).to receive(:mate?).and_return(false)
        allow(board.state).to receive(:draw?).and_return(false)
        game.instance_variable_set(:@players, [player1, player2])
      end

      it 'returns false' do
        expect(game).not_to be_game_end
      end

      it 'does not change winner' do
        expect { game.game_end? }.not_to change { game.instance_variable_get(:@winner) }.from(nil)
      end
    end
  end
end
