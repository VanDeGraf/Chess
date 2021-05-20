class PossibleMoves
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

      add_move(0, 1 * move_direction) { |point|
        @board.on_board?(point) &&
        @board.at(point).nil?
      }
      add_move(0, 2 * move_direction) { |point|
        @start_coordinate.y == 1 &&
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
      add_moves([
        [-1, 1],
        [0, 1],
        [1, 1],
        [1, 0],
        [1, -1],
        [0, -1],
        [-1, -1],
        [-1, 0],
      ])
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
    return false if !color.nil? && color != @figure.color
    return true if beat.nil?
    if beat == @moves_coordinates.reduce { |beat, point| beat || !@board.at(point).nil? }
      return true if beats.nil?
      @moves_coordinates.each do |point|
        return true if !@board.at(point).nil? && @board.at(point).figure == beats
      end
      return false
    else
      return false
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
        true
      end
    else
      if @board.can_move_at?(@figure, point)
        @moves_coordinates << point
        true
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
    add_move(point.x, point.y)
    while @board.on_board?(point) && @board.at(point).nil?
      point = yield point
      add_move(point.x, point.y)
    end
  end
end