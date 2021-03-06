require_relative 'figure_movement'
# bishop moves generator
class BishopMovement < FigureMovement
  def generate_moves
    create_moves_by_many_direction([
                                     [1, 1],
                                     [1, -1],
                                     [-1, -1],
                                     [-1, 1]
                                   ]) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point))
    end
  end
end
