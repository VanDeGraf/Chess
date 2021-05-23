class Board
  def initialize
    @board = [
        [Figure.new(:rook, :white), Figure.new(:knight, :white), Figure.new(:bishop, :white), Figure.new(:queen, :white), Figure.new(:king, :white), Figure.new(:bishop, :white), Figure.new(:knight, :white), Figure.new(:rook, :white)],
        [Figure.new(:pawn, :white), Figure.new(:pawn, :white), Figure.new(:pawn, :white), Figure.new(:pawn, :white), Figure.new(:pawn, :white), Figure.new(:pawn, :white), Figure.new(:pawn, :white), Figure.new(:pawn, :white)],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [Figure.new(:pawn, :black), Figure.new(:pawn, :black), Figure.new(:pawn, :black), Figure.new(:pawn, :black), Figure.new(:pawn, :black), Figure.new(:pawn, :black), Figure.new(:pawn, :black), Figure.new(:pawn, :black)],
        [Figure.new(:rook, :black), Figure.new(:knight, :black), Figure.new(:bishop, :black), Figure.new(:queen, :black), Figure.new(:king, :black), Figure.new(:bishop, :black), Figure.new(:knight, :black), Figure.new(:rook, :black)],
    ]
  end

  def remove_at(coordinate)
    return nil unless on_board?(coordinate)
    figure = @board[coordinate.y][coordinate.x]
    @board[coordinate.y][coordinate.x] = nil
    figure
  end

  def replace_at(coordinate, new_figure)
    return nil unless on_board?(coordinate) && !new_figure.nil?
    figure = @board[coordinate.y][coordinate.x]
    @board[coordinate.y][coordinate.x] = new_figure
    figure
  end

  def move(start_point, end_point)
    replace_at(end_point, remove_at(start_point))
  end

  def can_move_at?(figure, coordinate)
    return false unless on_board?(coordinate)
    return true if at(coordinate).nil?
    at(coordinate).color != figure.color
  end

  def at(coordinate)
    return nil unless on_board?(coordinate)
    @board.dig(coordinate.y, coordinate.x)
  end

  def on_board?(coordinate)
    coordinate.x.between?(0, 7) && coordinate.y.between?(0, 7)
  end

  def clone
    new_board = Board.new
    array = @board.map do |row|
      row.map { |figure| figure }
    end
    new_board.instance_variable_set(:@board, array)
    new_board
  end

  # @param color [Symbol]
  def shah?(color)
    opposite_color = color == :white ? :black : :white
    @board.each_index do |y|
      @board[y].each_index do |x|
        next if @board[y][x].nil? || @board[y][x].color != opposite_color
        moves = PossibleMoves.new(@board[y][x], Coordinate.new(x, y), self)
        return true if moves.match?(nil, true, :king)
      end
    end
    false
  end

  # @param color [Symbol]
  def mate?(color)
    possible_moves = generate_possible_moves_by_color(color)
    shah?(color) if possible_moves.empty?
    possible_moves.all? do |possible_move|
      point_start = possible_move.start_coordinate
      possible_move.moves_coordinates.all? do |point_end|
        board_clone = clone
        board_clone.move(point_start, point_end)
        board_clone.shah?(color)
      end
    end
  end

  # @param color [Symbol]
  def stalemate?(color)
    possible_moves = generate_possible_moves_by_color(color)
    return false unless possible_moves.empty?
    !shah?(color)
  end

  def deadmate?
    figure_types = []
    @board.flatten.each do |figure|
      figure_types << figure.figure if !figure.nil? &&
          !figure_types.include?(figure.figure)
    end
    figure_types.length == 1 && figure_types.first == :king
  end

  # @param color [Symbol]
  def generate_possible_moves_by_color(color)
    moves = []
    @board.each_index do |y|
      @board[y].each_index do |x|
        next if @board[y][x].nil? || @board[y][x].color != color
        moves << PossibleMoves.new(@board[y][x], Coordinate.new(x, y), self)
      end
    end
    moves
  end

  def print_board(rotate = false)
    point_start = 0
    point_end = 7
    step = 1
    if rotate
      point_start, point_end = point_end, point_start
      step = -1
    end
    print "  "
    point_end.step(point_start, step * -1) { |x| print " " + (97 + x).chr }
    print "\n"
    point_start.step(point_end, step) do |y|
      print (y + 1).to_s + " "
      point_end.step(point_start, step * -1) do |x|
        figure = @board[y][x].nil? ? "  " : @board[y][x].to_s
        print bg_color(figure, x + y)
      end
      puts " " + (y + 1).to_s
    end
    print "  "
    point_end.step(point_start, step * -1) { |x| print " " + (97 + x).chr }
    puts " "
  end

  private

  def bg_color(string, color_i)
    color_i.odd? ? "\e[46m#{string}\e[0m" : "\e[44m#{string}\e[0m"
  end
end
