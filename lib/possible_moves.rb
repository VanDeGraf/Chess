# generate possible moves of figure, depends by type and color of it, and depends by other figures on board
class PossibleMoves
  attr_reader :moves, :start_coordinate

  # @param figure [Figure]
  # @param start [Coordinate]
  # @param board [Board]
  # @param check_shah [Boolean]
  def initialize(figure, start, board, check_shah = true)
    # @type [Figure]
    @figure = figure
    # @type [Coordinate]
    @start_coordinate = start
    # @type [Board]
    @board = board
    # @type [Array<Move>]
    @moves = build_moves(check_shah)
  end

  # @return [Array<Move>]
  def pawn_moves
    promotion_figures = %i[queen knight rook bishop]
    moves = []

    # pawn possible moves depends of it's direction on board
    move_direction = @figure.color == :white ? 1 : -1

    # pawn can move towards 1 cell, if there empty cell
    move = get_move_relative(0, 1 * move_direction) do |point|
      @board.on_board?(point) && @board.there_empty?(point)
    end
    # pawn can do special move named promotion, if pawn move towards at last empty board cell
    if !move.nil? && (move.options[:point_end].y.zero? || move.options[:point_end].y == 7)
      promotion_figures.each do |figure_type|
        moves << Move.new(:promotion_move, {
                            figure: move.options[:figure],
                            point_start: move.options[:point_start],
                            point_end: move.options[:point_end],
                            promoted_to: Figure.new(figure_type, move.options[:figure].color)
                          })
      end
    else
      moves << move
    end

    # pawn can move towards 2 cell, if can move towards 1 cell, there empty cell and
    #   only from first position depends by direction(color)
    moves << get_move_relative(0, 2 * move_direction) do |point|
      (@start_coordinate.y == 1 || @start_coordinate.y == 6) &&
        moves.compact.length == 1 &&
        @board.there_empty?(point)
    end

    # pawn can beat enemy at towards-left and towards-right diagonal cells, if there enemy
    moves_temp = get_move_relative([[-1, 1 * move_direction], [1, 1 * move_direction]]) do |point|
      @board.on_board?(point) && @board.there_enemy?(@figure, point)
    end
    moves_temp.each do |move|
      # pawn can do special move named promotion, if pawn capture one of toward diagonals at last board cells
      if !move.nil? &&
         (move.options[:point_end].y == 0 || move.options[:point_end].y == 7)
        promotion_figures.each do |figure_type|
          moves << Move.new(:promotion_capture, {
                              figure: move.options[:figure],
                              point_start: move.options[:point_start],
                              point_end: move.options[:point_end],
                              promoted_to: Figure.new(figure_type, move.options[:figure].color),
                              captured: move.options[:captured]
                            })
        end
      else
        moves << move
      end
    end

    # pawn can do special move named en passant,
    # that algorithm check is last move do enemy pawn toward on 2 near with current pawn
    [-1, 1].each do |shift|
      enemy_point_start = @start_coordinate.relative(shift, move_direction * 2)
      enemy_point_end = @start_coordinate.relative(shift, 0)
      move = @board.history.last
      next unless !move.nil? &&
                  move.kind == :move &&
                  move.options[:figure].figure == :pawn &&
                  move.options[:point_end] == enemy_point_end &&
                  move.options[:point_start] == enemy_point_start

      moves << Move.new(:en_passant, {
                          figure: @figure,
                          point_start: @start_coordinate,
                          point_end: @start_coordinate.relative(shift, move_direction),
                          captured: move.options[:figure],
                          captured_at: enemy_point_start
                        })
    end

    moves.compact
  end

  # @return [Array<Move>]
  def knight_moves
    # for each default knight moves add move if there is enemy or empty
    get_move_relative([
                        [-1, 2],
                        [1, 2],
                        [-1, -2],
                        [1, -2],
                        [-2, 1],
                        [-2, -1],
                        [2, 1],
                        [2, -1]
                      ]) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point))
    end
  end

  # @return [Array<Move>]
  def king_moves
    opposite_color = @figure.color == :white ? :black : :white
    enemy_king_coordinate = @board.where_is(:king, opposite_color).first

    # for each default king moves add move if there is enemy or empty and distance between opposite kings
    # is more or equal 2
    get_move_relative([
                        [-1, 1],
                        [0, 1],
                        [1, 1],
                        [1, 0],
                        [1, -1],
                        [0, -1],
                        [-1, -1],
                        [-1, 0]
                      ]) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point)) &&
        (enemy_king_coordinate.nil? ||
          Math.sqrt((enemy_king_coordinate.x - point.x)**2 + (enemy_king_coordinate.y - point.y)**2) >= 2)
    end
  end

  # @return [Array<Move>]
  def bishop_moves
    # for every diagonal direction add coordinate if it's valid and there empty or enemy, then if added, try add next
    # coordinate on this direction
    get_moves_by_direction([
                             [1, 1],
                             [1, -1],
                             [-1, -1],
                             [-1, 1]
                           ]) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point))
    end
  end

  # @return [Array<Move>]
  def rook_moves
    # for every diagonal direction add coordinate if it's valid and there empty or enemy, then if added, try add next
    # coordinate on this direction
    get_moves_by_direction([
                             [0, 1],
                             [1, 0],
                             [0, -1],
                             [-1, 0]
                           ]) do |point|
      @board.on_board?(point) &&
        (@board.there_enemy?(@figure, point) || @board.there_empty?(point))
    end
  end

  # @return [Array<Move>]
  def queen_moves
    # queen can all of can bishop and rook
    bishop_moves + rook_moves
  end

  # @param check_shah [Boolean]
  # @return [Array<Move>]
  def build_moves(check_shah)
    moves = case @figure.figure
            when :pawn
              pawn_moves
            when :knight
              knight_moves
            when :king
              king_moves
            when :bishop
              bishop_moves
            when :rook
              rook_moves
            when :queen
              queen_moves
            else
              []
            end
    if check_shah
      moves.map { |move| @board.move(move).shah?(@figure.color) ? nil : move }.compact
    else
      moves
    end
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
      direction = :white ? -1 : 1
      if castling_type == :castling_short
        direction = :white ? 1 : -1
        rook_coordinate = Coordinate.new(3 * direction, y)
      else
        rook_coordinate = Coordinate.new(4 * direction, y)
        next unless board.there_empty?(king_coordinate.relative(3 * direction, 0))
      end

      next unless board.there_empty?(king_coordinate.relative(1 * direction, 0)) &&
                  board.there_empty?(king_coordinate.relative(2 * direction, 0)) &&
                  board.there_ally?(color, rook_coordinate) &&
                  !board.history.any? { |move| move.options[:point_start] == rook_coordinate } &&
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

  private

  # @overload get_move_relative(x,y)
  #   @param x [Numeric]
  #   @param y [Numeric]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Move, nil]
  # @overload get_move_relative(moves)
  #   @param moves [Array<Array<Fixnum>>]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Move>]
  def get_move_relative(*args, &block)
    if args.length == 2 && args[0].is_a?(Integer) && args[1].is_a?(Integer)
      point = @start_coordinate.relative(args[0], args[1])
      if yield(point)
        if @board.there_empty?(point)
          Move.new(:move, {
                     figure: @figure,
                     point_start: @start_coordinate,
                     point_end: point
                   })
        else
          Move.new(:capture, {
                     figure: @figure,
                     point_start: @start_coordinate,
                     point_end: point,
                     captured: @board.at(point)
                   })
        end
      end
    elsif args.length == 1 && args[0].is_a?(Array)
      args[0].map { |relative| get_move_relative(relative[0], relative[1], &block) }.compact
    else
      raise ArgumentError
    end
  end

  # @overload get_moves_by_direction(x,y)
  #   @param x [Fixnum]
  #   @param y [Fixnum]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Move>]
  # @overload get_moves_by_direction(directions)
  #   @param directions [Array<Array<Fixnum>>]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Move>]
  def get_moves_by_direction(*args, &block)
    if args.length == 2 && args[0].is_a?(Integer) && args[1].is_a?(Integer)
      moves = []
      iteration = 1
      loop do
        move = get_move_relative(args[0] * iteration, args[1] * iteration, &block)
        break if move.nil?

        moves << move
        break if move.kind == :capture

        iteration += 1
      end
      moves
    elsif args.length == 1 && args[0].is_a?(Array)
      args[0].map { |direction| get_moves_by_direction(direction[0], direction[1], &block) }.flatten
    end
  end
end
