class Capture < Move
  attr_reader :captured

  # @param figure [Figure]
  # @param point_start [Coordinate]
  # @param point_end [Coordinate]
  # @param captured [Figure]
  def initialize(figure, point_start, point_end, captured)
    super(figure, point_start, point_end)
    @captured = captured
  end
end
