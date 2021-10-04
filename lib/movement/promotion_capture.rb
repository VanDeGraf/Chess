class PromotionCapture < Promotion
  attr_reader :captured

  # @param figure [Figure]
  # @param point_start [Coordinate]
  # @param point_end [Coordinate]
  # @param captured [Figure]
  # @param promoted_to [Figure]
  def initialize(figure, point_start, point_end, captured, promoted_to)
    super(figure, point_start, point_end, promoted_to)
    @captured = captured
  end

  def to_s
    "move #{@figure} from #{@point_start} and capture #{@captured} at #{@point_end}, then promotion to #{@promoted_to}"
  end

  def algebraic_notation(file: false, rank: false)
    file = file ? @point_start.to_s.split('')[0] : ''
    rank = rank ? @point_start.to_s.split('')[1] : ''
    "#{@figure.algebraic_notation}#{file}#{rank}x#{@point_end}=#{@promoted_to.algebraic_notation}"
  end
end
