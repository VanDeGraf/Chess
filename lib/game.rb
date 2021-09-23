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
require 'yaml'

# Single chess game scope
class Game
  attr_reader :board, :winner

  def initialize(players = [], board = Board.new)
    @board = board
    @winner = nil
    @current_player = 0
    @players = players
    @finished = false
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
      save('autosave')
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

  SAVE_DIR = File.expand_path('../saves', __dir__).freeze
  EXPORT_DIR = File.expand_path('../saves', __dir__).freeze

  def save(filename)
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)
    filename = Game.full_name_of_save_file(filename)
    File.write(filename, YAML.dump(self))
  end

  # @param filename [String]
  # @return [String]
  def self.full_name_of_save_file(filename)
    return filename if filename.include?(SAVE_DIR)

    "#{SAVE_DIR}/#{filename}.yaml"
  end

  # @param filename [String]
  # @return [String]
  def self.full_name_of_export_file(filename)
    return filename if filename.include?(EXPORT_DIR)

    "#{EXPORT_DIR}/#{filename}.pgn"
  end

  # @return [Game, nil]
  def self.load(filename)
    filename = full_name_of_save_file(filename)
    return nil unless File.exist?(filename)

    YAML.safe_load(File.read(filename), permitted_classes: [
                     Game, Board, Figure, Player, Movement, Move, Capture, EnPassant, PromotionCapture, PromotionMove,
                     Castling, Coordinate, Symbol, Computer, RepetitionLog, BoardState
                   ], aliases: true)
  end

  def export(filename)
    Dir.mkdir(EXPORT_DIR) unless Dir.exist?(EXPORT_DIR)
    filename = Game.full_name_of_export_file(filename)
    buffer = StringIO.new
    buffer << "[Event \"Game\"]\n"
    buffer << "[Site \"?\"]\n"
    buffer << "[Date \"????.??.??\"]\n"
    buffer << "[Round \"?\"]\n"
    buffer << "[White \"#{@players[0].name}\"]\n"
    buffer << "[Black \"#{@players[1].name}\"]\n"
    game_result = if @finished
                    if @winner.nil?
                      '1/2-1/2'
                    else
                      @winner == @players[0] ? '1-0' : '0-1'
                    end
                  else
                    '*'
                  end
    buffer << "[Result \"#{game_result}\"]\n\n"

    row = StringIO.new
    current_board_state = Board.new
    current_color = :white
    @board.history.each_with_index do |movement, i|
      if i.even?
        if row.length >= 80
          buffer << "#{row.string}\n"
          row = StringIO.new
        end
        row << "#{(i + 2) / 2}."
      end

      possible_moves = current_board_state.possible_moves(current_color)
      player_turn = nil
      assoc = MovementGenerator.algebraic_notation(possible_moves)
      assoc.each_pair do |string, move|
        next if move != movement

        player_turn = string
        break
      end

      current_board_state = current_board_state.move(movement)
      current_color = current_color == :white ? :black : :white

      postfix = current_board_state.state.mate?(current_color) ? '#' : ''
      postfix = current_board_state.state.shah?(current_color) ? '+' : '' if postfix.length.zero?

      row << "#{player_turn}#{postfix} "
    end
    row << " #{game_result}" if @finished
    buffer << row.string

    File.write(filename, buffer.string)
  end

  # @param filename [String]
  # @return [Hash<Array<String>>]
  def self.split_pgn_to_saves(filename)
    data = File.read(filename)
    blocks = data.delete("\r").split("\n\n")
    data = {
      saves: []
    }
    blocks.each_index do |i|
      data[:saves] << blocks[i - 1] + blocks[i] if i.odd?
    end
    data[:descriptions] = data[:saves].map do |save_string|
      tags = parse_pgn_tags(save_string)
      "[#{tags['Event']}] #{tags['White']}  vs  #{tags['Black']}"
    end
    data
  end

  # @param pgn [String] - PGN save as string
  # @return [Game, nil]
  def self.import(pgn)
    tags = parse_pgn_tags(pgn)
    game = Game.new([
                      Player.new(tags['White'], :white),
                      Player.new(tags['Black'], :black)
                    ])
    if tags['Result'] == '*'
      game.instance_variable_set(:@finished, false)
      game.instance_variable_set(:@winner, nil)
    else
      game.instance_variable_set(:@finished, true)
      winner = case tags['Result']
               when '1-0'
                 game.instance_variable_get(:@players)[0]
               when '0-1'
                 game.instance_variable_get(:@players)[1]
               end
      game.instance_variable_set(:@winner, winner)
    end

    re = /([BNQKR]?[a-h]?[1-8]?x?[a-h][1-8]=?[BNQKR]?)|(O-O)|(O-O-O)/m
    pgn.scan(re) do |m|
      string_move = "#{m[0]}#{m[1]}#{m[2]}"

      possible_moves = game.board.possible_moves(game.current_player.color)

      move = MovementGenerator.algebraic_notation(possible_moves)[string_move]
      game.board.move!(move)

      game.instance_variable_set(:@current_player, game.instance_variable_get(:@current_player).zero? ? 1 : 0)
    end
    game
  end

  def self.parse_pgn_tags(pgn)
    tags = {}
    re = /\[(\w+) "([^"]*)"\]/m
    pgn.scan(re) do |match|
      tags[match[0]] = match[1]
    end
    tags
  end
end
