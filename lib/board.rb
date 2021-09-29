require_relative 'coordinate'
require_relative 'figure'
require_relative 'movement/movement_generator'
require_relative 'repetition_log'
require_relative 'board_state'
# Chess board, contains figures and methods for move it, checking position status for situations like shah(check),
# mate(checkmate), draw and other
class Board
  attr_reader :history, :eaten, :repetition_log, :state

  def initialize
    # @type [Array<Array<Figure,nil>>]
    @board = Array.new(8) { Array.new(8) }
    init_board_cells
    # @type [Array<Figure>]
    @eaten = []
    # @type [Array<Movement>]
    @history = []
    @repetition_log = RepetitionLog.new
    @state = BoardState.new(self)
  end

  def init_board_row(color, row_number)
    @board[row_number] = [
      Figure.new(:rook, color),
      Figure.new(:knight, color),
      Figure.new(:bishop, color),
      Figure.new(:queen, color),
      Figure.new(:king, color),
      Figure.new(:bishop, color),
      Figure.new(:knight, color),
      Figure.new(:rook, color)
    ]
  end

  def init_pawn_row(color, row_number)
    8.times do |i|
      @board[row_number][i] = Figure.new(:pawn, color)
    end
  end

  def init_board_cells
    init_board_row(:white, 0)
    init_pawn_row(:white, 1)
    init_pawn_row(:black, 6)
    init_board_row(:black, 7)
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
  # @param movement [Movement]
  # @return [Void]
  def move!(movement, repetition_hash: true)
    return if movement.nil?

    captured = movement.perform_movement(self)
    @eaten << captured unless captured.nil?
    @history << movement
    @repetition_log.add!(movement, self) if repetition_hash
    @state.clear!
  end

  # in clone of current board do move and return that clone
  # @param action [Movement]
  # @return [Board]
  def move(action)
    new_board = clone
    new_board.move!(action, repetition_hash: false)
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
  # @param figure_type [Symbol,nil] nil return any figure type
  # @param figure_color [Symbol,nil] nil return both figure color
  # @return [Array<Coordinate>] empty array if not found
  def where_is(figure_type = nil, figure_color = nil)
    positions = []
    each_figure(skip_empty: true) do |figure, x, y|
      positions << Coordinate.new(x, y) if (figure_type.nil? || figure.figure == figure_type) &&
                                           (figure_color.nil? || figure.color == figure_color)
    end
    positions
  end

  # @param skip_empty [Boolean] skip cells without figure
  # @yieldparam figure [Figure, nil]
  # @yieldparam x [Integer]
  # @yieldparam y [Integer]
  def each_figure(skip_empty: false)
    @board.each_index do |y|
      @board[y].each_index do |x|
        figure = @board[y][x]
        next if skip_empty && figure.nil?

        yield(figure, x, y)
      end
    end
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
    new_board.instance_variable_set(:@repetition_log, @repetition_log.clone)
    new_board.instance_variable_set(:@state, @state.clone(new_board))
    new_board
  end

  # @param color [Symbol]
  # @return [Array<Movement>]
  def possible_moves(color)
    (where_is(nil, color).map do |coordinate|
      MovementGenerator.generate_from(coordinate, self)
    end + MovementGenerator.castling(self, color)).flatten
  end
end
