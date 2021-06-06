# generate possible moves of figure, depends by type and color of it, and depends by other figures on board
class PossibleMoves
  # @param figure [Figure]
  # @param start [Coordinate]
  # @param board [Board]
  # @param check_shah [Boolean]
  def initialize(figure, start, board)
    # @type [Figure]
    @figure = figure
    # @type [Coordinate]
    @start_coordinate = start
    # @type [Board]
    @board = board
  end

  # @return [Array<Move>]
  def generate_moves
    case @figure.figure
    when :pawn
      PawnPossibleMoves.new(@figure, @start_coordinate, @board).generate_moves
    when :knight
      KnightPossibleMoves.new(@figure, @start_coordinate, @board).generate_moves
    when :king
      KingPossibleMoves.new(@figure, @start_coordinate, @board).generate_moves
    when :bishop
      BishopPossibleMoves.new(@figure, @start_coordinate, @board).generate_moves
    when :rook
      RookPossibleMoves.new(@figure, @start_coordinate, @board).generate_moves
    when :queen
      BishopPossibleMoves.new(@figure, @start_coordinate, @board).generate_moves +
        RookPossibleMoves.new(@figure, @start_coordinate, @board).generate_moves
    else
      []
    end
  end

  # @param coordinate [Coordinate]
  # @param board [Board]
  # @return [Array<Move>]
  def self.generate_from(coordinate, board, check_shah: true)
    figure = board.at(coordinate)
    return [] if figure.nil?

    moves = new(figure, coordinate, board).generate_moves
    moves = moves.map { |move| board.move(move).shah?(figure.color) ? nil : move }.compact if check_shah
    moves
  end

  # king and rook can do special move named castling, it possible, if king never move, not state shah on current and on
  # every path cells, one of rooks never moved and between them cells is empty.
  # @param board [Board]
  # @param color [Symbol]
  # @return [Array<Move>]
  def self.castling(board, color)
    moves = []
    return moves if board.shah?(color) || board.history.any? do |move|
      move.options[:figure].figure == :king &&
      move.options[:figure].color == color
    end

    king_coordinate = board.where_is(:king, color).first
    return moves if king_coordinate.nil?

    king_figure = board.at(king_coordinate)
    y = color == :white ? 0 : 7

    %i[castling_short castling_long].each do |castling_type|
      direction = color == :white ? -1 : 1
      if castling_type == :castling_short
        direction = color == :white ? 1 : -1
        rook_coordinate = Coordinate.new(3 * direction, y)
      else
        rook_coordinate = Coordinate.new(4 * direction, y)
        next unless board.there_empty?(king_coordinate.relative(3 * direction, 0))
      end

      next unless board.there_empty?(king_coordinate.relative(1 * direction, 0)) &&
                  board.there_empty?(king_coordinate.relative(2 * direction, 0)) &&
                  board.there_ally?(color, rook_coordinate) &&
                  board.history.none? { |move| move.options[:point_start] == rook_coordinate } &&
                  !board.move(Move.new(:move, {
                                         figure: king_figure,
                                         point_start: king_coordinate,
                                         point_end: king_coordinate.relative(1 * direction, 0)
                                       })).shah?(color) &&
                  !board.move(Move.new(:move, {
                                         figure: king_figure,
                                         point_start: king_coordinate,
                                         point_end: king_coordinate.relative(2 * direction, 0)
                                       })).shah?(color)

      moves << Move.new(castling_type, {
                          figure: king_figure,
                          support_figure: board.at(rook_coordinate),
                          king_point_start: king_coordinate,
                          king_point_end: king_coordinate.relative(2 * direction, 0),
                          rook_point_start: rook_coordinate,
                          rook_point_end: king_coordinate.relative(1 * direction, 0)
                        })
    end
    moves
  end

  private

  # @overload get_move_relative(x,y)
  #   @param x [Numeric]
  #   @param y [Numeric]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Move, nil]
  # @overload get_move_relative(moves)
  #   @param moves [Array<Array<Fixnum>>]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Move>]
  def get_move_relative(*args, &block)
    if args.length == 2 && args[0].is_a?(Integer) && args[1].is_a?(Integer)
      point = @start_coordinate.relative(args[0], args[1])
      if yield(point)
        if @board.there_empty?(point)
          Move.new(:move, {
                     figure: @figure,
                     point_start: @start_coordinate,
                     point_end: point
                   })
        else
          Move.new(:capture, {
                     figure: @figure,
                     point_start: @start_coordinate,
                     point_end: point,
                     captured: @board.at(point)
                   })
        end
      end
    elsif args.length == 1 && args[0].is_a?(Array)
      args[0].map { |relative| get_move_relative(relative[0], relative[1], &block) }.compact
    else
      raise ArgumentError
    end
  end

  # @overload get_moves_by_direction(x,y)
  #   @param x [Fixnum]
  #   @param y [Fixnum]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Move>]
  # @overload get_moves_by_direction(directions)
  #   @param directions [Array<Array<Fixnum>>]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Move>]
  def get_moves_by_direction(*args, &block)
    if args.length == 2 && args[0].is_a?(Integer) && args[1].is_a?(Integer)
      moves = []
      iteration = 1
      loop do
        move = get_move_relative(args[0] * iteration, args[1] * iteration, &block)
        break if move.nil?

        moves << move
        break if move.kind == :capture

        iteration += 1
      end
      moves
    elsif args.length == 1 && args[0].is_a?(Array)
      args[0].map { |direction| get_moves_by_direction(direction[0], direction[1], &block) }.flatten
    end
  end
end
