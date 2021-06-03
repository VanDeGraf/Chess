# Chess board, contains figures and methods for move it, checking position status for situations like shah(check),
# mate(checkmate), draw and other
class Board
  attr_reader :history, :eaten

  def initialize
    # @type [Array<Array<Figure,nil>>]
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
    # @type [Array<Figure>]
    @eaten = []
    # @type [Array<Move>]
    @history = []
  end

  # Remove from coordinate on board figure, if it's exists there, and coordinate is valid
  # @param coordinate [Coordinate]
  # @return [Figure,nil] Figure if removed, otherwise nil
  def remove_at!(coordinate)
    return nil unless on_board?(coordinate)
    figure = @board[coordinate.y][coordinate.x]
    @board[coordinate.y][coordinate.x] = nil
    figure
  end

  # Replace in coordinate on board with figure, if there is other figure or empty, and coordinate is valid
  # @param coordinate [Coordinate]
  # @param new_figure [Figure]
  # @return [Figure,nil] old Figure if exists and replaced, otherwise nil
  def replace_at!(coordinate, new_figure)
    return nil unless on_board?(coordinate) && !new_figure.nil?
    figure = @board[coordinate.y][coordinate.x]
    @board[coordinate.y][coordinate.x] = new_figure
    figure
  end

  # Do one of possible chess moves depends of inputted move data on current board and save in history, also update eaten
  # figures
  # @param action [Move]
  # @return [Void]
  def move!(action)
    return if action.nil?
    if action.kind == :move
      remove_at!(action.options[:point_start])
      replace_at!(action.options[:point_end], action.options[:figure])
    elsif action.kind == :capture
      remove_at!(action.options[:point_start])
      @eaten << replace_at!(action.options[:point_end], action.options[:figure])
    end
    # TODO: promotion, en passant, castling
    @history << action
  end

  # in clone of current board do move and return that clone
  # @param action [Move]
  # @return [Board]
  def move(action)
    new_board = clone
    new_board.move!(action)
    new_board
  end

  # Returns board cell value if coordinate is valid, otherwise return nil
  # @param coordinate [Coordinate]
  # @return [Figure,nil]
  def at(coordinate)
    return nil unless on_board?(coordinate)
    @board[coordinate.y][coordinate.x]
  end

  # If coordinate invalid, return false; If not empty and color opposite, return true
  # @param color [Figure,Symbol] use 'color = Figure.color' if color is Figure
  # @param coordinate [Coordinate]
  def there_enemy?(color, coordinate)
    color = color.color if color.is_a?(Figure)
    cell = at(coordinate)
    return false unless cell
    cell.color != color
  end

  # If coordinate invalid, return false; If not empty and color same, return true
  # @param color [Figure,Symbol] use 'color = Figure.color' if color is Figure
  # @param coordinate [Coordinate]
  def there_ally?(color, coordinate)
    color = color.color if color.is_a?(Figure)
    cell = at(coordinate)
    return false unless cell
    cell.color == color
  end

  # If coordinate invalid, return false; If empty, return true
  # @param coordinate [Coordinate]
  def there_empty?(coordinate)
    on_board?(coordinate) && @board[coordinate.y][coordinate.x].nil?
  end

  # Check coordinate is valid
  # @param coordinate [Coordinate]
  def on_board?(coordinate)
    coordinate.x.between?(0, 7) && coordinate.y.between?(0, 7)
  end

  # find all figures on board, filtered by it's type and color, and return that figures coordinates
  # @param figure_type [Symbol] nil return any figure type
  # @param figure_color [Symbol] nil return both figure color
  # @return [Array<Coordinate>] empty array if not found
  def where_is(figure_type = nil, figure_color = nil)
    positions = []
    @board.each_index do |y|
      @board[y].each_index do |x|
        next unless (figure = @board[y][x])
        positions << Coordinate.new(x, y) if (figure_type.nil? || figure.figure == figure_type) &&
            (figure_color.nil? || figure.color == figure_color)
      end
    end
    positions
  end

  # @return [Board]
  def clone
    new_board = Board.new
    array = @board.map do |row|
      row.map { |figure| figure }
    end
    new_board.instance_variable_set(:@board, array)
    new_board.instance_variable_set(:@history, @history.clone)
    new_board.instance_variable_set(:@eaten, @eaten.clone)
    new_board
  end

  # check inputted color is in shah(check) state, i.e. any enemy figure has possible move at next turn to beat king with
  # inputted color
  # @param color [Symbol]
  def shah?(color)
    opposite_color = color == :white ? :black : :white
    where_is(nil, opposite_color).any? do |coordinate|
      PossibleMoves.new(at(coordinate), coordinate, self, false).moves.
          any? { |move| move.kind == :capture && move.options[:captured].figure == :king }
    end
  end

  # check inputted color is in mate(checkmate) state, i.e. after all possible moves inputted color is in shah state, or
  # now is in shah state and no possible moves
  # @param color [Symbol]
  def mate?(color)
    turn_moves = []
    where_is(nil, color).each do |coordinate|
      figure_moves = PossibleMoves.new(at(coordinate), coordinate, self)
      turn_moves << figure_moves unless figure_moves.moves.empty?
    end
    shah?(color) if turn_moves.empty?
    turn_moves.all? do |figure_moves|
      figure_moves.moves.all? do |move_action|
        move(move_action).shah?(color)
      end
    end
  end

  # check inputted color is in stalemate state, i.e. now isn't in shah state and no possible moves
  # @param color [Symbol]
  def stalemate?(color)
    turn_moves = []
    where_is(nil, color).each do |coordinate|
      figure_moves = PossibleMoves.new(at(coordinate), coordinate, self)
      turn_moves << figure_moves unless figure_moves.moves.empty?
    end
    return false unless turn_moves.empty?
    !shah?(color)
  end

  # check is in deadmate state, i.e. both colors figures can move, but can't beat other, so can't win or lose
  def deadmate?
    figure_types = []
    @board.flatten.each do |figure|
      figure_types << figure.figure if !figure.nil? &&
          !figure_types.include?(figure.figure)
    end
    figure_types.length == 1 && figure_types.first == :king
  end

  # draw in Unix console current board state with figures, and rotated to white or black figures side
  # @param rotate [Boolean] true - white, false - black
  # @return [Void]
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

  # set background color for board cells
  def bg_color(string, color_i)
    color_i.odd? ? "\e[46m#{string}\e[0m" : "\e[44m#{string}\e[0m"
  end
end
