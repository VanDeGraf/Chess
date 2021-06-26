require_relative 'figure_movement'
# pawn moves generator
class PawnMovement < FigureMovement
  def initialize(figure, start, board)
    super
    @move_direction = @figure.color == :white ? 1 : -1
    @promotion_figures = %i[queen knight rook bishop]
  end

  def generate_moves
    moves = []
    toward_move = move_towards_once
    unless toward_move.nil?
      moves << toward_move
      moves += promotions_after_move(toward_move)
    end
    twice_toward_move = move_towards_twice
    moves << twice_toward_move unless twice_toward_move.nil?
    captured = capture
    moves += captured
    moves += promotions_after_capture(captured)
    moves + en_passant
  end

  private

  def move_towards_once
    get_move_relative(0, 1 * @move_direction) do |point|
      @board.on_board?(point) && @board.there_empty?(point)
    end
  end

  def move_towards_twice
    get_move_relative(0, 2 * @move_direction) do |point|
      (@start_coordinate.y == 1 || @start_coordinate.y == 6) &&
        @board.there_empty?(point)
    end
  end

  # @param move [Move]
  # @return [Array<PromotionMove>]
  def promotions_after_move(move)
    return [] unless move.point_end.y.zero? || move.point_end.y == 7

    PromotionMove.from_move(move)
  end

  def capture
    get_move_relative([[-1, 1 * @move_direction], [1, 1 * @move_direction]]) do |point|
      @board.on_board?(point) && @board.there_enemy?(@figure, point)
    end
  end

  # @param capture_moves [Array<Capture>]
  # @return [Array<PromotionCapture>]
  def promotions_after_capture(capture_moves)
    moves = []
    capture_moves.each do |move|
      next unless move.point_end.y.zero? || move.point_end.y == 7

      moves += PromotionCapture.from_capture(move)
    end
    moves
  end

  # @return [Array<EnPassant>]
  def en_passant
    moves = []
    [-1, 1].each do |shift|
      enemy_point_start = @start_coordinate.relative(shift, @move_direction * 2)
      enemy_point_end = @start_coordinate.relative(shift, 0)
      last_move = @board.history.last
      next unless !last_move.nil? &&
                  last_move.is_a?(Move) &&
                  last_move.figure.figure == :pawn &&
                  last_move.point_end == enemy_point_end &&
                  last_move.point_start == enemy_point_start

      moves << EnPassant.new(
        @figure,
        @start_coordinate,
        @start_coordinate.relative(shift, @move_direction),
        last_move.figure,
        enemy_point_end
      )
    end
    moves
  end
end