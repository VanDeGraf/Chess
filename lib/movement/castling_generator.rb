class CastlingGenerator
  def initialize(board, color)
    @board = board
    @color = color
    @king_coordinate = board.where_is(:king, color).first
  end

  # king and rook can do special move named castling, it possible, if king never move, not state shah on current and on
  # every path cells, one of rooks never moved and between them cells is empty.
  # @return [Array<Movement>]
  def generate
    moves = []
    return moves if @king_coordinate.nil? || !king_can_castling?

    %i[castling_short castling_long].each do |castling_type|
      direction = castling_direction(castling_type)
      rook_coordinate = castling_rook_coordinate(castling_type, direction)
      next unless castling_condition_verify?(rook_coordinate, castling_type, direction)

      moves << castling_instance(castling_type, direction, rook_coordinate)
    end
    moves
  end

  def king_can_castling?
    !@board.state.shah?(@color) && @board.history.none? do |move|
      move.figure.figure == :king &&
        move.figure.color == @color
    end
  end

  def castling_direction(castling_type)
    if castling_type == :castling_short
      @color == :white ? 1 : -1
    else
      @color == :white ? -1 : 1
    end
  end

  def castling_rook_coordinate(castling_type, direction)
    x = castling_type == :castling_short ? 3 : 4
    y = @color == :white ? 0 : 7
    Coordinate.new(x * direction, y)
  end

  def castling_condition_verify?(rook_coordinate, castling_type, direction)
    castling_path_clear?(castling_type, direction) &&
      !castling_rook_move?(rook_coordinate) &&
      !castling_path_shah?(direction)
  end

  def castling_path_clear?(castling_type, direction)
    false if castling_type == :castling_long && !@board.there_empty?(@king_coordinate.relative(3 * direction, 0))
    @board.there_empty?(@king_coordinate.relative(1 * direction, 0)) &&
      @board.there_empty?(@king_coordinate.relative(2 * direction, 0))
  end

  def castling_rook_move?(rook_coordinate)
    !@board.there_ally?(@color, rook_coordinate) ||
      @board.history.any? { |move| move.point_start == rook_coordinate }
  end

  def castling_path_shah?(direction)
    king_figure = @board.at(@king_coordinate)
    @board.move(Move.new(king_figure, @king_coordinate,
                         @king_coordinate.relative(1 * direction, 0))).state.shah?(@color) ||
      @board.move(Move.new(king_figure, @king_coordinate,
                           @king_coordinate.relative(2 * direction, 0))).state.shah?(@color)
  end

  def castling_instance(castling_type, direction, rook_coordinate)
    Castling.new(
      @board.at(@king_coordinate),
      @board.at(rook_coordinate),
      @king_coordinate,
      @king_coordinate.relative(2 * direction, 0),
      rook_coordinate,
      @king_coordinate.relative(1 * direction, 0),
      castling_type == :castling_short
    )
  end
end
