class TurnHandlerSimpleMove < TurnHandler
  # @param game [Game]
  # @param default_moves [Array<Movement>]
  # @param point_start [Coordinate]
  # @param point_end [Coordinate]
  def initialize(game, default_moves, point_start, point_end)
    super()
    @point_start = point_start
    @point_end = point_end
    @default_moves = default_moves
    @game = game
  end

  def perform_action
    @default_moves.any? do |move|
      return @game.perform_movement(move) if move.point_start == @point_start &&
                                             move.point_end == @point_end
    end
    @has_error = true
    nil
  end

  def error_msg
    "Sorry, you can't move here (or from)."
  end

  # @param game [Game]
  # @param default_moves [Array<Movement>]
  def self.create_filter(game, default_moves)
    InputFilter.new(/^(([a-h][1-8]) ([a-h][1-8]))$/, handler: proc { |match_data|
      new(game, default_moves, Coordinate.from_s(match_data[2]), Coordinate.from_s(match_data[3]))
    })
  end
end
