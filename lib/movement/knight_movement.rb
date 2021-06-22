require_relative 'figure_movement'
# knight moves generator
class KnightMovement < FigureMovement
  # @return [Array<Movement>]
  def generate_moves
    get_move_relative([
                        [-1, 2],
                        [1, 2],
                        [-1, -2],
                        [1, -2],
                        [-2, 1],
                        [-2, -1],
                        [2, 1],
                        [2, -1]
                      ]) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point))
    end
  end
end
