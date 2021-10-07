require_relative 'board'
require_relative 'player'
require_relative 'computer'
require_relative 'user_interface/screen'
require_relative 'user_interface/message_screen'
require_relative 'user_interface/accept_request_screen'
require_relative 'user_interface/multiple_choice_request_screen'
require_relative 'user_interface/serialize_screen'
require_relative 'user_interface/player_name_request_screen'
require_relative 'user_interface/command_help_screen'
require_relative 'user_interface/turn_history_screen'
require_relative 'user_interface/main_menu_screen'
require_relative 'user_interface/game_turn_screen'
require_relative 'user_interface/game_end_screen'
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

  # @param move [Movement, nil]
  def perform_movement(move)
    return if move.nil?

    @board.move!(move)
    swap_current_player
    SaveSerializer.new.serialize(self, 'autosave')
    nil
  end

  def perform_draw_command
    @winner = nil
    @finished = true
    nil
  end

  def perform_surrender_command
    @winner = opposite_player
    @finished = true
    nil
  end

  # @return [Symbol, nil]
  def play_game
    players_initialize
    until (@finished = game_end?)
      command = current_player.turn(self)
      return command unless command.nil?
    end
    nil
  end

  def players_initialize
    @players[0] = PlayerNameRequestScreen.show_and_read(:white) if @players[0].nil?
    @players[1] = PlayerNameRequestScreen.show_and_read(:black) if @players[1].nil?
  end

  def game_end?
    if @board.state.mate?(current_player.color)
      @winner = opposite_player
      true
    elsif @board.state.draw?(current_player.color)
      perform_draw_command
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

  def swap_current_player
    @current_player = @current_player.zero? ? 1 : 0
  end

  YAML_LOAD_PERMITTED_CLASSES = [
    Game, Board, Figure, Player, Movement, Move, Capture, EnPassant, PromotionCapture, PromotionMove,
    Castling, Coordinate, Symbol, Computer, RepetitionLog, BoardState
  ].freeze
end
