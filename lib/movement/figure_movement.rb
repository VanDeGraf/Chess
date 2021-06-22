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

  # @overload get_move_relative(x,y)
  #   @param x [Numeric]
  #   @param y [Numeric]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Move, Capture, nil]
  # @overload get_move_relative(moves)
  #   @param moves [Array<Array<Fixnum>>]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Move, Capture>]
  def get_move_relative(*args, &block)
    if args.length == 2 && args[0].is_a?(Integer) && args[1].is_a?(Integer)
      point = @start_coordinate.relative(args[0], args[1])
      if yield(point)
        if @board.there_empty?(point)
          Move.new(@figure, @start_coordinate, point)
        else
          Capture.new(@figure, @start_coordinate, point, @board.at(point))
        end
      end
    elsif args.length == 1 && args[0].is_a?(Array)
      args[0].map { |relative| get_move_relative(relative[0], relative[1], &block) }.compact
    end
  end

  # @overload get_moves_by_direction(x,y)
  #   @param x [Fixnum]
  #   @param y [Fixnum]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Move, Capture>]
  # @overload get_moves_by_direction(directions)
  #   @param directions [Array<Array<Fixnum>>]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Move, Capture>]

  def get_moves_by_direction(*args, &block)
    if args.length == 2 && args[0].is_a?(Integer) && args[1].is_a?(Integer)
      moves = []
      iteration = 1
      loop do
        move = get_move_relative(args[0] * iteration, args[1] * iteration, &block)
        break if move.nil?

        moves << move
        break if move.is_a?(Capture)

        iteration += 1
      end
      moves
    elsif args.length == 1 && args[0].is_a?(Array)
      args[0].map { |direction| get_moves_by_direction(direction[0], direction[1], &block) }.flatten
    end
  end
end
