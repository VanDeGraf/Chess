class Computer < Player
  def initialize(color)
    super('Computer', color)
  end

  # @param game [Game]
  # @return [Movement]
  def turn(game)
    scored_moves = {}
    game.board.possible_moves(@color).each do |move|
      score = score_turn(game, move)
      scored_moves[score] = [] unless scored_moves.key?(score)
      scored_moves[score] << move
    end
    best_score_moves = scored_moves[scored_moves.keys.max]
    best_score_moves[rand(best_score_moves.length)]
  end

  private

  # @param game [Game]
  # @param move [Movement]
  # @return [Integer]
  def score_turn(game, move)
    board_clone = game.board.move(move)
    return 0 if score_turn_0?(board_clone)

    capture_score = move.is_a?(PromotionMove) || move.is_a?(PromotionCapture) || move.is_a?(Capture) ? 1 : 0

    return 3 + capture_score if score_turn_3?(board_clone)
    return 1 + capture_score if score_turn_1?(board_clone)

    2 + capture_score
  end

  def score_turn_0?(board_clone)
    board_clone.state.draw?(opposite_color)
  end

  def score_turn_3?(board_clone)
    board_clone.state.shah?(opposite_color)
  end

  def score_turn_1?(board_clone)
    enemy_possible_moves = board_clone.possible_moves(opposite_color)
    enemy_possible_moves.any? do |enemy_move|
      enemy_move.is_a?(Capture) || enemy_move.is_a?(PromotionCapture)
    end
  end

  def opposite_color
    @color == :white ? :black : :white
  end
end
