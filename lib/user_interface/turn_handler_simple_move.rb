class TurnHandlerSimpleMove < TurnHandler
  def initialize(default_moves, point_start, point_end)
    super()
    @point_start = point_start
    @point_end = point_end
    @default_moves = default_moves
  end

  def perform_action
    @default_moves.any? do |move|
      return move if move.point_start == @point_start &&
                     move.point_end == @point_end
    end
    nil
  end

  def error_msg
    "Sorry, you can't move here (or from)."
  end

  # @param default_moves [Array<Movement>]
  def self.create_filter(default_moves)
    InputFilter.new(/^(([a-h][1-8]) ([a-h][1-8]))$/, handler: proc { |match_data|
      new(default_moves, match_data[2], match_data[3])
    })
  end
end
