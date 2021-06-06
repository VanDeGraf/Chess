require './lib/figure_possible_moves'
# rook moves generator
class RookPossibleMoves < FigurePossibleMoves
  def generate_moves
    get_moves_by_direction([
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