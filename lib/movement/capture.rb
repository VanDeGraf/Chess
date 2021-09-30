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

  def to_s
    "move #{@figure} from #{@point_start} and capture #{@captured} at #{@point_end}"
  end

  def algebraic_notation(file: false, rank: false)
    file = true if @figure.figure == :pawn

    file = file ? @point_start.to_s.split('')[0] : ''
    rank = rank ? @point_start.to_s.split('')[1] : ''
    "#{@figure.algebraic_notation}#{file}#{rank}x#{@point_end}"
  end
end
