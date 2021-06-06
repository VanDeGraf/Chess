require './lib/figure_possible_moves'
# king moves generator
class KingPossibleMoves < FigurePossibleMoves
  # @return [Array<Move>]
  def generate_moves
    opposite_color = @figure.color == :white ? :black : :white
    enemy_king_coordinate = @board.where_is(:king, opposite_color).first

    get_move_relative([
                        [-1, 1],
                        [0, 1],
                        [1, 1],
                        [1, 0],
                        [1, -1],
                        [0, -1],
                        [-1, -1],
                        [-1, 0]
                      ]) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point)) &&
        (enemy_king_coordinate.nil? ||
          Math.sqrt((enemy_king_coordinate.x - point.x)**2 + (enemy_king_coordinate.y - point.y)**2) >= 2)
    end
  end
end
