require './lib/coordinate'
require './lib/figure'
require './lib/move'
require './lib/board'
require './lib/possible_moves'

class Chess
  def initialize
    @board = Board.new
    @player_names = []
    @winner = nil
    @current_player = 0
  end

  def introdution
    puts 'Welcome to Chess!'
    puts 'Player White, say your name: '
    @player_names << player_name_input
    puts 'Player Black, say your name: '
    @player_names << player_name_input
    print_game_status
  end

  def print_game_status
    puts '---------------------------------'
    puts "Player #{@player_names[0]}(White) eats:"
    @board.eaten.each { |figure| print figure.to_s if figure.color == :white }
    puts "\nPlayer #{@player_names[1]}(Black) eats:"
    @board.eaten.each { |figure| print figure.to_s if figure.color == :black }
    print "\n"
    @board.print_board(@current_player.zero?)
  end

  def player_name_input
    input = gets.chomp
    until input.length >= 3
      puts 'Wrong input! Name length must more than 2! Type right: '
      input = gets.chomp
    end
    input
  end

  def player_turn
    puts "Player #{@player_names[@current_player]} turn."
    current_color = @current_player.zero? ? :white : :black
    possible_moves = @board.where_is(nil, current_color).map do |coordinate|
      PossibleMoves.new(@board.at(coordinate), coordinate, @board).moves
    end
    default_moves = []
    special_moves = []
    possible_moves.flatten.each do |move|
      if move.kind == :move || move.kind == :capture
        default_moves << move
      else
        special_moves << move
      end
    end

    unless special_moves.empty?
      puts 'You can do one of this special moves: '
      special_moves.each_with_index do |move, index|
        print "#{index + 1}) "
        case move.kind
        when :en_passant
          puts "en passant from #{move.options[:point_start]} to #{move.options[:point_end]}"
        when :promotion_move
          puts "pawn move to #{move.options[:point_end]} and promotion to #{move.options[:promotion_to].figure}"
        when :promotion_capture
          puts "pawn capture enemy at #{move.options[:point_end]} and promotion to #{move.options[:promotion_to].figure}"
        when :castling_short
          puts 'castling short'
        when :castling_long
          puts 'castling long'
        end
      end
    end

    move = player_turn_input(default_moves, special_moves)
    @board.move!(move)
    @current_player = @current_player.zero? ? 1 : 0
    print_game_status
  end

  def player_turn_input_parse
    input = gets.chomp
    until input.match?(%r{^([a-h][1-8] [a-h][1-8])|(/[a-z]+ ?(\S* ?)*)|(s \d+)$})
      puts 'Wrong input! Try again: '
      input = gets.chomp
    end
    case input[0]
    when '/'
      input = input[1..input.length - 1].split
      {
        action: :command,
        command: input.shift,
        arguments: input
      }
    when 's'
      {
        action: :special_move,
        move_index: input.split[1].to_i - 1
      }
    else
      input = input.split
      {
        action: :move,
        point_start: Coordinate.from_s(input[0]),
        point_end: Coordinate.from_s(input[1])
      }
    end
  end

  def player_turn_input(default_moves, special_moves)
    puts 'Type your figure coordinate and endpoint coordinate (delim: space), ' \
         'special move with s and number or command: '
    input = player_turn_input_parse
    case input[:action]
    when :move
      default_moves.any? do |move|
        return move if move.options[:point_start] == input[:point_start] &&
                       move.options[:point_end] == input[:point_end]
      end
      puts "Sorry, you can't move here (or from)."
      player_turn_input(default_moves, special_moves)
    when :special_move
      unless !special_moves.empty? && input[:move_index].between?(0, special_moves.length - 1)
        puts 'Mismatch number of special move choice.'
        player_turn_input(default_moves, special_moves)
      end
      special_moves[input[:move_index]]
    end
  end

  def play_game
    introdution
    player_turn until game_end?
    print_game_result
  end

  def game_end?
    player_color = @current_player.zero? ? :white : :black
    if @board.mate?(player_color)
      @winner = @current_player.zero? ? 1 : 0
      true
    elsif @board.stalemate?(player_color) || @board.deadmate?
      @winner = nil
      true
    else
      false
    end
  end

  def print_game_result
    if @winner.nil?
      puts "\nDraw! No winners!"
    else
      puts "\nPlayer #{@player_names[@winner]} Win! Congratulations!"
    end
  end
end

# Chess.new.play_game
