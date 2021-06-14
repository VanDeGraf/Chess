require './lib/coordinate'
require './lib/figure'
require './lib/move'
require './lib/board'
require './lib/moves_generator'
require './lib/player'
require './lib/view'

# Single chess game scope
class Game
  def initialize(players = [], board = Board.new)
    @board = board
    @winner = nil
    @current_player = 0
    @players = players
  end

  def player_turn
    move = View.game_turn(@board, @players[@current_player])
    @board.move!(move)
    @current_player = @current_player.zero? ? 1 : 0
  end

  def play_game
    @players[0] = View.player_welcome(:white) if @players[0].nil?
    @players[1] = View.player_welcome(:black) if @players[1].nil?
    player_turn until game_end?
    View.end_game(@board, @winner)
  end

  def game_end?
    if @board.mate?(@players[@current_player].color)
      @winner = @players[@current_player.zero? ? 1 : 0]
      true
    elsif @board.draw?(@players[@current_player].color)
      @winner = nil
      true
    else
      false
    end
  end
end
