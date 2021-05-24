class PossibleMoves
  attr_reader :moves_coordinates, :start_coordinate

  # @param figure [Figure]
  # @param start [Coordinate]
  # @param board [Board]
  def initialize(figure, start, board)
    @figure = figure
    @start_coordinate = start
    @moves_coordinates = []
    @board = board
    build_moves
  end

  def build_moves
    if @figure.figure == :pawn
      move_direction = @figure.color == :white ? 1 : -1

      first_position = add_move(0, 1 * move_direction) { |point|
        @board.on_board?(point) &&
            @board.at(point).nil?
      }
      add_move(0, 2 * move_direction) { |point|
        (@start_coordinate.y == 1 || @start_coordinate.y == 6) &&
            first_position &&
            @board.at(point).nil?
      }
      add_move(-1, 1 * move_direction) { |point|
        !@board.at(point).nil? &&
            @board.at(point).color != @figure.color
      }
      add_move(1, 1 * move_direction) { |point|
        !@board.at(point).nil? &&
            @board.at(point).color != @figure.color
      }
    elsif @figure.figure == :knight
      add_moves([
                    [-1, 2],
                    [1, 2],
                    [-1, -2],
                    [1, -2],
                    [-2, 1],
                    [-2, -1],
                    [2, 1],
                    [2, -1],
                ])
    elsif @figure.figure == :king
      relative = [
          [-1, 1],
          [0, 1],
          [1, 1],
          [1, 0],
          [1, -1],
          [0, -1],
          [-1, -1],
          [-1, 0],
      ]
      enemy_king_coordinate = nil
      0.upto(7) do |y|
        break unless enemy_king_coordinate.nil?
        0.upto(7) do |x|
          enemy_figure = @board.at(Coordinate.new(x, y))
          if !enemy_figure.nil? && enemy_figure.figure == :king && enemy_figure.color != figure.color
            enemy_king_coordinate = Coordinate.new(x, y)
            break
          end
        end
      end
      if enemy_king_coordinate.nil?
        add_moves(relative)
      else
        relative.each do |r|
          point = @start_coordinate.relative(r[0], r[1])
          # distance between kings after move
          if Math.sqrt((enemy_king_coordinate.x - point.x) ** 2 + (enemy_king_coordinate.y - point.y) ** 2) >= 2
            add_move(r[0], r[1])
          end
        end
      end
    elsif [:queen, :rook, :bishop].include?(@figure.figure)
      if [:queen, :rook].include?(@figure.figure)
        add_move_as_part_of_row { |point| point.relative(1, 0) }
        add_move_as_part_of_row { |point| point.relative(-1, 0) }
        add_move_as_part_of_row { |point| point.relative(0, 1) }
        add_move_as_part_of_row { |point| point.relative(0, -1) }
      end
      if [:queen, :bishop].include?(@figure.figure)
        add_move_as_part_of_row { |point| point.relative(-1, 1) }
        add_move_as_part_of_row { |point| point.relative(1, 1) }
        add_move_as_part_of_row { |point| point.relative(1, -1) }
        add_move_as_part_of_row { |point| point.relative(-1, -1) }
      end
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

  def add_move(x, y)
    point = @start_coordinate.relative(x, y)
    if block_given?
      if yield(point)
        @moves_coordinates << point
        return true
      end
    else
      if @board.can_move_at?(@figure, point)
        @moves_coordinates << point
        return true
      end
    end
    false
  end

  def add_moves(endpoints)
    endpoints.each do |coordinate|
      add_move(coordinate[0], coordinate[1])
    end
  end

  def add_move_as_part_of_row
    point = yield @start_coordinate
    @moves_coordinates << point if @board.can_move_at?(@figure, point)
    while @board.on_board?(point) && @board.at(point).nil?
      point = yield point
      @moves_coordinates << point if @board.can_move_at?(@figure, point)
    end
  end
end
