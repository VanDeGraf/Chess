class EnPassant < Capture
  attr_reader :captured_at

  # @param figure [Figure]
  # @param point_start [Coordinate]
  # @param point_end [Coordinate]
  # @param captured [Figure]
  # @param captured_at [Coordinate]
  def initialize(figure, point_start, point_end, captured, captured_at)
    super(figure, point_start, point_end, captured)
    @captured_at = captured_at
  end

  def special?
    true
  end

  def to_s
    "en passant from #{@point_start} to #{@point_end}"
  end

  def algebraic_notation
    file = @point_start.to_s.split('')[0]
    "#{file}x#{@point_end}"
  end

  def perform_movement(board)
    super
    board.remove_at!(captured_at)
  end
end
