require_relative 'figure_movement'
# knight moves generator
class KnightMovement < FigureMovement
  # @return [Array<Movement>]
  def generate_moves
    create_moves_relative_many(KNIGHT_RELATIVE_MOVEMENT_TABLE) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point))
    end
  end

  KNIGHT_RELATIVE_MOVEMENT_TABLE = [
    [-1, 2],
    [1, 2],
    [-1, -2],
    [1, -2],
    [-2, 1],
    [-2, -1],
    [2, 1],
    [2, -1]
  ].freeze
end
