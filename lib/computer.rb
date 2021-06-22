class Computer < Player
  def initialize(color)
    super('Computer', color)
  end

  # @param game [Game]
  # @return [Movement]
  def turn(game)
    scored_moves = {}
    generate_possible_moves(game.board, @color).each do |move|
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
    return 0 if board_clone.draw?(opposite_color)

    enemy_possible_moves = generate_possible_moves(board_clone, opposite_color)
    capture_score = move.is_a?(PromotionMove) || move.is_a?(PromotionCapture) || move.is_a?(Capture) ? 1 : 0

    return 3 + capture_score if board_clone.shah?(opposite_color)
    return 1 + capture_score if enemy_possible_moves.any? do |enemy_move|
      enemy_move.is_a?(Capture) || enemy_move.is_a?(PromotionCapture)
    end

    2 + capture_score
  end

  # @return [Array<Movement>]
  def generate_possible_moves(board, color)
    (board.where_is(nil, color).map do |coordinate|
      MovementGenerator.generate_from(coordinate, board)
    end + MovementGenerator.castling(board, color)).flatten
  end

  def opposite_color
    @color == :white ? :black : :white
  end
end
