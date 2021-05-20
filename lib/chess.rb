require "./lib/coordinate.rb"
require "./lib/figure.rb"
require "./lib/board.rb"
require "./lib/possible_moves.rb"

class Chess
  def initialize
    @board = Board.new
    @player_names = []
    @winner = nil
    @current_player = 0
    @eaten_figures = [[], []]
  end

  def introdution
    puts "Welcome to Chess!"
    puts "Player White, say your name: "
    @player_names << player_name_input
    puts "Player Black, say your name: "
    @player_names << player_name_input
    print_game_status
  end

  def print_game_status
    puts "---------------------------------"
    puts "Player #{@player_names[0]}(White) eats:"
    @eaten_figures[0].each { |figure| print figure.to_s }
    puts "\nPlayer #{@player_names[1]}(Black) eats:"
    @eaten_figures[1].each { |figure| print figure.to_s }
    print "\n"
    @board.print_board(@current_player == 0)
  end

  def player_name_input
    input = gets.chomp
    until input.length >= 3
      puts "Wrong input! Name length must more than 2! Type right: "
      input = gets.chomp
    end
    input
  end

  def player_turn
    puts "Player #{@player_names[@current_player]} turn."
    puts "Type your figure coordinate and endpoint coordinate (delim: space): "
    point_start, point_end = player_turn_input
    until current_move_possible?(point_start, point_end)
      puts "Sorry, you can't move here (or from), try other coordinate: "
      point_start, point_end = player_turn_input
    end
    # TODO: game state: check/shah
    eaten_figure = @board.replace_at(point_end, @board.remove_at(point_start))
    @eaten_figures << eaten_figure unless eaten_figure.nil?
    @current_player = @current_player == 0 ? 1 : 0
    print_game_status
  end

  def player_turn_input
    input = gets.chomp
    until input.match?(/^[a-h][1-8] [a-h][1-8]$/)
      puts "Wrong input! Try again: "
      input = gets.chomp
    end
    input = input.split
    [Coordinate.from_s(input[0]), Coordinate.from_s(input[1])]
  end

  def current_move_possible?(point_start, point_end)
    current_color = @current_player == 0 ? :white : :black
    possible_moves = @board.generate_possible_moves_by_color(current_color)
    possible_moves.each do |figure_moves|
      return true if figure_moves.can_move?(point_start, point_end)
    end
    false
  end

  def play_game
    introdution
    player_turn until game_end?
    print_game_result
  end

  def game_end?
    false
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
