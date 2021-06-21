require_relative 'board'
require_relative 'player'
require_relative 'interface/screen'
require_relative 'interface/message_screen'
require_relative 'interface/accept_request_screen'
require_relative 'interface/save_load_screen'
require_relative 'interface/player_name_request_screen'
require_relative 'interface/command_help_screen'
require_relative 'interface/main_menu_screen'
require_relative 'interface/game_turn_screen'
require_relative 'interface/game_end_screen'
require 'yaml'

# Single chess game scope
class Game
  attr_reader :board, :winner

  def initialize(players = [], board = Board.new)
    @board = board
    @winner = nil
    @current_player = 0
    @players = players
  end

  # @return [Symbol, nil]
  def player_turn
    action = GameTurnScreen.show_and_read(self)
    if action.is_a?(Move)
      @board.move!(action)
      @current_player = @current_player.zero? ? 1 : 0
      save('autosave')
      nil
    else
      action
    end
  end

  # @return [Symbol, nil]
  def play_game
    @players[0] = PlayerNameRequestScreen.show_and_read(:white) if @players[0].nil?
    @players[1] = PlayerNameRequestScreen.show_and_read(:black) if @players[1].nil?
    until game_end?
      action = player_turn
      return action unless action.nil?
    end
    nil
  end

  def game_end?
    if @board.mate?(current_player.color)
      @winner = @players[@current_player.zero? ? 1 : 0]
      true
    elsif @board.draw?(current_player.color)
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

  SAVE_DIR = File.expand_path('../saves', __dir__).freeze

  def save(filename)
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)
    filename = Game.full_name_of_save_file(filename)
    File.write(filename, YAML.dump(self))
  end

  def self.full_name_of_save_file(filename)
    "#{SAVE_DIR}/#{filename}.yaml"
  end

  # @return [Game, nil]
  def self.load(filename)
    filename = full_name_of_save_file(filename)
    return nil unless File.exist?(filename)

    YAML.safe_load(File.read(filename), permitted_classes: [
                     Game, Board, Figure, Player, Move, Coordinate, Symbol
                   ], aliases: true)
  end
end
