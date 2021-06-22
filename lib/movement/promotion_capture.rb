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

  PROMOTION_FIGURES = %i[queen knight rook bishop].freeze

  # @param capture [Capture]
  # @return [Array<PromotionCapture>]
  def self.from_capture(capture)
    PROMOTION_FIGURES.map do |figure_type|
      new(capture.figure, capture.point_start, capture.point_end, capture.captured, Figure.new(figure_type, capture.figure.color))
    end
  end
end
