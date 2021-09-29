require_relative 'figure_movement'
# queen moves generator
class QueenMovement < FigureMovement
  def generate_moves
    BishopMovement.new(@figure, @start_coordinate, @board).generate_moves +
      RookMovement.new(@figure, @start_coordinate, @board).generate_moves
  end
end
