require_relative 'figure_movement'
require_relative 'bishop_movement'
require_relative 'king_movement'
require_relative 'knight_movement'
require_relative 'pawn_movement'
require_relative 'rook_movement'
require_relative 'queen_movement'
require_relative 'castling_generator'
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

  # @param board [Board]
  # @param color [Symbol]
  # @return [Array<Movement>]
  def self.castling(board, color)
    CastlingGenerator.new(board, color).generate
  end

  # @param moves [Array<Movement>]
  # @return [Hash<Movement>]
  def self.algebraic_notation(moves)
    assoc = {}
    moves.each do |movement|
      if movement.is_a?(Castling) || movement.is_a?(PromotionMove) || movement.is_a?(EnPassant)
        assoc[movement.algebraic_notation] = movement
      else
        file_required, rank_required = movement_rank_file(moves, movement)
        assoc[movement.algebraic_notation(file: file_required, rank: rank_required)] = movement
      end
    end
    assoc
  end

  def self.rank_file_required?(move, movement)
    return false if !move.is_a?(Move) && !move.is_a?(Capture) && !move.is_a?(PromotionCapture)
    return false if movement == move || move.point_end != movement.point_end

    movement.figure.figure == move.figure.figure
  end

  # @return [Array<Boolean>] [file_required, rank_required]
  def self.movement_rank_file(moves, movement)
    moves.each do |move|
      next unless rank_file_required?(move, movement)

      return [false, true] if move.point_start.x == movement.point_start.x

      return [true, false]
    end
    [false, false]
  end
end
