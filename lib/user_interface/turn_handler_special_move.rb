class TurnHandlerSpecialMove < TurnHandler
  def initialize(special_moves, move_index)
    super()
    @special_moves = special_moves
    @move_index = move_index
  end

  def perform_action
    return @special_moves[@move_index] if !@special_moves.empty? && @move_index.between?(0, @special_moves.length - 1)

    nil
  end

  def error_msg
    'Mismatch number of special move choice.'
  end

  # @param special_moves [Array<Movement>]
  def self.create_filter(special_moves)
    InputFilter.new(/^(s (\d+))$/, handler: proc { |match_data|
      new(special_moves, match_data[2].to_i - 1)
    })
  end
end
