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
    figure = @board[coordinate.y][coordinate.x]
    @board[coordinate.y][coordinate.x] = nil
    figure
  end

  def replace_at(coordinate, new_figure)
    figure = @board[coordinate.y][coordinate.x]
    @board[coordinate.y][coordinate.x] = new_figure
    figure
  end

  def can_move_at?(figure, coordinate)
    return false unless on_board?(coordinate)
    return true if at(coordinate).nil?
    at(coordinate).color != figure.color
  end

  def at(coordinate)
    @board.dig(coordinate.y, coordinate.x)
  end

  def on_board?(coordinate)
    coordinate.x.between?(0, 7) && coordinate.y.between?(0, 7)
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
    coor_start = 0
    coor_end = 7
    step = 1
    if rotate
      coor_start, coor_end = coor_end, coor_start
      step = -1
    end
    print "  "
    coor_start.step(coor_end, step) { |x| print " " + (97 + x).chr }
    print "\n"
    coor_start.step(coor_end, step) do |y|
      print (y + 1).to_s + " "
      coor_start.step(coor_end, step) do |x|
        figure = @board[y][x].nil? ? "  " : @board[y][x].to_s
        print bg_color(figure, x + y)
      end
      puts " " + (y + 1).to_s
    end
    print " "
    coor_start.step(coor_end, step) { |x| print " " + (97 + x).chr }
    puts " "
  end

  private

  def bg_color(string, color_i)
    color_i.odd? ? "\e[46m#{string}\e[0m" : "\e[44m#{string}\e[0m"
  end
end
