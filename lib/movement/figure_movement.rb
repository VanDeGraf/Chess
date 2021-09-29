require_relative 'movement'
require_relative 'move'
require_relative 'capture'
require_relative 'castling'
require_relative 'en_passant'
require_relative 'promotion_move'
require_relative 'promotion_capture'
require_relative '../board'
# generate possible moves of figure, depends by type and color of it, and depends by other figures on board
class FigureMovement
  # @param figure [Figure]
  # @param start [Coordinate]
  # @param board [Board]
  def initialize(figure, start, board)
    # @type [Figure]
    @figure = figure
    # @type [Coordinate]
    @start_coordinate = start
    # @type [Board]
    @board = board
  end

  private

  # @param coordinate_x [Numeric]
  # @param coordinate_y [Numeric]
  # @yieldparam point [Coordinate]
  # @yieldreturn [Boolean]
  # @return [Move]
  def create_move_relative(coordinate_x, coordinate_y)
    point = @start_coordinate.relative(coordinate_x, coordinate_y)
    return unless yield(point)

    if @board.there_empty?(point)
      Move.new(@figure, @start_coordinate, point)
    else
      Capture.new(@figure, @start_coordinate, point, @board.at(point))
    end
  end

  # @param moves [Array<Array<Fixnum>>]
  # @yieldparam point [Coordinate]
  # @yieldreturn [Boolean]
  # @return [Array<Move>]
  def create_moves_relative_many(moves, &block)
    moves.map { |relative| create_move_relative(relative[0], relative[1], &block) }.compact
  end

  # @param coordinate_x [Numeric]
  # @param coordinate_y [Numeric]
  # @yieldparam point [Coordinate]
  # @yieldreturn [Boolean]
  # @return [Array<Move>]
  def create_moves_by_direction(coordinate_x, coordinate_y, &block)
    moves = []
    iteration = 1
    loop do
      move = create_move_relative(coordinate_x * iteration, coordinate_y * iteration, &block)
      break if move.nil?

      moves << move
      break if move.is_a?(Capture)

      iteration += 1
    end
    moves
  end

  # @param directions [Array<Array<Fixnum>>]
  # @yieldparam point [Coordinate]
  # @yieldreturn [Boolean]
  # @return [Array<Move>]
  def create_moves_by_many_direction(directions, &block)
    directions.map { |direction| create_moves_by_direction(direction[0], direction[1], &block) }.flatten
  end
end
