class Castling < Movement
  attr_reader :rook, :king_point_end, :short, :king_point_start, :rook_point_start, :rook_point_end

  # @param king [Figure]
  # @param rook [Figure]
  # @param king_point_start [Coordinate]
  # @param king_point_end [Coordinate]
  # @param rook_point_start [Coordinate]
  # @param rook_point_end [Coordinate]
  # @param short [Boolean]
  def initialize(
    king,
    rook,
    king_point_start,
    king_point_end,
    rook_point_start,
    rook_point_end,
    short
  )
    super(king)
    @rook = rook
    @king_point_start = king_point_start
    @king_point_end = king_point_end
    @rook_point_start = rook_point_start
    @rook_point_end = rook_point_end
    @short = short
  end

  def special?
    true
  end

  def to_s
    "castling #{@short ? 'short' : 'long'}"
  end

  def algebraic_notation
    @short ? 'O-O' : 'O-O-O'
  end

  def perform_movement(board)
    board.remove_at!(king_point_start)
    board.replace_at!(king_point_end, figure)
    board.remove_at!(rook_point_start)
    board.replace_at!(rook_point_end, rook)
    nil
  end
end
