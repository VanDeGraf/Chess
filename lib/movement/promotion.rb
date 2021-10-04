class Promotion < Movement
  attr_reader :point_start, :point_end, :promoted_to

  # @param figure [Figure]
  # @param point_start [Coordinate]
  # @param point_end [Coordinate]
  # @param promoted_to [Figure]
  def initialize(figure, point_start, point_end, promoted_to)
    super(figure)
    @point_start = point_start
    @point_end = point_end
    @promoted_to = promoted_to
  end

  def special?
    true
  end

  def perform_movement(board)
    board.remove_at!(point_start)
    board.replace_at!(point_end, promoted_to)
  end

  PROMOTION_FIGURES = %i[queen knight rook bishop].freeze

  # @param move [Move, Capture]
  def self.on_promotion_path?(move)
    (move.point_end.y.zero? && move.figure.color == :black) ||
      (move.point_end.y == 7 && move.figure.color == :white)
  end

  # @param move [Move, Capture]
  # @return [Array<PromotionMove,PromotionCapture>]
  def self.from_movement(move)
    return [] unless on_promotion_path?(move)

    PROMOTION_FIGURES.map { |figure_type| from_movement_by_figure(move, figure_type) }
  end

  # @param move [Move, Capture]
  # @param figure_type [Symbol]
  # @return [PromotionMove, PromotionCapture]
  def self.from_movement_by_figure(move, figure_type)
    if move.is_a?(Capture)
      PromotionCapture.new(move.figure, move.point_start, move.point_end, move.captured,
                           Figure.new(figure_type, move.figure.color))
    else
      PromotionMove.new(move.figure, move.point_start, move.point_end,
                        Figure.new(figure_type, move.figure.color))
    end
  end
end
