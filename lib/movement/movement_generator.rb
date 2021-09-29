require_relative 'figure_movement'
require_relative 'bishop_movement'
require_relative 'king_movement'
require_relative 'knight_movement'
require_relative 'pawn_movement'
require_relative 'rook_movement'
require_relative 'queen_movement'
# moves generation methods
module MovementGenerator
  # @param coordinate [Coordinate]
  # @param board [Board]
  # @return [Array<Movement>]
  def self.generate_from(coordinate, board, check_shah: true)
    figure = board.at(coordinate)
    return [] if figure.nil?

    moves = FIGURE_MOVEMENT[figure.figure].new(figure, coordinate, board).generate_moves
    moves = moves_remove_on_shah(board, moves, figure) if check_shah
    moves
  end

  FIGURE_MOVEMENT = {
    pawn: PawnMovement,
    knight: KnightMovement,
    king: KingMovement,
    bishop: BishopMovement,
    rook: RookMovement,
    queen: QueenMovement
  }.freeze

  def self.moves_remove_on_shah(board, moves, figure)
    moves.map { |move| board.move(move).state.shah?(figure.color) ? nil : move }.compact
  end

  # king and rook can do special move named castling, it possible, if king never move, not state shah on current and on
  # every path cells, one of rooks never moved and between them cells is empty.
  # @param board [Board]
  # @param color [Symbol]
  # @return [Array<Movement>]
  def self.castling(board, color)
    moves = []
    king_coordinate = board.where_is(:king, color).first
    return moves if king_coordinate.nil? || !king_can_castling?(board, color)

    %i[castling_short castling_long].each do |castling_type|
      direction = castling_direction(castling_type, color)
      rook_coordinate = castling_rook_coordinate(board, castling_type, direction, king_coordinate)
      next unless castling_condition_verify?(board, king_coordinate, rook_coordinate, castling_type, direction)

      moves << castling_instance(board, castling_type, direction, king_coordinate, rook_coordinate)
    end
    moves
  end

  def self.castling_condition_verify?(board, king_coordinate, rook_coordinate, castling_type, direction)
    castling_path_clear?(board, king_coordinate, castling_type, direction) &&
      !castling_rook_move?(board, rook_coordinate, king_coordinate) &&
      !castling_path_shah?(board, king_coordinate, direction)
  end

  def self.castling_direction(castling_type, color)
    if castling_type == :castling_short
      color == :white ? 1 : -1
    else
      color == :white ? -1 : 1
    end
  end

  def self.castling_rook_coordinate(board, castling_type, direction, king_coordinate)
    x = castling_type == :castling_short ? 3 : 4
    y = board.at(king_coordinate).color == :white ? 0 : 7
    Coordinate.new(x * direction, y)
  end

  def self.king_can_castling?(board, color)
    !board.state.shah?(color) && board.history.none? do |move|
      move.figure.figure == :king &&
        move.figure.color == color
    end
  end

  def self.castling_path_clear?(board, king_coordinate, castling_type, direction)
    false if castling_type == :castling_long && !board.there_empty?(king_coordinate.relative(3 * direction, 0))
    board.there_empty?(king_coordinate.relative(1 * direction, 0)) &&
      board.there_empty?(king_coordinate.relative(2 * direction, 0))
  end

  def self.castling_path_shah?(board, king_coordinate, direction)
    king_figure = board.at(king_coordinate)
    board.move(Move.new(king_figure, king_coordinate,
                        king_coordinate.relative(1 * direction, 0))).state.shah?(king_figure.color) ||
      board.move(Move.new(king_figure, king_coordinate,
                          king_coordinate.relative(2 * direction, 0))).state.shah?(king_figure.color)
  end

  def self.castling_rook_move?(board, rook_coordinate, king_coordinate)
    color = board.at(king_coordinate).color
    !board.there_ally?(color, rook_coordinate) ||
      board.history.any? { |move| move.point_start == rook_coordinate }
  end

  def self.castling_instance(board, castling_type, direction, king_coordinate, rook_coordinate)
    Castling.new(
      board.at(king_coordinate),
      board.at(rook_coordinate),
      king_coordinate,
      king_coordinate.relative(2 * direction, 0),
      rook_coordinate,
      king_coordinate.relative(1 * direction, 0),
      castling_type == :castling_short
    )
  end

  # @param moves [Array<Movement>]
  # @return [Hash<Movement>]
  def self.algebraic_notation(moves)
    assoc = {}
    moves.each do |movement|
      if movement.is_a?(Castling) || movement.is_a?(PromotionMove) || movement.is_a?(EnPassant)
        assoc[movement.algebraic_notation] = movement
      else
        file_required, rank_required = rank_file_required?(moves, movement)
        assoc[movement.algebraic_notation(file: file_required, rank: rank_required)] = movement
      end
    end
    assoc
  end

  def self.rank_file_required?(moves, movement)
    file_required = false
    rank_required = false
    moves.each do |move|
      next if movement == move || move.point_end != movement.point_end
      next if !move.is_a?(Move) && !move.is_a?(Capture) && !move.is_a?(PromotionCapture)
      next unless movement.figure.figure == move.figure.figure

      if move.point_start.x == movement.point_start.x
        rank_required = true
      else
        file_required = true
      end
      break
    end
    [file_required, rank_required]
  end
end
