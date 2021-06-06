# bishop moves generator
class BishopPossibleMoves < PossibleMoves
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
