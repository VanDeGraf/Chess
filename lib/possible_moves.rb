# generate possible moves of figure, depends by type and color of it, and depends by other figures on board
class PossibleMoves
  attr_reader :moves_coordinates, :start_coordinate

  # @param figure [Figure]
  # @param start [Coordinate]
  # @param board [Board]
  def initialize(figure, start, board)
    # @type [Figure]
    @figure = figure
    # @type [Coordinate]
    @start_coordinate = start
    # @type [Board]
    @board = board
    # @type [Array<Coordinate>]
    @moves_coordinates = build_moves
  end

  # @return [Array<Coordinate>]
  def pawn_moves
    moves = []
    # pawn possible moves depends of it's direction on board
    move_direction = @figure.color == :white ? 1 : -1

    # pawn can move towards 1 cell, if there empty cell
    moves << get_move_relative(0, 1 * move_direction) do |point|
      @board.on_board?(point) && @board.there_empty?(point)
    end

    # pawn can move towards 2 cell, if can move towards 1 cell, there empty cell and
    #   only from first position depends by direction(color)
    moves << get_move_relative(0, 2 * move_direction) do |point|
      (@start_coordinate.y == 1 || @start_coordinate.y == 6) &&
          moves.compact.length == 1 &&
          @board.there_empty?(point)
    end

    # pawn can beat enemy at towards-left and towards-right diagonal cells, if there enemy
    moves << get_move_relative([[-1, 1 * move_direction], [1, 1 * move_direction]]) do |point|
      @board.on_board?(point) && @board.there_enemy?(@figure, point)
    end

    # TODO: pawn special move - en passant
    # TODO: pawn special move - promotion

    moves.compact
  end

  # @return [Array<Coordinate>]
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
                          [2, -1],
                      ]) do |point|
      @board.on_board?(point) &&
          (@board.there_enemy?(@figure, point) || @board.there_empty?(point))
    end
  end

  # @return [Array<Coordinate>]
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
                          [-1, 0],
                      ]) do |point|
      @board.on_board?(point) &&
          (@board.there_enemy?(@figure, point) || @board.there_empty?(point)) &&
          (enemy_king_coordinate.nil? ||
              Math.sqrt((enemy_king_coordinate.x - point.x) ** 2 + (enemy_king_coordinate.y - point.y) ** 2) >= 2)
    end
    # TODO: king special move - castling
  end

  # @return [Array<Coordinate>]
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

  # @return [Array<Coordinate>]
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

  # @return [Array<Coordinate>]
  def queen_moves
    # queen can all of can bishop and rook
    bishop_moves + rook_moves
  end

  # @return [Array<Coordinate>]
  def build_moves
    case @figure.figure
    when :pawn
      return pawn_moves
    when :knight
      return knight_moves
    when :king
      return king_moves
    when :bishop
      return bishop_moves
    when :rook
      return rook_moves
    when :queen
      return queen_moves
    end
  end

  # @param color [Symbol] figure color, nil - doesn't matter
  # @param beat [Boolean] is figure beat other in any moves? nil - doesn't matter
  # @param beats [Symbol] figure beats this figure type, nil - doesn't matter
  def match?(color = nil, beat = nil, beats = nil)
    return false if (!color.nil? && color != @figure.color) || @moves_coordinates.length == 0
    return true if beat.nil?
    if beat == @moves_coordinates.reduce(false) { |beat, point| beat || !@board.at(point).nil? }
      return true if beats.nil?
      @moves_coordinates.each do |point|
        return true if !@board.at(point).nil? && @board.at(point).figure == beats
      end
      false
    else
      false
    end
  end

  # @param point_start [Coordinate]
  # @param point_end [Coordinate]
  def can_move?(point_start, point_end)
    return false if @start_coordinate.x != point_start.x ||
        @start_coordinate.y != point_start.y
    @moves_coordinates.each do |move|
      return true if move.x == point_end.x &&
          move.y == point_end.y
    end
    false
  end

  private

  # @overload get_move_relative(x,y)
  #   @param x [Numeric]
  #   @param y [Numeric]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Coordinate, nil]
  # @overload get_move_relative(moves)
  #   @param moves [Array<Array<Fixnum>>]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Coordinate>]
  def get_move_relative(*args)
    if args.length == 2 && args[0].is_a?(Fixnum) && args[1].is_a?(Fixnum)
      point = @start_coordinate.relative(args[0], args[1])
      if yield(point)
        point
      else
        nil
      end
    elsif args.length == 1 && args[0].is_a?(Array)
      args[0].map { |relative| get_move_relative(relative[0], relative[1]) { |params| yield params } }.compact
    else
      raise ArgumentError
    end
  end

  # @overload get_moves_by_direction(x,y)
  #   @param x [Fixnum]
  #   @param y [Fixnum]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Coordinate>]
  # @overload get_moves_by_direction(directions)
  #   @param directions [Array<Array<Fixnum>>]
  #   @yieldparam point [Coordinate]
  #   @yieldreturn [Boolean]
  #   @return [Array<Coordinate>]
  def get_moves_by_direction(*args)
    if args.length == 2 && args[0].is_a?(Fixnum) && args[1].is_a?(Fixnum)
      moves = []
      iteration = 1
      loop do
        coordinate = get_move_relative(args[0] * iteration, args[1] * iteration) { |point| yield point }
        break if coordinate.nil?
        moves << coordinate
        iteration += 1
      end
      moves
    elsif args.length == 1 && args[0].is_a?(Array)
      args[0].map { |direction| get_moves_by_direction(direction[0], direction[1]) { |point| yield point } }.flatten
    end
  end
end
