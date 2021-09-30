class CastlingGenerator
  def initialize(board, color)
    @board = board
    @color = color
    # @type [Coordinate]
    @king_coordinate = board.where_is(:king, color).first
  end

  # @param side [Symbol]
  # @return [Movement, nil]
  def generate_side(side)
    return if king_moves_ever?

    side_direction = side == :castling_short ? 1 : -1
    rook_start_point = calculate_rook_start_point(side)

    return unless path_between_pieces_clear?(side_direction)
    return if rook_moves_ever?(rook_start_point)
    return if king_path_on_shah?(side_direction)

    castling_instance(side_direction, rook_start_point)
  end

  def king_moves_ever?
    @king_coordinate.nil? ||
      @board.at(@king_coordinate).nil? ||
      @board.history.any? do |move|
        move.figure.figure == :king &&
          move.figure.color == @color
      end
  end

  def calculate_rook_start_point(side)
    if side == :castling_short
      @king_coordinate.relative(3, 0)
    else
      @king_coordinate.relative(-4, 0)
    end
  end

  def path_between_pieces_clear?(side_direction)
    return false if side_direction.negative? &&
                    !@board.there_empty?(@king_coordinate.relative(-3, 0))

    @board.there_empty?(@king_coordinate.relative(1 * side_direction, 0)) &&
      @board.there_empty?(@king_coordinate.relative(2 * side_direction, 0))
  end

  def rook_moves_ever?(rook_start_point)
    @board.history.any? do |move|
      next unless move.is_a?(Move) || move.is_a?(Capture)

      move.point_start == rook_start_point
    end ||
      @board.at(rook_start_point).nil?
  end

  def king_path_on_shah?(side_direction)
    @board.state.shah?(@color) ||
      @board.move(Move.new(@board.at(@king_coordinate), @king_coordinate,
                           @king_coordinate.relative(-1 * side_direction, 0))).state.shah?(@color) ||
      @board.move(Move.new(@board.at(@king_coordinate), @king_coordinate,
                           @king_coordinate.relative(-2 * side_direction, 0))).state.shah?(@color)
  end

  def castling_instance(side_direction, rook_start_point)
    Castling.new(
      @board.at(@king_coordinate),
      @board.at(rook_start_point),
      @king_coordinate,
      @king_coordinate.relative(2 * side_direction, 0),
      rook_start_point,
      @king_coordinate.relative(1 * side_direction, 0),
      side_direction.positive?
    )
  end
end
