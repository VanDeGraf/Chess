require_relative 'board'
require_relative 'player'
require_relative 'computer'
require_relative 'interface/screen'
require_relative 'interface/message_screen'
require_relative 'interface/accept_request_screen'
require_relative 'interface/multiple_choice_request_screen'
require_relative 'interface/save_load_screen'
require_relative 'interface/player_name_request_screen'
require_relative 'interface/command_help_screen'
require_relative 'interface/turn_history_screen'
require_relative 'interface/main_menu_screen'
require_relative 'interface/game_turn_screen'
require_relative 'interface/game_end_screen'
require_relative 'serializer'
require_relative 'save_serializer'
require_relative 'pgn_serializer'
require 'yaml'

# Single chess game scope
class Game
  attr_reader :board, :winner, :finished, :players

  def initialize(players = [], board = Board.new)
    @board = board
    @winner = nil
    @current_player = 0
    @players = players
    @finished = false
  end

  def description
    status = if !@finished
               'In process'
             elsif @winner.nil?
               'Draw'
             elsif @winner == @players[0]
               'Win'
             else
               'Lose'
             end
    "#{@players[0].name} vs #{@players[1].name} : #{status}"
  end

  # @return [Symbol, nil]
  def player_turn
    action = if current_player.is_a?(Computer)
               current_player.turn(self)
             else
               GameTurnScreen.show_and_read(self)
             end
    if action.is_a?(Movement)
      @board.move!(action)
      @current_player = @current_player.zero? ? 1 : 0
      SaveSerializer.new.serialize(self, 'autosave')
      nil
    else
      case action
      when :draw
        @winner = nil
        @finished = true
        nil
      when :surrender
        @winner = opposite_player
        @finished = true
        nil
      else
        action
      end
    end
  end

  # @return [Symbol, nil]
  def play_game
    @players[0] = PlayerNameRequestScreen.show_and_read(:white) if @players[0].nil?
    @players[1] = PlayerNameRequestScreen.show_and_read(:black) if @players[1].nil?
    until @finished || (@finished = game_end?)
      action = player_turn
      return action unless action.nil?
    end
    nil
  end

  def game_end?
    if @board.state.mate?(current_player.color)
      @winner = @players[@current_player.zero? ? 1 : 0]
      true
    elsif @board.state.draw?(current_player.color)
      @winner = nil
      true
    else
      false
    end
  end

  # @return [Player]
  def current_player
    @players[@current_player]
  end

  # @return [Player]
  def opposite_player
    @players[@current_player.zero? ? 1 : 0]
  end

  YAML_LOAD_PERMITTED_CLASSES = [
    Game, Board, Figure, Player, Movement, Move, Capture, EnPassant, PromotionCapture, PromotionMove,
    Castling, Coordinate, Symbol, Computer, RepetitionLog, BoardState
  ].freeze
end
