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
  describe '#player_turn' do
    before do
      allow(View).to receive(:game_turn).and_return(Movement.new(:test))
      allow(board).to receive(:move!)
    end
    it 'should get move from view' do
      expect(View).to receive(:game_turn)
      game.player_turn
    end
    it 'should do move on board' do
      expect(board).to receive(:move!)
      game.player_turn
    end
    it 'should change current player to opposite' do
      expect { game.player_turn }.to change { game.instance_variable_get(:@current_player) }.from(0).to(1)
    end
  end
  describe '#play_game' do
    context 'when turns before end is 3' do
      before do
        allow(View).to receive(:player_welcome).and_return(player1, player2)
        allow(game).to receive(:player_turn)
        allow(game).to receive(:game_end?).and_return(false, false, true)
        allow(View).to receive(:end_game).and_return(1)
      end
      it 'should return view end menu option number' do
        expect(game.play_game).to be_a(Integer)
      end
      it 'should get players names from view' do
        expect(View).to receive(:player_welcome).twice
        game.play_game
      end
      it 'should check end game 3 times' do
        expect(game).to receive(:game_end?).exactly(3).times
        game.play_game
      end
      it 'should do 2 turns' do
        expect(game).to receive(:player_turn).exactly(2).times
        game.play_game
      end
    end
  end
end
