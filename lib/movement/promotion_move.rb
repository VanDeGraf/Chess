class PromotionMove < Move
  attr_reader :promoted_to

  # @param figure [Figure]
  # @param point_start [Coordinate]
  # @param point_end [Coordinate]
  # @param promoted_to [Figure]
  def initialize(figure, point_start, point_end, promoted_to)
    super(figure, point_start, point_end)
    @promoted_to = promoted_to
  end

  def special?
    true
  end

  def to_s
    "#{super}, then promotion to #{@promoted_to}"
  end

  PROMOTION_FIGURES = %i[queen knight rook bishop].freeze

  # @param move [Move]
  # @return [Array<PromotionMove>]
  def self.from_move(move)
    PROMOTION_FIGURES.map do |figure_type|
      new(move.figure, move.point_start, move.point_end, Figure.new(figure_type, move.figure.color))
    end
  end
end
