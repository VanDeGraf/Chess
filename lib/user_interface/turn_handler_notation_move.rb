class TurnHandlerNotationMove < TurnHandler
  # @param game [Game]
  # @param all_moves [Array<Movement>]
  # @param move_notation [String]
  def initialize(game, all_moves, move_notation)
    super()
    @all_moves = all_moves
    @move_notation = move_notation
    @game = game
  end

  def perform_action
    move = MovementGenerator.algebraic_notation(@all_moves)[@move_notation]
    @game.perform_movement(move)
    @has_error = move.nil?
    nil
  end

  def error_msg
    "Sorry, you can't move here (or from)."
  end

  # @param game [Game]
  # @param all_moves [Array<Movement>]
  def self.create_filter(game, all_moves)
    InputFilter.new(/^([BNQKR]?[a-h]?[1-8]?x?[a-h][1-8]=?[BNQKR]?)|(O-O)|(O-O-O)$/,
                    handler: proc { |match_data| new(game, all_moves, match_data[0]) })
  end
end
