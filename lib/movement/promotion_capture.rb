class PromotionCapture < Capture
  attr_reader :promoted_to

  # @param figure [Figure]
  # @param point_start [Coordinate]
  # @param point_end [Coordinate]
  # @param captured [Figure]
  # @param promoted_to [Figure]
  def initialize(figure, point_start, point_end, captured, promoted_to)
    super(figure, point_start, point_end, captured)
    @promoted_to = promoted_to
  end

  def special?
    true
  end

  def to_s
    "#{super}, then promotion to #{@promoted_to}"
  end

  def algebraic_notation(file: false, rank: false)
    file = file ? @point_start.to_s.split('')[0] : ''
    rank = rank ? @point_start.to_s.split('')[1] : ''
    "#{@figure.algebraic_notation}#{file}#{rank}x#{@point_end}=#{@promoted_to.algebraic_notation}"
  end

  PROMOTION_FIGURES = %i[queen knight rook bishop].freeze

  # @param capture [Capture]
  # @return [Array<PromotionCapture>]
  def self.from_capture(capture)
    PROMOTION_FIGURES.map do |figure_type|
      new(capture.figure, capture.point_start, capture.point_end, capture.captured,
          Figure.new(figure_type, capture.figure.color))
    end
  end
end
