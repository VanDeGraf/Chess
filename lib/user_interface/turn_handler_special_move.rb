class TurnHandlerSpecialMove < TurnHandler
  # @param game [Game]
  # @param special_moves [Array<Movement>]
  # @param move_index [Integer]
  def initialize(game, special_moves, move_index)
    super()
    @special_moves = special_moves
    @move_index = move_index
    @game = game
  end

  def perform_action
    if !@special_moves.empty? && @move_index.between?(0, @special_moves.length - 1)
      return @game.perform_movement(@special_moves[@move_index])
    end

    @has_error = true
    nil
  end

  def error_msg
    'Mismatch number of special move choice.'
  end

  # @param game [Game]
  # @param special_moves [Array<Movement>]
  def self.create_filter(game, special_moves)
    InputFilter.new(/^(s (\d+))$/, handler: proc { |match_data|
      new(game, special_moves, match_data[2].to_i - 1)
    })
  end
end
