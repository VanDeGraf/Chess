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
end
