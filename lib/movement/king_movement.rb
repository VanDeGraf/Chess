require_relative 'figure_movement'
# king moves generator
class KingMovement < FigureMovement
  # @return [Array<Movement>]
  def generate_moves
    opposite_color = @figure.color == :white ? :black : :white
    enemy_king_coordinate = @board.where_is(:king, opposite_color).first

    get_move_relative(KING_RELATIVE_MOVEMENT_TABLE) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point)) &&
        (enemy_king_coordinate.nil? || distance_between_kings_enough(point, enemy_king_coordinate))
    end
  end

  # @param king1 [Coordinate]
  # @param king2 [Coordinate]
  def distance_between_kings_enough(king1, king2)
    Math.sqrt((king2.x - king1.x)**2 + (king2.y - king1.y)**2) >= 2
  end

  KING_RELATIVE_MOVEMENT_TABLE = [
    [-1, 1],
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1],
    [-1, -1],
    [-1, 0]
  ].freeze
end
