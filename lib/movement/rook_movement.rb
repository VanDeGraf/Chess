require_relative 'figure_movement'
# rook moves generator
class RookMovement < FigureMovement
  def generate_moves
    create_moves_by_many_direction([
                                     [0, 1],
                                     [1, 0],
                                     [0, -1],
                                     [-1, 0]
                                   ]) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point))
    end
  end
end
