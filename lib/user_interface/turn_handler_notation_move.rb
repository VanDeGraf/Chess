class TurnHandlerNotationMove < TurnHandler
  def initialize(all_moves, move_notation)
    super()
    @all_moves = all_moves
    @move_notation = move_notation
  end

  def perform_action
    MovementGenerator.algebraic_notation(@all_moves)[@move_notation]
  end

  def error_msg
    "Sorry, you can't move here (or from)."
  end

  # @param all_moves [Array<Movement>]
  def self.create_filter(all_moves)
    InputFilter.new(/^([BNQKR]?[a-h]?[1-8]?x?[a-h][1-8]=?[BNQKR]?)|(O-O)|(O-O-O)$/,
                    handler: proc { |match_data| new(all_moves, match_data[0]) })
  end
end
