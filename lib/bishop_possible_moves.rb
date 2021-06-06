require './lib/figure_possible_moves'
# bishop moves generator
class BishopPossibleMoves < FigurePossibleMoves
  def generate_moves
    get_moves_by_direction([
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
