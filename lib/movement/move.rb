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

  def algebraic_notation(file: false, rank: false)
    file = file ? @point_start.to_s.split('')[0] : ''
    rank = rank ? @point_start.to_s.split('')[1] : ''
    "#{@figure.algebraic_notation}#{file}#{rank}#{@point_end}"
  end

  def perform_movement(board)
    board.remove_at!(point_start)
    board.replace_at!(point_end, figure)
  end
end
