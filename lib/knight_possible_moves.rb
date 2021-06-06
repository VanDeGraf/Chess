require './lib/figure_possible_moves'
# knight moves generator
class KnightPossibleMoves < FigurePossibleMoves
  # @return [Array<Move>]
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
