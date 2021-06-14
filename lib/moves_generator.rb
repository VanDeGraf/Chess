require './lib/figure_possible_moves'
require './lib/bishop_possible_moves'
require './lib/king_possible_moves'
require './lib/knight_possible_moves'
require './lib/pawn_possible_moves'
require './lib/rook_possible_moves'
# moves generation methods
module MovesGenerator
  # @param coordinate [Coordinate]
  # @param board [Board]
  # @return [Array<Move>]
  def self.generate_from(coordinate, board, check_shah: true)
    figure = board.at(coordinate)
    return [] if figure.nil?

    moves = case figure.figure
            when :pawn
              PawnPossibleMoves.new(figure, coordinate, board).generate_moves
            when :knight
              KnightPossibleMoves.new(figure, coordinate, board).generate_moves
            when :king
              KingPossibleMoves.new(figure, coordinate, board).generate_moves
            when :bishop
              BishopPossibleMoves.new(figure, coordinate, board).generate_moves
            when :rook
              RookPossibleMoves.new(figure, coordinate, board).generate_moves
            when :queen
              BishopPossibleMoves.new(figure, coordinate, board).generate_moves +
              RookPossibleMoves.new(figure, coordinate, board).generate_moves
            end
    moves = moves.map { |move| board.move(move).shah?(figure.color) ? nil : move }.compact if check_shah
    moves
  end

  # king and rook can do special move named castling, it possible, if king never move, not state shah on current and on
  # every path cells, one of rooks never moved and between them cells is empty.
  # @param board [Board]
  # @param color [Symbol]
  # @return [Array<Move>]
  def self.castling(board, color)
    moves = []
    return moves if board.shah?(color) || board.history.any? do |move|
      move.options[:figure].figure == :king &&
      move.options[:figure].color == color
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
                  board.history.none? { |move| move.options[:point_start] == rook_coordinate } &&
                  !board.move(Move.new(:move, {
                                         figure: king_figure,
                                         point_start: king_coordinate,
                                         point_end: king_coordinate.relative(1 * direction, 0)
                                       })).shah?(color) &&
                  !board.move(Move.new(:move, {
                                         figure: king_figure,
                                         point_start: king_coordinate,
                                         point_end: king_coordinate.relative(2 * direction, 0)
                                       })).shah?(color)

      moves << Move.new(castling_type, {
                          figure: king_figure,
                          support_figure: board.at(rook_coordinate),
                          king_point_start: king_coordinate,
                          king_point_end: king_coordinate.relative(2 * direction, 0),
                          rook_point_start: rook_coordinate,
                          rook_point_end: king_coordinate.relative(1 * direction, 0)
                        })
    end
    moves
  end
end
