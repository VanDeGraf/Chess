class Move < Movement
  attr_reader :point_start, :point_end

  # @param figure [Figure]
  # @param point_start [Coordinate]
  # @param point_end [Coordinate]
  def initialize(figure, point_start, point_end)
    super(figure)
    @point_start = point_start
    @point_end = point_end
  end

  def special?
    false
  end

  def to_s
    "move #{@figure} from #{@point_start} to #{@point_end}"
  end
end
