require_relative 'figure_possible_moves'
# pawn moves generator
class PawnPossibleMoves < FigurePossibleMoves
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
  # @return [Array<Move>]
  def promotions_after_move(move)
    return [] unless move.options[:point_end].y.zero? || move.options[:point_end].y == 7

    @promotion_figures.map do |figure_type|
      Move.new(:promotion_move, {
                 figure: move.options[:figure],
                 point_start: move.options[:point_start],
                 point_end: move.options[:point_end],
                 promoted_to: Figure.new(figure_type, move.options[:figure].color)
               })
    end
  end

  # @return [Array<Move>]
  def capture
    get_move_relative([[-1, 1 * @move_direction], [1, 1 * @move_direction]]) do |point|
      @board.on_board?(point) && @board.there_enemy?(@figure, point)
    end
  end

  # @param capture_moves [Array<Move>]
  # @return [Array<Move>]
  def promotions_after_capture(capture_moves)
    moves = []
    capture_moves.each do |move|
      next unless move.options[:point_end].y.zero? || move.options[:point_end].y == 7

      @promotion_figures.each do |figure_type|
        moves << Move.new(:promotion_capture, {
                            figure: move.options[:figure],
                            point_start: move.options[:point_start],
                            point_end: move.options[:point_end],
                            promoted_to: Figure.new(figure_type, move.options[:figure].color),
                            captured: move.options[:captured]
                          })
      end
    end
    moves
  end

  # @return [Array<Move>]
  def en_passant
    moves = []
    [-1, 1].each do |shift|
      enemy_point_start = @start_coordinate.relative(shift, @move_direction * 2)
      enemy_point_end = @start_coordinate.relative(shift, 0)
      last_move = @board.history.last
      next unless !last_move.nil? &&
                  last_move.kind == :move &&
                  last_move.options[:figure].figure == :pawn &&
                  last_move.options[:point_end] == enemy_point_end &&
                  last_move.options[:point_start] == enemy_point_start

      moves << Move.new(:en_passant, {
                          figure: @figure,
                          point_start: @start_coordinate,
                          point_end: @start_coordinate.relative(shift, @move_direction),
                          captured: last_move.options[:figure],
                          captured_at: enemy_point_start
                        })
    end
    moves
  end
end
