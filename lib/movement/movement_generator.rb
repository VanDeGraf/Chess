require_relative 'figure_movement'
require_relative 'bishop_movement'
require_relative 'king_movement'
require_relative 'knight_movement'
require_relative 'pawn_movement'
require_relative 'rook_movement'
# moves generation methods
module MovementGenerator
  # @param coordinate [Coordinate]
  # @param board [Board]
  # @return [Array<Movement>]

  def self.generate_from(coordinate, board, check_shah: true)
    figure = board.at(coordinate)
    return [] if figure.nil?

    moves = case figure.figure
            when :pawn
              PawnMovement.new(figure, coordinate, board).generate_moves
            when :knight
              KnightMovement.new(figure, coordinate, board).generate_moves
            when :king
              KingMovement.new(figure, coordinate, board).generate_moves
            when :bishop
              BishopMovement.new(figure, coordinate, board).generate_moves
            when :rook
              RookMovement.new(figure, coordinate, board).generate_moves
            when :queen
              BishopMovement.new(figure, coordinate, board).generate_moves +
              RookMovement.new(figure, coordinate, board).generate_moves
            end
    moves = moves.map { |move| board.move(move).shah?(figure.color) ? nil : move }.compact if check_shah
    moves
  end

  # king and rook can do special move named castling, it possible, if king never move, not state shah on current and on
  # every path cells, one of rooks never moved and between them cells is empty.
  # @param board [Board]
  # @param color [Symbol]
  # @return [Array<Movement>]

  def self.castling(board, color)
    moves = []
    return moves if board.shah?(color) || board.history.any? do |move|
      move.figure.figure == :king &&
      move.figure.color == color
    end

    king_coordinate = board.where_is(:king, color).first
    return moves if king_coordinate.nil?

    king_figure = board.at(king_coordinate)
    y = color == :white ? 0 : 7

    %i[castling_short castling_long].each do |castling_type|
      direction = color == :white ? -1 : 1
      if castling_type == :castling_short
        direction = color == :white ? 1 : -1
        rook_coordinate = Coordinate.new(3 * direction, y)
      else
        rook_coordinate = Coordinate.new(4 * direction, y)
        next unless board.there_empty?(king_coordinate.relative(3 * direction, 0))
      end

      next unless board.there_empty?(king_coordinate.relative(1 * direction, 0)) &&
                  board.there_empty?(king_coordinate.relative(2 * direction, 0)) &&
                  board.there_ally?(color, rook_coordinate) &&
                  board.history.none? { |move| move.point_start == rook_coordinate } &&
                  !board.move(Move.new(king_figure, king_coordinate,
                                       king_coordinate.relative(1 * direction, 0))).shah?(color) &&
                  !board.move(Move.new(king_figure, king_coordinate,
                                       king_coordinate.relative(2 * direction, 0))).shah?(color)

      moves << Castling.new(
        king_figure,
        board.at(rook_coordinate),
        king_coordinate,
        king_coordinate.relative(2 * direction, 0),
        rook_coordinate,
        king_coordinate.relative(1 * direction, 0),
        castling_type == :castling_short
      )
    end
    moves
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
